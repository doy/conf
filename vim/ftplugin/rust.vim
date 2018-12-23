let b:ale_linters = { 'rust': ['rls'] }
let b:ale_rust_rls_toolchain = 'stable'
let b:ale_fixers = { 'rust': ['rustfmt'] }
let b:ale_fix_on_save = 1

if filereadable("Cargo.toml")
    compiler cargo
    setlocal makeprg=cargo\ build
else
    setlocal makeprg=rustc\ %
endif
