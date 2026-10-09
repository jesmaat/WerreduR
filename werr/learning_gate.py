"""
werr/learning_gate.py
=====================
LearningGate: Fractal-Seeded Step-Size Controller for Adaptive Learning
Based on the WERR Tripod Mandelbrot Kernel (24-byte coordinate seed).

Reference:
"Where Does a Fractal-Seeded Controller Stand? A Simulation Study Positioning
a 24-Byte, Estimation-Free Difficulty Controller Against Adaptive Testing,
Staircase Rules and a Language Model"

Mathematical Specification:
- 24-byte frozen seed: Theta = (cx0 = -0.80792578443908969, cy0 = 0.18302136198124994, z0 = 300.0)
- Symmetric servo update: b <- b + (s_min + (s_max - s_min) * g) * (2x - 1)
- State projection: K = 4 latent features [a1, a2, m, a3] from 4-bit response history + leaky accumulator rho
- Tripod multi-scale Mandelbrot evaluation (0.60x, 1.00x, 1.60x) extracting 4 bounded quadrant ratios
- Single neuron activation: g = sigmoid(clamp(w1*a1 + w2*a2 + w3*m + w4, -50, 50))
"""

from __future__ import annotations

import math
from dataclasses import dataclass, field
from typing import Any, Dict, List, Optional, Sequence, Tuple, Union

import numpy as np
from werr.fractal import compute_mandelbrot_patch, extract_bounded_quadrant_weights

# -----------------------------------------------------------------------------
# Canonical Constants
# -----------------------------------------------------------------------------
WERR_BASE_SEED: Tuple[float, float, float] = (-0.7436438870371587, 0.1318259042053119, 50.0)
GATE_SEED: Tuple[float, float, float] = (-0.80792578443908969, 0.18302136198124994, 300.0)
TWIN_W: Tuple[float, float, float, float] = (0.031895461427411224, 1.067104626736044, 3.0, -3.0)

RHO_LEAK: float = 1.0 / 3.0
S_MIN: float = 0.05
S_MAX: float = 0.60


# -----------------------------------------------------------------------------
# Tripod Kernel & State Projection Functions
# -----------------------------------------------------------------------------
def werr_tripod(
    cx: float, cy: float, zoom: float, res: int = 36, max_iter: int = 36, bandwidth: float = 0.12
) -> np.ndarray:
    """
    Evaluates the WERR multi-scale tripod escape-time pass.
    Combines 3 zoom scales (0.60x, 1.00x, 1.60x) with weights (0.25, 0.50, 0.25).
    Returns 4 bounded quadrant ratios in [0, 1]^4.
    """
    scales: List[Tuple[float, float]] = [(0.60, 0.25), (1.00, 0.50), (1.60, 0.25)]
    fused_q = np.zeros(4, dtype=np.float64)

    for zf, wz in scales:
        _, _, esc = compute_mandelbrot_patch(
            cx=cx, cy=cy, zoom=zoom * zf, res=res, max_iter=max_iter
        )
        *_, q = extract_bounded_quadrant_weights(esc, max_iter=max_iter, bandwidth=bandwidth)
        fused_q += wz * np.array(q, dtype=np.float64)

    return fused_q


def agree(a: Optional[int], b: Optional[int]) -> float:
    """Agreement between consecutive responses: 0 if missing, +1 if equal, -1 if distinct."""
    if a is None or b is None:
        return 0.0
    return 1.0 if a == b else -1.0


def project_state(
    hist: Sequence[Optional[int]], rho: float
) -> Tuple[Tuple[float, float, float, float], float]:
    """
    Projects the controller state (4 recent response bits + leaky sum rho)
    into 4 latent agreement/imbalance features vec and scalar net_risk.
    """
    a1 = agree(hist[0], hist[1])
    a2 = agree(hist[1], hist[2])
    a3 = agree(hist[2], hist[3])
    m = 2.0 * abs(rho) / 3.0 - 1.0
    net_risk = abs(rho) - 1.0
    return (a1, a2, m, a3), net_risk


