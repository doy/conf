include ../Makefile.include

install:
	@systemctl --user enable xss-lock
	@systemctl --user start xss-lock

uninstall:
	@systemctl --user stop xss-lock
	@systemctl --user disable xss-lock
