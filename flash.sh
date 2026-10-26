#!/usr/bin/env bash
# Wait for the GitHub build of the current commit, download it, and flash it.
# Usage: ./flash.sh [left|right|both]
# Default is left: keymap changes (layers, hold-taps, combos) live on the left/central half.
set -euo pipefail

side=${1:-left}
vol=/Volumes/NICENANO
sha=$(git rev-parse HEAD)
# Tell gh which repo to use (owner/name from origin), so no `gh repo set-default` is needed.
GH_REPO=$(git remote get-url origin | sed -E 's#^.*github\.com[:/]##; s#\.git$##')
export GH_REPO

# The run can take a few seconds to appear after a push.
for _ in $(seq 30); do
  run=$(gh run list --commit "$sha" --limit 1 --json databaseId --jq '.[0].databaseId // empty')
  [ -n "$run" ] && break
  sleep 2
done
[ -n "${run:-}" ] || { echo "No build found for $sha. Did you push?"; exit 1; }

gh run watch "$run" --exit-status
dir=$(mktemp -d)
gh run download "$run" --dir "$dir"

flash() {
  local f
  f=$(find "$dir" -name "*_$1 *.uf2" -o -name "*_$1-*.uf2" | head -1)
  [ -n "$f" ] || { echo "No $1 firmware in build:"; find "$dir" -name '*.uf2'; exit 1; }
  echo "Plug in the $1 half and enter bootloader (double-tap reset, or &bootloader key)..."
  until [ -d "$vol" ]; do sleep 1; done
  # The drive ejects itself mid-copy when flashing finishes, so macOS may report an error here.
  cp -X "$f" "$vol/" 2>/dev/null || true
  while [ -d "$vol" ]; do sleep 1; done
  echo "$1 flashed."
}

case $side in
  left|right) flash "$side" ;;
  both) flash left; flash right ;;
  *) echo "Usage: $0 [left|right|both]"; exit 1 ;;
esac
