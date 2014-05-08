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
set wildignore+=*.o,*.obj,.git,*.pyc,*.egg-info,*.vim,*/htmlcov/*
set clipboard=unnamed

" Vundle configuration and packages
set rtp+=~/.vim/bundle/vundle
call vundle#rc()
Bundle 'gmarik/vundle'
Bundle 'kien/ctrlp.vim'
Bundle 'Shougo/neocomplcache'
Bundle 'scrooloose/syntastic'
Bundle 'majutsushi/tagbar'
" Bundle 'SirVer/ultisnips'
Bundle 'kchmck/vim-coffee-script'
Bundle 'tpope/vim-commentary'
Bundle 'tpope/vim-fugitive'
Bundle 'altercation/vim-colors-solarized'
Bundle 'tpope/vim-fireplace'
Bundle 'tpope/vim-classpath'
Bundle 'guns/vim-clojure-static'
Bundle 'grep.vim'
Bundle 'QuickBuf'
Bundle 'taglist.vim'
" Bundle 'VimClojure'
Bundle 'sudo.vim'
Bundle 'ScrollColors'
Bundle 'Colour-Sampler-Pack'
Bundle 'spacehi.vim'
Bundle 'groenewege/vim-less'
Bundle 'airblade/vim-gitgutter'
Bundle 'http://mg.pov.lt/vim/plugin/py-coverage-highlight.vim'
Bundle 'tclem/vim-arduino'
Bundle 'rking/ag.vim'

" Syntax config
syntax on
au BufNewFile,BufRead *.less set filetype=less
au BufNewFile,BufRead *.zsh-theme set filetype=zsh
au BufRead,BufNewFile *.pde set filetype=arduino
au BufRead,BufNewFile *.ino set filetype=arduino
" autocmd BufWritePre * :%s/\s\+$//e " strip trailing whitespace

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

" Syntastic
let g:syntastic_python_checkers = ["flake8", "pep8", "pyflakes", "python", "pylint"]

" UltiSnips setup
"let g:UltiSnipsSnippetDirectories=["bundle/ultisnips/UltiSnips", "snippets"]
"let g:UltiSnipsEditSplit="horizontal"

" neocomplcache setup
let g:neocomplcache_enable_at_startup = 0

" Git gutter
" autocmd VimEnter * EnableGitGutterLineHighlights

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

" File-specific tab settings
au FileType html setl noexpandtab tabstop=4

" File-specific key mappings
" + Eval line or visual selection
au FileType clojure map [e :Eval<CR>
" + Reload current namespace
au FileType clojure map [r :Eval (use :reload-all (symbol (str *ns*)))<CR>

" Add the virtualenv's site-packages to vim path
py << EOF
import os.path
import sys
import vim
if 'VIRTUAL_ENV' in os.environ:
    project_base_dir = os.environ['VIRTUAL_ENV']
    sys.path.insert(0, project_base_dir)
    activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
    execfile(activate_this, dict(__file__=activate_this))
EOF

