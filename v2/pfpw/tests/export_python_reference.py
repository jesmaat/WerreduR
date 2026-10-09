"""Exports reference tripod outputs from the ORIGINAL Python WERR for parity testing."""
import sys, csv, numpy as np
sys.path.insert(0, sys.argv[1])
from werr.fractal import compute_mandelbrot_patch, extract_bounded_quadrant_weights
rng = np.random.default_rng(2026)
rows = []
seeds = [(-0.7436438870371587, 0.1318259042053119, 50.0), (-0.7445, 0.125, 65.0),
         (-0.748, 0.065, 60.0), (-0.745, 0.112, 85.0), (-0.7495, 0.082, 70.0)]
for _ in range(195):
    seeds.append((rng.uniform(-1.9, 0.5), rng.uniform(-1.1, 1.1), float(np.exp(rng.uniform(0, 7)))))
for cx, cy, zoom in seeds:
    fq = np.zeros(4); fb = 0.0
    for zf, wz in [(0.60, 0.25), (1.00, 0.50), (1.60, 0.25)]:
        b, a, esc = compute_mandelbrot_patch(cx, cy, zoom * zf, res=36, max_iter=36)
        *_, q = extract_bounded_quadrant_weights(esc, max_iter=36, bandwidth=0.12)
        fq += wz * np.array(q); fb += wz * b
    rows.append([repr(cx), repr(cy), repr(zoom)] + [repr(float(v)) for v in fq] + [repr(float(fb))])
with open(sys.argv[2], "w", newline="") as f:
    w = csv.writer(f); w.writerow(["cx", "cy", "zoom", "q1", "q2", "q3", "q4", "black"]); w.writerows(rows)
