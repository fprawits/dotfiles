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
"   -> Status line
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

" Set to auto read when a file is changed from the outside
" | execute 'redraw!'
set autoread
augroup autoread
    autocmd!
    autocmd FocusGained * : silent! checktime
    autocmd WinEnter,BufEnter,BufWinEnter * :silent! checktime
    autocmd CursorMoved,CursorMovedI * :silent! checktime
    " Disable if performance hit becomes noticable
    autocmd CursorHold,CursorHoldI * :silent! checktime
augroup END

" NOTE: the usual way of setting the <Leader>:
"   let mapleader = "\<Space>"
" requires an additional mapping to prevent timeouts from triggering <Right>:
"   nnoremap <Space> <Nop>
" causing its own problems as the timedout sequence is trapped, see:
" https://vi.stackexchange.com/questions/13862/using-a-no-op-key-in-insert-mode-cant-use-key-after-using-no-op-mapping
map <Space> <Leader>

" Fast saving
noremap <Leader>w :update<cr>

" :w!! sudo saves the file
" (useful for handling the permission-denied error)
cnoreabbrev w!! w !sudo /usr/bin/tee % > /dev/null

" better copy & paste
set pastetoggle=<F10>
set clipboard=unnamed,unnamedplus
" useful mappings for direct interaction with system clipboard
nnoremap <Leader>y "+yiw <bar> :echo 'Yanked to clipboard:' <bar> echo '  '.@*<CR>
nnoremap <Leader>Y "+Y
xnoremap <Leader>y "+y <bar> :echo 'Yanked to clipboard:' <bar> echo '  '.@*<CR>
nnoremap <Leader>p "+p
xnoremap <Leader>p "+p

" OPTIONAL: Starting with Vim 7, the filetype of empty .tex files defaults to
" 'plaintex' instead of 'tex', which results in vim-latex not being loaded.
" The following changes the default filetype back to 'tex':
let g:tex_flavor='latex'

" Start netrw with dotfiles hidden
let g:netrw_list_hide = '\(^\|\s\s\)\zs\.\S\+'

" Disable interpretation of numbers with leading 0 as octal when using <C-a>/<C-x>
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


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugins
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" activate the matchit plugin that ships with vi by default
packadd! matchit

" vim-plug configuration, see:
" https://github.com/junegunn/vim-plug/wiki/tutorial
"
" Make sure that we have vim-plug
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

    " collection of color schemes
    Plug 'rafi/awesome-vim-colorschemes'
    Plug 'vim-scripts/peaksea'
    Plug 'skielbasa/vim-material-monokai'

    " new text object based on indentation level
    Plug 'michaeljsmith/vim-indent-object'

    " highlight targets of next f/F/t/T find command
    Plug 'unblevable/quick-scope'

    " new motion: sneak
    Plug 'justinmk/vim-sneak'

    " autocompletion for python
    Plug 'davidhalter/jedi-vim'

    " fzf integration (fuzzy finder)
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
    Plug 'junegunn/fzf.vim'

" List ends here. Plugins become visible to Vim after this call.
call plug#end()

" IMPORTANT: grep will sometimes skip displaying the file name if you
" search in a singe file. This will confuse Latex-Suite. Set your grep
" program to always generate a file-name.
set grepprg=grep\ -nH\ $*

" Remap latexsuite's placeholder jump to avoid clash with window navigation
imap <C-@> <Plug>IMAP_JumpForward
nmap <C-@> <Plug>IMAP_JumpForward
vmap <C-@> <Plug>IMAP_JumpForward

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
" molokai airline theme has confusing palette for current/hidden/modified buffers
" alternative candidates are: serene, badcat, raven, jellybeans, fairyfloss, luna
" seagull, simple, sol
let g:airline_theme = 'raven'

" Quick-Scope:
" Trigger a highlight in the appropriate direction when pressing these keys:
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']

" Configuration for jedi-vim
let g:jedi#popup_on_dot=0
let g:jedi#show_call_signatures_delay=0


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set 7 lines to the cursor - when moving vertically using j/k
set scrolloff=7
set sidescrolloff=5

" Turn on the WiLd menu
set wildmenu
set wildmode=longest:full,full

" Ignore compiled files
set wildignore=*.o,*~,*.pyc
if has("win16") || has("win32")
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
else
    set wildignore+=.git\*,.hg\*,.svn\*
endif

" when populating wildmenus, the suffixes list is considerd with least priority
set suffixes+=".pdf,.png,.jpg"

" Always show current position - obsolete with airline
set ruler

" toggle relative linenumber " default: hybrid mode
set number
nnoremap <F3> :set relativenumber!<CR>

" Show Column on right margin
set colorcolumn=80

" Change cursor depending on current mode, works for VTE compatible terminals
" taken from: https://vim.fandom.com/wiki/Change_cursor_shape_in_different_modes
if &term =~ 'xterm'
    let &t_SI = "\<Esc>[5 q"
    let &t_SR = "\<Esc>[4 q"
    let &t_EI = "\<Esc>[2 q"
endif

" Highlight current line in active window, disable relativenumber in inactive windows
augroup highlight_active_window
    autocmd!
    autocmd VimEnter,WinEnter * set cursorline relativenumber colorcolumn=80
    autocmd WinLeave * set nocursorline norelativenumber colorcolumn=
augroup END

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

" When searching try to be smart about cases
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch

" Don't redraw while executing macros (good performance config)
" Disabled as it causes the statusline to be drawn only after a key is pressed
"set lazyredraw

" For regular expressions turn magic on
set magic

