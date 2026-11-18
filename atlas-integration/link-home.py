#!/usr/bin/env python3
"""Acrescenta navegação para Atlas somente após a compilação ter sido validada."""
from pathlib import Path
p = Path("public/index.html")
html = p.read_text(encoding="utf-8")
if 'href="/atlas/"' not in html:
    library = '<a class="side-link" href="#biblioteca"><span class="ico">▤</span> Coleções</a>'
    atlas = '<a class="side-link" href="/atlas/"><span class="ico">◈</span> Atlas 3D</a>'
    if html.count(library) != 1:
        raise SystemExit("Navegação do Aria World mudou; nenhuma alteração aplicada.")
    html = html.replace(library, library + '\n ' + atlas)
    study = '<button class="btn hero-secondary" id="hero-study">▷ Começar a estudar</button>'
    atlas_cta = '<a class="btn hero-secondary" href="/atlas/">◈ Explorar Atlas 3D</a>'
    if html.count(study) != 1:
        raise SystemExit("Abertura do Aria World mudou; nenhuma alteração aplicada.")
    html = html.replace(study, study + atlas_cta)
p.write_text(html, encoding="utf-8")
