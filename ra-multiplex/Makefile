include ../Makefile.include

install:
	@systemctl --user enable ra-multiplex
	@systemctl --user start ra-multiplex

uninstall:
	@systemctl --user stop ra-multiplex
	@systemctl --user disable ra-multiplex
