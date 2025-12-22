include ../Makefile.include

install:
	@[ -n "$XDG_RUNTIME_DIR" ] && systemctl --user enable logout
	@[ -n "$XDG_RUNTIME_DIR" ] && systemctl --user start logout

uninstall:
	@[ -n "$XDG_RUNTIME_DIR" ] && systemctl --user stop logout
	@[ -n "$XDG_RUNTIME_DIR" ] && systemctl --user disable logout
