include ../Makefile.include

install:
	@systemctl --user enable mbsyncloop
	@systemctl --user start mbsyncloop

uninstall:
	@systemctl --user stop mbsyncloop
	@systemctl --user disable mbsyncloop
