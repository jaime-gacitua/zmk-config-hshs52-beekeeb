This is an example ZMK configuration for HSHS52 and HSHS46. This configuration is based on the [Hillside ZMK config by mmccoyd](https://github.com/mmccoyd/zmk-config).

## Keymap

![HSHS52 keymap](keymap-drawer/hshs52.svg)

Redrawn automatically by [keymap-drawer](https://github.com/caksoylar/keymap-drawer) (`.github/workflows/draw.yml`) whenever the keymap changes. Small labels under a key are what it does when held.

## Workflow

- **Trying out where a key goes:** change it live in [ZMK Studio](https://zmk.studio/) (unlock: hold Nav + Sym, press X). No build or flash. Once it feels right, copy it into `hshs52.keymap`: whatever Studio saves overrides the file.
- **New behaviors** (hold-taps, macros, timings, layers): edit the keymap, batch several changes, push, then `./flash.sh`. It waits for the GitHub build (~2.5 min), downloads it, and flashes the left half (`./flash.sh both` for both).
- Run `git pull --rebase` before pushing: the keymap-drawer workflow commits the SVG back.
