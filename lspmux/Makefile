include ../Makefile.include

install:
	@systemctl --user enable lspmux
	@systemctl --user start lspmux

uninstall:
	@systemctl --user stop lspmux
	@systemctl --user disable lspmux
