#!/usr/bin/env bash
set -Eeuo pipefail
# Revisão auditada/pinada: sem puxar mudanças novas automaticamente.
UPSTREAM_SHA="424cfcc9a559da87847575bbfb5c0e780847d25f"
WORK="${RUNNER_TEMP:-/tmp}/aria-vet-atlas"
rm -rf "$WORK"
git clone --no-checkout --filter=blob:none https://github.com/Ketbome/vet-atlas.git "$WORK"
git -C "$WORK" fetch --no-tags --depth=1 origin "$UPSTREAM_SHA"
git -C "$WORK" checkout --detach "$UPSTREAM_SHA"
test "$(git -C "$WORK" rev-parse HEAD)" = "$UPSTREAM_SHA"
cp "$GITHUB_WORKSPACE/atlas-integration/aria-theme.css" "$WORK/aria-world-theme.css"
# A folha de estilos original permanece, acrescida de cores somente na camada UI.
cat "$WORK/aria-world-theme.css" >> "$WORK/app/globals.css"
# Mantém o cabeçalho original do Atlas, adicionando retorno ao Aria World.
python3 - "$WORK" <<'PY'
import sys
from pathlib import Path
p=Path(sys.argv[1])/'components/atlas/site-header.tsx'
s=p.read_text()
anchor='        <FeedbackButton />'
assert s.count(anchor)==1, "Cabeçalho do Atlas mudou; atualize o patch explicitamente."
s=s.replace(anchor,'''        <a href="/" className="hidden sm:inline-flex items-center rounded-md border border-border px-3 py-2 text-xs font-medium text-foreground hover:bg-muted" aria-label="Voltar ao Aria World">← Aria World</a>
        <FeedbackButton />''')
p.write_text(s)
PY
cd "$WORK"
export NEXT_PUBLIC_BASE_PATH="/atlas"
export NEXT_PUBLIC_SITE_URL="https://ariaverso.pages.dev/atlas"
pnpm install --frozen-lockfile
pnpm build
test -s out/index.html
test -d out/_next
for animal in dog cat cow horse; do
 for system in skeletal muscular visceral integumentary; do
  test -s "out/models/$animal/$system.glb" || { echo "::error::Faltou out/models/$animal/$system.glb"; exit 1; }
 done
done
cp LICENSE out/LICENSE.txt
cp LICENSE-CONTENT.md out/LICENSE-CONTENT.md
cp content/sources.json out/SOURCES.json
cat > out/UPSTREAM.txt <<EOF
Vet Atlas upstream: https://github.com/Ketbome/vet-atlas
Revision: $UPSTREAM_SHA
Code: MIT. Written content: CC BY-SA 4.0.
Individual assets: consult SOURCES.json and in-page attribution.
These anatomical models are for study, not diagnostic use.
EOF
echo "Atlas compilado com 16 GLBs e páginas Next.js exportadas."
