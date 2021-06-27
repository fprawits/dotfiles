#!/bin/bash
set -euo pipefail

ctags -R --kinds-C=+px -f ~/.vim/systags /usr/include/ /usr/local/include/
