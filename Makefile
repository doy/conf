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
	    mutt \
	    nethackrc \
	    pentadactylrc \
	    procmailrc \
	    pwsafe.dat \
	    screenrc \
	    tmux.conf \
	    vimrc \
	    Xdefaults \
	    xinitrc \
	    xmobarrc \
	    abook \
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
	    pentadactyl \
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

BUILD     = bin/nethack/timettyrec pwsafe.dat $(addsuffix .dat,$(filter-out %.dat,$(wildcard fortune/*)))

EMPTYDIRS = .log .vim/undo .vim/yankring-data

ECHO      = @echo
LN        = @ln -sf
MKDIR     = @mkdir -p
RM        = @rm -f

build : $(BUILD)

install : build $(INSTALLED) /var/spool/cron/$(USER)
	@for dir in $(EMPTYDIRS); do mkdir -p $(INTO)/$$dir; done
	$(ECHO) Installed into $(HOME)

clean :
	$(ECHO) Cleaning from $(HOME)
	$(RM) $(BUILD) $(INSTALLED)
	@crontab -d

$(INTO)/.% : %
	@[ ! -e $@ ] || [ -h $@ ] || mv -f $@ $@.bak
	$(LN) $(PWD)/$< $@

/var/spool/cron/$(USER) : crontab
	@crontab crontab

pwsafe.dat :
	wget -q http://tozt.net/.pwsafe.dat -O pwsafe.dat

fortune/%.dat : fortune/%
	@echo "Compiling $@"
	@strfile -s $(basename $@)

.PHONY: build install clean
