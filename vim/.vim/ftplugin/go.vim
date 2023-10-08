setlocal ts=4
let b:ale_fixers = {"go": ["gofmt"]}
let b:ale_fix_on_save = 1

map <buffer> <CR> :ALEGoToDefinition<CR>
