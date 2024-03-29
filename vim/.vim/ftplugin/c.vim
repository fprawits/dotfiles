" do not indent the case label after a switch statement
setlocal cinoptions+=:0

" Add system headers to tags
setlocal tags+=~/.vim/systags

let b:ale_fixers = ['remove_trailing_lines', 'trim_whitespace']

" Add additonal directories to search for `compile_commands.json`
let g:ale_c_build_dir_names = ['build', 'build/Debug', 'build/Release',
                              \'bin', 'bin/Debug', 'bin/Release'
                              \'Debug', 'Debug/bin', 'Debug/build',
                              \'Release', 'Release/bin', 'Release/build'
                              \]

" Quickly switch between header and source file
nnoremap <buffer> <Leader>6 :find **/%:t:s@\.hp\{,2}$@.X123X@:s@.cp\{,2}$@.h*@:s@.X123X$@.c*@<CR>
