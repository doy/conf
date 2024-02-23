include ../Makefile.include

install:
	@systemctl --user enable xcape
	@systemctl --user start xcape

uninstall:
	@systemctl --user stop xcape
	@systemctl --user disable xcape
