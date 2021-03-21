#!/bin/bash
#
# Create symlinks in $HOME and its correct sub-directories to configuration
# files in this repository.

# bash 'strict' mode
set -euo pipefail
IFS=$'\n\t'

# setup for globbing all target files
shopt -s extglob globstar

# get the path to and name of this script, note that the cd into the repository
# ensures that the globstar below works as expected
cd "$(dirname "${BASH_SOURCE[0]}")"
repo_root="$PWD"
script_name="$(basename "${BASH_SOURCE[0]}")"

i=0
echo "Creating symlinks ..."
for f in **/!(README.md|"${script_name}"); do
	if [ -d "$f" ]; then
		mkdir -p "${HOME}/.$f"
	else
		ln -sfi "${repo_root}/$f" "${HOME}/.$f"
		echo "$f -> ${HOME}/.$f"
		((i += 1))
	fi
done
echo "... done (total: $i links)"
