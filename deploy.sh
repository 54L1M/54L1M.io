#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

sourcePath="/Users/54l1m/Library/Mobile Documents/iCloud~md~obsidian/Documents/TheGreatLibrary/01-Posts/"
destinationPath="/Users/54l1m/Documents/54L1M.io/content/posts/"

echo "Syncing posts from Obsidian..."
rsync -av --delete "$sourcePath" "$destinationPath"

echo "Processing image links..."
python3 images.py

echo "Committing to GitHub..."
git add .
commit_message="New Blog Post on $(date +'%Y-%m-%d %H:%M:%S')"

if git diff --cached --quiet; then
  echo "No changes to commit."
else
  git commit -m "$commit_message"
  git push origin master
  echo "Pushed to GitHub! Action will now build and deploy to VPS."
fi
