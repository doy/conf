let b:ale_linters = { 'rust': ['analyzer'] }
let b:ale_rust_analyzer_config = {
    \'checkOnSave': { 'command': 'clippy' },
    \'cargo': { 'allFeatures': v:true },
    \'diagnostics': { 'disabled': ['inactive-code'] },
\}
let b:ale_fixers = { 'rust': ['rustfmt'] }
let b:ale_fix_on_save = 1
let b:ale_rust_rustfmt_options = "--edition 2018"

map <buffer> <CR> :ALEGoToDefinition<CR>

if filereadable("Cargo.toml")
    compiler cargo
    setlocal makeprg=cargo\ build
else
    setlocal makeprg=rustc\ %
endif
