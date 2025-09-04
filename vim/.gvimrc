" Change font to make it more readable
if has("gui_running")
    if has("gui_gtk")
        set guifont=FiraCode\ Nerd\ Font\ 12,DejaVu\ Sans\ Mono\ 12
    endif
endif

set guioptions-=T  " remove toolbar
set guioptions-=e  " remove tabbar
set termguicolors
" set t_Co=256
set guitablabel=%M\ %t
