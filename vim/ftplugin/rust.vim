let b:ale_rust_cargo_use_check = 1
let b:rustfmt_autosave = 1

if filereadable("Cargo.toml")
    compiler cargo
    setlocal makeprg=cargo\ build
else
    setlocal makeprg=rustc\ %
endif
