" Vim syntax file
" Language:	TAEB logfiles
" Author:	Jesse Luehrs <doy at tozt dot net>
" Version:	20081207
" Copyright:	Copyright (c) 2008 Jesse Luehrs
" Licence:	You may redistribute this under the same terms as Vim itself

if exists("b:current_syntax")
  finish
endif

syn keyword TAEBlevellow  DEBUG INFO NOTICE
            \ contained
syn keyword TAEBlevelmid  WARNING
            \ contained
syn keyword TAEBlevelhigh ERROR CRITICAL EMERGENCY
            \ contained
syn match   TAEBinfo      /^.\{-}\]/
            \ contains=TAEBturn,TAEBtime,TAEBmsgtype
syn match   TAEBtime      /\d\d\d\d-\d\d-\d\d \d\d:\d\d:\d\d/
            \ display nextgroup=TAEBmsgtype skipwhite contained
syn match   TAEBturn      /^<T\(-\|\d\+\)>/
            \ display nextgroup=TAEBtime skipwhite contained
syn match   TAEBmsgtype   /\[[^]]\{-}\]/
            \ display contains=TAEBlevel.*,TAEBchannel contained
syn match   TAEBchannel   /:\zs\w\+\ze\]/
            \ display contained

hi def link TAEBturn      Keyword
hi def link TAEBtime      Comment
hi def link TAEBlevellow  Identifier
hi def link TAEBlevelmid  Todo
hi def link TAEBlevelhigh Error
hi def link TAEBchannel   Special
hi def link TAEBmsgtype   Type

let b:current_syntax = "taeb-log"
