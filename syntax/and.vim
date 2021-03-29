if exists("b:current_syntax")
  finish
endif

let b:current_syntax = "and"

set foldmethod=syntax
syn sync fromstart

syn match variable contained '\w\+\ze:'
syn match parameter contained '\w\+'
syn keyword root contained ROOT
syn region parameters contained start='(' end=')' contains=parameter transparent
syn region placeholder contained start='\[' end='\]' contains=variable,root,parameters
syn match comment '//.*'
syn region object start="<" end=">" contained contains=parameters

" This doesn't highlight anything, but it is used for folding the objects.
syn region object_fold start="<[^/>]\{-}>" end="</[^>]\{-}>" contains=object_fold,object,comment,placeholder keepend extend fold transparent

hi def link placeholder Statement
hi def link object Statement
hi def link comment Comment
hi def link variable Constant
hi def link parameter Constant
hi def link root Keyword

" Set the fold text to include the whole fold to a max of 80 characters,
" skipping multiple spaces except for the initial indentation.
set foldtext=FoldText()
function FoldText()
  let lines = join(getline(v:foldstart, v:foldend), ' ')
  let indent = matchstr(lines, "^ *") " We keep the indent of the first line, since this is more readable.
  let lines = trim(lines)
  let lines = substitute(lines, "  *", " ", 'g')
  let lines = indent . lines
  return lines[0:80]
endfunction
