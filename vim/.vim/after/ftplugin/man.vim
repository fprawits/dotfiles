" Note that this file was placed in `after/ftplugin` such that it does not
" shadow the `ftplugin/man.vim` that ships with vim and is sourced in `.vimrc`
" via `runtime ftplugin/man.vim`
setlocal nolist
setlocal nonumber
setlocal norelativenumber
setlocal signcolumn=no
setlocal colorcolumn=
setlocal sidescrolloff=0

" Quit man pages by pressing <q>, to mimic e.g. `less` behaviour
nnoremap q <Cmd>q<CR>

" The custom function HighlightActiveWindow(), defined in vimrc, will add a
" colorcolum to the man page when the window becomes active, overriding the
" (buffer-local) value set in the ftplugin file here.
" We will thus excplicitly turn off the colorcolumn highlighting of
" HighlightActiveWindow() via the variable below.
let b:disable_active_window_highlight_cc = 1
