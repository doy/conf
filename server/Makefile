include ../Makefile.include

install:
	@systemctl --user enable logout
	@systemctl --user start logout

uninstall:
	@systemctl --user stop logout
	@systemctl --user disable logout
