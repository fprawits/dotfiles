alias ..='cd ..'
alias ...='cd ../..'
alias -- -='cd -'

alias t1='tree -L 1'
alias t2='tree -L 2'
alias t3='tree -L 3'

alias rs='rsync -avhF'
alias lc='locate'
alias nb='newsboat'
alias vi='vim'
alias vw='vim -c "VimwikiIndex"'

alias t='task'; _completion_loader task; complete -o nospace -F _task t

alias ipy='ipython --pylab'
alias jqt='jupyter qtconsole'
alias jnb='jupyter notebook'
alias jlab='jupyter lab --browser chromium 1>/tmp/jupyter-lab.log 2>&1 & disown "$!"'
alias jconvert='jupyter nbconvert --to html --HTMLExporter.exclude_input=True'

if [ -f "$HOME/.exclude.diff" ]; then
	alias xdiff="diff -qr --exclude-from $HOME/.exclude.diff"
fi

alias save="rsync -avhFr \
  --files-from=$HOME/.list.rsync \
  --delete \
  --delete-excluded \
  --log-file=/tmp/save.$(hostname).log \
  $HOME \
  /media/$USER/office_Prawits/sync\
  && sync && notify-send 'backup completed'\
"

alias fsave="rsync -avhr \
  --progress \
  --files-from=$HOME/.list.rsync \
  --delete \
  --delete-excluded \
  --log-file=/tmp/save.$(hostname).log \
  $HOME \
  /media/$USER/office_Prawits/sync\
  && sync && notify-send 'backup completed'
"

alias tags='rm tags; ctags -R --exclude=.git --exclude="LibRelease-*" --exclude="LQuNet_Mike"; ctags -a --c-kinds=+px-d include/AIT/*.h'
