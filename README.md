.dotfiles
=========

Installation Guide
------------------
    git clone https://github.com/fprawits/dotfiles.git ~/.dotfiles
    cd ~/.dotfiles
    chmod +x makesymlinks.sh && ./makesymlinks.sh

Contents
--------
- bash_aliases      custom abbreviations for often used commands
- bashrc            bash configuration
- config/zathura/   zathura configuration file
- exclude.diff      excluded files for the `xdiff` alias to compare directories
- gitconfig         global git configuration (`~/.gitconfig`)
- gvimrc            gvim configuration, loaded in addition to vimrc
- list.rsync        list of files that are backed up via the `save` alias
- makesymlinks.sh   install script
- ssh/config        ssh configuration
- vim/ftplugin/     configuration specific to filetypes
- vimrc             vim configuration
