" Pathogen
filetype off
call pathogen#incubate()
call pathogen#helptags()
filetype plugin indent on

" Eclim is fully superseded by coc-java (see the eclim comment further
" down) but was still autostarting its own jdt.ls process on every
" FileType java, in every session, on top of coc-java's. This flag short-
" circuits .vim/plugin/eclim.vim before it adds eclim/ to the runtimepath
" at all, so eclim/ftplugin/java.vim never gets a chance to spin one up.
let g:EclimDisabled = 1

" Per-directory local vimrc (".vimrc"/".exrc" in the cwd Vim was launched
" from), read on startup before any file is opened. 'secure' blocks
" autocmd/shell/write from those local files so a random directory can't
" run arbitrary commands just by cd-ing into it and opening vim.
set exrc
set secure

syntax enable
set background=dark
colorscheme solarized

set clipboard+=unnamed
set mouse=a
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
" eclim's GetExisting() uses :redir, which airline now calls via execute(),
" triggering E930. eclim's Java duties are already handled by coc.nvim.
let g:airline#extensions#eclim#enabled = 0

" Powerline
let g:Powerline_symbols = 'unicode'

" NERDTree
let g:NERDTreeShowHidden = 1
let g:NERDTreeWinSize = 40
let g:NERDTreeIgnore = ['.git$','.DS_Store', '\.pyc$']

" Auto-refresh the NERDTree listing (no built-in filesystem watch, so this
" simulates pressing 'R' in the tree window) whenever a buffer is entered or
" Vim regains focus, e.g. after `git checkout` or file creation outside Vim.
function! s:RefreshNERDTree()
    if nerdtree#treeExistsForTab() && bufwinnr(t:NERDTreeBufName) != -1
        let l:winnr = winnr()
        execute bufwinnr(t:NERDTreeBufName) . 'wincmd w'
        execute 'normal R'
        execute l:winnr . 'wincmd w'
    endif
endfunction

augroup NERDTreeRefresh
    autocmd!
    autocmd BufEnter,FocusGained * call s:RefreshNERDTree()
augroup END

" Session management (vim-obsession) — IntelliJ-style "reopen where I left
" off". Session files are per-directory (".vim-session" in whatever dir Vim
" was launched from), so backend/, frontend/, and the repo root each keep
" their own tabs/splits/buffers independently. Only kicks in when Vim is
" launched with no file args (plain `vim`); opening a specific file
" (`vim foo.java`) bypasses session restore/recording entirely.
function! s:RestoreOrStartSession()
    let l:session = getcwd() . '/.vim-session'
    if filereadable(l:session)
        execute 'source' fnameescape(l:session)
        " NERDTree's buffer isn't covered by &sessionoptions, so a restored
        " session never brings it back on its own — reopen it as a fresh
        " sidebar, then restore focus to whatever window the session left
        " active (NERDTree opens as the new window 1, shifting others +1).
        if !(exists('t:NERDTreeBufName') && bufwinnr(t:NERDTreeBufName) != -1)
            let l:active = winnr()
            silent! NERDTree
            execute (l:active + 1) . 'wincmd w'
        endif
    else
        " silent! — NERDTree can throw a harmless E716 here (it renders
        " before other plugins finish their own VimEnter setup); without
        " silent! that error would abort this function before Obsession
        " ever starts recording.
        silent! NERDTree
        execute 'Obsession' fnameescape(l:session)
    endif
endfunction

augroup SessionManagement
    autocmd!
    autocmd VimEnter * nested if argc() == 0 | call s:RestoreOrStartSession() | else | NERDTree | endif
augroup END

" CTRLP
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_dont_split = 'NERD_tree_2'
let g:ctrlp_custom_ignore = 'node_modules\|DS_Store\|public\|git\||build'
set runtimepath^=~/.vim/bundle/ctrlp.vim

" ack.vim — global text search across files (":Ack pattern"), the IntelliJ
" "Find in Path" equivalent to CtrlP's find-by-filename. Backed by ripgrep;
" results land in the quickfix list, same as :make and vim-test
" (<Leader>tc from the vim-test section below closes it either way).
let g:ackprg = 'rg --vimgrep --no-heading --smart-case'
nnoremap <Leader>a :Ack!<Space>
nnoremap <Leader>aw :Ack! <C-r><C-w><CR>

" Color lines that go over 80 chars
" highlight OverLength ctermbg=red ctermfg=white guibg=#592929
" match OverLength /\%81v.\+/

" Eclim Intellisense
inoremap <C-l> <C-x><C-u>

" IndentLine
" vertical line indentation
let g:indentLine_color_term = 239
let g:indentLine_color_gui = '#09AA08'
let g:indentLine_char = '│'

" Auto close brackets/parenthesis
"let delimitMate_expand_cr = 1

" coc.nvim — LSP client for Java only (ALE keeps handling JS/TS/eslint).
" Backs gd/gr/K/rename/code-action via coc-java (same jdt.ls engine as
" before) and adds real semantic-token highlighting: classes, fields,
" locals, and static-vs-instance methods get distinct colors because coc
" asks jdt.ls to resolve them, instead of guessing from regex like a
" plain syntax file would.
"
" coc-java (jdtls) is ~600-700MB per instance and activates on any
" FileType java regardless of which directory Vim was started in, so it
" defaults to OFF here. Projects that actually have Java opt back in via
" a local ".vimrc" (see 'exrc' above), e.g. backend/.vimrc:
"   let g:coc_user_config = {'java.enabled': v:true}
let g:coc_user_config = {'java.enabled': v:false}
set hidden
set nobackup
set nowritebackup
set updatetime=300
set signcolumn=yes

inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
      \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" ALE
let g:ale_linters = {
\   'typescript':      ['tsserver', 'eslint'],
\   'typescriptreact': ['tsserver', 'eslint'],
\   'javascript':      ['eslint'],
\   'javascriptreact': ['eslint'],
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
" jdtls (Eclipse JDT Language Server) itself now runs via coc-java below,
" which manages its own workspace dirs and Lombok support instead of the
" hand-rolled ALE javaagent wiring this used to need.

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
    autocmd FileType java nmap <buffer> gd <Plug>(coc-definition)
    autocmd FileType java nmap <buffer> gr <Plug>(coc-references)
    autocmd FileType java nnoremap <buffer> K  :call CocActionAsync('doHover')<CR>
    autocmd FileType java nmap <buffer> <Leader>rn <Plug>(coc-rename)
    autocmd FileType java nnoremap <buffer> <Leader>oi :CocCommand java.action.organizeImports<CR>
    autocmd FileType java nmap <buffer> <Leader>ca <Plug>(coc-codeaction-cursor)
    autocmd FileType java nnoremap <buffer> <Leader>mc :Make<CR>
    autocmd FileType java nnoremap <buffer> <Leader>mt :Dispatch mvn -q -B test<CR>
    autocmd FileType java nnoremap <buffer> <Leader>mr :Start mvn spring-boot:run<CR>
augroup END

" vim-test — the "green gutter triangle" equivalent: run the JUnit test
" under the cursor (or the whole file/suite) via Maven, in a vim-dispatch
" split so pass/fail output shows without leaving the editor.
let test#strategy = 'dispatch'
let test#java#runner = 'maventest'

nmap <silent> <Leader>tt :TestNearest<CR>
nmap <silent> <Leader>tf :TestFile<CR>
nmap <silent> <Leader>ta :TestSuite<CR>
nmap <silent> <Leader>tl :TestLast<CR>
nmap <silent> <Leader>tv :TestVisit<CR>
nmap <silent> <Leader>tc :cclose<CR>

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

