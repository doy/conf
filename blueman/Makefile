include ../Makefile.include

install:
	@mkdir -p ~/.config/systemd/user/blueman-applet.service.d
	@systemctl --user enable blueman-applet
	@systemctl --user start blueman-applet

uninstall:
	@systemctl --user stop blueman-applet
	@systemctl --user disable blueman-applet
	@rmdir -p ~/.config/systemd/user/blueman-applet.service.d
