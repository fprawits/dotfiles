# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
# Additionally: disable XON/XOFF flow control for interactive shells
case $- in
    *i*) stty -ixon ;;
    *) return ;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=10000

# exclude these commands from the history as they are just polluting the hist
HISTIGNORE="&:l[salt]:cd:[bf]g:exit:pwd:history:clear:mount:unmount"

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color | *-256color) color_prompt=yes ;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    BLUE="\[$(tput bold)$(tput setaf 4)\]"
    GREEN="\[$(tput bold)$(tput setaf 2)\]"
else
    BLUE=
    GREEN=
fi
RESET="\[$(tput sgr0)\]"

# If we are on a remote machine, add user and hostname to prompt
if [ -n "$SSH_CONNECTION" ] || [ -n "$SSH_TTY" ]; then
    PS1="${GREEN}\u@\h${RESET}:${BLUE}\w${RESET}\$ "
else
    PS1="${BLUE}\w${RESET}\$ "
fi

unset color_prompt force_color_prompt BLUE GREEN RESET
PS1='${debian_chroot:+($debian_chroot)}'"${PS1}"

# If this is an xterm set the *title* to user@host:dir
case "$TERM" in
    xterm* | rxvt*)
        PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
        ;;
    *) ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    if [ -r ~/.dircolors ]; then
        eval "$(dircolors -b ~/.dircolors)"
    else
        eval "$(dircolors -b)"
    fi
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias l='ls -CF --color=auto'
alias la='ls -A --color=auto'
alias ll='ls -alF --color=auto'
alias lt='ls -altF --color=auto'
alias l.='ls -d --color=auto .*'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# colorize man pages, for available options see:
# * bold, italic, etc.: https://en.wikipedia.org/wiki/ANSI_escape_code#SGR_parameters
# * 8 colors: https://en.wikipedia.org/wiki/ANSI_escape_code#3/4_bit
# * 256 colors: https://en.wikipedia.org/wiki/ANSI_escape_code#8-bit
man() {
    env \
        LESS_TERMCAP_md="$(printf "\e[1;38;5;107m")" \
        LESS_TERMCAP_me="$(printf "\e[0m")" \
        LESS_TERMCAP_se="$(printf "\e[0m")" \
        LESS_TERMCAP_so="$(printf "\e[1;90;107m")" \
        LESS_TERMCAP_ue="$(printf "\e[0m")" \
        LESS_TERMCAP_us="$(printf "\e[1;3;38;5;152m")" \
        man "$@"
}

# added by fzf install script
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# add a preview generated by tree to fzf change dir command
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"

# use `fd` instead of `find`
if command -v fd &>/dev/null; then
    export FZF_DEFAULT_OPTS="--bind tab:toggle-out,shift-tab:toggle-in"
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    _fzf_compgen_path() {
        fd --hidden --follow --exclude ".git" . "$1"
    }
    _fzf_compgen_dir() {
        fd --type d --hidden --follow --exclude ".git" . "$1"
    }
fi

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!

# point to the local installation (usual default: ~/anaconda3 or ~/miniconda3)
if [ -d "${HOME}/anaconda3" ]; then
    __anaconda_dir="${HOME}"/anaconda3
elif [ -d "${HOME}/miniconda3" ]; then
    __anaconda_dir="${HOME}"/miniconda3
fi

if [ -d "${__anaconda_dir}" ]; then
    __conda_setup="$("${__anaconda_dir}/bin/conda" 'shell.bash' 'hook' 2>/dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
    else
        if [ -f "${__anaconda_dir}/etc/profile.d/conda.sh" ]; then
            . "${__anaconda_dir}/etc/profile.d/conda.sh"
        else
            export PATH="${__anaconda_dir}/bin:$PATH"
        fi
    fi
    unset __conda_setup __anaconda_dir
fi
# <<< conda initialize <<<

# use `ipdb` as a python debugger
if command -v ipdb{,3} &>/dev/null; then
    export PYTHONBREAKPOINT=ipdb.set_trace
fi

# color the `minicom` terminal
if command -v minicom &>/dev/null; then
    export MINICOM='-c on'
fi

# Add a bash function to use DirDiff plugin for vim from command line
function vimdirdiff() {
    # Shell-escape each path:
    DIR1=$(printf '%q' "$1")
    shift
    DIR2=$(printf '%q' "$1")
    shift
    vim $@ -c "DirDiff $DIR1 $DIR2"
}

# hook `direnv` to the shell
eval "$(direnv hook bash)"

function set_win_title() {
    echo -ne "\033]0; $(basename "$PWD") \007"
}
# let starship also set the window title to cwd
starship_precmd_user_func="set_win_title"
# load starship prompt
eval "$(starship init bash)"
