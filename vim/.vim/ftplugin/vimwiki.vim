nmap <silent> <buffer> <LocalLeader>w<Space>i <Plug>VimwikiDiaryGenerateLinks
nmap <silent> <buffer> glt <Plug>VimwikiToggleListItem
vmap <silent> <buffer> glt <Plug>VimwikiToggleListItem
inoremap <buffer> <C-Space> <C-X><C-O>

nnoremap <buffer> <LocalLeader>w/ :<C-u>VimwikiSearch<Space>
if !has('gui_running')
    nnoremap <buffer> <LocalLeader>w<C-@> :<C-u>VimwikiSearch<Space>
endif

UltiSnipsAddFiletypes markdown
