"""
WerreduR: Confidential Academic Embargo Vault Tool
Provides AES-256 authenticated encryption/decryption for confidential manuscripts,
referee defense reports, and journal submission forms directly within the repository.

Usage:
    python tools/vault.py lock [--passphrase PASS]
    python tools/vault.py unlock [--passphrase PASS]
"""

import os
import sys
import argparse
import zipfile
import base64
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives.kdf.pbkdf2 import PBKDF2HMAC
from cryptography.fernet import Fernet

DEFAULT_SALT = b"WerreduR_Academic_Embargo_Salt_2026"
DEFAULT_PASSPHRASE = "TR2026/016285"
VAULT_ENC_PATH = os.path.join("embargo", "academic_vault.enc")

INTERNAL_FILES = [
    "docs/Hakem_Elestirisi_Cozum_ve_Revizyon_Raporu.pdf",
    "docs/WerreduR_Simulasyon_Karsilastirma_ve_Stratejik_Yol_Haritasi_Raporu.pdf",
    "docs/WerreduR_Stratejik_Analiz_ve_GitHub_Yol_Haritasi.pdf",
    "docs/manuscript/Cover_Letter.docx",
    "docs/manuscript/Declaration_Statement.docx",
    "docs/manuscript/Highlights.docx",
    "docs/manuscript/Manuscript.docx",
    "docs/manuscript/Supplementary_Material.docx",
    "docs/manuscript/Title_Page.docx",
    "legacy/docs/CAEAI_Hakem_Elestirisi_Cozum_ve_Revizyon_Raporu.pdf",
    "legacy/docs/WerreduR_Simulasyon_Karsilastirma_ve_Stratejik_Yol_Haritasi_Raporu.pdf",
    "legacy/docs/WerreduR_Stratejik_Analiz_ve_GitHub_Yol_Haritasi.pdf",
    "legacy/BULGULAR_OZETI_edu.md",
    "legacy/HAKEM_SAVUNMASI_ZPD_GEOMETRI_REBUTTAL.html",
    "legacy/REVISION_NOTES_edu.md",
    "legacy/ZENODO_ARXIV_Q1_YUKLEME_REHBERI.md",
    "legacy/latex/main_edu_revision.pdf",
    "ARXIV_V4_YUKLEME_REHBERI.md",
    "releases/arxiv_submission_pfp_v4.zip",
    "legacy/zenodo_dist/arxiv_submission_pfp_v1.zip",
    "legacy/zenodo_dist/arxiv_submission_pfp_v4.zip",
    "arxiv_pfp_v4",
]


def derive_key(passphrase: str) -> bytes:
    kdf = PBKDF2HMAC(
        algorithm=hashes.SHA256(),
        length=32,
        salt=DEFAULT_SALT,
        iterations=480000,
    )
    return base64.urlsafe_b64encode(kdf.derive(passphrase.encode("utf-8")))


def lock_vault(passphrase: str):
    os.makedirs("embargo", exist_ok=True)
    temp_zip = os.path.join("embargo", "_temp_vault.zip")
    
    count = 0
    with zipfile.ZipFile(temp_zip, "w", zipfile.ZIP_DEFLATED) as zf:
        for rel in INTERNAL_FILES:
            if os.path.exists(rel):
                if os.path.isdir(rel):
                    for root, _, files in os.walk(rel):
                        for f in files:
                            fpath = os.path.join(root, f)
                            zf.write(fpath, fpath)
                            count += 1
                else:
                    zf.write(rel, rel)
                    count += 1
            else:
                print(f"[!] Warning: Missing {rel}")
                
    if count == 0:
        print("[-] Error: No internal documents found to encrypt.")
        if os.path.exists(temp_zip):
            os.remove(temp_zip)
        return False

    with open(temp_zip, "rb") as f:
        data = f.read()
    os.remove(temp_zip)

    key = derive_key(passphrase)
    fernet = Fernet(key)
    encrypted = fernet.encrypt(data)

    with open(VAULT_ENC_PATH, "wb") as f:
        f.write(encrypted)

    print(f"[+] Successfully locked {count} files into {VAULT_ENC_PATH} ({len(encrypted)} bytes).")
    return True


def unlock_vault(passphrase: str):
    if not os.path.exists(VAULT_ENC_PATH):
        print(f"[-] Error: Vault file {VAULT_ENC_PATH} not found.")
        return False

    with open(VAULT_ENC_PATH, "rb") as f:
        encrypted = f.read()

    try:
        key = derive_key(passphrase)
        fernet = Fernet(key)
        decrypted = fernet.decrypt(encrypted)
    except Exception as e:
        print("[-] Decryption failed: Invalid passphrase or corrupted vault.")
        return False

    temp_zip = os.path.join("embargo", "_temp_unlocked.zip")
    with open(temp_zip, "wb") as f:
        f.write(decrypted)

    with zipfile.ZipFile(temp_zip, "r") as zf:
        zf.extractall(".")
    os.remove(temp_zip)

    print(f"[+] Successfully unlocked and extracted all confidential documents into workspace.")
    return True


def main():
    parser = argparse.ArgumentParser(description="WerreduR Academic Embargo Vault Tool")
    parser.add_argument("action", choices=["lock", "unlock"], help="lock (encrypt) or unlock (decrypt) the vault")
    parser.add_argument("--passphrase", "-p", default=DEFAULT_PASSPHRASE, help="Vault passphrase (default: Patent Priority No)")
    args = parser.parse_args()

    if args.action == "lock":
        lock_vault(args.passphrase)
    elif args.action == "unlock":
        unlock_vault(args.passphrase)


if __name__ == "__main__":
    main()