def modulate_seed(
    seed: Tuple[float, float, float],
    vec: Tuple[float, float, float, float],
    net_risk: float,
) -> Tuple[float, float, float]:
    """
    Modulates the 24-byte seed coordinates based on state features.
    Verbatim implementation of werr/gates/base.py boundary coordinate shift.
    """
    cx0, cy0, z0 = seed
    scale = 1.0 / z0
    a1, a2, m, a3 = vec

    dx_in = net_risk if net_risk != 0.0 else (a1 + m) / 2.0
    dx = math.tanh(dx_in) * scale * 0.45
    dy = math.tanh((a2 + a3) / 2.0) * scale * 0.45

    cx = cx0 + dx
    cy = cy0 + dy
    zoom = z0 * (1.0 + 0.1 * math.sin(a1 + a2 + m + a3))
    return (cx, cy, zoom)


def gate_gain(
    hist: Sequence[Optional[int]],
    rho: float,
    seed: Tuple[float, float, float] = GATE_SEED,
    mode: str = "werr",
    w_explicit: Optional[Sequence[float]] = None,
) -> float:
    """
    Computes the sigmoid neuron gain g in [0, 1].
    mode:
      - 'werr': full fractal gate (state-modulated tripod kernel) [proposed]
      - 'frozen': weights read once at unmodulated seed [ablation]
      - 'explicit': free weights supplied directly, no fractal [matched control]
    """
    vec, net_risk = project_state(hist, rho)

    if mode == "werr":
        mod_seed = modulate_seed(seed, vec, net_risk)
        q = werr_tripod(*mod_seed)
        w = (q - 0.5) * 6.0
    elif mode == "frozen":
        q = werr_tripod(*seed)
        w = (q - 0.5) * 6.0
    elif mode == "explicit":
        if w_explicit is None:
            raise ValueError("Explicit weights must be provided for mode='explicit'")
        w = np.array(w_explicit, dtype=np.float64)
    else:
        raise ValueError(f"Unknown mode: {mode}")

    z = float(w[0] * vec[0] + w[1] * vec[1] + w[2] * vec[2] + w[3])
    z_clamped = max(-50.0, min(50.0, z))
    return 1.0 / (1.0 + math.exp(-z_clamped))


# -----------------------------------------------------------------------------
# Controller Implementations
# -----------------------------------------------------------------------------
@dataclass
class LearningGate:
    """
    Fractal-seeded adaptive step-size controller.
    Maintains a 4-bit response history, leaky balance accumulator rho,
    and symmetric difficulty b.
    """

    seed: Tuple[float, float, float] = GATE_SEED
    mode: str = "werr"
    w_explicit: Optional[Sequence[float]] = None
    s_min: float = S_MIN
    s_max: float = S_MAX

    b: float = 0.0
    hist: List[Optional[int]] = field(default_factory=lambda: [None, None, None, None])
    rho: float = 0.0
    last_gain: float = 0.0
    _w_frozen: Optional[np.ndarray] = None

    def __post_init__(self):
        if self.mode == "frozen":
            q = werr_tripod(*self.seed)
            self._w_frozen = (q - 0.5) * 6.0
        elif self.mode == "explicit" and self.w_explicit is None:
            self.w_explicit = TWIN_W

    def reset(self, b_init: float = 0.0) -> None:
        """Resets the controller to initial state."""
        self.b = b_init
        self.hist = [None, None, None, None]
        self.rho = 0.0
        self.last_gain = 0.0

    @property
    def difficulty(self) -> float:
        """Current presentation difficulty in logits."""
        return self.b

    def update(self, x: int) -> float:
        """
        Updates the controller state upon observing response x in {0, 1}.
        Returns updated presentation difficulty b.
        """
        x_int = int(x)
        self.hist = [x_int, self.hist[0], self.hist[1], self.hist[2]]
        self.rho = (1.0 - RHO_LEAK) * self.rho + (2.0 * x_int - 1.0)

        if self.mode == "frozen":
            self.last_gain = gate_gain(
                self.hist, self.rho, mode="explicit", w_explicit=self._w_frozen
            )
        else:
            self.last_gain = gate_gain(
                self.hist, self.rho, seed=self.seed, mode=self.mode, w_explicit=self.w_explicit
            )

        step_size = self.s_min + (self.s_max - self.s_min) * self.last_gain
        self.b += step_size * (2.0 * x_int - 1.0)
        return self.b


