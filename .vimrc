set expandtab
set softtabstop=4
set tabstop=4
set shiftwidth=4
set autoindent
"set smartindent
set hlsearch
colorscheme desert256
if &diff
    colorscheme evening
endif

" set filetype detection, syntax highlighting, and filetype omnicompletion
filetype on
filetype plugin on
filetype indent on
syntax on
" detect in-file modelines for filetype detection
set modeline

" ensure letter size paper printing (not A4)
set printoptions=paper:letter
" makes left-right movement jump across lines
set whichwrap=h,l
" makes backspace key more powerful
set backspace=indent,eol,start
"set nu
set foldenable
set foldlevel=200
set textwidth=78
" allow switching between buffers without saving
set hidden
" show status line
set laststatus=2
" show complete options
set wildmenu
" show ruler
set ruler
" allow 256 or true colors
if $TERM_PROGRAM =~ "iTerm"
    set termguicolors
else
    set t_Co=256
endif


if has("autocmd")
" Drupal *.module files.
augroup module
autocmd BufRead *.module set filetype=php
augroup END
endif

call pathogen#infect()

"" Plugins (vim-plug manager)
call plug#begin()
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/syntastic'
Plug 'valloric/youcompleteme'
Plug 'epmatsw/ag.vim'
Plug 'easymotion/vim-easymotion'
Plug 'tomasr/molokai'
Plug 'morhetz/gruvbox'
Plug 'nanotech/jellybeans.vim', { 'tag':'v1.6' }
Plug 'chriskempson/base16-vim'
Plug 'Zenburn'
call plug#end()

" ========== Mappings ==========
" plugin-specific
noremap <silent> ,vc :cal VimCommanderToggle()<CR>
noremap <silent> ,tl :Tlist<CR>
noremap <silent> ,nt :NERDTreeToggle<CR>
let NERDShutUp=1
let VCSCommandMapPrefix='<Leader>v'

map ,gtd :!gtd %<C-M>:e<C-M><C-M>
map ,cd :cd %:p:h<CR>

" navigate wrapped lines visually using alt-key
map <A-DOWN> gj
map <A-UP> gk
imap <A-DOWN> <ESC>gji
imap <A-UP> <ESC>gki

" search visually selected text with g/ or g?
vnoremap <silent> g/ y/<C-R>=escape(@", '\\/.*$^~[]')<CR><CR>
vnoremap <silent> g? y?<C-R>=escape(@", '\\/.*$^~[]')<CR><CR>

" C settings
" set make program
set makeprg=gcc\ -Wall\ -o\ %<\ %
func! CompileGcc()
exec "w"
exec "!gcc -Wall % -o %<"
endfunc

func! CompileRunGcc()
exec "w"
exec "!gcc -Wall % -o %<"
exec "! ./%<"
endfunc
augroup C
map <F3> : call CompileGcc()<CR>
map <F4> : call CompileRunGcc()<CR>
augroup END

" Python settings
" set auto-continuation of comments
augroup Python
au!
au FileType python inoremap # X#
set tags+=~/.vim/tags/python.ctags
"au FileType python set omnifunc=pythoncomplete#Complete
"au FileType python set fo=croq
"au FileType python set foldenable
augroup END

" HTML settings
au BufRead,BufNewFile *.mako,*.mak,*.mko  set filetype=mako
au FileType html,xml,xsl,mako source ~/.vim/scripts/closetag.vim

" Biological sequence file settings
au BufRead,BufNewFile *.fasta   set filetype=fasta
au BufRead,BufNewFile *.gb,*.genbank   set filetype=gb
au FileType gb,fasta set fo=wc

au BufRead,BufNewFile *.typ     set filetype=text
au FileType mail set tw=60

"au BufRead,BufNewFile * syntax match Search /\%<81v.\%>77v/
"au BufRead,BufNewFile * syntax match ErrorMsg /\%>80v.\+/

" set unicode symbol keys
inoremap <C-h>oo °
inoremap <C-h>+- ±
inoremap <C-h>.. ·
inoremap <C-h><= ≤
inoremap <C-h>>= ≥
inoremap <C-h>!= ≠
"inoremap <C-h>int ∫
"inoremap <C-h>inf ∞

"inoremap <C-h>flat ♭
"inoremap <C-h>nat ♮
"inoremap <C-h>sharp ♯

inoremap <C-h>a α
inoremap <C-h>b β
inoremap <C-h>g γ
inoremap <C-h>d δ
inoremap <C-h>ep ε
inoremap <C-h>z ζ
inoremap <C-h>et η
inoremap <C-h>th θ
inoremap <C-h>i ι
inoremap <C-h>k κ
inoremap <C-h>l λ
inoremap <C-h>m μ
inoremap <C-h>n ν
inoremap <C-h>x ξ
inoremap <C-h>oc ο
inoremap <C-h>pi π
inoremap <C-h>r ρ
inoremap <C-h>s σ
inoremap <C-h>t τ
inoremap <C-h>u υ
inoremap <C-h>ph φ
inoremap <C-h>c χ
inoremap <C-h>ps ψ
inoremap <C-h>om ω

inoremap <C-h>A A
inoremap <C-h>B Β
inoremap <C-h>G Γ
inoremap <C-h>D Δ
inoremap <C-h>Ep Ε
inoremap <C-h>Z Ζ
inoremap <C-h>Et Η
inoremap <C-h>Th Θ
inoremap <C-h>I Ι
inoremap <C-h>K Κ
inoremap <C-h>L Λ
inoremap <C-h>M Μ
inoremap <C-h>N Ν
inoremap <C-h>X Ξ
inoremap <C-h>Oc Ο
inoremap <C-h>Pi Π
inoremap <C-h>R Ρ
inoremap <C-h>S Σ
inoremap <C-h>Ta Τ
inoremap <C-h>U Υ
inoremap <C-h>Ph Φ
inoremap <C-h>C Χ
inoremap <C-h>Ps Ψ
inoremap <C-h>Om Ω
