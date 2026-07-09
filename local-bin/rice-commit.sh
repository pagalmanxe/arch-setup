#!/usr/bin/env bash
# rice-commit.sh — commit a rice change to BOTH testing and stable in ~/arch-setup
# and push both, so the setup is portable to other PCs.
#
# Usage: rice-commit.sh "descriptive commit message"
#   (no args -> auto message with timestamp)
#
# Invariant: testing and stable always point to the SAME commit.
set -euo pipefail

REPO="$HOME/arch-setup"
SRC="$HOME/.config"
KEY="$HOME/.ssh/arch_setup_ed25519"
export GIT_SSH_COMMAND="ssh -i $KEY -o IdentitiesOnly=yes -o StrictHostKeyChecking=accept-new"

cd "$REPO" || { echo "ERROR: $REPO not found"; exit 1; }

MSG="${1:-auto: rice change $(date '+%Y-%d %H:%M')}"

# Junk never committed (test artifacts, local backups)
JUNK=(matugen/config.test.toml matugen/templates/debug.txt '*.bak*' '*~')

# 1. Sync live ~/.config rice into the repo (repo mirrors ~/.config at root)
for d in hypr kitty waybar wofi matugen fastfetch bashrc README.md; do
  if [ -d "$SRC/$d" ]; then mkdir -p "$REPO/$d"; cp -r "$SRC/$d/." "$REPO/$d/" 2>/dev/null || true
  elif [ -f "$SRC/$d" ]; then cp "$SRC/$d" "$REPO/$d"; fi
done
# Sync helper scripts (~/.local/bin -> local-bin/ in repo)
mkdir -p "$REPO/local-bin"
for s in wp-theme.sh retheme-current.sh hermes-focus.sh; do
  [ -f "$HOME/.local/bin/$s" ] && cp "$HOME/.local/bin/$s" "$REPO/local-bin/$s"
done
# rice-commit.sh itself lives in ~/.hermes/scripts; mirror it so the repo
# is self-contained and portable to other PCs.
[ -f "$HOME/.hermes/scripts/rice-commit.sh" ] && cp "$HOME/.hermes/scripts/rice-commit.sh" "$REPO/local-bin/rice-commit.sh"

# Normalize perms so synced config files commit as 644 (not 600 from a
# restrictive live umask) and scripts as 755 — portable to other PCs.
chmod 755 "$REPO"/local-bin/* 2>/dev/null || true
find "$REPO"/fastfetch -type f -exec chmod 644 {} + 2>/dev/null || true

git fetch -q origin testing stable 2>/dev/null || true

# 2. Stage everything, then unstage known junk
git add -A
for j in "${JUNK[@]}"; do git reset -q -- "$j" 2>/dev/null || true; done

# 3. Commit dirty changes on whatever branch we're currently on (clean tree needed
#    before force-realigning branches, and this preserves in-progress edits).
if git diff --cached --quiet; then
  echo "No rice changes to commit."
else
  git commit -q -m "$MSG"
  echo "Committed on $(git branch --show-current): $MSG"
fi

# 4. Force-align both branches to current HEAD (guaranteed identical).
#    update-ref works on the currently checked-out branch too, so no checkout
#    dance and no "branch already exists" failure.
cur=$(git rev-parse HEAD)
git update-ref refs/heads/testing "$cur"
git update-ref refs/heads/stable "$cur"
echo "Aligned testing == stable == $cur"

# 5. Push both
git push -q origin testing 2>&1
git push -q origin stable 2>&1
echo "Pushed testing + stable to origin. Left on branch: $(git branch --show-current)"
