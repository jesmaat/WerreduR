# Benchmark Datasets and Setup Instructions

Due to file sizes and repository licensing terms, the raw public datasets are not distributed inside this archive. They can be retrieved directly from their public open-access sources using the instructions below.

---

## 1. ASSISTments 2009–2010 Skill-Builder Dataset
* **Source:** Feng, Heffernan, & Koedinger (2009). *Addressing the assessment challenge with an online system that tutors as it assesses.* User Modeling and User-Adapted Interaction.
* **Expected Location:** `data/skill_builder_data.csv`
* **Retrieval:**
  Download `skill_builder_data.csv` from the official ASSISTments repository or public mirror (e.g., https://github.com/jhljx/GKT/raw/master/data/skill_builder_data.csv).
* **Expected Dimensions:** 525,534 total rows prior to deduplication; 312,232 clean practice responses across 123 skills.

---

## 2. ASSISTments 2017 Dataset
* **Source:** Ghosh, Heffernan, & Lan (2020). *Context-aware attentive knowledge tracing.* KDD 2020.
* **Expected Location:** `data/assist2017_long.csv`
* **Retrieval:**
  Clone the processed repository:
  ```bash
  git clone --depth 1 https://github.com/arghosh/AKT.git
  ```
  The script `replay/00_convert_assist2017.py` automatically converts the split files (`assist2017_pid_train1.csv`, `valid1.csv`, `test1.csv`) into the unified long format (`data/assist2017_long.csv`, 942,816 responses).
