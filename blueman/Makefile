include ../Makefile.include

install:
	@systemctl --user enable blueman-applet
	@systemctl --user start blueman-applet

uninstall:
	@systemctl --user stop blueman-applet
	@systemctl --user disable blueman-applet
