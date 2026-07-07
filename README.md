# arch-setup

My Arch Linux configuration and dotfiles.

## Contents

- `hypr/` — Hyprland (Wayland) config
- `waybar/` — status bar
- `shell/` — shell + terminal config
- `scripts/` — helper scripts

## Install

```bash
git clone git@github.com:pagalmanxe/arch-setup.git
cd arch-setup
# symlink or stow the configs you need
```

## Maintenance

End-of-day changes are committed and pushed automatically by a cron job
(`~/.hermes/scripts/eod-commit.sh`), daily at 23:30.
