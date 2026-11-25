#!/bin/bash
set -e
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
mkdir -p public/sounds
unzip -q "ea3487-Streiter_V12 Nissan SR20 Engine Sound Mod.zip" -d "$tmp/mod"
curl -fL --max-time 60 https://github.com/vgmstream/vgmstream/releases/latest/download/vgmstream-linux-cli.zip -o "$tmp/vgm.zip"
unzip -q "$tmp/vgm.zip" -d "$tmp/vgm"
cli=$(find "$tmp/vgm" -type f -name vgmstream-cli | head -1)
chmod +x "$cli"
export LD_LIBRARY_PATH="$(dirname "$cli"):${LD_LIBRARY_PATH:-}"
for f in $(find "$tmp/mod" -name '*.awc'); do
  "$cli" -m "$f" || true
  "$cli" -S 0 -o "public/sounds/$(basename "$f" .awc)_?s.wav" "$f" || true
done
ls -lh public/sounds
