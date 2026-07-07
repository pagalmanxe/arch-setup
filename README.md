# arch-setup

My Arch Linux configuration and dotfiles.

## Contents

- `hypr/` — Hyprland (Wayland) config — `hyprland.lua`, `hypridle.conf`, `hyprpaper.conf`
- `waybar/` — status bar — `config.jsonc`, `style.css`
- `wofi/` — application launcher — `config`, `style.css`
- `kitty/` — terminal emulator — `kitty.conf`, `rosepine.conf` (theme), `startup.session`
- `bashrc` — shell rc (symlink to `~/.bashrc`)

Layout mirrors `~/.config/<name>` for easy `stow`-style symlinking.

## Install

```bash
git clone git@github.com:pagalmanxe/arch-setup.git
cd arch-setup
# symlink or stow the configs you need
```

## Maintenance

End-of-day changes are committed and pushed automatically by a cron job
(`~/.hermes/scripts/eod-commit.sh`), daily at 23:30.
