#!/bin/bash
#
# Create symlinks in home to the files in .dotfiles
#
# largely taken from:
# https://github.com/michaeljsmalley/dotfiles/blob/master/makesymlinks.sh

dir=$HOME/.dotfiles
files="bashrc bash_aliases vimrc"

for file in $files; do
    echo "Creating symlink to $file in $HOME ..."
    ln -s $dir/$file $HOME/.$file
done

echo "...done"
