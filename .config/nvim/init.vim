set timeoutlen=0
set ignorecase
set smartcase


" plug-vim plugins
call plug#begin('~/.local/share/nvim/plugged')

Plug 'editorconfig/editorconfig-vim'
Plug 'vifm/neovim-vifm'
Plug 'w0rp/ale'
Plug 'neomake/neomake'
Plug 'lervag/vimtex'
Plug 'tomlion/vim-solidity'
Plug 'aklt/plantuml-syntax' " yay -S plantuml
Plug 'fatih/vim-go'
Plug 'stephpy/vim-yaml'
Plug 'cespare/vim-toml'
Plug 'in3d/vim-raml'
Plug 'SirVer/ultisnips'
Plug 'OmniSharp/omnisharp-vim'
Plug 'terryma/vim-multiple-cursors'
"Plug 'vim-syntastic/syntastic'

Plug 'rust-lang/rust.vim'
Plug 'racer-rust/vim-racer'

Plug 'ludovicchabant/vim-gutentags' " needs pacman -S ctags

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

Plug 'reedes/vim-pencil'

call plug#end()

"let mapleader="\<SPACE>"
map <Space> <Leader>
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


"augroup vimrc_autocmds
"  autocmd BufEnter * highlight OverLength ctermbg=darkgrey guibg=#592929
"  autocmd BufEnter * match OverLength /\%>81v.\+/
"augroup END


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

" Pencil (for writing text)
augroup pencil
  autocmd!
  autocmd FileType markdown,mkd,md call pencil#init({'wrap': 'soft'})
  autocmd FileType text            call pencil#init()
augroup END
let g:pencil#textwidth = 80
let g:vim_markdown_folding_disabled = 1

" Markdown
"autocmd FileType markdown,mkd,md setlocal textwidth=80 expandtab
autocmd FileType markdown,mkd,md setlocal columns=80

" Text
autocmd FileType text setlocal textwidth=80 wrap

" LaTex
autocmd bufreadpre *.tex setlocal textwidth=80

" Mediawiki
"autocmd bufreadpre *.mediawiki setlocal textwidth=80

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
let g:rustfmt_autosave = 0
let g:racer_cmd = '/usr/bin/racer'

" ctags
let g:gutentags_add_default_project_roots = 0
let g:gutentags_project_root = ['tags']

"This unsets the "last search pattern" register by hitting return
nnoremap <CR> :noh<CR><CR>
