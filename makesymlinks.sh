#!/bin/bash
#
# Create symlinks in home to the files in .dotfiles
#
# largely taken from:
# https://github.com/michaeljsmalley/dotfiles/blob/master/makesymlinks.sh

mkdir -p "$HOME/.ssh/"
mkdir -p "$HOME/.vim/" "$HOME/.vim/ftplugin/"
mkdir -p "$HOME/.config/zathura/"

dir="$HOME/.dotfiles"
files="bashrc \
    bash_aliases \
    config/zathura/zathurarc \
    ssh/config \
    gvimrc \
    vimrc \
    vim/ftplugin/tex.vim \
    vim/ftplugin/latex.vim \
    vim/ftplugin/text.vim"

for file in $files; do
    echo "Creating symlink to $file in $HOME ..."
    ln -sf "${dir}/$file" "${HOME}/.$file"
done

echo "...done"
