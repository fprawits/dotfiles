" specifically add the python-language-server pyls to the default list:
" Enabled Linters: ['flake8', 'mypy', 'pylint', 'pyright']
let b:ale_linters = ['flake8', 'mypy', 'pylint', 'pyright', 'pyls']
" prefer black over yapf as it needs no configuration
let b:ale_fixers = ['black']
