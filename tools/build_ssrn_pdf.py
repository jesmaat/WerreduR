#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
SSRN Camera-Ready Academic PDF Builder for Procedural Fractal Pedagogy (WerreduR)
Builds the official SSRN preprint version based on Zenodo v4.0 / Concept DOI: 10.5281/zenodo.22999420.
"""

import os
import subprocess
import shutil

BASE_DIR = r"C:\Users\maat\Desktop\WerreduR_git"
BUILD_SCRIPT = os.path.join(BASE_DIR, "legacy", "sim", "build_camera_ready_pdf.py")
ORIG_HTML = os.path.join(BASE_DIR, "legacy", "latex", "camera_ready_manuscript.html")
HTML_OUT = os.path.join(BASE_DIR, "legacy", "latex", "camera_ready_manuscript_ssrn.html")
PDF_RELEASE = os.path.join(BASE_DIR, "releases", "Procedural_Fractal_Pedagogy_SSRN_Preprint.pdf")
PDF_ROOT = os.path.join(BASE_DIR, "Procedural_Fractal_Pedagogy_SSRN_Preprint.pdf")

namespace = {
    "os": os,
    "base64": __import__("base64"),
    "__file__": BUILD_SCRIPT
}
with open(BUILD_SCRIPT, "r", encoding="utf-8") as f:
    code = f.read()
exec(compile(code, BUILD_SCRIPT, 'exec'), namespace)

# Execute build_html to generate ORIG_HTML
namespace["build_html"]()

with open(ORIG_HTML, "r", encoding="utf-8") as f:
    html = f.read()

# Apply SSRN-specific neutral & open-science metadata replacements
html = html.replace(
    '<div><strong>ZENODO / arXiv SEED PREPRINT</strong> &bull; Target Q1 Venue: <em>Computers &amp; Education: Artificial Intelligence</em> (Elsevier)</div>',
    '<div><strong>ZENODO / SSRN OPEN-SCIENCE PREPRINT</strong> &bull; <em>Education Research Network (ERN) &bull; Cognitive Science Network (CSN)</em></div>'
)
html = html.replace(
    '<div>Priority Patent: <strong>T&Uuml;RKPATENT TR 2026/016285</strong> &bull; September 27, 2026 (v1.0)</div>',
    '<div>Priority Patent: <strong>T&Uuml;RKPATENT TR 2026/016285</strong> &bull; Zenodo: <strong>10.5281/zenodo.23128224</strong></div>'
)
html = html.replace(
    '<em>Companion Open-Science Series:</em> <code>arXiv:2609.25498</code> &bull; <code>arXiv:2609.30115</code> &bull; <code>doi:10.5281/zenodo.22774934</code> &bull; <code>doi:10.5281/zenodo.22983889</code>',
    '<em>Companion Open-Science Series:</em> <code>arXiv:2609.25498</code> &bull; <code>arXiv:2609.30115</code> &bull; SSRN: <code>7626279 (Werracle)</code> &bull; <code>doi:10.5281/zenodo.23128224</code>'
)
html = html.replace(
    '<h3>Research Highlights (Computers &amp; Education: Artificial Intelligence)</h3>',
    '<h3>Research Highlights (Procedural Fractal Pedagogy &amp; Adaptive AIED)</h3>'
)
html = html.replace(
    '<strong>Declaration of Generative AI (COPE / Elsevier Policy):</strong>',
    '<strong>Declaration of Generative AI (COPE / SSRN Open-Science Policy):</strong>'
)

with open(HTML_OUT, "w", encoding="utf-8") as f:
    f.write(html)

print(f"Generated SSRN HTML: {HTML_OUT} ({len(html):,} bytes)")

browser = r"C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
if not os.path.exists(browser):
    browser = r"C:\Program Files\Google\Chrome\Application\chrome.exe"

cmd = [
    browser,
    "--headless",
    "--disable-gpu",
    "--no-pdf-header-footer",
    f"--print-to-pdf={PDF_RELEASE}",
    f"file:///{HTML_OUT.replace(os.sep, '/')}",
]

subprocess.run(cmd, check=True)
shutil.copyfile(PDF_RELEASE, PDF_ROOT)

print(f"[+] Successfully generated SSRN Camera-Ready PDF:")
print(f"    - {PDF_RELEASE} ({os.path.getsize(PDF_RELEASE):,} bytes)")
print(f"    - {PDF_ROOT} ({os.path.getsize(PDF_ROOT):,} bytes)")
