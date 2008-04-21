" Vim syntax file
" Language:	Hiveminder tasks file
" Maintainer:	Marc Hartstein <marc.hartstein@alum.vassar.edu>
" Last Change:	2007 Dec 22

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

" Only spellcheck in appropriate regions
syn spell notoplevel

" Tasks -- turn on spellchecking here
syn region hmTask   start=/^\S/ end=/$/     contains=@Spell,hmTag,hmCommand,hmID nextgroup=hmDescription skipnl skipempty oneline

" Description - Detailed information on a task, spellcheck this too
syn match hmDescription /^\s\+.*$/  contained contains=@Spell nextgroup=hmDescription,hmTask skipnl skipempty

" Tag: One or more tags enclosed in []
syn region hmTag matchgroup=hmParen start=/\[/ end=/\]/ contained   contains=@noSpell

" ID: Task ID enclosed in ()
syn region hmID  matchgroup=hmParen start=/(/  end=/)/  contained   contains=@noSpell

" Commands: [command:parameter]
" Done as a match to find the internal colon which indicates a command.
syn match hmCommand         /\[[^\]]\+:[^\]]\+\]/       contained   contains=@NoSpell,hmCommandError,hmParameterError
syn match hmCommandError    /\[\s*\zs[^:\]\[]\+\ze\s*:/ contained
syn match hmParameterError  /[^\[\]]\s*\zs[^\]]\+/      contained

" [due: date|day]
syn match hmCommandDue  /\[\s*\zs\%(due\)\ze\s*:/               contained   containedin=hmCommand nextgroup=hmDueColon skipwhite
syn match hmDueColon    /:/   contained nextgroup=hmDate,hmDay,hmParameterError skipwhite

" [prio|priority: priority]
syn match hmCommandPri  /\[\s*\zs\%(prio\|priority\)\ze\s*:/    contained   containedin=hmCommand nextgroup=hmPriColon skipwhite
syn match hmPriColon    /:/   contained nextgroup=hmPriority,hmParameterError skipwhite
syn keyword hmPriority  contained highest 5 e high 4 d normal 3 c low 2 b lowest 1 a

" [owner|by: person]
syn match hmCommandOwn  /\[\s*\zs\%(owner\|by\)\ze\s*:/         contained   containedin=hmCommand nextgroup=hmOwnColon skipwhite
syn match hmOwnColon    /:/   contained nextgroup=hmEmail skipwhite
syn match hmEmail       /[^\]]\+/   contained

" [group: group]
syn match hmCommandGroup /\[\s*\zs\%(group\)\ze\s*:/            contained   containedin=hmCommand nextgroup=hmGroupColon skipwhite
syn match hmGroupColon  /:/   contained nextgroup=hmGroup skipwhite
syn match hmGroup       /[^\]]\+/   contained

" [hide[ until]: date]
syn match hmCommandHide /\[\s*\zshide\%( until\)\?\ze\s*:/      contained   containedin=hmCommand nextgroup=hmHideColon skipwhite
syn match hmHideColon   /:/   contained nextgroup=hmDate,hmDay,hmParameterError skipwhite

" Date or day of week keyword
syn match hmDate        /\d\{4}-\d\{2}-\d\{2}/  contained
syn keyword hmDay   contained monday tuesday wednesday thursday friday saturday sunday mon tue wed thu fri sat sun today tomorrow

" Special markers used in the tasks.txt file below

" Divider
syn match hmDivider     /^---\s*$/

" Header - don't parse this for anything special
syn region hmHeader     start=/\%^Your todo list appears below./ end=/^$/ contains=@noSpell

" Footer - don't parse this for anything special
syn region hmFooter     start=/^The code below this line lets Hiveminder know which tasks are on this list./  end=/\%$/  contains=@noSpell 

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_df_syntax_inits")
  if version < 508
    let did_df_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink hmHeader       Comment
  HiLink hmFooter       Comment

  HiLink hmTask         Identifier

  HiLink hmDescription  Normal

  HiLink hmTag          String
  HiLink hmID           Special

  HiLink hmCommandDue   Keyword
  HiLink hmCommandPri   Keyword
  HiLink hmCommandOwn   Keyword
  HiLink hmCommandGroup Keyword
  HiLink hmCommandHide  Keyword

  HiLink hmPriority     String
  HiLink hmDate         Number
  HiLink hmDay          String
  HiLink hmEmail        String

  HiLink hmDivider      Statement

  HiLink hmCommandError     Error
  HiLink hmParameterError   Error

  delcommand HiLink
endif

let b:current_syntax = "hiveminder"

" vim: ts=8