" Show matching brackets when text indicator is over them
set showmatch
" How many tenths of a second to blink when matching brackets
set matchtime=2

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set timeoutlen=500

" Add a bit extra margin to the left
set foldcolumn=1

" show whitespace
set list
set listchars=tab:▸\ ,eol:¬,trail:␣,extends:>,precedes:<,nbsp:+


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set background=dark
"
" Enable syntax highlighting
syntax enable

" Set extra options when running in GUI mode
if has("gui_running")
    set guioptions-=T
    set guioptions-=e
    set t_Co=256
    set guitablabel=%M\ %t
endif

try
    let g:molokai_original=1
    let g:rehash256=1
    colorscheme molokai
    " Fix irritating parens matching in standard molokai by:
    " * switching fg and bg
    "highlight MatchParen cterm=bold ctermbg=none ctermfg=208
    " * using a custom palette different form standard molokai
    highlight MatchParen cterm=bold ctermbg=DarkGray ctermfg=DarkGreen
catch
endtry


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf-8

" Use Unix as the standard file type
set ffs=unix,dos,mac

" Turn backup off, since most stuff is in SVN, git et.c anyway...
set nobackup
set nowb
set noswapfile

set undolevels=700

" expand '%%' to path of current file, useful for quickly opening files in same
" directory without the need to change cwd - try ':e %%'
cnoremap <expr> %% getcmdtype()==':' ? expand('%:h') . '/' : '%%'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use spaces instead of tabs
set expandtab

" Be smart when using tabs ;)
set smarttab

" 1 tab == 4 spaces
" softtabstop additionally added in order to no have to delete tab generated
" whitespace individually, see (negative value uses shiftwidth):
" https://stackoverflow.com/questions/1562336/tab-vs-space-preferences-in-vim?rq=1
set shiftwidth=4
set tabstop=4
set softtabstop=-1
set shiftround

" Linebreak on 500 characters
set linebreak
set textwidth=500

set autoindent
set smartindent
set nowrap "dont wrap lines


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

" Remap H and L since they are basically never used
" TODO: remap these to something more useful, for now underutilized
noremap H ^
noremap L $

" Easier to enter cmd- and search-mode
" Remark: <C-space> is send to vim by the terminal as <C-@>
noremap <Leader><Space> /
noremap q<Space> q/
noremap <Leader><C-@> :
noremap q<C-@> q:


" Disable highlight when <Leader>c is pressed
noremap <silent> <Leader>c :nohlsearch<CR>
" a better version of the above command would be to extend the standard redraw
" <C-l> hotkey, however this is currently shadowed by the window navigation below
"nnoremap <silent> <C-l> :<C-u>nohlsearch<cr><C-l>

" Smart way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

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

" Close the current buffer
noremap <Leader>bd :Bclose<cr>

" Close all the buffers
noremap <Leader>ba :1,1000 bd!<cr>

" Return to last edit position when opening files (You want this!)
augroup lastedit
    autocmd!
    autocmd BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal! g`\"" |
        \ endif
augroup END


""""""""""""""""""""""""""""""
" => Status line
""""""""""""""""""""""""""""""
" Always show the status line
set laststatus=2

" Format the status line -> overwritten by airline plugin!
"set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l\ \ %P


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Editing mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" press jj to enter command mode
imap jj <ESC>

" Remap VIM 0 to first non-blank character
noremap 0 ^

" easier typing of go to mark command
noremap gm `
noremap gM '

" Move a line of text using ALT+[jk] or Comamnd+[jk] on mac
nmap <M-j> mz:m+<cr>`z
nmap <M-k> mz:m-2<cr>`z
vmap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
vmap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z

if has("mac") || has("macunix")
  nmap <D-j> <M-j>
  nmap <D-k> <M-k>
  vmap <D-j> <M-j>
  vmap <D-k> <M-k>
endif

" show registers
" taken from http://superuser.com/questions/656949/always-show-the-register-list-in-vim
nnoremap <silent> "" :registers "0123456789abcdefghijklmnopqrstuvwxyz*+.<CR>

" Delete trailing white space on save, useful for Python and CoffeeScript ;)
func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc
augroup trailingws
    autocmd!
    autocmd BufWrite *.py :call DeleteTrailingWS()
    autocmd BufWrite *.coffee :call DeleteTrailingWS()
augroup END


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Ack searching and cope displaying
"    requires ack.vim - it's much better than vimgrep/grep
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" When you press gv you Ack after the selected text
vnoremap <silent> gv :call VisualSelection('gv', '')<CR>

" Open Ack and put the cursor in the right position
noremap <Leader>g :Ack

" When you press <Leader>r you can search and replace the selected text
vnoremap <silent> <Leader>r :call VisualSelection('replace', '')<CR>

" When you search with Ack, display your results in cope by doing:
noremap <Leader>cc :botright copen<cr>


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
noremap <Leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

" Quickly open a buffer for scribble
noremap <Leader>q :e ~/scribble<cr>

" Quickly open a markdown buffer for scribble
noremap <Leader>x :e ~/scribble.md<cr>

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


" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    en
    return ''
endfunction

" Don't close window, when deleting a buffer
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
   let l:currentBufNum = bufnr("%")
   let l:alternateBufNum = bufnr("#")

   if buflisted(l:alternateBufNum)
     buffer #
   else
     bnext
   endif

   if bufnr("%") == l:currentBufNum
     new
   endif

   if buflisted(l:currentBufNum)
     execute("bdelete! ".l:currentBufNum)
   endif
endfunction
