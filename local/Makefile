include ../Makefile.include

install:
	@systemctl --user enable watch-kbd
	@systemctl --user start watch-kbd

uninstall:
	@systemctl --user stop watch-kbd
	@systemctl --user disable watch-kbd
