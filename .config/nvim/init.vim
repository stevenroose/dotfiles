
" plug-vim
call plug#begin('~/.local/share/nvim/plugged')

" github plugins
"Plug 'LaTeX-Box-Team/LaTeX-Box'
Plug 'lervag/vimtex'
Plug 'tomlion/vim-solidity'
Plug 'aklt/plantuml-syntax'
Plug 'fatih/vim-go'
Plug 'stephpy/vim-yaml'
Plug 'in3d/vim-raml'

call plug#end()
set timeoutlen=0

set number

set textwidth=80
set formatoptions+=t
set formatoptions-=l
" from alvaro 
set clipboard=unnamedplus
set mouse=a

augroup vimrc_autocmds
  autocmd BufEnter * highlight OverLength ctermbg=darkgrey guibg=#592929
  autocmd BufEnter * match OverLength /\%>81v.\+/
augroup END

"This unsets the "last search pattern" register by hitting return
nnoremap <CR> :noh<CR><CR>
" Remap semicolon to colon
nnoremap ; :
nnoremap : ;
