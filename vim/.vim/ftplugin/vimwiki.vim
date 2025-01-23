nmap <silent> <buffer> <Leader>w<Space>i <Plug>VimwikiDiaryGenerateLinks
nmap <silent> <buffer> glt <Plug>VimwikiToggleListItem
vmap <silent> <buffer> glt <Plug>VimwikiToggleListItem
inoremap <buffer> <C-Space> <C-X><C-O>

nnoremap <buffer> <Leader>w/ :<C-u>VimwikiSearch<Space>
if !has('gui_running')
    nnoremap <buffer> <Leader>w<C-@> :<C-u>VimwikiSearch<Space>
endif

UltiSnipsAddFiletypes markdown
