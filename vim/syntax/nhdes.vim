" Vim syntax file
" Language:	NetHack DES file
" Author:	Pasi Kallinen <paxed@alt.org>
" Version:	20061119
" Copyright:	Copyright (c) 2006 Pasi Kallinen
" Licence:	You may redistribute this under the same terms as NetHack itself

if exists("b:current_syntax")
  finish
endif

syn sync minlines=30

" we're case sensitive
syn case match

syn region nhDesComment start=/^[ \t]*#/ end=/$/

syn keyword nhDesCommandNoArgs
    \ NOMAP RANDOM_CORRIDORS WALLIFY

syn keyword nhDesCommandWithArgs
    \ ALTAR BRANCH CHANCE CONTAINER CORRIDOR DOOR DRAWBRIDGE ENGRAVING
    \ FLAGS FOUNTAIN GEOMETRY GOLD INIT_MAP LADDER LEVEL MAZE MAZEWALK
    \ MESSAGE MONSTER NAME NON_DIGGABLE NON_PASSWALL OBJECT POOL PORTAL
    \ RANDOM_MONSTERS RANDOM_OBJECTS RANDOM_PLACES REGION ROOM SINK STAIR
    \ SUBROOM TELEPORT_REGION TRAP

syn keyword nhDesRegister
    \ align monster object place

syn keyword nhDesConstant
    \ altar arboreal asleep awake blessed bottom broken burn center chaos
    \ closed coaligned \contained cursed down dust east engrave false filled
    \ half-left half-right hardfloor hostile law left levregion lit locked
    \ mark m_feature m_monster m_object neutral noalign nodoor nommap
    \ noncoaligned none north noteleport open peaceful random right sanctum
    \ shortsighted shrine south top true uncursed unfilled unlit up west

syn region nhDesString start=/"/ end=/"/
syn match nhDesChar /'.'/

syn match nhDesMapCharDoor /[+S]/ contained
syn match nhDesMapCharFloor /[\.B]/ contained
syn match nhDesMapCharCorridor /[#H]/ contained
syn match nhDesMapCharWall /[\-\| ]/ contained
syn match nhDesMapCharWater /[WP}{]/ contained
syn match nhDesMapCharThrone /\\/ contained
syn match nhDesMapCharAir /A/ contained
syn match nhDesMapCharCloud /C/ contained
syn match nhDesMapCharLava /L/ contained
syn match nhDesMapCharSink /K/ contained
syn match nhDesMapCharIce /I/ contained
syn match nhDesMapCharTree /T/ contained
syn match nhDesMapCharIronbars /F/ contained
syn match nhDesMapCharLinenum /[0123456789]/ contained
" TODO: Any better way to do this?
syn match nhDesMapCharError /[^+S\.B#H\-\| WP}{\\ACLKITF0-9]/ contained

syn region nhDesMap matchgroup=nhDesCommandNoArgs start=/^MAP$/ end=/^ENDMAP$/ contains=nhDesMapCharError,nhDesMapCharDoor,nhDesMapCharFloor,nhDesMapCharCorridor,nhDesMapCharWall,nhDesMapCharWater,nhDesMapCharThrone,nhDesMapCharAir,nhDesMapCharCloud,nhDesMapCharLava,nhDesMapCharSink,nhDesMapCharIce,nhDesMapCharTree,nhDesMapCharIronbars,nhDesMapCharLinenum

hi def link nhDesComment	 Comment
hi def link nhDesCommandNoArgs	 KeyWord
hi def link nhDesCommandWithArgs KeyWord
hi def link nhDesRegister	 Constant
hi def link nhDesConstant	 Constant
hi def link nhDesString		 String
hi def link nhDesChar		 String

highlight   nhDesMapCharDoor ctermbg=black   ctermfg=brown
highlight   nhDesMapCharFloor ctermbg=black   ctermfg=grey
highlight   nhDesMapCharCorridor ctermbg=black   ctermfg=grey
highlight   nhDesMapCharWall ctermbg=black   ctermfg=grey
highlight   nhDesMapCharWater ctermbg=black   ctermfg=darkblue
highlight   nhDesMapCharThrone ctermbg=black   ctermfg=yellow
highlight   nhDesMapCharAir ctermbg=black   ctermfg=lightblue
highlight   nhDesMapCharCloud ctermbg=black   ctermfg=grey
highlight   nhDesMapCharLava ctermbg=black   ctermfg=red
highlight   nhDesMapCharSink ctermbg=black   ctermfg=grey
highlight   nhDesMapCharIce ctermbg=black   ctermfg=lightblue
highlight   nhDesMapCharTree ctermbg=black   ctermfg=green
highlight   nhDesMapCharIronbars ctermbg=black   ctermfg=cyan
highlight   nhDesMapCharLinenum ctermbg=black   ctermfg=darkgrey
highlight   nhDesMapCharError ctermbg=red   ctermfg=yellow

let b:current_syntax = "nhdes"
