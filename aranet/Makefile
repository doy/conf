include ../Makefile.include

install:
	@systemctl --user enable aranet.timer
	@systemctl --user start aranet.timer

uninstall:
	@systemctl --user stop aranet.timer
	@systemctl --user disable aranet.timer
