#!/usr/bin/env bash
# Read the key log from the left half (flashed with ./flash.sh log, plugged in by USB).
# Every line gets the wall-clock time, so a glitch can be matched to when you saw it.
# It records everything you type, passwords included: delete the file when done.
set -euo pipefail
out=${1:-$HOME/keylog.txt}
dev=$(ls /dev/cu.usbmodem* | head -1)
echo "Logging $dev to $out (Ctrl-C to stop)"
while IFS= read -r line; do printf '%s %s\n' "$(date +%T)" "$line"; done < "$dev" | tee -a "$out"
