"""
sim_claude_3exp.py
==================
Executes the 3 proposed experiments from Claude's review:
  Exp 1: Pullback sweep (kappa in [0.44, 0.22, 0.10, 0.05, 0.0]) for PFP-Core
         - At kappa = 0.0, PFP-Core becomes an unconstrained 1-up/1-down staircase.
  Exp 2: Explicit Elo benchmark arm (K = 0.30) vs true MAP/MLE CAT.
  Exp 3: Non-stationarity / fast-learning stress test (eta in [0.02, 0.05, 0.10])
         comparing MLE-CAT, Elo, PFP-Core (kappa=0.44), and Pure Staircase (kappa=0.0).

Follows exact 5-seed protocol (42, 137, 369, 1024, 2026; N=1,000 learners, T=120).
"""

import math
import numpy as np
import scipy.stats as stats

SEEDS = [42, 137, 369, 1024, 2026]
N_PER_SEED = 200
TOTAL_N = len(SEEDS) * N_PER_SEED  # 1,000 learners
T_STEPS = 120

def logistic(x):
    return 1.0 / (1.0 + np.exp(-np.clip(x, -30, 30)))

def logit(p):
    return math.log(p / (1.0 - p))

def solve_map_theta(b_hist, y_hist, prior_mean=0.0, prior_sd=1.0, max_iter=15, tol=1e-4):
    """
    Computes MAP estimate of theta given item difficulties and responses so far.
    Prior: N(prior_mean, prior_sd^2).
    """
    t = len(b_hist)
    if t == 0:
        return prior_mean
    
    b_arr = np.array(b_hist)
    y_arr = np.array(y_hist)
    prior_var = prior_sd ** 2
    
    # Start at current mean or 0
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

def simulate_student(seed, student_idx, arm, rule, eta=0.02, p_target=0.50, kappa=0.44, K=0.30, beta=10.0, delta=0.05):
    """
    Simulates a single student for T_STEPS under a given arm and learning rule.
    """
    rng = np.random.default_rng(seed * 10000 + student_idx)
    theta0 = rng.normal(0.0, 1.0)
    U = rng.random(T_STEPS)
    sat_diffs = np.random.default_rng(seed * 10000 + student_idx + 9999).uniform(-3.0, 3.0, T_STEPS)
    
    theta = theta0
    b_hist = []
    y_hist = []
    P_hist = []
    track_hist = []
    
    # State variables
    c = complex(0.25, 0.18)
    X = complex(0.25, 0.18)
    th_hat_elo = 0.0
    th_hat_map = 0.0
    staircase_b = 0.0
    
    off = logit(p_target)
    
    for t in range(T_STEPS):
        if arm == "Saturn":
            b = sat_diffs[t]
        elif arm == "Factory":
            b = -1.0 + 0.01 * t
        elif arm == "PFP":
            # PFP-Core leaky integrator
            b = beta * (c - X).real
        elif arm == "Staircase":
            # Pure 1-up / 1-down staircase (kappa = 0)
            b = staircase_b
        elif arm == "Elo":
            b = th_hat_elo - off
        elif arm == "MAP_CAT":
            b = th_hat_map - off
        else:
            raise ValueError(f"Unknown arm: {arm}")
            
        p = logistic(theta - b)
        y = 1 if U[t] < p else 0
        
        b_hist.append(b)
        y_hist.append(y)
        P_hist.append(p)
        track_hist.append(abs(b - theta))
        
        # Updates
        if arm == "PFP":
            dc = delta if y == 1 else -delta
            c = c + dc - kappa * (c - X)
        elif arm == "Staircase":
            step = beta * delta  # = 10 * 0.05 = 0.50
            if y == 1:
                staircase_b += step
            else:
                staircase_b -= step
        elif arm == "Elo":
            p_pred = logistic(th_hat_elo - b)
            th_hat_elo += K * (y - p_pred)
        elif arm == "MAP_CAT":
            th_hat_map = solve_map_theta(b_hist, y_hist)
            
        # Learner updates
        if rule == "Rule 1":
            theta = theta + (eta if y == 1 else -eta)
        elif rule == "Rule 2":
            theta = theta + (eta * (1.0 - p) if y == 1 else 0.0)
            
    P_arr = np.array(P_hist)
    return {
        "theta0": theta0,
        "theta_final": theta,
        "gain": theta - theta0,
        "mean_p": np.mean(P_arr),
        "corridor_40_60": np.mean((P_arr >= 0.40) & (P_arr <= 0.60)),
        "zpd_50_70": np.mean((P_arr >= 0.50) & (P_arr <= 0.70)),
        "frustration": np.mean(P_arr < 0.30),
        "boredom": np.mean(P_arr > 0.85),
        "tracking": np.mean(track_hist),
    }

def run_cohort(arm, rule, eta=0.02, p_target=0.50, kappa=0.44, K=0.30, beta=10.0, delta=0.05):
    results = []
    for seed in SEEDS:
        for idx in range(N_PER_SEED):
            res = simulate_student(seed, idx, arm, rule, eta=eta, p_target=p_target, 
                                   kappa=kappa, K=K, beta=beta, delta=delta)
            results.append(res)
            
    # Compute summary means and 95% CIs
    summary = {}
    for key in ["gain", "corridor_40_60", "zpd_50_70", "frustration", "boredom", "tracking", "mean_p"]:
        vals = [r[key] for r in results]
        m = np.mean(vals)
        sem = stats.sem(vals)
        ci = 1.96 * sem
        summary[key] = (m, m - ci, m + ci)
    return summary

