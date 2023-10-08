include ../Makefile.include

install: /var/spool/cron/$(USER)

uninstall:
	@crontab -r

/var/spool/cron/$(USER) : crontab.stowskip
	@crontab $<
