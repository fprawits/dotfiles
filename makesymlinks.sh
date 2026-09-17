#!/bin/bash
#
# Update symlinks in $HOME via GNU stow to apply configuration files in this
# repository.
# NOTE: currently this script only manages packages actively tracked in git (by
# inspecting git's HEAD).

# bash 'strict' mode
set -euo pipefail
IFS=$'\n\t'

if ! command -v stow &> /dev/null; then
    echo "Required program GNU Stow not found!" >&2
    echo "Aborting." >&2
    exit 1
fi

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
cd "$SCRIPT_DIR"

# Make sure the script is located at the repository root
if ! DOTFILE_DIR="$(git rev-parse --show-toplevel 2>/dev/null)"; then
    echo "The script must be located inside a Git repository." >&2
    echo "Aborting." >&2
    exit 1
fi

mapfile -t packages < <(
    git ls-tree -d --name-only HEAD
)

for package in "${packages[@]}"; do
    stow \
        --restow \
        --verbose=1 \
        --dir="$DOTFILE_DIR" \
        --target="$HOME" \
        "$package"
done

if [ ! -f ~/.vim/systags ]; then
    echo -n "Generating tagfile for system C headers ... "
    bash "$HOME/.vim/generate-systags.sh"
    echo "done"
fi
