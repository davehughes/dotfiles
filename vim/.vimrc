filetype off
filetype plugin indent on
set nocompatible
set modelines=0
set nowrap
set hidden
set expandtab
set ruler
set number
set textwidth=0
set tabstop=4
set bs=2
set softtabstop=4
set shiftwidth=4
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
Bundle 'kien/ctrlp.vim'
Bundle 'jceb/vim-orgmode'
Bundle 'scrooloose/syntastic'
Bundle 'majutsushi/tagbar'
Bundle 'kchmck/vim-coffee-script'
Bundle 'tpope/vim-commentary'
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-leiningen'
Bundle 'tpope/vim-projectionist'
Bundle 'tpope/vim-dispatch'
" Bundle 'vim-fireplace'
Bundle 'altercation/vim-colors-solarized'
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
Bundle 'rking/ag.vim'
Bundle 'digitaltoad/vim-jade'
Bundle 'fatih/vim-go'
Bundle 'vim-scripts/dbext.vim'
Bundle 'easymotion/vim-easymotion'
Plugin 'nsf/gocode', {'rtp': 'vim/'}
Plugin 'vim-scripts/paredit.vim'

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
au BufRead,BufNewFile *.sls set filetype=yaml
au BufRead,BufNewFile *.go set filetype=go
au BufRead,BufNewFile *.org set filetype=org
au BufRead,BufNewFile *.sql set filetype=sql
au BufRead,BufNewFile *.sql.j2 set filetype=sql
" autocmd BufWritePre * :%s/\s\+$//e " strip trailing whitespace
au FileType jade setl sw=2 sts=2 et
au FileType javascript setl sw=2 sts=2 et
au FileType yaml setl sw=2 sts=2 et
au FileType html setl sw=2 sts=2 et noexpandtab
au FileType go setl sw=2 sts=2 ts=2 et

" File-specific key mappings
" + Eval line or visual selection
au FileType clojure map [e :Eval<CR>
" + Reload current namespace
au FileType clojure map [r :Eval (use :reload-all (symbol (str *ns*)))<CR>

nmap <silent> <C-h> :bp<CR>
nmap <silent> <C-l> :bn<CR>
nmap <silent> <C-j> :wincmd w<CR>
nmap <silent> <C-k> :wincmd W<CR>
nmap ,gs :Gstatus<CR>
nmap ,gc :Gcommit<CR>
highlight SpellBad term=underline gui=undercurl guisp=Orange
nmap <Leader>t :TagbarToggle<CR>
nmap <Leader>j :cn<CR>zz
nmap <Leader>k :cp<CR>zz
nmap <Leader>s :set opfunc=SearchMotion<CR>g@

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

" Ctrl-P
let g:ctrlp_extensions = ["tag"]
" let g:ctrlp_cmd = 'CtrlPMRUFiles'
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif

" Syntastic
let g:syntastic_python_checkers = ["flake8", "pep8", "pyflakes", "python", "pylint"]
let g:syntastic_jslint_checkers = ["jshint"]

" UltiSnips setup
"let g:UltiSnipsSnippetDirectories=["bundle/ultisnips/UltiSnips", "snippets"]
"let g:UltiSnipsEditSplit="horizontal"

" neocomplcache setup
let g:neocomplcache_enable_at_startup = 0

" Git gutter
" autocmd VimEnter * EnableGitGutterLineHighlights
let g:gitgutter_max_signs = 10000

" Solarized color scheme and color/theme tools
set background=dark
colorscheme solarized

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

" dbext setup (adds psycopg2-style substitutions to regex, e.g. %(myvar)s)
let g:dbext_default_variable_def_regex = '\(\w\|'."'".'\)\@<!?\(\w\|'."'".'\)\@<!,\zs\(@\|:\a\|\$\)\w\+\>,\zs%(\s*\w\+\s*)s\>'
