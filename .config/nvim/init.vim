set timeoutlen=0
set ignorecase
set smartcase


" plug-vim plugins
call plug#begin('~/.local/share/nvim/plugged')

Plug 'editorconfig/editorconfig-vim'
Plug 'vifm/neovim-vifm'
Plug 'lervag/vimtex'
Plug 'tomlion/vim-solidity'
Plug 'aklt/plantuml-syntax' " pacaur -S plantuml
Plug 'fatih/vim-go'
Plug 'stephpy/vim-yaml'
Plug 'cespare/vim-toml'
Plug 'in3d/vim-raml'
Plug 'SirVer/ultisnips'
Plug 'OmniSharp/omnisharp-vim'
Plug 'terryma/vim-multiple-cursors'
Plug 'vim-syntastic/syntastic'

Plug 'rust-lang/rust.vim'
Plug 'racer-rust/vim-racer'


Plug 'ludovicchabant/vim-gutentags' " needs pacman -S ctags

Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'zchee/deoplete-go', { 'do': 'make'}
"Plug 'sebastianmarkow/deoplete-rust'
Plug 'zchee/deoplete-clang'
Plug 'zchee/deoplete-jedi'

Plug 'dart-lang/dart-vim-plugin'
Plug 'plasticboy/vim-markdown'

Plug 'Shougo/vimproc.vim', {'do' : 'make'}
Plug 'miyakogi/vim-dartanalyzer'

" fzf search at ctrl-P
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

" git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" status line
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

call plug#end()

nnoremap <C-p> :FZF<CR>

" Easier pane switching 
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
set splitbelow
set splitright


"augroup vimrc_autocmds
"  autocmd BufEnter * highlight OverLength ctermbg=darkgrey guibg=#592929
"  autocmd BufEnter * match OverLength /\%>81v.\+/
"augroup END

" Remap semicolon to colon
nnoremap ; :
nnoremap : ;


let g:vim_markdown_folding_disabled = 1
let mapleader=","

" multi-cursor
let g:multi_cursor_use_default_mapping=0
" Default mapping
let g:multi_cursor_start_word_key      = '<C-n>'
let g:multi_cursor_select_all_word_key = '<A-n>'
let g:multi_cursor_start_key           = 'g<C-n>'
let g:multi_cursor_select_all_key      = 'g<A-n>'
let g:multi_cursor_next_key            = '<C-n>'
let g:multi_cursor_prev_key            = '<C-p>'
let g:multi_cursor_skip_key            = '<C-x>'
let g:multi_cursor_quit_key            = '<Esc>'

"set statusline = "%{FugitiveStatusline()}"
let g:airline_theme = 'solarized'
let g:airline_solarized_bg = 'dark'

" Python plugins
let g:python_host_prog  = '/usr/bin/python'
let g:python3_host_prog = '/usr/bin/python3'

" TODO
iabbrev todo TODO(stevenroose)


set showcmd
"
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
set encoding=utf-8
set tabstop=4
set shiftwidth=4
set autowrite
set colorcolumn=+0
highlight ColorColumn ctermbg=darkgrey guibg=#592929

set formatoptions+=t
set formatoptions-=l
" from alvaro 
set clipboard=unnamedplus
set mouse=a

" Shorts for languages: ts=tabstop sw=shiftwidth

" Text
autocmd FileType text setlocal textwidth=80 wrap

" LaTex
autocmd bufreadpre *.tex setlocal textwidth=80

" Markdown
autocmd bufreadpre *.md setlocal textwidth=80

" Solidity
autocmd FileType solidity setlocal tabstop=4 shiftwidth=4 expandtab

" BibTex
autocmd FileType bib setlocal tabstop=4 shiftwidth=4 expandtab

" PlantUML
autocmd FileType plantuml setlocal tabstop=2 shiftwidth=2 expandtab

" Dart
autocmd FileType dart setlocal tabstop=2 shiftwidth=2 expandtab

" Python
au BufNewFile,BufRead *.py set tabstop=4 softtabstop=4 shiftwidth=4 expandtab autoindent fileformat=unix

" TOML
autocmd FileType toml setlocal tabstop=2 shiftwidth=2 expandtab

" C++
autocmd FileType cpp setlocal tabstop=4 shiftwidth=4 expandtab

" Rust
autocmd FileType rust setlocal tabstop=4 shiftwidth=4 expandtab! textwidth=100
let g:rustfmt_autosave = 1
let g:racer_cmd = '/usr/bin/racer'
autocmd FileType rust nmap <C-]> <plug>(rust-def)
autocmd FileType rust nmap gs <Plug>(rust-def-split)
autocmd FileType rust nmap gx <Plug>(rust-def-vertical)
autocmd FileType rust nmap <leader>gd <Plug>(rust-doc)
" deoplete
let g:deoplete#sources#rust#racer_binary='/usr/bin/racer'
let g:deoplete#sources#rust#rust_source_path='/usr/src/rust'
"autocmd FileType rust nmap <C-]> <plug>DeopleteRustGoToDefinitionDefault

" ctags
let g:gutentags_add_default_project_roots = 0
let g:gutentags_project_root = ['tags']

"This unsets the "last search pattern" register by hitting return
nnoremap <CR> :noh<CR><CR>
