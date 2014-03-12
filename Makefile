INTO      = $(HOME)
INSTALL   = aliases \
	    bash_logout \
	    bash_profile \
	    bashrc \
	    conkyrc \
	    crawlrc \
	    env \
	    extract_urlview \
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
	    muttrc \
	    nethackrc \
	    notmuch-config \
	    offlineimaprc \
	    pentadactylrc \
	    procmailrc \
	    proverc \
	    replyrc \
	    screenrc \
	    signature \
	    tmux.conf \
	    vimrc \
	    xbindkeysrc \
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
	    offlineimap \
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

BUILD     = bin/nethack/timettyrec \
	    $(addsuffix .dat,$(filter-out %.dat,$(wildcard fortune/*))) \
	    vim/bundle/vimproc/autoload/vimproc_unix.so \
	    vim/spell/en.utf-8.add.spl

EMPTYDIRS = .log .vim/undo

ECHO      = @echo
LN        = @ln -sf
MKDIR     = @mkdir -p
RM        = @rm -f

build : $(BUILD)

install : build $(INSTALLED) /var/spool/cron/$(USER) $(INTO)/Maildir/.notmuch
	@for dir in $(EMPTYDIRS); do mkdir -p $(INTO)/$$dir; done
	$(ECHO) Installed into $(INTO)

clean :
	$(ECHO) Cleaning from $(INTO)
	@crontab -r
	$(RM) $(BUILD) $(INSTALLED)

$(INTO)/.% : %
	@[ ! -e $@ ] || [ -h $@ ] || mv -f $@ $@.bak
	$(LN) $(PWD)/$< $@

/var/spool/cron/$(USER) : crontab
	@crontab crontab

fortune/%.dat : fortune/%
	@echo "Compiling $@"
	@strfile -s $(basename $@)

vim/bundle/vimproc/autoload/vimproc_unix.so : vim/bundle/vimproc/autoload/proc.c
	cd vim/bundle/vimproc && make

$(INTO)/Maildir/.notmuch: notmuch
	@[ ! -e $@ ] || [ -h $@ ] || mv -f $@ $@.bak
	$(LN) $(PWD)/$< $@

%.spl : %
	@vim -u NONE -c':mkspell! $< | :q'

.PHONY: build install clean
