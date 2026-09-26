#!/usr/bin/env python3
"""Build a single combined PDF of the whole book from md/*.md.

Usage: tools/build_book.py            (writes pdf/<Book-Title>.pdf)
Needs pandoc and Chromium/Chrome (set CHROME=/path/to/chrome if not found).
"""
import glob, os, re, shutil, subprocess, sys, tempfile

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
os.chdir(ROOT)

readme = open("README.md", encoding="utf-8").read()
book_title = re.search(r"^# (.+)$", readme, re.M).group(1).strip()
intro = open(sorted(glob.glob("md/*.md"))[0], encoding="utf-8").read()
m = re.search(r'subtitle: "(.+?)"', intro)
checked = m.group(1).split("·")[1].strip() if m and "·" in m.group(1) else ""

def chrome():
    env = os.environ.get("CHROME")
    if env:
        return env
    for c in ["chromium", "chromium-browser", "google-chrome", "google-chrome-stable",
              "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome",
              "/Applications/Chromium.app/Contents/MacOS/Chromium"]:
        p = shutil.which(c) or (c if os.path.exists(c) else None)
        if p:
            return p
    sys.exit("Chromium/Chrome not found; set CHROME=/path/to/chrome")

parts = []
for f in sorted(glob.glob("md/*.md")):
    text = open(f, encoding="utf-8").read()
    fm = re.match(r"^---\n(.*?)\n---\n", text, re.S)
    body = text[fm.end():] if fm else text
    title = re.search(r'title: "(.+?)"', fm.group(1)).group(1) if fm else os.path.basename(f)
    title = re.sub(r"\s+—\s+A Readable Companion.*$", "", title)
    num = int(os.path.basename(f)[:2])
    heading = title if num == 0 else f"{num}. {title}"
    sub = re.search(r'subtitle: "(.+?)"', fm.group(1)).group(1) if fm else ""
    parts.append(f"# {heading}\n\n*{sub}*\n\n{body.strip()}\n")

front = f"""---
title: "{book_title}"
subtitle: "A readable companion to the official documentation · {checked}"
author: "Anatoly Rodionov, with Claude"
---

"""
md = front + "\n\n".join(parts)

css = open("tools/style.css", encoding="utf-8").read() + """
h1 { page-break-before: always; font-size: 20pt; margin-top: 0; }
#TOC { page-break-before: always; }
#TOC ul { list-style: none; padding-left: 0; }
#TOC li { margin: 3px 0; }
header#title-block-header { text-align: center; padding-top: 30%; }
header#title-block-header .title { font-size: 30pt; }
header#title-block-header .subtitle { font-size: 13pt; color: #555; }
header#title-block-header .author { margin-top: 40px; font-size: 12pt; }
"""
with tempfile.TemporaryDirectory() as tmp:
    src, style, html = (os.path.join(tmp, n) for n in ("book.md", "book.css", "book.html"))
    open(src, "w", encoding="utf-8").write(md)
    open(style, "w", encoding="utf-8").write(css)
    subprocess.run(["pandoc", src, "-s", "--toc", "--toc-depth=1", "--metadata=toc-title:Contents",
                    "--css", style, "--embed-resources", "--highlight-style=tango", "-o", html], check=True)
    out = os.path.join("pdf", book_title.replace(" ", "-") + ".pdf")
    subprocess.run([chrome(), "--headless", "--no-sandbox", "--disable-gpu", "--no-pdf-header-footer",
                    f"--print-to-pdf={out}", html], check=True,
                   stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
print("built", out)
