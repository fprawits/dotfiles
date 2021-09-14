.dotfiles
=========

Dependencies
------------
Make sure to install GNU `stow`. For Ubuntu, it can usually be found in the
`apt` resources:

```bash
sudo apt install stow
```


Installation
------------
```bash
git clone https://github.com/fprawits/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
chmod +x makesymlinks.sh && ./makesymlinks.sh
```


Contents
--------
```bash
.
├── bash
│   ├── .bash_aliases  # custom abbreviations for often used commands
│   ├── .bashrc  # bash configuration
│   ├── .exclude.diff  # excluded files for the `xdiff` alias
│   └── .list.rsync  # list of files that are backed up via the `save` alias
├── conda
│   └── .condarc  # conda configuration
├── git
│   ├── .config
│   │   └── git
│   │       └── ignore  # (global) git ignore list
│   └── .gitconfig  # (global) git configuration
├── makesymlinks.sh  # installation script
├── manpath
│   └── .manpath  # location to manpages of custom installed software
├── newsbeuter
│   └── .config
│       └── newsbeuter
│           └── config  # newsbeuter configuration
├── README.md
├── ssh
│   └── .ssh
│       └── config  # ssh configuration
├── tmux
│   └── .config
│       └── tmux
│           └── tmux.conf  # tmux configuration
├── terminator
│   └── .config
│       └── terminator
│           └── config
├── vim
│   ├── .gvimrc  # gvim specific configuration, loaded in addition to vimrc
│   ├── .vim
│   │   ├── ftplugin  # configuration specific to filetypes
│   │   │   ├── bib.vim
│   │   │   ├── c.vim
│   │   │   ├── gitconfig.vim
│   │   │   ├── help.vim
│   │   │   ├── latex.vim
│   │   │   ├── man.vim
│   │   │   ├── markdown.vim
│   │   │   ├── python.vim
│   │   │   ├── sh.vim
│   │   │   ├── text.vim
│   │   │   └── tex.vim
│   │   └── generate-systags.sh  # tag generation script for system C headers
│   └── .vimrc  # vim configuration
└── zathura
    └── .config
        └── zathura
            └── zathurarc  # zathura configuration file
```
