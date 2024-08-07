include ../Makefile.include

build:
	@mkdir -p ~/.config/systemd/user/blueman-applet.service.d

install:
	@systemctl --user enable blueman-applet
	@systemctl --user start blueman-applet

uninstall:
	@systemctl --user stop blueman-applet
	@systemctl --user disable blueman-applet

clean:
	@rmdir -p ~/.config/systemd/user/blueman-applet.service.d
