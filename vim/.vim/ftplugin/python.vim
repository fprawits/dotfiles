" specifically add the python-language-server pyls to the default list:
"let b:ale_linters = ['ruff', 'pylsp']
let b:ale_linters = ['flake8', 'pyright', 'pylint', 'pylsp']
" prefer black over yapf as it needs no configuration
let b:ale_fixers = ['remove_trailing_lines', 'trim_whitespace', 'black']

" py-lsp uses pycodestyle, mccabe and pyflakes by default. We are going to use
" the wrapper flake8 around all 3 tools and configure it directly. See also:
" https://github.com/python-lsp/python-lsp-server#Configuration
" and
" https://github.com/python-lsp/python-lsp-server/blob/develop/CONFIGURATION.md
let b:ale_python_pylsp_config = {
      \   'pylsp': {
      \     'plugins': {
      \       'pycodestyle' : { 'enabled': v:false },
      \       'mccabe' : { 'enabled': v:false },
      \       'pyflakes' : { 'enabled': v:false },
      \       'flake8': {
      \         'enabled': v:true,
      \         'maxLineLength': 88,
      \         'ignore': ['E203', 'W503',],
      \         'exclude': ['.git', '__pycache__', 'build', 'dist'],
      \       },
      \     'configurationSources': ['flake8'],
      \     },
      \   },
      \ }
