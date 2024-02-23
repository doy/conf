include ../Makefile.include

install:
	@systemctl --user enable weather.timer
	@systemctl --user start weather.timer

uninstall:
	@systemctl --user stop weather.timer
	@systemctl --user disable weather.timer
