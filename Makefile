INTO      = $(HOME)
INSTALL   = abcde.conf \
	    aliases \
	    bash_logout \
	    bash_profile \
	    bashrc \
	    conkyrc \
	    crawlrc \
	    env \
	    gdbinit \
	    gitconfig \
	    gitignore \
	    gtkrc \
	    gtkrc-2.0 \
	    i3status.conf \
	    inputrc \
	    logout \
	    mailcap \
	    minicpanrc \
	    mutt \
	    nethackrc \
	    notmuch-config \
	    pentadactylrc \
	    procmailrc \
	    proverc \
	    replyrc \
	    screenrc \
	    tmux.conf \
	    vimrc \
	    Xdefaults \
	    Xmodmap \
	    xinitrc \
	    zlogout \
	    zshcomplete \
	    zshinput \
	    zshrc \
	    abook \
	    sh \
	    bin \
	    dzil \
	    gnupg \
	    i3 \
	    interhack \
	    fortune \
	    ncmpc \
	    procmail \
	    pentadactyl \
	    services \
	    ssh \
	    taeb \
	    terminfo \
	    themes \
	    urxvt \
	    vim \
	    weechat \
	    zsh
INSTALLED = $(patsubst %,$(INTO)/.%,$(INSTALL))

BUILD     = bin/nethack/timettyrec $(addsuffix .dat,$(filter-out %.dat,$(wildcard fortune/*)))

EMPTYDIRS = .log .vim/undo

ECHO      = @echo
LN        = @ln -sf
MKDIR     = @mkdir -p
RM        = @rm -f

build : $(BUILD)

install : build $(INSTALLED) /var/spool/cron/$(USER)
	@for dir in $(EMPTYDIRS); do mkdir -p $(INTO)/$$dir; done
	$(ECHO) Installed into $(INTO)

clean :
	$(ECHO) Cleaning from $(INTO)
	@crontab -d
	$(RM) $(BUILD) $(INSTALLED)

$(INTO)/.% : %
	@[ ! -e $@ ] || [ -h $@ ] || mv -f $@ $@.bak
	$(LN) $(PWD)/$< $@

/var/spool/cron/$(USER) : crontab
	@crontab crontab

fortune/%.dat : fortune/%
	@echo "Compiling $@"
	@strfile -s $(basename $@)

.PHONY: build install clean
