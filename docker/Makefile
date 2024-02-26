include ../Makefile.include

install:
	@systemctl --user enable docker-prune.timer
	@systemctl --user start docker-prune.timer

uninstall:
	@systemctl --user stop docker-prune.timer
	@systemctl --user disable docker-prune.timer
