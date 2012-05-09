filetype off
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()
filetype plugin indent on
set nocompatible
set modelines=0
set nowrap
set hidden
set expandtab
set ruler
set number
set textwidth=0
set tabstop=8
set bs=2
set softtabstop=4
set shiftwidth=4
set autoindent
set hlsearch
set backupdir=~/.vim/sessions//
set directory=~/.vim/sessions//
set tags=tags,env/lib/tags,env/src/tags
set wildignore+=*.o,*.obj,.git,*.pyc,*.egg-info,*.vim,/usr/local/repo/asurepo/static/**

" Syntax config
syntax on
au BufNewFile,BufRead *.less set filetype=less


nmap <silent> <C-h> :noh<CR>
nmap <silent> <C-j> :bn<CR>
nmap <silent> <C-k> :bp<CR>
nmap ,gs :Gstatus<CR>
nmap ,gc :Gcommit<CR>
highlight SpellBad term=underline gui=undercurl guisp=Orange 

" Snipmate settings
autocmd FileType python set ft=python.django
autocmd FileType html set ft=htmldjango.html

" Command-T - bump max-files so virtualenv files don't completely
" overwhelm other selections.
let g:CommandTMaxFiles=50000

" VimClojure setup
let vimclojure#HighlightBuiltins=1
let vimclojure#HighlightContrib=1
let vimclojure#DynamicHighlighting=1
let vimclojure#ParenRainbow=1
let vimclojure#WantNailgun = 1
let vimclojure#NailgunClient = $HOME . "/.vim/bin/ng"

" neocomplcache setup
let g:neocomplcache_enable_at_startup = 0

" Easy color chooser bindings
nmap <silent> <f3> :NEXTCOLOR<cr>
nmap <silent> <f2> :PREVCOLOR<cr>
colorscheme aqua

" Add the virtualenv's site-packages to vim path
" py << EOF
" import os.path
" import sys
" import vim
" if 'VIRTUAL_ENV' in os.environ:
"     project_base_dir = os.environ['VIRTUAL_ENV']
"     sys.path.insert(0, project_base_dir)
"     activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
"     execfile(activate_this, dict(__file__=activate_this))
" EOF

