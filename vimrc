"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Inspired_by::
"   https://github.com/amix/vimrc
"
" Sections:
"   -> General
"   -> Plugins
"   -> VIM user interface
"   -> Colors and Fonts
"   -> Files and backups
"   -> Text, tab and indent related
"   -> Visual mode related
"   -> Moving around, tabs and buffers
"   -> Editing mappings
"   -> vimgrep searching and cope displaying
"   -> Spell checking
"   -> Misc
"   -> Helper functions
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" automatic reloading of .vimrc
autocmd! BufWritePost .vimrc source %

" Sets how many lines of history VIM has to remember
set history=700

" Enable filetype plugins
" see file specific configurations in $HOME/.vim/ftplugin
filetype plugin on
filetype indent on

" register terminal key codes here in order to use them in mappings
if !has('gui_running')
    if &term =~ 'xterm'
        set <S-F3>=[1;2R
        set <M-j>=j
        set <M-k>=k
        set <M-l>=l
        set <M-h>=h
        map <C-@> <C-Space>
        map! <C-@> <C-Space>
    endif
endif

" Set to auto read when a file is changed from the outside
" | execute 'redraw!'
set autoread
if !has("gui_running")
    augroup autoread
        autocmd!
        autocmd FocusGained * : silent! checktime
        autocmd WinEnter,BufEnter,BufWinEnter * :silent! checktime
        autocmd CursorMoved,CursorMovedI * :silent! checktime
        " Disable if performance hit becomes noticable
        autocmd CursorHold,CursorHoldI * :silent! checktime
    augroup END
endif

" Return to last edit position when opening files
augroup lastedit
    autocmd!
    autocmd BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal! g`\"" |
        \ endif
augroup END

" NOTE: the usual way of setting the <Leader>:
"   let mapleader = "\<Space>"
" requires an additional mapping to prevent timeouts from triggering <Right>:
"   nnoremap <Space> <Nop>
" causing its own problems as the timedout sequence is trapped, see:
" https://vi.stackexchange.com/questions/13862/using-a-no-op-key-in-insert-mode-cant-use-key-after-using-no-op-mapping
" Mapping the desired key to <Leader> directly instead has the additional
" advantage of echoing when `showcmd` is set.
map <Space> <Leader>

" better copy & paste
set clipboard=unnamed,unnamedplus
set pastetoggle=<F9>

" OPTIONAL: Starting with Vim 7, the filetype of empty .tex files defaults to
" 'plaintex' instead of 'tex', which results in vim-latex not being loaded.
" The following changes the default filetype back to 'tex':
let g:tex_flavor='latex'

" Start netrw with dotfiles hidden
let g:netrw_list_hide = '\(^\|\s\s\)\zs\.\S\+'

" Disable interpretation of numbers with leading 0 as octal when using <C-A>/<C-X>
set nrformats-=octal

" Delete comment character when joining commented lines
set formatoptions+=j

" Remember global variables consisting of capital letters (e.g. 'KEEP_THIS')
set viminfo^=!

" Disable Ex-mode
nnoremap Q <Nop>

" search for tags in current directory and all parents (until root)
if has('path_extra')
    setglobal tags-=./tags tags-=./tags; tags^=./tags;
endif

" time to wait for completing mappings / terminal keycodes [ms]
" NOTE: as keycodes aren't typed manually, low timeouts prevent blocking <Esc>
set timeoutlen=750 ttimeoutlen=25

" vim 8 introduced a mode to discern between keys like <Tab> and <C-I> if the
" terminal supports it (e.g. xterm). This however causes problems in
" gnome-terminal, therefore this will be disabled (see `:h modifyOtherKeys`)
if v:version >= 800
    let &t_TI = ""
    let &t_TE = ""
endif

if has('nvim') || v:version >= 800
    tnoremap <Esc> <C-\><C-N>
    tnoremap <C-V><Esc> <Esc>
endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugins
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" activate the matchit plugin that ships with vi by default
packadd! matchit

" activate man pager that ships with vim
runtime ftplugin/man.vim
let g:ft_man_open_mode = 'vert'
set keywordprg=:Man

" automatically update the gnu-global database, see `~/.local/plugin/gtags.vim`
let g:Gtags_Auto_Update = 1

" Make sure that vim-plug is installed, see:
" https://github.com/junegunn/vim-plug/wiki/tutorial
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Plugins will be downloaded under the specified directory.
" Make sure you use single quotes
call plug#begin('~/.vim/plugged')

    " latex-suite for vim
    Plug 'vim-latex/vim-latex'
    " set grep program to always generate a file-name, even for single match
    if executable('rg')
        let &grepprg = 'rg --vimgrep $*'
        set grepformat=%f:%l:%c:%m
    else
        set grepprg=grep\ -nH\ $*
    endif

    " better manipulation of brackets and HTML/XML tags
    Plug 'tpope/vim-surround'

    " make vim's repeat command '.' work with plugins
    Plug 'tpope/vim-repeat'

    " add 'gc' command for commenting
    Plug 'tpope/vim-commentary'

    " enhance netrw behaviour
    Plug 'tpope/vim-vinegar'

    " pairs of useful mappings
    Plug 'tpope/vim-unimpaired'

    " Better Statusbar - vim airline + themes
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    " Disable default option to show current mode, as airline will do this for us
    augroup airline_showmode
        autocmd!
        autocmd User AirlineToggledOn set noshowmode
        autocmd User AirlineToggledOff set showmode
    augroup END
    " Display buffers in the tab line if only one tab is open
    let g:airline#extensions#tabline#enabled = 1
    " Show only filename in tabline
    let g:airline#extensions#tabline#formatter = 'unique_tail'
    " unicode symbols
    if !exists('g:airline_symbols')
        let g:airline_symbols = {}
    endif
    let g:airline_symbols.crypt = '🔒'
    let g:airline_symbols.branch = '⎇'
    let g:airline_symbols.spell = 'Ꞩ'
    let g:airline_symbols.notexists = 'Ɇ'

    " collection of color schemes
    Plug 'rafi/awesome-vim-colorschemes'
    Plug 'vim-scripts/peaksea'
    Plug 'skielbasa/vim-material-monokai'

    " new text object based on indentation level
    Plug 'michaeljsmith/vim-indent-object'

    " create custom textobjects - requisite for unify plugin below
    Plug 'kana/vim-textobj-user'
    " unify (), [], {}, "", '', <> textobjects under shortcut `ib` and `ab`
    Plug 'rhysd/vim-textobj-anyblock'
    " textoject-anyblock: restrict matching to (), [], {}, <>
    let g:textobj#anyblock#blocks = ['(', '[', '{', '<']


    " highlight targets of next f/F/t/T find command
    Plug 'unblevable/quick-scope'
    let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']

    " autocompletion for python
    Plug 'davidhalter/jedi-vim'
    let g:jedi#popup_on_dot=0
    let g:jedi#show_call_signatures_delay=0


    " fzf integration (fuzzy finder)
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'
    nnoremap <Leader>fb :Buffers<CR>
    nnoremap <Leader>ff :Files<CR>
    nnoremap <Leader>fl :Lines<CR>
    nnoremap <Leader>fL :BLines<CR>
    nnoremap <Leader>fh :Helptags<CR>
    nnoremap <Leader>fr :Rg<Space>
    nnoremap <Leader>fw :Windows<CR>
    nnoremap <Leader>fa :Locate<Space>
    nnoremap <Leader>ft :Tags<CR>
    nnoremap <Leader>fT :BTags<CR>
    nnoremap <Leader>fm :Marks<CR>
    nnoremap <Leader>f: :History:<CR>
    nnoremap <Leader>f/ :History/<CR>
    nnoremap <Leader>c :Commands<CR>
    nnoremap <Leader>gf :GFiles<CR>
    nnoremap <Leader>gF :GFiles?<CR>
    nnoremap <Leader>gc :Commits<CR>
    nnoremap <Leader>gC :BCommits<CR>

    " markdown folding, concealing and syntax highlight
    Plug 'plasticboy/vim-markdown'
    let g:vim_markdown_conceal_code_blocks = 0
    let g:highlightedyank_max_lines = 1000

    " asynchronous linting
    Plug 'dense-analysis/ale'
    nmap <silent> [W <Plug>(ale_first)
    nmap <silent> [w <Plug>(ale_previous)
    nmap <silent> ]w <Plug>(ale_next)
    nmap <silent> ]W <Plug>(ale_last)

    " git integration
    Plug 'tpope/vim-fugitive'
    nnoremap <Leader>gs :Git<CR>

    " visualization of undotree
    Plug 'mbbill/undotree'
    nnoremap <Leader>u :UndotreeToggle<CR>

    " recursively diff directories
    Plug 'will133/vim-dirdiff'

    " highlight the yanked text
    Plug 'machakann/vim-highlightedyank'
    let g:highlightedyank_highlight_duration = 500

    " Snippets
    Plug 'sirver/ultisnips'

    " Exchange command `cx`
    Plug 'tommcdo/vim-exchange'

" List ends here. Plugins become visible to Vim after this call.
call plug#end()


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Better scrolling
set scrolloff=7
set sidescroll=1
set sidescrolloff=5

" Turn on the WiLd menu
set wildmenu
set wildmode=longest:full,full

" Ignore compiled files
set wildignore=*.o,*~,*.pyc
if has("win16") || has("win32")
    set wildignore+=.git\*,.hg\*,.svn\*
else
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif

" when populating wildmenus, the suffixes list is considered with least priority
set suffixes+=.pdf,.png,.jpg

" Always show current position - obsolete with airline
set ruler

" Change cursor depending on current mode, works for VTE compatible terminals
" taken from: https://vim.fandom.com/wiki/Change_cursor_shape_in_different_modes
if &term =~ 'xterm'
    " let &t_SI = "\<Esc>[5 q"
    let &t_SR = "\<Esc>[4 q"
    let &t_EI = "\<Esc>[2 q"
endif

" show line numbers
set number

" Highlight active window with rel. line numbers, cursorline and colorcolumn
augroup highlight_active_window
    autocmd!
    autocmd VimEnter,WinEnter * set cursorline relativenumber colorcolumn=80
    autocmd WinLeave * set nocursorline norelativenumber colorcolumn=
augroup END

" Always show the status line
set laststatus=2

" Height of the command bar
set cmdheight=2

" Show typed commands, useful for showing incomplete sequences of mappings
set showcmd

" A buffer becomes hidden when it is abandoned
set hidden

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Ignore case when searching
set ignorecase

" Case sensitive search when the search pattern contains upper case
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch

" Show matching brackets when text indicator is over them
set showmatch
" How many tenths of a second to blink when matching brackets
set matchtime=2

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=

" Add a bit extra margin to the left
set foldcolumn=1

" show whitespace
set list
set listchars=tab:▸\ ,eol:¬,trail:•,extends:»,precedes:«,nbsp:␣

let &showbreak = '↪ '   " highlight wrapped lines
set nowrap              " dont wrap lines
set display+=lastline   " show as much of the last (wrapped) line as possible

" Disable macro recording when insinde cmdline-window (`q:`, `q/`, `q?`)
" and press 'q' to close the window
augroup cmdlinewindow
    autocmd!
    autocmd CmdwinEnter * noremap <buffer> <silent> <nowait> q <Cmd>quit<CR>
augroup END


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set background=dark
set termguicolors

" Enable syntax highlighting
syntax enable

" Set extra options when running in GUI mode
if has("gui_running")
    set guioptions-=T  " remove toolbar
    set guioptions-=e  " remove tabbar
    set t_Co=256
    set guitablabel=%M\ %t
endif

try
    let g:gruvbox_italic = '1'
    if !has("gui_running")
        let g:gruvbox_guisp_fallback = 'bg'
    endif
    colorscheme gruvbox
catch
endtry


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf-8

" Use Unix as the standard file type
set ffs=unix,dos,mac

" Turn off backup and swap files, use persistent undo instead
set nobackup
set nowb
set noswapfile

set undolevels=700

if has("persistent_undo")
   let s:target_path = expand('~/.vim/undodir')

    " create the directory and any parent directories
    " if the location does not exist.
    if !isdirectory(s:target_path)
        call mkdir(s:target_path, "p", 0700)
    endif

    let &undodir = s:target_path . '//'
    set undofile
endif

" variable assignment no longer blocks <C-X><C-F> filename completion
set isfname-==

" expand '%%' to path of current file, useful for quickly opening files in same
" directory without the need to change cwd - try ':e %%'
cnoremap <expr> %% getcmdtype()==':' ? expand('%:h') . '/' : '%%'

" abbreviations for often used file patterns
" TODO: maybe replace by abbrev or use filetype specific mappings mapped to common key, e.g. <F9>
cnoremap <expr> %c getcmdtype()==':' ? '**/*.[ch]' : '%c'
cnoremap <expr> %py getcmdtype()==':' ? '**/*.py' : '%py'
cnoremap <expr> %md getcmdtype()==':' ? '**/*.md' : '%md'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use spaces instead of tabs
set expandtab

" Respect shiftwidth setting when using <Tab> in front of a line
set smarttab

" 1 tab == 4 spaces
" softtabstop additionally added in order to no have to delete tab generated
" whitespace individually, see (negative value uses shiftwidth):
" https://stackoverflow.com/questions/1562336/tab-vs-space-preferences-in-vim?rq=1
set tabstop=4
let &shiftwidth = &tabstop
set softtabstop=-1
set shiftround

" Linebreak on 500 characters
set linebreak
set textwidth=500

set autoindent
set smartindent


""""""""""""""""""""""""""""""
" => Visual mode related
""""""""""""""""""""""""""""""
" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :call VisualSelection('f', '')<CR>
vnoremap <silent> # :call VisualSelection('b', '')<CR>

" easier moving of code blocks
" Try to go into visual mode (v), thenselect several lines of code here and
" then press ``>`` several times.
vnoremap < <gv
vnoremap > >gv


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around, tabs, windows and buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Treat long lines as break lines (useful when moving around in them)
noremap j gj
noremap k gk

" Easier to enter cmd- and search-mode
" Remark: <C-Space> is send to vim by the terminal as <C-@>
noremap <C-Space> /
noremap <Leader><Space> za

" Use <C-Space> to put word under cursor into commandline
cnoremap <C-Space> <C-R><C-W>

" Redrawing the screen also disables highlight and updates diffs
nnoremap <silent> <C-L> :<C-U>nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>

" With this function we can create cabbreviations that trigger only if:
"   1) commandline is beginning with ':', not '/' or '?'
"   2) only right after the ':', i.e. there is nothing after the cursor
function! CNoreAbbrev(abb, ...)
    "execute 'cnoreabbrev <expr> '.a:abb.' getcmdtype()==":" && getcmdpos()==strlen('.string(a:abb).')+1 && getcmdline()=='.string(a:abb).' ? '.string(a:exp).' : '.string(a:abb)
     execute 'cnoreabbrev <expr> '.a:abb.' getcmdtype()==":" && getcmdline()=='.string(a:abb).' ? '.string(join(a:000)).' : '.string(a:abb)
endfunction
command! -nargs=+ CNoreAbbrev call CNoreAbbrev(<f-args>)

" show bufferlist when switching/deleting/splitting buffers
CNoreAbbrev b buffers<CR>:buffer
CNoreAbbrev bd buffers<CR>:bdelete
CNoreAbbrev bdel buffers<CR>:bdelete
CNoreAbbrev sb buffers<CR>:sb
CNoreAbbrev vsb buffers<CR>:vertical sb

" open help in vertical split
CNoreAbbrev h vert h


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Editing mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Press jj to enter command mode
inoremap jj <ESC>

" Make Y consistent with other cmds in capital form
noremap Y y$

" Remap VIM 0 to first non-blank character
noremap 0 ^

" Easier typing of go to mark command
noremap gm `
noremap gM '

" Insert undo breaks
inoremap <C-U> <C-G>u<C-U>
inoremap <C-W> <C-G>u<C-W>

" Bash like cmdline editing mappings for moving around
cnoremap <C-A> <Home>
cnoremap <C-F> <Right>
cnoremap <C-B> <Left>
cnoremap <Esc>b <S-Left>
cnoremap <Esc>f <S-Right>

" show registers
" taken from http://superuser.com/questions/656949/always-show-the-register-list-in-vim
nnoremap <silent> "" :registers "0123456789abcdefghijklmnopqrstuvwxyz*+.<CR>

" Delete trailing white space on save, useful for Python and CoffeeScript ;)
func! DeleteTrailingWS()
  let l:winview = winsaveview()
  keeppatterns %s/\s\+$//e
  call winrestview(l:winview)
endfunc
augroup trailingws
    autocmd!
    autocmd BufWritePre *.c,*.h :call DeleteTrailingWS()
    autocmd BufWritePre *.cpp,.*hpp :call DeleteTrailingWS()
    autocmd BufWritePre *.py :call DeleteTrailingWS()
    autocmd BufWritePre *.coffee :call DeleteTrailingWS()
augroup END

" useful mappings for direct interaction with system clipboard
if has('clipboard')
    nnoremap <Leader>y "+y
    xnoremap <Leader>y "+y
    onoremap <Leader>y "+y
    nnoremap <Leader>Y "+y$
    nnoremap <expr> <Leader>p &paste ? '"+p' : ':setlocal paste<CR>"+p:setlocal nopaste<CR>'
    xnoremap <expr> <Leader>p &paste ? '"+p' : ':setlocal paste<CR>"+p:setlocal nopaste<CR>'
endif

" delete to blackhole register
noremap <Leader>d "_d
noremap <Leader>D "_D

" When you press <Leader>r you can search and replace the selected text
vnoremap <silent> <Leader>r :call VisualSelection('replace', '')<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Ack searching and cope displaying
"    requires ack.vim - it's much better than vimgrep/grep
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" When you press gv you Ack after the selected text
"vnoremap <silent> gv :call VisualSelection('gv', '')<CR>

" Open Ack and put the cursor in the right position
"noremap <Leader>g :Ack

" map <F3> and <S-F3> to jump between locations in a quickfix list, or
" differences if in window in diff mode
nnoremap <expr> <silent> <F3>   (&diff ? "]c" : ":cnext\<CR>")
nnoremap <expr> <silent> <S-F3> (&diff ? "[c" : ":cprev\<CR>")


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Spell checking
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn on spell checking with specific language
noremap <Leader>se :setlocal spell spelllang=en_us<CR>
noremap <Leader>sd :setlocal spell spelllang=de_de<CR>

" Shortcuts using <Leader>
noremap <Leader>sn ]s
noremap <Leader>sp [s
noremap <Leader>sa zg
noremap <Leader>ss z=


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Misc
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Remove the Windows ^M - when the encodings gets messed up
noremap <Leader>m mmHmt:%s/<C-V><CR>//ge<CR>'tzt'm

" Fast saving
noremap <Leader>w :update<cr>

" :w!! sudo saves the file
" (useful for handling the permission-denied error)
cnoreabbrev w!! w !sudo /usr/bin/tee % > /dev/null

" common typos
command! -bang -nargs=? -complete=file E   e<bang> <args>
command! -bang -nargs=? -complete=file W   w<bang> <args>
command! -bang -nargs=? -complete=file Wq wq<bang> <args>
command! -bang -nargs=? -complete=file WQ wq<bang> <args>
command! -bang Wa wa<bang>
command! -bang WA wa<bang>
command! -bang Q  q<bang>
command! -bang Qa qa<bang>
command! -bang QA qa<bang>

" insert current date and time
iabbrev xdate <C-R>=strftime("%F %T")<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Helper functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! CmdLine(str)
    exe "menu Foo.Bar :" . a:str
    emenu Foo.Bar
    unmenu Foo
endfunction

function! VisualSelection(direction, extra_filter) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    elseif a:direction == 'gv'
        call CmdLine("Ack \"" . l:pattern . "\" " )
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    elseif a:direction == 'f'
        execute "normal /" . l:pattern . "^M"
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

function! ToggleQuickFix()
    if getqflist({'winid' : 0}).winid
    " Alternative implementation
    " if !empty(filter(getwininfo(), 'v:val.quickfix'))
        cclose
    else
        copen
    endif
endfunction
command! -nargs=0 -bar ToggleQuickFix silent call ToggleQuickFix()
nnoremap <silent> <Leader>q :silent ToggleQuickFix<CR>
