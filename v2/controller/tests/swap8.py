import sys, itertools, numpy as np, io, contextlib
sys.path.insert(0, "."); sys.path.insert(0, "scripts")
from werr import WerrEngine, NoulQuestion, ChoiceQuestion, ScoreQuestion
import test_100_questions as T
sc = T.build_scenarios(batch=2)
print("scenarios:", len(sc), "| keys:", list(sc[0].keys()))
def qtype(q): return "noul" if isinstance(q, NoulQuestion) else "choice" if isinstance(q, ChoiceQuestion) else "score"
def answers(engine):
    out = []
    for s in sc:
        with contextlib.redirect_stdout(io.StringIO()):
            r = engine.decide(s["state"], s["questions"])
        for k, q in s["questions"].items():
            a = r.answers.get(k)
            v = getattr(a, "decision", None) if qtype(q) == "noul" else getattr(a, "choice", None) if qtype(q) == "choice" else getattr(a, "level", None)
            out.append((qtype(q), v))
    return out
ALT = [(-0.1, 0.8, 10.0), (0.3, 0.0, 3.0), (-2.5, 2.5, 1.0), (0.0, 0.0, 1.0), (-1.4, 0.0, 200.0)]   # incl. all-outside and all-inside windows
print(f"{'domain':7}{'lexical':8}{'reson.':7} | share of answers unchanged when the seed is moved (mean over 5 alternative seeds)")
for dom, lex, res in itertools.product([False, True], repeat=3):
    mk = lambda **kw: WerrEngine(resolution=32, max_iter=35, enable_domain=dom, enable_lexical=lex, enable_resonance=res, **kw)
    try:
        base = answers(mk())
        agree = {}
        for cx, cy, z in ALT:
            alt = answers(mk(base_cx=cx, base_cy=cy, base_zoom=z))
            for (t, a), (_, b) in zip(base, alt): agree.setdefault(t, []).append(a == b)
        n = {t: sum(1 for x, _ in base if x == t) for t in agree}
        print(f"{str(dom):7}{str(lex):8}{str(res):7} | " + " | ".join(f"{t}: {100*np.mean(v):5.1f}% (n={n[t]})" for t, v in sorted(agree.items())))
    except Exception as e:
        print(dom, lex, res, "ERROR", repr(e)[:150])
