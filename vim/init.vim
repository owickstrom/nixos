" General
set nocompatible            " get rid of Vi compatibility mode. SET FIRST!
filetype plugin indent on   " filetype detection[ON] plugin[ON] indent[ON]
syntax enable               " enable syntax highlighting (previously syntax on).
set exrc                    " load .vimrc files from cwd
set secure                  " and do so in a secure way

" Tabs/spaces
set tabstop=2
set expandtab
set shiftwidth=2

" Navigation
set scrolloff=3             " some lines around scroll for context

" Cursor/Line
set number
set colorcolumn=-0          " based on textwidth
set cursorline              " highlight the current line

" Status/History
set history=200             " remember a lot of stuff
set ruler                   " Always show info along bottom.
set cmdheight=1

" Scrolling
set ttyfast

" Files
set autoread                            " auto-reload files changed on disk
set updatecount=0                       " disable swap files
set wildmode=longest,list,full 

" Vimdiff
set diffopt=filler,vertical

" Conceal (disabled by default)
set conceallevel=0

" Wrapping
set nowrap

" Leader
nnoremap <Space> <Nop>
let mapleader = ' '
let maplocalleader = ' '

" Make F1 work like Escape.
map <F1> <Esc>
imap <F1> <Esc>

" Mouse issue (https://github.com/neovim/neovim/wiki/Following-HEAD#20170403)
set mouse=a

" Use system clipboard for yanks.
set clipboard+=unnamedplus

" Use ,t for 'jump to tag'.
nnoremap <Leader>t <C-]>

" Allow hidden windows
set hidden

" Grep with rg
set grepprg=rg\ --line-number\ --column
set grepformat=%f:%l:%c:%m

" Theme
set termguicolors

if executable('darkman')
  let s:darkman_mode = trim(system('darkman get'))

  " Optional: fallback if the command failed
  if v:shell_error
    let s:darkman_mode = 'dark'
  endif

  if s:darkman_mode ==# 'light'
    set background=light
  else
    set background=dark
  endif
endif

colorscheme quiet

function! MyHighlights() abort
  " highlight Normal         guibg=none
  highlight Comment        gui=italic
  highlight link debugPC DiffAdd
endfunction

augroup MyColors
  autocmd!
  autocmd ColorScheme * call MyHighlights()
augroup END

call MyHighlights()

autocmd BufEnter * TSEnable highlight indent
autocmd BufEnter * TSBufEnable highlight indent
