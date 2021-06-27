" Set the standard compile and view targets for vim-latexsuite to 'pdf' instead
" of the default 'dvi', this can always be changed on the fly via latexsuites'
" :TTarget command
let g:Tex_DefaultTargetFormat='pdf'
let g:Tex_MultipleCompileFormats='pdf,dvi'

" Use biber instead of bibtex
let g:Tex_BibtexFlavor = 'biber'

" Use zathura to view pdfs
if executable('zathura')
    let g:Tex_ViewRule_pdf='zathura'
endif

" Use Xelatex to compile
let g:Tex_CompileRule_pdf = 'xelatex -synctex=1 -interaction=nonstopmode $*'

" Add ':' to keywords, in order to have CTRL+N complete popular labels like
" fig:, eq:, ect
setlocal iskeyword+=:

" Add spellchecking
setlocal spell
setlocal spelllang=en_us,de_de

" Set text wrapping
setlocal wrap
setlocal wrapmargin=0
setlocal textwidth=0
setlocal linebreak
setlocal breakindent

" Disable visual hints for tabs, EOL, trailing whitespace etc.
"setlocal nolist

" Ignore compiled files created by latex engine
setlocal suffixes+=.bcf,.lof,.lot,.synctex.gz,.run.xml

" Typical endings for `gf` command
setlocal suffixesadd+=.sty,.cls
