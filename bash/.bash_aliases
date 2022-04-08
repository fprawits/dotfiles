# Load custom bash completion scripts
if [ -d ~/.bash_completion.d ] && [ -n "$(ls -A ~/.bash_completion.d)" ]; then
	for f in ~/.bash_completion.d/*; do source "$f"; done
fi

alias ..='cd ..'
alias ...='cd ../..'
alias rs='rsync -avhF'
alias lc='locate'
alias nb='newsbeuter'
alias vw='vim -c "VimwikiIndex"'

alias t='task'
complete -o nospace -F _task t

alias ipy='ipython --pylab'
alias jqt='jupyter qtconsole'
alias jnb='jupyter notebook'
alias jlab='jupyter lab --browser chromium-browser 1>/tmp/jupyter-lab.log 2>&1 & disown "$!"'
alias jconvert='jupyter nbconvert --to html --HTMLExporter.exclude_input=True'

if [ -f "$HOME/.exclude.diff" ]; then
	alias xdiff="diff -qr --exclude-from $HOME/.exclude.diff"
fi

alias save="rsync -avhFr \
  --files-from=$HOME/.list.rsync \
  --backup \
  --backup-dir=../xps13.deleted.rsync/$(date +%Y-%m-%d) \
  --delete \
  --delete-excluded \
  --log-file=/tmp/save.xps13.log \
  $HOME \
  /media/$USER/backupXPS13/xps13.home.rsync \
"
