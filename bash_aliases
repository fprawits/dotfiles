alias vi='vim'
alias ..='cd ..'
alias rs='rsync -avhF'
alias lc='locate'

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
  $HOME \
  /media/sheep/backupXPS13/xps13.home.rsync \
"
