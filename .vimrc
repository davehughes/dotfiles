filetype off
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()
filetype plugin indent on
set nocompatible
set modelines=0
set nowrap
set hidden
set expandtab
set textwidth=0
set tabstop=8
set softtabstop=4
set shiftwidth=4
set autoindent
set hlsearch
set backupdir=~/.vim/sessions//
set directory=~/.vim/sessions//
set tags=tags,/virtualenvs/asurepo/lib/python2.7/site-packages/tags,/virtualenvs/src/tags
syntax on
" nmap <silent> <c-t> :TlistToggle<CR>
nmap <silent> <c-q> :NERDTreeToggle<CR>
nmap <silent> <c-h> :noh<CR>
nmap <silent> <c-n> :bn<CR>
nmap <silent> <c-k> :bp<CR>
nmap <silent> <c-p> :b#<CR>
nmap ,s :Gstatus<CR>
nmap ,c :Gcommit<CR>
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

