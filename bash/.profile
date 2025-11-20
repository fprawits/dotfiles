# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# set PATH so it includes npm global dir if it exists
if [ -d "$HOME/.npm-global/bin" ] ; then
    PATH="$HOME/.npm-global/bin:$PATH"
fi

# add manpages of locally installed software
# NOTE: the *nicer* approach via .manpath is currently not possible due to
# to the rudder agent setting MANPATH
# if [ -d "$HOME/.local/share/man" ] ; then
#   export MANPATH="${MANPATH:+$MANPATH:}$HOME/.local/share/man"
# fi
if type manpath >/dev/null 2>&1
then
    MANPATH="$(manpath 2> /dev/null):$HOME/.local/share/man:$HOME/.vim/plugged/fzf/man"
elif [ ! -z "${MANPATH}" ]
then
    MANPATH="${MANPATH}:$HOME/.local/share/man:$HOME/.vim/plugged/fzf/man"
else
    MANPATH="$HOME/.local/share/man:$HOME/.vim/plugged/fzf/man"
fi

export MANPATH

# Add rust dev environment (installed bia rustup.sh)
if [ -f  "${HOME}/.cargo/env" ] ; then
    source  "${HOME}/.cargo/env"
fi

# Add Raspberry Pi Pico-SDK environment variable in order to build projects
if [ -d "${HOME}/Documents/pico/pico-sdk" ] ; then
    PICO_SDK_PATH="${HOME}/Documents/pico/pico-sdk"
fi

# Set XDG_CONFIG_HOME if not yet set, helps non-xdg-compliant programs to act properly (looking at you tmux!)
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-${HOME}/.config}"

# Added by Perl's cpan module when configured for local::lib, can be removed to get back the configuration dialogue
PATH="/home/prawitsf/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/home/prawitsf/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/home/prawitsf/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/home/prawitsf/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/prawitsf/perl5"; export PERL_MM_OPT;

# Added by the deno (javascript runtime) installer
if [ -f "${HOME}/.deno/env" ]; then
    . "/home/prawitsf/.deno/env"
fi
