include ../Makefile.include

install:
	@systemctl --user enable unclutter
	@systemctl --user start unclutter

uninstall:
	@systemctl --user stop unclutter
	@systemctl --user disable unclutter
