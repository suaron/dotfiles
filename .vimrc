" set shell=$SHELL\ -l
set shell=bash

set nocompatible

let g:solarized_termcolors=256
set background=dark

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" Common
Plug 'altercation/vim-colors-solarized'
Plug 'ervandew/supertab'
Plug 'junegunn/vim-easy-align'
Plug 'mileszs/ack.vim', { 'tag': '1.0.9' }
Plug 'plasticboy/vim-markdown'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-ragtag'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'ctrlpvim/ctrlp.vim', { 'tag': '1.80' }
Plug 'slim-template/vim-slim'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'jlanzarotta/bufexplorer'
Plug 'chrisbra/csv.vim'
Plug 'lambdalisue/suda.vim'
Plug 'tpope/vim-rhubarb'

" Ruby
Plug 'tpope/vim-rails'
Plug 'tpope/vim-rake'
Plug 'tpope/vim-bundler'
Plug 'kana/vim-textobj-user'
Plug 'nelstrom/vim-textobj-rubyblock'
Plug 'vim-ruby/vim-ruby', { 'tag': 'stable-20160928' }
Plug 'aliou/sql-heredoc.vim'

" Elixir
Plug 'elixir-lang/vim-elixir'
Plug 'slashmili/alchemist.vim'
Plug 'c-brenn/phoenix.vim'
Plug 'tpope/vim-projectionist'
let g:alchemist_tag_disable = 1

Plug 'sheerun/vim-polyglot'
Plug 'ludovicchabant/vim-gutentags'
let g:gutentags_cache_dir = '~/.tags_cache'

" Frontend
Plug 'groenewege/vim-less'
Plug 'kchmck/vim-coffee-script'
Plug 'othree/html5.vim'
Plug 'pangloss/vim-javascript'
Plug 'posva/vim-vue'

call plug#end()

colorscheme solarized

" Expand tabs to spaces
set expandtab
set nosmarttab

set softtabstop=2
set shiftwidth=2
set tabstop=4

set wildignore+=tags

" Switch betwin buffers without savingl
set hidden

" Show line numbers
set number

" Cursor highlights
set cursorline

" Turn off folding
set nofoldenable

" Use the system clipboard
set clipboard=unnamed

" Indicator chars
set showbreak=↪\

" Use mouse everywhere
set mouse=a

if has("autocmd")
  " In Makefiles, use real tabs, not tabs expanded to spaces
  au FileType make set noexpandtab

  " Treat JSON files like JavaScript
  au BufNewFile,BufRead *.json set ft=javascript

  " Remember last location in file, but not for commit messages.
  " see :help last-position-jump
  au BufReadPost * if &filetype !~ '^git\c' && line("'\"") > 0 && line("'\"") <= line("$")
        \| exe "normal! g`\"" | endif

  au BufRead,BufNewFile {Procfile} set ft=ruby
  au BufRead,BufNewFile {.localrc,localrc} set ft=sh
endif

" Set Leader
let mapleader = ","

" Move between open buffers.
map <C-n> :bnext<CR>
map <C-p> :bprev<CR>

" Toggle spell check with <F5> for English
map <F5> :setlocal spell! spelllang=en_us<cr>
imap <F5> <ESC>:setlocal spell! spelllang=en_us<cr>

" Toggle spell check with <F6> for Russian
map <F6> :setlocal spell! spelllang=ru_RU<cr>
imap <F6> <ESC>:setlocal spell! spelllang=ru_RU<cr>


" Turn backup off
set nobackup
set nowb
set noswapfile
set updatecount=0

" Tab completion
set wildmode=list:longest,list:full
set wildignore=*.swp,*.bak,*.pyc,*.class,*.jar,*.gif,*.png,*.jpg,*.jpeg
set wildignore+=*.so,*.swp,*.zip,*/tmp/*,*/log/*
set wildignore+=**/coverage       " ignores coverage
set wildignore+=**/node_modules   " ignores node_modules
set wildignore+=**/spec/reports   " ignores spec/reports
set wildignore+=**/tmp/cache      " ignores tmp/cache
set wildignore+=**/_build         " ignores elixir _build folder
set wildignore+=**deps            " ignores elixir deps folder

set complete=.,w,b,u,t,i

" Be smart about it
set smartindent

" Do not wrap lines
set nowrap

" Enable visual bell (disable audio bell)
set vb
set t_vb=

" Status bar
set sidescrolloff=2
if has("statusline") && !&cp
  set statusline=%f\ %m\ %r                " filename, modified, readonly
  set statusline+=%{fugitive#statusline()}
  set statusline+=\ %l/%L[%p%%]            " current line/total lines
  set statusline+=\ %v[0x%B]               " current column [hex char]
endif

" Highlight search
set hlsearch

" Ignore case when searching
set ignorecase

" Ignore case when searching lowercase
set smartcase

" Have :s///g flag by default on
set gdefault

" Paste lines from unnamed register and fix indentation
nmap <leader>p pV`]=
nmap <leader>P PV`]=

" You don't know what you're missing if you don't use this.
nmap <C-e> :e#<CR>

" In command-line mode, C-a jumps to beginning (to match C-e)
cnoremap <C-a> <Home>

:command WQ wq
:command Wq wq
:command W w
:command Q q

" http://vimcasts.org/e/14
cnoremap %% <C-R>=expand('%:h').'/'<cr>
cnoremap %$ <C-R>=expand('%:t:r')<cr>

" Strip trailing whitespace (,ss)
function! StripWhitespace()
  let save_cursor = getpos(".")
  let old_query = getreg('/')
  :%s/\s\+$//e
  call setpos('.', save_cursor)
  call setreg('/', old_query)
endfunction
noremap <leader>ss :call StripWhitespace()<CR>

" Clear the search buffer when hitting return
nnoremap <CR> :nohlsearch<cr>

map <leader>F :Ack<space>

xmap \\  <Plug>Commentary<CR>
nmap \\  <CR><Plug>Commentary
nmap \\\ <Plug>CommentaryLine<CR>
nmap \\u <Plug>CommentaryUndo<CR>

map <leader>f :CtrlP <cr>

let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn)$',
  \ 'file': '\v\.(exe|so|dll)$',
  \ 'link': 'some_bad_symbolic_links',
  \ }
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']

let g:SuperTabDefaultCompletionType = "context"
let g:SuperTabCompletionContexts = ['s:ContextText', 's:ContextDiscover']
let g:SuperTabContextTextOmniPrecedence = ['&omnifunc', '&completefunc']
let g:SuperTabContextDiscoverDiscovery = ["&completefunc:<c-x><c-u>", "&omnifunc:<c-x><c-o>"]

" http://eduncan911.com/software/fix-slow-scrolling-in-vim-and-neovim.html
set cursorline!
set lazyredraw

cabbrev help tab help

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" https://stackoverflow.com/questions/7000960/in-vim-why-doesnt-my-mouse-work-past-the-220th-column
if has("mouse_sgr")
  set ttymouse=sgr
else
  set ttymouse=xterm2
end

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

let g:rails_projections = {
\    "Gemfile": { "command": "gemfile"  }
\ }

if has('persistent_undo')      "check if your vim version supports it
  set undofile                 "turn on the feature  
  set undodir=$HOME/.vim_undo  "directory where the undo files will be stored
endif
