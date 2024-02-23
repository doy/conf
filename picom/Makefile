include ../Makefile.include

install:
	@systemctl --user enable picom
	@systemctl --user start picom

uninstall:
	@systemctl --user stop picom
	@systemctl --user disable picom
