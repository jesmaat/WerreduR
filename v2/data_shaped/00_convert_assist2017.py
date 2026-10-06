"""Converts the ASSISTments 2017 files distributed with github.com/arghosh/AKT to long format.
Usage: python 00_convert_assist2017.py <AKT/data/assist2017_pid> <out.csv>
Each learner occupies four lines: header, problem ids, skill ids, answers.
Learners are numbered from 1 in file order train1, valid1, test1 (together: all learners once).
Expected output: 942,816 rows, 1,709 learners, 102 skills."""
import csv, sys
src, out = sys.argv[1], sys.argv[2]
rows, uid = [], 0
for part in ("train1", "valid1", "test1"):
    L = open(f"{src}/assist2017_pid_{part}.csv").read().strip().split("\n")
    assert len(L) % 4 == 0
    for i in range(0, len(L), 4):
        pid, sk, ans = L[i + 1].split(","), L[i + 2].split(","), L[i + 3].split(",")
        assert len(pid) == len(sk) == len(ans)
        uid += 1
        rows += [(uid, t, p, s, int(a)) for t, (p, s, a) in enumerate(zip(pid, sk, ans))]
with open(out, "w", newline="") as f:
    w = csv.writer(f); w.writerow(["user_id", "t", "problem_id", "skill_id", "correct"]); w.writerows(rows)
print(len(rows), "rows;", uid, "learners;", len({r[3] for r in rows}), "skills")
assert len(rows) == 942816 and uid == 1709
