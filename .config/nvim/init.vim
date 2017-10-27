set timeoutlen=0
set ignorecase
set smartcase


" plug-vim plugins
call plug#begin('~/.local/share/nvim/plugged')

Plug 'vifm/neovim-vifm'
Plug 'lervag/vimtex'
Plug 'tomlion/vim-solidity'
Plug 'aklt/plantuml-syntax'
Plug 'fatih/vim-go'
Plug 'stephpy/vim-yaml'
Plug 'in3d/vim-raml'
Plug 'SirVer/ultisnips'

Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'zchee/deoplete-go', { 'do': 'make'}
Plug 'dart-lang/dart-vim-plugin'
Plug 'plasticboy/vim-markdown'

" fzf search at ctrl-P
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

call plug#end()

nnoremap <C-p> :FZF<CR>


set showcmd
" Completion
set completeopt+=noinsert
set completeopt+=noselect
let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_ignore_case = 1

" Go completion
let g:deoplete#sources#go#gocode_binary = '/home/steven/gocode/bin/gocode'
let g:deoplete#sources#go#package_dot = 1
let g:deoplete#sources#go#pointer = 1
let g:deoplete#sources#go#sort_class = ['package', 'func', 'type', 'var', 'const']
" VimGo
let g:go_fmt_command = "goimports"
map <C-n> :cnext<CR>
map <C-m> :cprevious<CR>
nnoremap <leader>a :cclose<CR>
let g:go_list_type = "quickfix"
autocmd FileType go nmap <leader>t  <Plug>(go-test)
function! s:build_go_files()
  " run :GoBuild or :GoTestCompile based on the go file
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#test#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction
" autocmd FileType go nmap <leader>b :<C-u>call <SID>build_go_files()<CR>
nnoremap <leader>b :<C-u>call <SID>build_go_files()<CR>

" Disable deoplete for tex
autocmd FileType tex  let b:deoplete_disable_auto_complete = 1

" ProtoBuf
augroup filetype
  au! BufRead,BufNewFile *.proto setfiletype proto
augroup end



set number
set tabstop=4
set shiftwidth=4
set autowrite

autocmd bufreadpre *.tex setlocal textwidth=80
set formatoptions+=t
set formatoptions-=l
" from alvaro 
set clipboard=unnamedplus
set mouse=a

" Solidity
autocmd Filetype solidity setlocal ts=4 sw=4 expandtab

" BibTex
autocmd Filetype bib setlocal ts=4 sw=4 expandtab

" PlantUML
autocmd Filetype plantuml setlocal ts=2 sw=2 expandtab

augroup vimrc_autocmds
  autocmd BufEnter * highlight OverLength ctermbg=darkgrey guibg=#592929
  autocmd BufEnter * match OverLength /\%>81v.\+/
augroup END

"This unsets the "last search pattern" register by hitting return
nnoremap <CR> :noh<CR><CR>
" Remap semicolon to colon
nnoremap ; :
nnoremap : ;


let g:vim_markdown_folding_disabled = 1
let mapleader=","
