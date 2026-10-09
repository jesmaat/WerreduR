"""
sim_rigorous_revision_suite.py
==============================
Rigorous empirical investigation addressing Claude's specific review points:

1. FAIR BEST-VS-BEST GRID:
   - Staircase step size sweep: s in [0.05, 0.10, 0.15, 0.20, 0.25, 0.50]
   - Windowed MAP-CAT window sweep: W in [10, 15, 20, 30, 50, None (Full)]
   - Across learning rates: eta in [0.02, 0.05, 0.10]
   Finds the optimal configuration for both paradigms at each learning rate.

2. MILD PULLBACK TEST (with calibrated step size s = 0.15):
   - kappa in [0.0, 0.02, 0.05, 0.10, 0.20, 0.44]
   - Across eta in [0.02, 0.10]
   Tests whether mild pullback regularizes without suffocating rapid learning.

3. ISOLATED STATE-JUMP SAFEGUARD (+J):
   - Tests the +J operator (triggered after 4 consecutive failures)
   - Evaluated on:
     a) Staircase (s = 0.15) vs Staircase+J
     b) Staircase (s = 0.50) vs Staircase+J
     c) PFP-Core (kappa = 0.44) vs PFP-Core+J
   - Measures frustration rate (P < 0.30), max consecutive errors, corridor, and gain.

Follows exact 5-seed protocol (42, 137, 369, 1024, 2026; N=1,000 learners, T=120).
"""

import numpy as np
import scipy.stats as stats

SEEDS = [42, 137, 369, 1024, 2026]
N_PER_SEED = 200
T_STEPS = 120

def logistic(x):
    return 1.0 / (1.0 + np.exp(-np.clip(x, -30, 30)))

def solve_map_theta_windowed(b_hist, y_hist, window_size=None, prior_mean=0.0, prior_sd=1.0, max_iter=15, tol=1e-4):
    if len(b_hist) == 0:
        return prior_mean
    if window_size is not None and len(b_hist) > window_size:
        b_arr = np.array(b_hist[-window_size:])
        y_arr = np.array(y_hist[-window_size:])
    else:
        b_arr = np.array(b_hist)
        y_arr = np.array(y_hist)
        
    prior_var = prior_sd ** 2
    th = prior_mean
    for _ in range(max_iter):
        p = logistic(th - b_arr)
        score = -(th - prior_mean) / prior_var + np.sum(y_arr - p)
        info = 1.0 / prior_var + np.sum(p * (1.0 - p))
        delta = score / info
        delta = np.clip(delta, -1.0, 1.0)
        th += delta
        if abs(delta) < tol:
            break
    return th

def simulate_student(seed, idx, arm_type, rule="Rule 2", eta=0.02, step_size=0.15, 
                     window=None, kappa=0.0, has_jump=False, jump_threshold=4):
    rng = np.random.default_rng(seed * 10000 + idx)
    theta0 = rng.normal(0.0, 1.0)
    U = rng.random(T_STEPS)
    
    theta = theta0
    b_hist = []
    y_hist = []
    P_hist = []
    track_hist = []
    
    consecutive_fails = 0
    max_fails = 0
    jump_count = 0
    
    # State variables
    b_curr = 0.0
    c = complex(0.25, 0.18)
    X = complex(0.25, 0.18)
    
    for t in range(T_STEPS):
        if arm_type == "MAP_CAT":
            b = solve_map_theta_windowed(b_hist, y_hist, window_size=window)
        elif arm_type == "Staircase":
            b = b_curr
        elif arm_type == "PFP":
            # beta = 10, delta = 0.05 (or custom)
            b = 10.0 * (c - X).real
        elif arm_type == "LeakyStaircase":
            # Leaky staircase with direct step size and pullback to 0
            b = b_curr
        else:
            raise ValueError(arm_type)
            
        p = logistic(theta - b)
        y = 1 if U[t] < p else 0
        
        b_hist.append(b)
        y_hist.append(y)
        P_hist.append(p)
        track_hist.append(abs(b - theta))
        
        if y == 0:
            consecutive_fails += 1
            max_fails = max(max_fails, consecutive_fails)
        else:
            consecutive_fails = 0
            
        # Check Jump safeguard
        triggered_jump = False
        if has_jump and consecutive_fails >= jump_threshold:
            triggered_jump = True
            jump_count += 1
            consecutive_fails = 0
            
        # State updates
        if arm_type == "MAP_CAT":
            pass # updated at step start
        elif arm_type == "Staircase":
            if triggered_jump:
                b_curr -= 3.0 * step_size  # easing jump
            else:
                b_curr += step_size if y == 1 else -step_size
        elif arm_type == "LeakyStaircase":
            if triggered_jump:
                b_curr -= 3.0 * step_size
            else:
                db = step_size if y == 1 else -step_size
                b_curr = b_curr + db - kappa * b_curr
        elif arm_type == "PFP":
            if triggered_jump:
                c = X  # reset to anchor
            else:
                dc = 0.05 if y == 1 else -0.05
                c = c + dc - kappa * (c - X)
                
        # Learner ability update
        if rule == "Rule 1":
            theta += eta if y == 1 else -eta
        elif rule == "Rule 2":
            theta += (eta * (1.0 - p) if y == 1 else 0.0)
            
    P_arr = np.array(P_hist)
    return {
        "gain": theta - theta0,
        "corridor": np.mean((P_arr >= 0.40) & (P_arr <= 0.60)),
        "zpd": np.mean((P_arr >= 0.50) & (P_arr <= 0.70)),
        "frustration": np.mean(P_arr < 0.30),
        "boredom": np.mean(P_arr > 0.85),
        "tracking": np.mean(track_hist),
        "max_fails": max_fails,
        "jumps": jump_count
    }

