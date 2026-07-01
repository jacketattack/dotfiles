" Vim compiler file
" Compiler:	Apache Maven (compiler plugin output)

if exists("current_compiler")
  finish
endif
let current_compiler = "mvn"

if exists(":CompilerSet") != 2
  command -nargs=* CompilerSet setlocal <args>
endif

let s:cpo_save = &cpo
set cpo&vim

CompilerSet makeprg=mvn\ -q\ -B\ compile
CompilerSet errorformat=
    \%E[ERROR]\ %f:[%l\\,%c]\ %m,
    \%W[WARNING]\ %f:[%l\\,%c]\ %m,
    \%-G%.%#

let &cpo = s:cpo_save
unlet s:cpo_save
