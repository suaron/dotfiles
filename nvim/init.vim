" Set Leader
let mapleader = ","

let g:solarized_termcolors=256
set background=dark

" auto install vim-plug and plugins
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.nvim/plugged')

Plug 'chrisbra/matchit'
:packadd! matchit

" Projectionist provides granular project configuration using "projections"
Plug 'tpope/vim-projectionist'

Plug 'tpope/vim-abolish'

" Targets.vim is a Vim plugin that adds various text objects to give you more targets to operate on
Plug 'wellle/targets.vim'

Plug 'hashivim/vim-terraform'
let g:terraform_align=1

" Syntax highlighting, matching rules and mappings for the original Markdown and extensions.
Plug 'plasticboy/vim-markdown'

Plug 'honza/vim-snippets'

let g:snipMate = {}
let g:snipMate.scope_aliases = {}
let g:snipMate.scope_aliases['ruby'] = 'ruby,ruby-rails'

Plug 'ntpeters/vim-better-whitespace'

noremap <leader>ss :StripWhitespace<CR>

Plug 'altercation/vim-colors-solarized'

Plug 'dyng/ctrlsf.vim'

map <leader>F :CtrlSF<space>

" Clear the search buffer when hitting return
nnoremap <CR> :nohlsearch<cr>

" https://github.com/junegunn/vim-easy-align
Plug 'junegunn/vim-easy-align'
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

Plug 'tpope/vim-commentary'

xmap \\  <Plug>Commentary<CR>
nmap \\  <CR><Plug>Commentary
nmap \\\ <Plug>CommentaryLine<CR>
nmap \\u <Plug>CommentaryUndo<CR>

Plug 'junegunn/fzf', {'dir': '~/.fzf','do': './install --all'}
Plug 'junegunn/fzf.vim' " needed for previews

" Mapping selecting mappings
nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)

" Insert mode completion
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-l> <plug>(fzf-complete-line)

command! -bang -nargs=* GGrep
  \ call fzf#vim#grep(
   \   'git grep --line-number -- '.shellescape(<q-args>), 0,
   \   fzf#vim#with_preview({'dir': systemlist('git rev-parse --show-toplevel')[0]}), <bang>0)

command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case -- '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview(), <bang>0)

nnoremap <silent><nowait> <leader>b :Buffers<CR>
nnoremap <silent><nowait> <leader>p :GFiles --cached --others --exclude-standard<CR>
nnoremap <silent><nowait> <leader>g :GGrep<CR>
nnoremap <silent><nowait> <leader>f :FZF<CR>

Plug 'tpope/vim-endwise'

Plug 'tpope/vim-eunuch'
" :Delete: Delete a buffer and the file on disk simultaneously.
" :Move: Rename a buffer and the file on disk simultaneously.
" :Rename: Like :Move, but relative to the current file's containing directory.
" :SudoWrite: Write a privileged file with sudo.
" :SudoEdit: Edit a privileged file with sudo.

" Git & Github
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'

" A set of mappings for HTML, XML, PHP, ASP, eRuby, JSP, and more (formerly allml)
Plug 'tpope/vim-ragtag'

Plug 'scrooloose/nerdtree'
nmap <silent> <leader><leader> :NERDTreeToggle<CR>
nnoremap <C-n> :NERDTreeFind<CR>
let NERDTreeIgnore = ['\.pyc$', '\.retry$']

" https://github.com/tpope/vim-surround
Plug 'tpope/vim-surround'

" https://github.com/AndrewRadev/splitjoin.vim/blob/main/ftplugin/ruby/splitjoin.vim
" gS to split a one-liner into multiple lines
" gJ (with the cursor on the first line of a block) to join a block into a single-line statement.
Plug 'AndrewRadev/splitjoin.vim'

Plug 'ekalinin/Dockerfile.vim'

" Ruby
Plug 'tpope/vim-rails'
Plug 'tpope/vim-bundler'
Plug 'aliou/sql-heredoc.vim'

Plug 'sheerun/vim-polyglot'

" This plugin is provides file detection and syntax highlighting support for Prisma 2.
Plug 'pantharshit00/vim-prisma'

Plug 'tpope/vim-sensible'

" Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Plug 'antoinemadec/coc-fzf', {'branch': 'release'}

" \ 'coc-docker', https://github.com/neoclide/coc.nvim/pull/2756
" \ 'coc-tabnine',
" let g:coc_global_extensions = [
"       \ 'coc-cspell-dicts',
"       \ 'coc-markdownlint',
"       \ 'coc-prisma',
"       \ 'coc-spell-checker',
"       \ 'coc-tsserver',
"       \ 'coc-prettier',
"       \ 'coc-html',
"       \ 'coc-lists',
"       \ 'coc-xml',
"       \ 'coc-sh',
"       \ 'coc-css',
"       \ 'coc-stylelint',
"       \ 'coc-vimlsp',
"       \ 'coc-go',
"       \ 'coc-elixir',
"       \ 'coc-json',
"       \ 'coc-eslint',
"       \ 'coc-pyright',
"       \ 'coc-java',
"       \ 'coc-java-debug',
"       \ 'coc-jest',
"       \ 'coc-solargraph',
"       \ 'coc-yaml',
"       \ 'coc-highlight',
"       \ 'coc-snippets',
"       \ 'coc-diagnostic',
"       \ 'coc-yank',
"       \ 'coc-git',
"       \]

Plug 'folke/which-key.nvim'

call plug#end()

colorscheme solarized

set completeopt=noinsert,menuone,noselect
set complete+=kspell

" Expand tabs to spaces
set expandtab

" https://github.com/vim/vim/blob/master/runtime/doc/russian.txt
" Enable hotkeys for Russian layout
set langmap=ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz

" Use the system clipboard
set clipboard=unnamed

set softtabstop=2
set shiftwidth=2
set tabstop=4

"" Show line numbers
set number

"" Cursor highlights
set cursorline

"" Turn off folding
set nofoldenable

" Indicator chars
set showbreak=↪\

"" Use mouse everywhere
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
set wildignore+=tags

set complete=.,w,b,u,t,i

" Be smart about it
set smartindent

" Do not wrap lines
set nowrap

" Enable visual bell (disable audio bell)
set vb
set t_vb=
set visualbell

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

"" http://eduncan911.com/software/fix-slow-scrolling-in-vim-and-neovim.html
set cursorline!

cabbrev help tab help

if has('persistent_undo')      "check if your vim version supports it
  set undofile                 "turn on the feature
  set undodir=$HOME/.nvim_undo  "directory where the undo files will be stored
endif

let g:ruby_host_prog = '~/.rbenv/versions/2.6.6/bin/neovim-ruby-host'
let g:python3_host_prog = '/usr/local/bin/python3'
let g:node_host_prog = '/usr/local/bin/neovim-node-host'

" Set internal encoding of vim, not needed on neovim, since coc.nvim using some
" unicode characters in the file autoload/float.vim
set encoding=utf-8


" source ~/dotfiles/nvim/configs-coc.vim
source ~/dotfiles/nvim/configs-ale.vim

" TODO
" Plug 'puremourning/vimspector'
" Plug 'dhruvasagar/vim-table-mode'
" Plug 'tpope/vim-unimpaired'
" Plug 'tpope/vim-repeat'
" Plug 'Chiel92/vim-autoformat'
" Plug 'rlue/vim-barbaric'
" Plug 'tpope/vim-rake'
" Plug 'vim-ruby/vim-ruby'
" Plug 'vim-airline/vim-airline'
