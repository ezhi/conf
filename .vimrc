set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set smarttab
set shiftround

set autoindent
set smartindent

set incsearch
"set hlsearch

set ignorecase smartcase
set wrap
set ruler
set scrolloff=4
set showmatch
set laststatus=2

set fencs=utf8,cp1251,koi8-r

set tags=tags;/
set path+=~/src/trunk/arcadia

autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g'\"" | endif

autocmd BufEnter * let &titlestring = system("echo $USER@ | grep -v '^ezhi@$'") . substitute(hostname(), "\\.[A-Z-]*\\.[A-Z-]*$", "", "") . ": " . expand("%:t")

let &titlestring = "vim"

if &term == "screen"
    set t_ts=k
    set t_fs=\
    autocmd BufEnter * let &titlestring =  expand("%:t") . " "
endif
if &term == "screen" || &term == "xterm"
    set title
endif

" Perl settings
let perl_extended_vars=1
let perl_want_scope_in_variables=1
let perl_include_pod=1

"set foldmethod=syntax

" that's for taglist
"set Tlist_Inc_Winwidth=0
"set number
"
syntax on

noremap <UP> <NOP>
noremap <DOWN> <NOP>
noremap <LEFT> <NOP>
noremap <RIGHT> <NOP>
noremap <PAGEUP> <NOP>
noremap <PAGEDOWN> <NOP>

inoremap <UP> <NOP>
inoremap <DOWN> <NOP>
inoremap <LEFT> <NOP>
inoremap <RIGHT> <NOP>
inoremap <PAGEUP> <NOP>
inoremap <PAGEDOWN> <NOP>

" navigate through top level blocks with k&r style opening braces
map [[ ?{<CR>e99[{
map ][ /}<CR>b99]}
map ]] j0[[%/{<CR>
map [] k$][%?}<CR>

map й q
map ц w
map у e
map к r
map е t
map н y
map г u
map ш i
map щ o
map з p
map х [
map ъ ]
map ф a
map ы s
map в d
map а f
map п g
map р h
map о j
map л k
map д l
map ж ;
map э '
map я z
map ч x
map с c
map м v
map и b
map т n
map ь m
map б ,
map ю .
map Й Q
map Ц W
map У E
map К R
map Е T
map Н Y
map Г U
map Ш I
map Щ O
map З P
map Х {
map Ъ }
map Ф A
map Ы S
map В D
map А F
map П G
map Р H
map О J
map Л K
map Д L
map Ж :
map Э "
map Я Z
map Ч X
map С C
map М V
map И B
map Т N
map Ь M
map Б <
map Ю >

map <Leader>ps bevT 

autocmd BufNewFile *:* call MyOpen(expand("<afile>"))
"autocmd BufReadPre echo "*"

"autocmd BufReadPre *:* exec 'file ' . substitute(expand('%'), ':.*', '', '')

function! MyOpen(filename)
  bdel
  exec "edit " . substitute(a:filename, ':.*', '', '')
  exec ":" . substitute(a:filename, '.*:', '', '')
  doau BufNewFile
endfunction

"autocmd BufWritePost ~/.vimrc   so ~/.vimrc
