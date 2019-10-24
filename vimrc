"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Maintainer:
"       Amir Salihefendic
"       http://amix.dk - amix@amix.dk
"
" Version:
"       5.0 - 29/05/12 15:43:36
"
" Blog_post:
"       http://amix.dk/blog/post/19691#The-ultimate-Vim-configuration-on-Github
"
" Awesome_version:
"       Get this config, nice color schemes and lots of plugins!
"
"       Install the awesome version from:
"
"           https://github.com/amix/vimrc
"
" Syntax_highlighted:
"       http://amix.dk/vim/vimrc.html
"
" Raw_version:
"       http://amix.dk/vim/vimrc.txt
"
" Sections:
"    -> General
"    -> Plugins
"    -> VIM user interface
"    -> Colors and Fonts
"    -> Files and backups
"    -> Text, tab and indent related
"    -> Visual mode related
"    -> Moving around, tabs and buffers
"    -> Status line
"    -> Editing mappings
"    -> vimgrep searching and cope displaying
"    -> Spell checking
"    -> Misc
"    -> Helper functions
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

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = "ä"
let g:mapleader = "ä"

" Fast saving
nmap <leader>w :w!<cr>

" :w!! sudo saves the file
" (useful for handling the permission-denied error)
cabbrev w!! w !sudo /usr/bin/tee % > /dev/null

" better copy & paste
set pastetoggle=<F10>
set clipboard=unnamed,unnamedplus

" OPTIONAL: Starting with Vim 7, the filetype of empty .tex files defaults to
" 'plaintex' instead of 'tex', which results in vim-latex not being loaded.
" The following changes the default filetype back to 'tex':
let g:tex_flavor='latex'

" Start netrw with dotfiles hidden
let g:netrw_list_hide = '\(^\|\s\s\)\zs\.\S\+'


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugins
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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

    " Better Statusbar - vim airline + themes
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'

    " collection of color schemes
    Plug 'rafi/awesome-vim-colorschemes'
    Plug 'vim-scripts/peaksea'
    Plug 'skielbasa/vim-material-monokai'

    " new text object based on indentation level
    Plug 'michaeljsmith/vim-indent-object'

    " highlight yanked text
    Plug 'machakann/vim-highlightedyank'

    " highlight targets of next f/F/t/T find command
    Plug 'unblevable/quick-scope'

    " new motion: sneak
    Plug 'justinmk/vim-sneak'

    " autocompletion for python
    Plug 'davidhalter/jedi-vim'

" List ends here. Plugins become visible to Vim after this call.
call plug#end()

" Remap latexsuite's placeholder jump to avoid clash with window navigation
imap <C-@> <Plug>IMAP_JumpForward
nmap <C-@> <Plug>IMAP_JumpForward
vmap <C-@> <Plug>IMAP_JumpForward

" Display buffers in the tab line if only one tab is open
let g:airline#extensions#tabline#enabled = 1
" Show only filename in tabline
let g:airline#extensions#tabline#formatter = 'unique_tail'
" molokai airline theme has confusing palette for current/hidden/modified buffers
" alternative candidates are: serene, badcat, raven, jellybeans, fairyfloss, luna
" seagull, simple, sol
let g:airline_theme = 'raven'

" needed for highlightedyank to work
map y <Plug>(highlightedyank)
let g:highlightedyank_highlight_duration = 750

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

" Avoid garbled characters in Chinese language windows OS
let $LANG='en'
set langmenu=en
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim

" Turn on the WiLd menu
set wildmenu
set wildmode=list:longest,full

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

" Highlight current line in active window, disable relativenumber in inactive windows
augroup HighlightActiveWindow
    autocmd!
    " autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline
    " autocmd WinLeave * setlocal nocursorline
    autocmd VimEnter,WinEnter * set cursorline
    autocmd VimEnter,WinEnter * set relativenumber
    autocmd WinLeave * set nocursorline
    autocmd WinLeave * set norelativenumber
augroup END

" Show Column on right margin
set colorcolumn=80

" Height of the command bar
set cmdheight=2

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
map j gj
map k gk

" Remap H and L since they are basically never used
noremap H ^
noremap L $

" Map <Space> to / (search) and Ctrl-<Space> to ? (backwards search)
noremap <space> /
" This key is used for latexsuite's placeholder jumping for now
" Remark: <C-space> is send to vim by the terminal as <C-@>
" noremap <C-@> ?

" Disable highlight when <leader><cr> is pressed
map <silent> <leader>c :noh<cr>

" Smart way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Close the current buffer
map <leader>bd :Bclose<cr>

" Close all the buffers
map <leader>ba :1,1000 bd!<cr>

" Return to last edit position when opening files (You want this!)
augroup lastedit
    autocmd!
    autocmd BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal! g`\"" |
        \ endif
augroup END

" Remember info about open buffers on close
set viminfo^=%


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
map 0 ^

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
" IMPORTANT: grep will sometimes skip displaying the file name if you
" search in a singe file. This will confuse Latex-Suite. Set your grep
" program to always generate a file-name.
set grepprg=grep\ -nH\ $*

" When you press gv you Ack after the selected text
vnoremap <silent> gv :call VisualSelection('gv', '')<CR>

" Open Ack and put the cursor in the right position
map <leader>g :Ack

" When you press <leader>r you can search and replace the selected text
vnoremap <silent> <leader>r :call VisualSelection('replace', '')<CR>

" When you search with Ack, display your results in cope by doing:
map <leader>cc :botright copen<cr>

" To go to the next search result do:
map <leader>n :cn<cr>

" To go to the previous search results do:
map <leader>p :cp<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Spell checking
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Pressing ,ss will toggle and untoggle spell checking
noremap <leader>st :setlocal spell!<cr>
noremap <leader>se :setlocal spell spelllang=en_us<cr>
noremap <leader>sd :setlocal spell spelllang=de_de<cr>

" Shortcuts using <leader>
map <leader>sn ]s
map <leader>sp [s
map <leader>sa zg
map <leader>ss z=


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Misc
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Remove the Windows ^M - when the encodings gets messed up
noremap <Leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

" Quickly open a buffer for scribble
map <leader>q :e ~/scribble<cr>

" Quickly open a markdown buffer for scribble
map <leader>x :e ~/scribble.md<cr>

" Toggle paste mode on and off
map <leader>pp :setlocal paste!<cr>


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
