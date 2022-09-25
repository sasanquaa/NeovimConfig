call plug#begin()

Plug 'neoclide/coc.nvim', { 'branch': 'release' }
Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'easymotion/vim-easymotion'
Plug 'itchyny/lightline.vim'
Plug 'pocco81/auto-save.nvim'
Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
Plug 'tpope/vim-commentary'
Plug 'doums/darcula'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'ryanoasis/vim-devicons'
Plug 'akinsho/bufferline.nvim', { 'tag': 'v2.*' }
Plug 'airblade/vim-gitgutter'
Plug 'haya14busa/incsearch.vim'
Plug 'haya14busa/incsearch-easymotion.vim'
Plug 'haya14busa/incsearch-fuzzy.vim'

call plug#end()

colorscheme darcula

hi clear SignColumn
hi! link CocErrorSign ErrorSign
hi! link CocWarningSign WarningSign
hi! link CocInfoSign InfoSign
hi! link CocHintSign HintSign
hi! link CocErrorFloat Pmenu
hi! link CocWarningFloat Pmenu
hi! link CocInfoFloat Pmenu
hi! link CocHintFloat Pmenu
hi! link CocHighlightText IdentifierUnderCaret
hi! link CocHighlightRead IdentifierUnderCaret
hi! link CocHighlightWrite IdentifierUnderCaretWrite
hi! link CocErrorHighlight CodeError
hi! link CocWarningHighlight CodeWarning
hi! link CocInfoHighlight CodeInfo
hi! link CocHintHighlight CodeHint

hi! link GitGutterAdd GitAddStripe
hi! link GitGutterChange GitChangeStripe
hi! link GitGutterDelete GitDeleteStripe

let g:lightline = { 'colorscheme': 'darculaOriginal' }
let g:gitgutter_sign_removed = '▶'
let g:gitgutter_signs=0
let g:incsearch#auto_nohlsearch = 1

filetype plugin indent on
syntax on

set noswapfile
set nobackup
set number
set cursorline
set nowritebackup
set updatetime=100
set signcolumn=number

set statusline+=%{GitStatus()}
set backspace=start,eol,indent
set smartindent
set autoindent
set shiftwidth=4
set tabstop=4
set softtabstop=4
set expandtab
set smarttab


noremap <silent><expr> <Leader><Leader><Leader> incsearch#go(<SID>config_easyfuzzymotion())

inoremap <silent><expr> <TAB> coc#pum#visible() ? coc#_select_confirm() : "\<Tab>"
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#_select_confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

nnoremap <silent> K :call CocShowDocumentation()<CR>
nnoremap ntf :NERDTreeFocus<CR>
nnoremap ntt :NERDTreeToggle<CR>
nnoremap ntc :NERDTreeClose<CR>
nnoremap nts :NERDTreeFind<CR>
nnoremap ntr :NERDTreeRefreshRoot<CR>

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <Leader>rn <Plug>(coc-rename)
nmap <Leader>f <Plug>(coc-format-selected)

xmap <Leader>f <Plug>(coc-format-selected)

autocmd CursorHold * silent call CocActionAsync('highlight')

lua << EOF
    require("nvim-treesitter.configs").setup {
        ensure_installed = { "c", "cpp", "lua" },
        highlight = {
            enabled = true
        },
        indent = {
            enabled = true
        }
    }
    require("bufferline").setup {}
    require("auto-save").setup {
        write_all_buffers = true
    }
EOF

function! s:config_easyfuzzymotion(...) abort
    return extend(copy({
    \   'converters': [incsearch#config#fuzzy#converter()],
    \   'modules': [incsearch#config#easymotion#module()],
    \   'keymap': {"\<CR>": '<Over>(easymotion)'},
    \   'is_expr': 0,
    \   'is_stay': 1
    \ }), get(a:, 1, {}))
endfunction

function! CocShowDocumentation()
    if CocAction('hasProvider', 'hover')
        call CocActionAsync('doHover')
    else
        call feedkeys('K', 'in')
    endif
endfunction

function! GitStatus()
  return join(filter(map(['A','M','D'], {i,v -> v.': '.GitGutterGetHunkSummary()[i]}), 'v:val[-1:]'), ' ')
endfunction