def run_cohort(arm_type, **kwargs):
    results = []
    for s in SEEDS:
        for i in range(N_PER_SEED):
            results.append(simulate_student(s, i, arm_type, **kwargs))
    res = {}
    for k in ["gain", "corridor", "zpd", "frustration", "boredom", "tracking", "max_fails", "jumps"]:
        vals = [r[k] for r in results]
        m = np.mean(vals)
        ci = 1.96 * stats.sem(vals)
        res[k] = (m, m - ci, m + ci)
    return res

def fmt(tup):
    return f"{tup[0]:.3f} [{tup[1]:.3f}, {tup[2]:.3f}]"

def main():
    print("=" * 100)
    print("EXPERIMENT A: FAIR BEST-VS-BEST GRID (Staircase step vs Windowed MAP-CAT across eta)")
    print("=" * 100)
    etas = [0.02, 0.05, 0.10]
    steps = [0.05, 0.10, 0.15, 0.25, 0.50]
    windows = [None, 50, 30, 20, 10]
    
    for eta in etas:
        print(f"\n--- LEARNING RATE eta = {eta:.2f} (Rule 2) ---")
        print(f"{'Condition':<28} | {'Corridor (0.4-0.6)':<22} | {'Gain':<22} | {'Tracking |b-th|':<22} | {'Frustration':<12}")
        print("-" * 115)
        # MAP-CAT sweep
        for w in windows:
            label = "Full MAP-CAT (W=inf)" if w is None else f"Windowed MAP-CAT (W={w})"
            r = run_cohort("MAP_CAT", eta=eta, window=w)
            print(f"{label:<28} | {fmt(r['corridor']):<22} | {fmt(r['gain']):<22} | {fmt(r['tracking']):<22} | {r['frustration'][0]:.3f}")
        print("-" * 115)
        # Staircase sweep
        for s in steps:
            label = f"Staircase (step={s:.2f})"
            r = run_cohort("Staircase", eta=eta, step_size=s)
            print(f"{label:<28} | {fmt(r['corridor']):<22} | {fmt(r['gain']):<22} | {fmt(r['tracking']):<22} | {r['frustration'][0]:.3f}")

    print("\n" + "=" * 100)
    print("EXPERIMENT B: MILD PULLBACK TEST (kappa in [0.0, 0.02, 0.05, 0.10, 0.20, 0.44] with s=0.15)")
    print("=" * 100)
    kappas = [0.0, 0.02, 0.05, 0.10, 0.20, 0.44]
    for eta in [0.02, 0.10]:
        print(f"\n--- Pullback Sweep with Calibrated Step (s = 0.15) at eta = {eta:.2f} ---")
        print(f"{'Condition':<25} | {'Corridor (0.4-0.6)':<22} | {'Gain':<22} | {'Tracking |b-th|':<22} | {'Frustration':<12}")
        print("-" * 115)
        for k in kappas:
            label = f"LeakyStair (k={k:.2f})"
            r = run_cohort("LeakyStaircase", eta=eta, step_size=0.15, kappa=k)
            print(f"{label:<25} | {fmt(r['corridor']):<22} | {fmt(r['gain']):<22} | {fmt(r['tracking']):<22} | {r['frustration'][0]:.3f}")

    print("\n" + "=" * 100)
    print("EXPERIMENT C: ISOLATED STATE-JUMP SAFEGUARD (+J: Drop after 4 consecutive fails)")
    print("=" * 100)
    jump_tests = [
        ("Staircase (s=0.15)", "Staircase", {"step_size": 0.15, "has_jump": False}),
        ("Staircase+J (s=0.15)", "Staircase", {"step_size": 0.15, "has_jump": True}),
        ("Staircase (s=0.50)", "Staircase", {"step_size": 0.50, "has_jump": False}),
        ("Staircase+J (s=0.50)", "Staircase", {"step_size": 0.50, "has_jump": True}),
        ("PFP-Core (k=0.44)", "PFP", {"kappa": 0.44, "has_jump": False}),
        ("PFP-Core+J (k=0.44)", "PFP", {"kappa": 0.44, "has_jump": True}),
    ]
    for eta in [0.02, 0.10]:
        print(f"\n--- Jump Safeguard (+J) Isolation at eta = {eta:.2f} ---")
        print(f"{'Condition':<25} | {'Corridor':<12} | {'Gain':<12} | {'Frustration':<12} | {'Max Consecutive Fails':<24} | {'Jumps Triggered':<16}")
        print("-" * 115)
        for label, arm, kw in jump_tests:
            r = run_cohort(arm, eta=eta, **kw)
            print(f"{label:<25} | {r['corridor'][0]:<12.3f} | {r['gain'][0]:<12.3f} | {r['frustration'][0]:<12.3f} | {r['max_fails'][0]:<24.2f} | {r['jumps'][0]:<16.2f}")

if __name__ == "__main__":
    main()
