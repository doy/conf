include ../Makefile.include

install:
	@systemctl --user enable redshift
	@systemctl --user start redshift

uninstall:
	@systemctl --user stop redshift
	@systemctl --user disable redshift