def format_cell(tup):
    m, lo, hi = tup
    return f"{m:.3f} [{lo:.3f}, {hi:.3f}]"

def main():
    print("=" * 80)
    print("EXPERIMENT 1: Pullback sweep (kappa in [0.44, 0.22, 0.10, 0.05, 0.0])")
    print("Testing if removing pullback allows PFP to track theta freely and approach CAT")
    print("=" * 80)
    kappas = [0.44, 0.22, 0.10, 0.05, 0.0]
    for rule in ["Rule 2", "Rule 1"]:
        print(f"\n--- {rule} (eta = 0.02) ---")
        print(f"{'Condition':<20} | {'Corridor (0.4-0.6)':<22} | {'ZPD (0.5-0.7)':<22} | {'Frustration (<0.3)':<22} | {'Gain':<22} | {'Tracking |b-th|':<22}")
        print("-" * 135)
        for k in kappas:
            if k == 0.0:
                s = run_cohort("Staircase", rule, eta=0.02)
                label = f"Staircase (k=0)"
            else:
                s = run_cohort("PFP", rule, eta=0.02, kappa=k)
                label = f"PFP (k={k})"
            print(f"{label:<20} | {format_cell(s['corridor_40_60']):<22} | {format_cell(s['zpd_50_70']):<22} | {format_cell(s['frustration']):<22} | {format_cell(s['gain']):<22} | {format_cell(s['tracking']):<22}")
            
    print("\n" + "=" * 80)
    print("EXPERIMENT 2: Elo benchmark vs MAP CAT (P* = 0.50, 0.70, 0.85 under Rule 2)")
    print("=" * 80)
    print(f"{'Model & Target':<25} | {'Corridor (0.4-0.6)':<22} | {'ZPD (0.5-0.7)':<22} | {'Frustration (<0.3)':<22} | {'Gain':<22} | {'Tracking |b-th|':<22}")
    print("-" * 140)
    models = [
        ("Elo (P*=0.50, K=0.30)", "Elo", 0.50, 0.30),
        ("MAP_CAT (P*=0.50)", "MAP_CAT", 0.50, 0.0),
        ("Elo (P*=0.70, K=0.30)", "Elo", 0.70, 0.30),
        ("MAP_CAT (P*=0.70)", "MAP_CAT", 0.70, 0.0),
        ("Elo (P*=0.85, K=0.30)", "Elo", 0.85, 0.30),
        ("MAP_CAT (P*=0.85)", "MAP_CAT", 0.85, 0.0),
        ("PFP-Core (k=0.44)", "PFP", 0.50, 0.0),
        ("Pure Staircase (k=0.0)", "Staircase", 0.50, 0.0),
    ]
    for label, arm, pt, K in models:
        if arm == "PFP":
            s = run_cohort("PFP", "Rule 2", eta=0.02, kappa=0.44)
        elif arm == "Staircase":
            s = run_cohort("Staircase", "Rule 2", eta=0.02)
        else:
            s = run_cohort(arm, "Rule 2", eta=0.02, p_target=pt, K=K)
        print(f"{label:<25} | {format_cell(s['corridor_40_60']):<22} | {format_cell(s['zpd_50_70']):<22} | {format_cell(s['frustration']):<22} | {format_cell(s['gain']):<22} | {format_cell(s['tracking']):<22}")

    print("\n" + "=" * 80)
    print("EXPERIMENT 3: Non-stationarity Stress Test (eta in [0.02, 0.05, 0.10])")
    print("Testing if rapid learning violates MLE CAT stationarity while reactive servos hold up")
    print("=" * 80)
    etas = [0.02, 0.05, 0.10]
    exp3_arms = [
        ("MAP_CAT (P*=0.50)", "MAP_CAT", 0.50),
        ("Elo (P*=0.50, K=0.30)", "Elo", 0.50),
        ("PFP-Core (k=0.44)", "PFP", 0.50),
        ("Pure Staircase (k=0.0)", "Staircase", 0.50),
    ]
    for eta in etas:
        print(f"\n--- Learning Rate eta = {eta:.2f} (Rule 2) ---")
        print(f"{'Model':<25} | {'Corridor (0.4-0.6)':<22} | {'Gain':<22} | {'Tracking |b-th|':<22} | {'Frustration (<0.3)':<22}")
        print("-" * 115)
        for label, arm, pt in exp3_arms:
            if arm == "PFP":
                s = run_cohort("PFP", "Rule 2", eta=eta, kappa=0.44)
            elif arm == "Staircase":
                s = run_cohort("Staircase", "Rule 2", eta=eta)
            else:
                s = run_cohort(arm, "Rule 2", eta=eta, p_target=pt, K=0.30)
            print(f"{label:<25} | {format_cell(s['corridor_40_60']):<22} | {format_cell(s['gain']):<22} | {format_cell(s['tracking']):<22} | {format_cell(s['frustration']):<22}")

if __name__ == "__main__":
    main()
