if filereadable("Cargo.toml")
    setlocal makeprg=cargo\ build
else
    setlocal makeprg=rustc\ %
endif
