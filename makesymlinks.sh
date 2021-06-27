#!/bin/bash
#
# Update symlinks in $HOME via GNU stow to apply configuration files in this
# repository.

# bash 'strict' mode
set -euo pipefail
IFS=$'\n\t'

if ! command -v stow &> /dev/null
then
	echo "Required program GNU stow not found!"
	echo "Aborting"
	exit 1
fi

cd "$(dirname "${BASH_SOURCE[0]}")"
DOTFILE_DIR="$PWD"

for d in $(git ls-tree -d --name-only master); do
	stow --restow --verbose=1 --dir="$DOTFILE_DIR" --target="$HOME" "$d"
done

if [ ! -f ~/.vim/systags ]; then
	echo -n "Generating tagfile for system C headers ... "
	bash ~/.vim/generate-systags.sh
	echo "done"
fi
