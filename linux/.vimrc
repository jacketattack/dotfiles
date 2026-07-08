" Pathogen
filetype off
call pathogen#incubate()
call pathogen#helptags()
filetype plugin indent on

syntax enable
set background=dark
colorscheme solarized

set clipboard+=unnamed
set incsearch
set hlsearch
set nocompatible
set wildmenu
set t_Co=16
set ruler
set noswapfile
set cursorline
set backspace=2
set laststatus=2
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set autoindent
set ff=unix
set autoread
au FocusGained,BufEnter * checktime

set encoding=utf-8
set background=dark

set rtp+=~/.config/powerline/bindings/vim " runtime path
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc " files to ignore
set fillchars+=stl:\ ,stlnc:\ " set blank statusline separator

noremap <C-e> :NERDTreeToggle<CR>
noremap <F5> :%s/\s\+$//g
noremap <F6> :let &background = ( &background == "dark"? "light" : "dark" )<CR>
nnoremap <C-i> :IndentGuidesToggle<CR>
vnoremap <C-r> "hy:%s/<C-r>h//gc<left><left><left>

let mapleader = "\<Space>"
nnoremap <Leader>w :w<CR>
nnoremap <Leader>m :noh<CR>
nnoremap <Leader>p :set paste<CR>
noremap <Leader>q :%! jq .<CR>
imap jj <Esc>

" json synatx for vim
autocmd BufNewFile,BufRead *.json set ft=javascript
autocmd BufNewFile,BufRead *.tsx setlocal tabstop=2 shiftwidth=2 softtabstop=2
autocmd BufRead,BufNewFile *.md setlocal spell

" Airline
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline_theme = 'base16'

" Powerline
let g:Powerline_symbols = 'unicode'

" NERDTree
autocmd vimenter * NERDTree
let g:NERDTreeShowHidden = 1
let g:NERDTreeWinSize = 40
let g:NERDTreeIgnore = ['.git$','.DS_Store', '\.pyc$']

" CTRLP
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_dont_split = 'NERD_tree_2'
let g:ctrlp_custom_ignore = 'node_modules\|DS_Store\|public\|git\||build'
set runtimepath^=~/.vim/bundle/ctrlp.vim

" Color lines that go over 80 chars
highlight OverLength ctermbg=red ctermfg=white guibg=#592929
match OverLength /\%81v.\+/

" Eclim Intellisense
inoremap <C-l> <C-x><C-u>

" IndentLine
" vertical line indentation
let g:indentLine_color_term = 239
let g:indentLine_color_gui = '#09AA08'
let g:indentLine_char = '│'

" Auto close brackets/parenthesis
"let delimitMate_expand_cr = 1

" ALE
let g:ale_linters = {
\   'typescript':      ['tsserver', 'eslint'],
\   'typescriptreact': ['tsserver', 'eslint'],
\   'javascript':      ['eslint'],
\   'javascriptreact': ['eslint'],
\   'java':            ['eclipselsp'],
\}
let g:ale_fixers = {
\   'typescript':      ['prettier', 'eslint'],
\   'typescriptreact': ['prettier', 'eslint'],
\   'javascript':      ['prettier'],
\   'javascriptreact': ['prettier'],
\}
let g:ale_fix_on_save = 1
let g:ale_lint_on_text_changed = 'delay'
let g:ale_lint_delay = 500

highlight ALEError   cterm=underline ctermfg=NONE ctermbg=NONE
highlight ALEWarning cterm=underline ctermfg=NONE ctermbg=NONE
highlight ALEInfo    cterm=underline ctermfg=NONE ctermbg=NONE

let g:ale_sign_error   = '✗'
let g:ale_sign_warning = '▲'
let g:ale_virtualtext_cursor = 'current'

nmap <Leader>en <Plug>(ale_next_wrap)
nmap <Leader>ep <Plug>(ale_previous_wrap)
nmap <Leader>ee <Plug>(ale_detail)

" ALE completion (powers IntelliSense-style autocomplete from eclipselsp/tsserver)
let g:ale_completion_enabled = 1
let g:ale_completion_autoimport = 1
set completeopt=menu,menuone,popup,noselect,noinsert

" Java / Spring / Maven
" jdtls (Eclipse JDT Language Server) lives at ~/eclipse.jdt.ls, matching
" ALE's default g:ale_java_eclipselsp_path. Lombok needs to be loaded as a
" javaagent or jdtls will flag Lombok-generated methods as missing.
let g:ale_java_eclipselsp_javaagent = get(split(
\   globpath($HOME . '/.m2/repository/org/projectlombok/lombok', '*/lombok-*.jar'),
\   "\n"
\), -1, '')

" Walk up from a Java file to the nearest directory containing a pom.xml,
" so :Make/:Dispatch/:Start run mvn from the right place regardless of
" where Vim itself was launched (NERDTree opens at the repo root).
function! FindMavenRoot(path) abort
    let l:dir = fnamemodify(a:path, ':p:h')
    while l:dir !=# '/'
        if filereadable(l:dir . '/pom.xml')
            return l:dir
        endif
        let l:dir = fnamemodify(l:dir, ':h')
    endwhile
    return ''
endfunction

augroup java_lsp
    autocmd!
    autocmd FileType java compiler mvn
    autocmd FileType java let b:maven_root = FindMavenRoot(expand('%:p'))
    autocmd FileType java if !empty(get(b:, 'maven_root', '')) | execute 'lcd' fnameescape(b:maven_root) | endif
    autocmd FileType java nnoremap <buffer> gd :ALEGoToDefinition<CR>
    autocmd FileType java nnoremap <buffer> gr :ALEFindReferences<CR>
    autocmd FileType java nnoremap <buffer> K  :ALEHover<CR>
    autocmd FileType java nnoremap <buffer> <Leader>rn :ALERename<CR>
    autocmd FileType java nnoremap <buffer> <Leader>oi :ALEOrganizeImports<CR>
    autocmd FileType java nnoremap <buffer> <Leader>ca :ALECodeAction<CR>
    autocmd FileType java nnoremap <buffer> <Leader>mc :Make<CR>
    autocmd FileType java nnoremap <buffer> <Leader>mt :Dispatch mvn -q -B test<CR>
    autocmd FileType java nnoremap <buffer> <Leader>mr :Start mvn spring-boot:run<CR>
augroup END

" vim-dadbod / vim-dadbod-ui — Postgres client (DataGrip-style browse + query)
" Saved connections shown in the :DBUI tree. "pickempals_local" points at the
" Postgres container from backend/compose.yaml (user/pass/db all "pickempals").
" Requires the `psql` CLI (postgresql-client) to actually run queries.
let g:dbs = {
\   'pickempals_local': 'postgres://pickempals:pickempals@localhost:5432/pickempals',
\ }
let g:db_ui_save_location = expand('~/.vim/db_ui_queries')
let g:db_ui_show_database_icon = 1
let g:db_ui_use_nerd_fonts = 1

nnoremap <Leader>db :DBUIToggle<CR>
nnoremap <Leader>df :DBUIFindBuffer<CR>
nnoremap <Leader>dr :DBUIRenameBuffer<CR>
nnoremap <Leader>dl :DBUILastQueryInfo<CR>

