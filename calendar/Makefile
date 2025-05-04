include ../Makefile.include

install:
	@systemctl --user enable calendar
	@systemctl --user start calendar

uninstall:
	@systemctl --user stop calendar
	@systemctl --user disable calendar
