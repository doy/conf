INTO      = $(HOME)
INSTALL   = abcde.conf \
	    bash_logout \
	    bash_profile \
	    bashrc \
	    conkerorrc \
	    conkyrc \
	    crawlrc \
	    gitconfig \
	    gitignore \
	    gtkrc \
	    gtkrc-2.0 \
	    inputrc \
	    minicpanrc \
	    muttrc \
	    nethackrc \
	    procmailrc \
	    pwsafe.dat \
	    screenrc \
	    tmux.conf \
	    vimperatorrc \
	    vimrc \
	    Xdefaults \
	    xinitrc \
	    xmobarrc \
	    bash \
	    bin \
	    dzil \
	    interhack \
	    irssi \
	    fortune \
	    module-setup \
	    ncmpc \
	    newsbeuter \
	    procmail \
	    re.pl \
	    services \
	    ssh \
	    taeb \
	    terminfo \
	    themes \
	    urxvt \
	    vim \
	    xmonad
INSTALLED = $(patsubst %,$(INTO)/.%,$(INSTALL))

BUILD     = bin/nethack/timettyrec pwsafe.dat

ECHO      = @echo
LN        = @ln -sf
MKDIR     = @mkdir -p
RM        = @rm -f

build : $(BUILD)

install : build $(INSTALLED) /var/spool/cron/$(USER)
	$(MKDIR) .log
	$(ECHO) Installed into $(HOME)

clean :
	$(ECHO) Cleaning from $(HOME)
	$(RM) $(BUILD) $(INSTALLED)
	@crontab -d

$(INTO)/.% : %
	@[ -e $@ ] && [ ! -h $@ ] && mv -f $@ $@.bak
	$(LN) $(PWD)/$< $@

/var/spool/cron/$(USER) : crontab
	@crontab crontab

pwsafe.dat :
	wget http://tozt.net/.pwsafe.dat -O pwsafe.dat

.PHONY: build install clean
