if filereadable("Cargo.toml")
     compiler cargo
    setlocal makeprg=cargo\ build
else
    setlocal makeprg=rustc\ %
endif

let b:ale_rust_cargo_use_check = 1
