import sys, io, contextlib, numpy as np, random
sys.path.insert(0, "."); sys.path.insert(0, "scripts")
from werr import WerrEngine, NoulQuestion, ChoiceQuestion, ScoreQuestion
from werr.gates import DOMAIN_GATES
import test_100_questions as T, genetic_seed_optimizer as G
sc = T.build_scenarios(batch=2)
e0 = WerrEngine(resolution=32, max_iter=35)
print("default engine: mode =", e0.mode, "| domain =", e0.enable_domain, "| lexical =", getattr(e0, "enable_lexical", None), "| resonance =", getattr(e0, "enable_resonance", None))
def qtype(q): return "noul" if isinstance(q, NoulQuestion) else "choice" if isinstance(q, ChoiceQuestion) else "score"
def answers(**kw):
    e = WerrEngine(resolution=32, max_iter=35, **kw); out = []
    for s in sc:
        with contextlib.redirect_stdout(io.StringIO()): r = e.decide(s["state"], s["questions"])
        for k, q in s["questions"].items():
            a = r.answers.get(k); out.append((qtype(q), getattr(a, "decision", None) if qtype(q) == "noul" else getattr(a, "choice", None) if qtype(q) == "choice" else getattr(a, "level", None)))
    return out
orig = {n: (c.cx, c.cy, c.zoom) for n, c in DOMAIN_GATES.items()}
ALT = [(-0.1, 0.8, 10.0), (0.3, 0.0, 3.0), (-2.5, 2.5, 1.0), (0.0, 0.0, 1.0), (-1.4, 0.0, 200.0)]
for label, kw in [("default engine", {}), ("domain + lexical", dict(enable_domain=True, enable_lexical=True)), ("domain only", dict(enable_domain=True, enable_lexical=False, enable_resonance=False))]:
    base = answers(**kw); agree = {}
    for cx, cy, z in ALT:
        for c in DOMAIN_GATES.values(): c.cx, c.cy, c.zoom = cx, cy, z
        alt = answers(base_cx=cx, base_cy=cy, base_zoom=z, **kw)
        for n, c in DOMAIN_GATES.items(): c.cx, c.cy, c.zoom = orig[n]
        for (t, a), (_, b) in zip(base, alt): agree.setdefault(t, []).append(a == b)
    print(f"{label:18} gate seeds AND engine seed moved -> unchanged: " + " | ".join(f"{t} {100*np.mean(v):.1f}%" for t, v in sorted(agree.items())))

# accuracy against the repo's own labelled items (scripts/genetic_seed_optimizer.py, 34 items)
QS = {"financial_risk": "Approve credit facility?", "iot_safety": "Hazard alert detected?", "ecommerce_fraud": "Flag suspicious fraud transaction?", "game_combat": "Engage enemy target?"}
items = [(d, it["state"], it["expected"]) for d, L in G.DOMAIN_GROUND_TRUTHS.items() for it in L]
def acc(**kw):
    e = WerrEngine(resolution=32, max_iter=35, **kw); ok = 0
    for d, st, exp in items:
        with contextlib.redirect_stdout(io.StringIO()): r = e.decide(st, {"q": NoulQuestion(instructions=QS[d])})
        ok += (r.answers["q"].decision == exp)
    return ok / len(items)
print(f"\nlabelled items: {len(items)} (share with expected=True: {np.mean([x[2] for x in items]):.2f})")
print(f"default engine accuracy: {acc():.3f}")
print(f"domain + lexical       : {acc(enable_domain=True, enable_lexical=True):.3f}")
pure = dict(enable_domain=False, enable_lexical=False, enable_resonance=False)
print(f"pure fractal, shipped seed: {acc(**pure):.3f}")
random.seed(7); rs = [acc(base_cx=random.uniform(-2, 0.5), base_cy=random.uniform(-1.2, 1.2), base_zoom=float(np.exp(random.uniform(0, 6))), **pure) for _ in range(40)]
print(f"pure fractal, 40 random seeds: mean {np.mean(rs):.3f}, min {min(rs):.3f}, max {max(rs):.3f}")
lex = dict(enable_domain=False, enable_lexical=True, enable_resonance=False)
print(f"lexical only (no domain), shipped seed: {acc(**lex):.3f}")