@dataclass
class Staircase:
    """Fixed-step 1-up / 1-down staircase (Levitt, 1971; equivalent to Elo K=2*step)."""

    step: float = 0.15
    b: float = 0.0

    def reset(self, b_init: float = 0.0) -> None:
        self.b = b_init

    @property
    def difficulty(self) -> float:
        return self.b

    def update(self, x: int) -> float:
        self.b += self.step * (2.0 * int(x) - 1.0)
        return self.b


@dataclass
class PEST:
    """
    Accelerated staircase (Taylor & Creelman, 1967).
    Halves step at reversals, doubles from 3rd consecutive equal response.
    """

    start_step: float = 0.30
    s_min: float = S_MIN
    s_max: float = S_MAX
    b: float = 0.0
    step: float = 0.30
    last_response: Optional[int] = None
    run_length: int = 0

    def __post_init__(self):
        self.step = self.start_step

    def reset(self, b_init: float = 0.0) -> None:
        self.b = b_init
        self.step = self.start_step
        self.last_response = None
        self.run_length = 0

    @property
    def difficulty(self) -> float:
        return self.b

    def update(self, x: int) -> float:
        x_int = int(x)
        if self.last_response is not None and x_int != self.last_response:
            self.step = max(self.s_min, self.step / 2.0)
            self.run_length = 1
        else:
            self.run_length += 1
            if self.run_length >= 3:
                self.step = min(self.s_max, self.step * 2.0)

        self.b += self.step * (2.0 * x_int - 1.0)
        self.last_response = x_int
        return self.b


@dataclass
class CAT:
    """
    Computerized Adaptive Testing targeting P* = 0.50 under Rasch model with EAP estimation.
    Supports standard N(0,1) prior, custom prior, and likelihood discounting (forgetting).
    """

    discount: float = 1.0
    prior_mean: float = 0.0
    prior_sd: float = 1.0
    grid_min: float = -6.0
    grid_max: float = 6.0
    grid_step: float = 0.1

    b: float = 0.0
    grid: np.ndarray = field(init=False)
    log_prior: np.ndarray = field(init=False)
    log_lik: np.ndarray = field(init=False)

    def __post_init__(self):
        self.grid = np.arange(self.grid_min, self.grid_max + 1e-9, self.grid_step)
        self.log_prior = -0.5 * ((self.grid - self.prior_mean) / self.prior_sd) ** 2
        self.log_prior -= np.log(self.prior_sd * np.sqrt(2.0 * np.pi))
        self.reset(self.prior_mean)

    def reset(self, b_init: float = 0.0) -> None:
        self.b = b_init
        self.log_lik = np.zeros_like(self.grid)

    @property
    def difficulty(self) -> float:
        return self.b

    def update(self, x: int) -> float:
        x_int = int(x)
        # Rasch item response probability: p = 1 / (1 + exp(-(theta - b)))
        logit_diff = self.grid - self.b
        p = 1.0 / (1.0 + np.exp(-logit_diff))
        # Clip to avoid log(0)
        p = np.clip(p, 1e-12, 1.0 - 1e-12)

        item_ll = np.log(p) if x_int == 1 else np.log(1.0 - p)
        self.log_lik = self.discount * self.log_lik + item_ll

        log_post = self.log_lik + self.log_prior
        w = np.exp(log_post - np.max(log_post))
        self.b = float(np.sum(self.grid * w) / np.sum(w))
        return self.b


@dataclass
class PFPCore:
    """
    Legacy PFP-Core controller from v1:
    c <- c + (+/- delta) - kappa * (c - X), X = 0.25 + 0.18i
    b = beta * Re(c - X) = 10 * d
    +J: resets d <- 0 after 4 consecutive failures.
    """

    jump: bool = False
    kappa: float = 0.44
    delta: float = 0.05
    beta: float = 10.0
    d: float = 0.0
    consecutive_fails: int = 0

    def reset(self, b_init: float = 0.0) -> None:
        self.d = b_init / self.beta
        self.consecutive_fails = 0

    @property
    def difficulty(self) -> float:
        return self.beta * self.d

    def update(self, x: int) -> float:
        x_int = int(x)
        if x_int == 0:
            self.consecutive_fails += 1
        else:
            self.consecutive_fails = 0

        if self.jump and self.consecutive_fails >= 4:
            self.d = 0.0
            self.consecutive_fails = 0
        else:
            step = self.delta if x_int == 1 else -self.delta
            self.d = self.d + step - self.kappa * self.d

        return self.difficulty
