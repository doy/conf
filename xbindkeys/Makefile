include ../Makefile.include

install:
	@systemctl --user enable xbindkeys
	@systemctl --user start xbindkeys

uninstall:
	@systemctl --user stop xbindkeys
	@systemctl --user disable xbindkeys
