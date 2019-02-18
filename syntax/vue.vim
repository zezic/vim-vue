" Vim syntax file
" Language:             Vue Singlefile Component
" Maintainer:           Sergey Ukolov <zezic51@yandex.ru>
" Repository:           https://github.com/zezic/vim-vue
" Last Change:          2019 February 18
"

" quit when a syntax file was already loaded
if !exists("main_syntax")
  if exists("b:current_syntax")
    finish
  endif
  let main_syntax = 'vue'
endif

let s:cpo_save = &cpo
set cpo&vim

syntax spell toplevel

syn case ignore

" mark illegal characters
syn match vueError "[<>&]"


" tags
syn region  vueString   contained start=+"+ end=+"+
syn region  vueString   contained start=+'+ end=+'+
syn region  vueEndTag             start=+</+      end=+>+ contains=vueTagN,vueTagError
syn region  vueTag                start=+<[^/]+   end=+>+ fold contains=vueTagN,vueString,vueArg,vueValue,vueTagError,@vueArgCluster
syn match   vueTagN     contained +<\s*[-a-zA-Z0-9]\++hs=s+1 contains=vueTagName,vueSpecialTagName,@vueTagNameCluster
syn match   vueTagN     contained +</\s*[-a-zA-Z0-9]\++hs=s+2 contains=vueTagName,vueSpecialTagName,@vueTagNameCluster
syn match   vueTagError contained "[^>]<"ms=s+1


" tag names
" syn keyword vueTagName contained template script style

" legal arg names
syn keyword vueArg contained lang scoped

" Comments
syn region vueComment                start=+<!--+    end=+--\s*>+ contains=@Spell
syn region vueComment                start=+<!+      end=+>+   contains=vueCommentPart,vueCommentError,@Spell
syn match  vueCommentError contained "[^><!]"
syn region vueCommentPart  contained start=+--+      end=+--\s*+  contains=@Spell

if !exists("vue_no_rendering")
  " rendering
  syn cluster vueTop contains=@Spell,vueTag,vueEndTag,vueComment,javaScript,@vuePreproc
  syn match vueLeadingSpace "^\s\+" contained
endif

syn keyword vueSpecialTagName  contained template script style



" Pug
syn include @vuePug syntax/pug.vim
unlet b:current_syntax
syn region  pug start=+<template lang='pug'\_[^>]*>+ keepend end=+</template\_[^>]*>+me=s-1 contains=@vuePug,vueTemplateTag,@vuePreproc
syn region  vueTemplateTag     contained start=+<template+ end=+>+ fold contains=vueTagN,vueString,vueArg,vueValue,vueTagError
hi def link vueTemplateTag vueTag

syn cluster vuePug      add=@vuePreproc

" JavaScript
syn include @vueJavaScript syntax/javascript.vim
unlet b:current_syntax
syn region  javaScript start=+<script\_[^>]*>+ keepend end=+</script\_[^>]*>+me=s-1 contains=@vueJavaScript,vueScriptTag,@vuePreproc
syn region  vueScriptTag     contained start=+<script+ end=+>+ fold contains=vueTagN,vueString,vueArg,vueValue,vueTagError
hi def link vueScriptTag vueTag

syn cluster vueJavaScript      add=@vuePreproc

" CSS
syn include @vueCss syntax/css.vim
unlet b:current_syntax
syn region cssStyle start=+<style>+ keepend end=+</style>+ contains=@vueCss,vueTag,vueEndTag,@vuePreproc
syn region cssStyle start=+<style scoped>+ keepend end=+</style>+ contains=@vueCss,vueTag,vueEndTag,@vuePreproc

" Sass
syn include @vueSass syntax/sass.vim
unlet b:current_syntax
syn region sassStyle start=+<style lang='sass+ keepend end=+</style>+ contains=@vueSass,vueTag,vueEndTag,@vuePreproc
syn region sassStyle start=+<style scoped lang='sass+ keepend end=+</style>+ contains=@vueSass,vueTag,vueEndTag,@vuePreproc


if main_syntax == "vue"
  " synchronizing (does not always work if a comment includes legal
  " vue tags, but doing it right would mean to always start
  " at the first line, which is too slow)
  syn sync match vueHighlight groupthere NONE "<[/a-zA-Z]"
  syn sync match vueHighlight groupthere javaScript "<script"
  syn sync match vueHighlightSkip "^.*['\"].*$"
  syn sync minlines=10
endif

" The default highlighting.
hi def link vueTag                     Function
hi def link vueEndTag                  Identifier
hi def link vueArg                     Type
hi def link vueTagName                 htmlStatement
hi def link vueSpecialTagName          Exception
hi def link vueValue                     String

hi def link vueString             String
hi def link vueComment            Comment
hi def link vueCommentPart        Comment
hi def link vueValue              String
hi def link vueCommentError       htmlError
hi def link vueTagError           htmlError
hi def link vueError              Error

hi def link javaScript             Special

let b:current_syntax = "vue"

if main_syntax == 'vue'
  unlet main_syntax
endif

let &cpo = s:cpo_save
unlet s:cpo_save
" vim: ts=2
