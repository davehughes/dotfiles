filetype off
filetype plugin indent on
let mapleader="\\"
set nocompatible
set modelines=0
set nowrap
set hidden
set ruler
set number
set textwidth=0
set bs=2
set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2
set autoindent
set hlsearch
set backupdir=~/.vim/sessions//
set directory=~/.vim/sessions//
set tags=.tags,tags,env/lib/tags,env/src/tags
set wildignore+=*.o,*.obj,.git,*.pyc,*.egg-info,*.vim,*/htmlcov/*,*/vendor/*
set clipboard=unnamed

" Vundle configuration and packages
set rtp+=~/.vim/bundle/vundle
call vundle#rc()
Bundle 'gmarik/vundle'
Bundle 'jceb/vim-orgmode'
Bundle 'majutsushi/tagbar'
Bundle 'tomtom/tcomment_vim'
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-leiningen'
Bundle 'tpope/vim-projectionist'
Bundle 'tpope/vim-dispatch'
" Bundle 'altercation/vim-colors-solarized'
Bundle 'tpope/vim-fireplace'
Bundle 'tpope/vim-classpath'
Bundle 'guns/vim-clojure-static'
Bundle 'grep.vim'
Bundle 'taglist.vim'
" Bundle 'VimClojure'
Bundle 'sudo.vim'
Bundle 'ScrollColors'
Bundle 'Colour-Sampler-Pack'
Bundle 'spacehi.vim'
Bundle 'groenewege/vim-less'
Bundle 'airblade/vim-gitgutter'
Bundle 'tclem/vim-arduino'
Bundle 'digitaltoad/vim-pug'
Bundle 'fatih/vim-go'
Bundle 'vim-scripts/dbext.vim'
Bundle 'nathanielc/vim-tickscript'
" Bundle 'easymotion/vim-easymotion'
Bundle 'vim-ruby/vim-ruby'
Bundle 'janko/vim-test'
Bundle 'jakwings/vim-pony'
Plugin 'nsf/gocode', {'rtp': 'vim/'}
Plugin 'vim-scripts/paredit.vim'
Plugin 'hashivim/vim-terraform'
Plugin 'posva/vim-vue'
Plugin 'leafgarland/typescript-vim'
Plugin 'ngmy/vim-rubocop'
" Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'
Bundle 'sirtaj/vim-openscad'
Bundle 'venantius/vim-cljfmt'
Plugin 'morhetz/gruvbox'
Bundle 'sotte/presenting.vim'
Bundle 'honza/dockerfile.vim'
Plugin 'jremmen/vim-ripgrep'
" Bundle 'ruanyl/vim-gh-line'
Bundle 'davehughes/vim-gh-line'
Plugin 'udalov/kotlin-vim'
Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim'
Plugin 'dense-analysis/ale'
Plugin 'madox2/vim-ai'

" Syntax config
syntax on
au BufNewFile,BufRead *.less set filetype=less
au BufNewFile,BufRead *.zsh-theme set filetype=zsh
au BufNewFile,BufRead *.zshenv set filetype=zsh
au BufNewFile,BufRead *.zsh set filetype=zsh
au BufRead,BufNewFile *.pde set filetype=arduino
au BufRead,BufNewFile *.ino set filetype=arduino
au BufRead,BufNewFile *.js set filetype=javascript
au BufRead,BufNewFile *.clj set filetype=clojure
au BufRead,BufNewFile *.cljs set filetype=clojure
au BufRead,BufNewFile *.rkt,*.rktl,*.rktd set filetype=scheme
au BufRead,BufNewFile *.sls set filetype=yaml
au BufRead,BufNewFile *.go set filetype=go
au BufRead,BufNewFile *.org set filetype=org
au BufRead,BufNewFile *.sql set filetype=sql
au BufRead,BufNewFile *.sql.j2 set filetype=sql
au BufRead,BufNewFile *.tick set filetype=tick
au BufRead,BufNewFile *.vue set filetype=vue
au BufRead,BufNewFile *.ts set filetype=typescript
au BufRead,BufNewFile *.tsx set filetype=typescript
au BufRead,BufNewFile *.rb set filetype=ruby
au BufRead,BufNewFile *.jbuilder set filetype=ruby
au BufRead,BufNewFile *.pony set filetype=pony
au BufRead,BufNewFile *.html set filetype=html
au BufRead,BufNewFile *.tf* set filetype=terraform
au BufRead,BufNewFile *.df set filetype=dockerfile
au BufRead,BufNewFile *.make set filetype=makefile
au BufRead,BufNewFile *.kt set filetype=kotlin
" autocmd BufWritePre * :%s/\s\+$//e " strip trailing whitespace
au FileType html setl noexpandtab
au FileType tick commentstring=//\ %s
au FileType sql setl commentstring=--\ %s
au FileType pug setl commentstring=//-\ %s

" File-specific key mappings
" + Eval line or visual selection
au FileType clojure map [e :Eval<CR>
" + Reload current namespace
au FileType clojure map [r :Eval (use :reload-all (symbol (str *ns*)))<CR>

nmap <silent> <C-h> :bp<CR>
nmap <silent> <C-l> :bn<CR>
nmap <silent> <C-j> :wincmd w<CR>
nmap <silent> <C-k> :wincmd W<CR>
nmap <silent> <C-p> :GFiles<CR>
nmap <silent> <C-o> :Buffers<CR>
nmap <silent> <C-f> :Rg<CR>
nmap <silent> <C-g> :ALEGoToDefinition<CR>
nmap ,gs :Gstatus<CR>
nmap ,gc :Gcommit<CR>
nmap ,gb :Git blame<CR>
highlight SpellBad term=underline gui=undercurl guisp=Orange
nmap <Leader>t :TagbarToggle<CR>
nmap <Leader>T :Tags<CR>
nmap <Leader>j :cn<CR>zz
nmap <Leader>k :cp<CR>zz
nmap <Leader>s :set opfunc=SearchMotion<CR>g@
nmap <Leader>\\ gcc
vmap <Leader>\ gc

function! SearchMotion(type, ...)
  " Save selection and register and update selection for proper yanking
  let sel_save = &selection
  let reg_save = @@
  let &selection = "inclusive"

  if a:0  " Invoked from Visual mode, use '< and '> marks
    silent exe "normal! `<" . a:type . "`>y"
  elseif a:type == 'line'
    silent exe "normal! '[V']"
  elseif a:type == 'block'
    silent exe "normal! `[\<C-V>`]y"
  else
    silent exe "normal! `[v`]y"
  endif

  silent exe "Ag " . @@

  " Reset selection and register
  let &selection = sel_save
  let @@ = reg_save

endfunction

" Use ripgrep for default grep, CtrlP
if executable('rg')
  set grepprg=rg\ --color=never
  set grepformat=%f:%l:%c:%m
endif

" Git gutter
" autocmd VimEnter * EnableGitGutterLineHighlights
let g:gitgutter_max_signs = 10000

" Solarized color scheme and color/theme tools
set background=dark
" colorscheme solarized
colorscheme gruvbox

" Transparent background
hi Normal guibg=NONE ctermbg=NONE

" Easy color chooser bindings
nmap <silent> <f3> :NEXTCOLOR<cr>
nmap <silent> <f2> :PREVCOLOR<cr>

" Automatically reload this file when it changes
augroup myvimrc
    au!
    au BufWritePost .vimrc,_vimrc,vimrc,.gvimrc,_gvimrc,gvimrc so $MYVIMRC | if has('gui_running') | so $MYGVIMRC | endif
augroup END

" vim-go
let g:go_fmt_command = "goimports"
let g:go_version_warning = 0

" vim-terraform
let g:terraform_fmt_on_save = 1
let g:terraform_align = 1

" dbext setup (adds psycopg2-style substitutions to regex, e.g. %(myvar)s)
let g:dbext_default_variable_def_regex = '\(\w\|'."'".'\)\@<!?\(\w\|'."'".'\)\@<!,\zs\(@\|:\a\|\$\)\w\+\>,\zs%(\s*\w\+\s*)s\>'

" ultisnips
" let g:UltiSnipsEnableSnipMate = 0
let g:UltiSnipsExpandTrigger="<C-i><C-o>"
" let g:UltiSnipsJumpForwardTrigger="<c-N>"
" let g:UltiSnipsJumpBackwardTrigger="<c-M>"
" let g:UltiSnipsEditSplit="horizontal"
let g:UltiSnipsSnippetsDir=$HOME . '/.vim/snippets/davehughes'
let g:UltiSnipsSnippetDirectories=[$HOME . '/.vim/snippets/UltiSnips', $HOME . '/.vim/snippets/davehughes']

" folding
augroup AutoSaveFolds
  autocmd!
  "autocmd BufWinLeave ?* nested silent! mkview!
  "autocmd BufWinEnter ?* silent loadview
augroup END

let g:ale_fixers = {
\ '*': ['remove_trailing_lines', 'trim_whitespace'],
\ 'ruby': ['syntax_tree'],
\}
let g:ale_fix_on_save = 1
