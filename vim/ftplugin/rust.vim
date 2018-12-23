let b:ale_linters = { 'rust': ['rls'] }
let b:ale_rust_rls_toolchain = 'stable'
let b:rustfmt_autosave = 1

if filereadable("Cargo.toml")
    compiler cargo
    setlocal makeprg=cargo\ build
else
    setlocal makeprg=rustc\ %
endif
