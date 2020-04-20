let b:ale_linters = { 'rust': ['rls'] }
let b:ale_rust_rls_toolchain = 'stable'
let b:ale_rust_rls_config = { 'rust': { 'clippy_preference': 'on' } }
let b:ale_fixers = { 'rust': ['rustfmt'] }
let b:ale_fix_on_save = 1
let b:ale_rust_rustfmt_options = "--edition 2018"

if filereadable("Cargo.toml")
    compiler cargo
    setlocal makeprg=cargo\ build
else
    setlocal makeprg=rustc\ %
endif
