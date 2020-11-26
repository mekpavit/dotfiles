set nopaste
set number relativenumber
set backspace=indent,eol,start
set noswapfile
set autowrite
set completeopt-=preview
set splitright

inoremap jk <ESC>
let mapleader = " "
filetype plugin indent on
syntax on
set encoding=utf-8
set clipboard=unnamed

inoremap " ""<left>
inoremap ' ''<left>
inoremap ( ()<left>
inoremap [ []<left>
inoremap { {}<left>
inoremap {<CR> {<CR>}<ESC>O
inoremap {;<CR> {<CR>};<ESC>O

let g:UltiSnipsExpandTrigger = '<C-j>'
let g:UltiSnipsJumpForwardTrigger = '<C-j>'
let g:UltiSnipsJumpBackwardTrigger = '<C-k>'
let g:ycm_key_list_stop_completion = ['<C-y>', '<CR>']

function! s:build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#test#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction
autocmd FileType go nmap <leader>b :<C-u>call <SID>build_go_files()<CR>
autocmd FileType go nmap <leader>t  <Plug>(go-test)
autocmd FileType go nmap <Leader>c <Plug>(go-coverage-toggle)
let g:go_debug_windows = {
      \ 'vars':       'rightbelow 60vnew',
      \ 'stack':      'rightbelow 10new',
\ }
let g:go_fmt_command = "goimports"

call plug#begin('~/.vim/plugged')

Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

Plug 'preservim/nerdtree'

Plug 'tpope/vim-fugitive'

Plug 'vim-airline/vim-airline'

Plug 'airblade/vim-gitgutter'

Plug 'SirVer/ultisnips'

Plug 'Xuyuanp/nerdtree-git-plugin'

Plug 'valloric/youcompleteme'

call plug#end()
