" specifically add the python-language-server pyls to the default list:
" Enabled Linters: ['flake8', 'mypy', 'pylint', 'pyright']
" let b:ale_linters = ['flake8', 'pyright', 'pylint', 'pylsp']
" let b:ale_linters = ['ruff', 'pyright']
let g:ale_python_mypy_ignore_invalid_syntax = 1
let b:ale_linters = ['ruff', 'mypy', 'pylsp']
" let b:ale_fixers = ['remove_trailing_lines', 'trim_whitespace', 'black']
let b:ale_fixers = ['ruff_format', ]

" we can replace the old tools used by pylsp (pyflakes, flake8, mccabe, pycodestyle) with ruff, see
" https://github.com/python-lsp/python-lsp-ruff
" NOTE: the plugin needs to be installed separately, e.g. via conda
let b:ale_python_pylsp_config = {
      \   'pylsp': {
      \     'plugins': {
      \       'ruff': {
      \         'enabled': v:true,
      \         'ignore': ['E203', 'W503',],
      \         'exclude': ['.git', '__pycache__', 'build', 'dist'],
      \       },
      \     },
      \   },
      \ }

" --- OUTDATED ---
" py-lsp uses pycodestyle, mccabe and pyflakes by default. We are going to use
" the wrapper flake8 around all 3 tools and configure it directly. See also:
" https://github.com/python-lsp/python-lsp-server#Configuration
" and
" https://github.com/python-lsp/python-lsp-server/blob/develop/CONFIGURATION.md
" let b:ale_python_pylsp_config = {
"       \   'pylsp': {
"       \     'plugins': {
"       \       'pycodestyle' : { 'enabled': v:false },
"       \       'mccabe' : { 'enabled': v:false },
"       \       'pyflakes' : { 'enabled': v:false },
"       \       'flake8': {
"       \         'enabled': v:true,
"       \         'maxLineLength': 88,
"       \         'ignore': ['E203', 'W503',],
"       \         'exclude': ['.git', '__pycache__', 'build', 'dist'],
"       \       },
"       \     'configurationSources': ['flake8'],
"       \     },
"       \   },
"       \ }
