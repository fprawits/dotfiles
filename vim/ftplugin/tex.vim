" Set the standard compile and view targets for vim-latexsuite to 'pdf' instead
" of the default 'dvi', this can always be changed on the fly via latexsuites'
" :TTarget command
let g:Tex_DefaultTargetFormat='pdf'
let g:Tex_MultipleCompileFormats='pdf,dvi'

" Add ':' to keywords, in order to have CTRL+N complete popular labels like 
" fig:, eq:, ect
set iskeyword+=:

" Add spellchecking
setlocal spell
setlocal spelllang=en_us,de_de
