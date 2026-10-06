"""Does the fractal seed change WERR's own decisions? Usage: python werr_seed_swap_test.py /path/to/werr"""
import sys, random, numpy as np
sys.path.insert(0, sys.argv[1])
from werr.gates.game_combat import GameCombatGate
from werr.datatypes import NoulQuestion, ChoiceQuestion, ScoreQuestion
random.seed(1)
def mk(): return dict(health_pct=random.choice([10,30,45,60,90]), ammo_pct=random.choice([0,3,40]),
                      enemy_count=random.choice([1,2,5]), has_cover=random.random()<.5, under_fire=random.random()<.5)
states = [mk() for _ in range(200)]
qs = {"noul_deny": NoulQuestion(instructions="Retreat now? danger"),
      "noul_allow": NoulQuestion(instructions="Engage allowed?"),
      "choice_4tier": ChoiceQuestion(instructions="pick", criteria={"engage":"fight","take_cover":"cover","manual_review":"call","evacuate":"run"}),
      "choice_free": ChoiceQuestion(instructions="pick", criteria={"alpha":"x","beta":"y","gamma":"z"}),
      "score": ScoreQuestion(instructions="threat", criteria=["low","mid","high"])}
def run(cx, cy, zoom):
    out = []
    for s in states:
        a = GameCombatGate(cx=cx, cy=cy, zoom=zoom).evaluate_state_and_questions(s, qs).answers
        out.append((a["noul_deny"].decision, a["noul_allow"].decision, a["choice_4tier"].choice, a["choice_free"].choice, a["score"].level))
    return out
base = run(-0.7445, 0.125, 65.0)
for alt in [(-0.1,0.8,10.0), (0.3,0.0,3.0), (-2.5,2.5,1.0), (0.0,0.0,1.0), (-0.75,0.1,500.0)]:
    o = run(*alt)
    print(alt, {n: round(float(np.mean([b[i]==c[i] for b,c in zip(base,o)])),3) for i,n in enumerate(qs)})
