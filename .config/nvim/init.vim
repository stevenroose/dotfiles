"set timeoutlen=0
set ignorecase
set smartcase
set hidden


" plug-vim plugins
call plug#begin('~/.local/share/nvim/plugged')

" some core plugins
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround' " use: cs
Plug 'tpope/vim-commentary' " use: gc
Plug 'vim-scripts/ReplaceWithRegister' " use: gr
"Plug 'christoomey/vim-titlecase' " use: gt
Plug 'christoomey/vim-sort-motion' " use: gs
Plug 'christoomey/vim-system-copy' " use: cp, cv
Plug 'kana/vim-textobj-user' " enables following:
Plug 'kana/vim-textobj-indent' " use: ai, ii
Plug 'kana/vim-textobj-entire' " use: ae, ie
Plug 'kana/vim-textobj-line' " use: ??

" recognize .editorconfig files
Plug 'editorconfig/editorconfig-vim'

" async linting engine
"Plug 'dense-analysis/ale'

" async compile error engine
Plug 'neomake/neomake'

" latex
Plug 'lervag/vimtex'

" plantuml
Plug 'aklt/plantuml-syntax' " yay -S plantuml

" Go development
Plug 'fatih/vim-go'

" snippets
Plug 'sirver/ultisnips'

" multiple cursos support
Plug 'terryma/vim-multiple-cursors'

" Rust integration
Plug 'rust-lang/rust.vim'
Plug 'racer-rust/vim-racer'

" ctags integration
Plug 'ludovicchabant/vim-gutentags' " needs pacman -S ctags

" lsp clients
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }
Plug 'ncm2/ncm2'
Plug 'roxma/nvim-yarp'
"Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

" fzf search at ctrl-P
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

" git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" status line
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Dart & Flutter
Plug 'dart-lang/dart-vim-plugin'
Plug 'thosakwe/vim-flutter'

call plug#end()

let mapleader="\<SPACE>"
"map <Space> <Leader>
" Remap semicolon to colon
nnoremap ; :
nnoremap : ;

vnoremap <Leader>p "0p

nnoremap <C-p> :FZF<CR>

" Easier pane switching 
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
set splitbelow
set splitright


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

" syntax color scheme
syntax enable
set background=dark
colorscheme solarized

"set statusline = "%{FugitiveStatusline()}"
let g:airline_theme = 'solarized'
"let g:airline_solarized_bg = 'dark'
let g:airline_solarized_bg = 'light'

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
set completeopt+=menuone

" Neomake
" Automake hen writing a buffer (no delay), 
" and on normal mode changes (after 750ms).
call neomake#configure#automake('nw', 750)

" Go completion

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

" ProtoBuf
augroup filetype
  au! BufRead,BufNewFile *.proto setfiletype proto
augroup end



set number relativenumber
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


" lsp clients
let g:LanguageClient_serverCommands = {
    \ 'rust': ['/usr/bin/rustup', 'run', 'stable', 'rls'],
	\ 'dart': ['/usr/bin/dart', '/opt/dart-sdk/bin/snapshots/analysis_server.dart.snapshot', '--lsp'],
    \ }
let g:LanguageClient_useVirtualText = "No"
let g:LanguageClient_loggingFile =  expand('~/tmp/LanguageClient.log')
let g:LanguageClient_serverStderr = expand('~/tmp/LanguageServer.log')
nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>
" first unmap C-] so that it uses gutentags in all other file types
"autocmd FileType * silent! nunmap <C-]>
"autocmd FileType dart silent! nunmap <Esc>
"autocmd FileType rust,rs silent! nunmap <Esc>
autocmd FileType dart nnoremap <C-[> :call LanguageClient#textDocument_definition()<CR>
autocmd FileType rust,rs nnoremap <C-[> :call LanguageClient#textDocument_definition()<CR>

" autocompletion
"autocmd BufEnter * call ncm2#enable_for_buffer()
"let g:deoplete#enable_at_startup = 1

" Shorts for languages: ts=tabstop sw=shiftwidth

" default use tabs
set expandtab!

" because stupid editorconfig thinks it's more important than my own config:
let g:EditorConfig_exclude_patterns = ['fugitive://.\*', '*Makefile']

" Markdown
autocmd FileType markdown,mkd,md setlocal expandtab
"autocmd FileType markdown,mkd,md setlocal columns=80

" Text
autocmd FileType text setlocal wrap

" LaTex
autocmd bufreadpre *.tex setlocal

" Mediawiki
"autocmd bufreadpre *.mediawiki setlocal textwidth=80

" Solidity
autocmd FileType solidity setlocal tabstop=4 shiftwidth=4 expandtab

" BibTex
autocmd FileType bib setlocal tabstop=4 shiftwidth=4 expandtab

" PlantUML
autocmd FileType plantuml setlocal tabstop=2 shiftwidth=2 expandtab
let g:plantuml_executable_script='plantuml -tsvg'

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
"au FileType rust nmap gd <Plug>(rust-def)
"au FileType rust nmap gs <Plug>(rust-def-split)
"au FileType rust nmap gx <Plug>(rust-def-vertical)
au FileType rust nmap <leader>gd <Plug>(rust-doc)
let g:rustfmt_autosave = 0
let g:racer_cmd = '/home/steven/.cargo/bin/racer'
let g:racer_experimental_completer = 1

" Makefile
autocmd FileType make set noexpandtab

" ctags
let g:gutentags_add_default_project_roots = 0
let g:gutentags_project_root = ['tags']

"This unsets the "last search pattern" register by hitting return
nnoremap <CR> :noh<CR><CR>

