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
	    screenrc \
	    tmux.conf \
	    vimrc \
	    Xdefaults \
	    xinitrc \
	    xmobarrc \
	    bash \
	    bin \
	    interhack \
	    irssi \
	    fortune \
	    module-setup \
	    ncmpc \
	    newsbeuter \
	    procmail \
	    re.pl \
	    services \
	    taeb \
	    terminfo \
	    themes \
	    urxvt \
	    vim \
	    xmonad
INSTALLED = $(patsubst %,$(INTO)/.%,$(INSTALL))

BUILD     = bin/nethack/timettyrec

ECHO      = @echo
LN        = @ln -sf
MKDIR     = @mkdir -p
RM        = @rm -f

build : $(BUILD)

install : build $(INSTALLED) /var/spool/cron/$(USER)
	$(MKDIR) $(INTO)/.ssh
	$(LN) $(PWD)/authorized_keys $(INTO)/.ssh/
	@crontab crontab
	$(ECHO) Installed into $(HOME)

clean :
	$(ECHO) Cleaning from $(HOME)
	$(RM) $(BUILD) $(INSTALLED) $(INTO)/.ssh/authorized_keys
	@crontab -d

$(INTO)/.% : %
	@[ ! -f $@ ] || readlink -q $@ || mv -f $@ $@.bak
	$(LN) $(PWD)/$< $@

.PHONY: build install clean
