" specifically add the python-language-server pyls to the default list:
" Enabled Linters: ['flake8', 'mypy', 'pylint', 'pyright']
" let b:ale_linters = ['flake8', 'pyright', 'pylint', 'pylsp']
let b:ale_linters = ['ruff', 'pylsp']
" prefer black over yapf as it needs no configuration
let b:ale_fixers = ['remove_trailing_lines', 'trim_whitespace', 'black']
