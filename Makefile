INTO      = $(HOME)
INSTALL   = agignore \
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
	    mpdconf \
	    msmtprc \
	    muttrc \
	    nethackrc \
	    notmuch-config \
	    offlineimaprc \
	    procmailrc \
	    proverc \
	    replyrc \
	    screenrc \
	    signature \
	    tigrc \
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
	    ginn \
	    gnupg \
	    i3 \
	    interhack \
	    fortune \
	    mpdscribble \
	    ncmpc \
	    procmail \
	    offlineimap \
	    services \
	    ssh \
	    taeb \
	    terminfo \
	    themes \
	    urxvt \
	    vim \
	    vimfx \
	    weechat \
	    zsh
INSTALLED = $(patsubst %,$(INTO)/.%,$(INSTALL))

BUILD     = bin/nethack/timettyrec \
	    $(addsuffix .dat,$(filter-out %.dat,$(wildcard fortune/*))) \
	    vim/bundle/vimproc/autoload/vimproc_linux64.so \
	    vim/spell/en.utf-8.add.spl

EMPTYDIRS = $(patsubst services/%,.log/%,$(wildcard services/*)) \
	    Maildir \
	    .vim/data/undo \
	    .cache/mutt/headers \
	    .cache/mutt/bodies \
	    .cache/mpd \
	    .config/mpd/playlists

ECHO      = @echo
LN        = @ln -sf
MKDIR     = @mkdir -p
RM        = @rm -f

build : $(BUILD)

install : build $(INSTALLED) /var/spool/cron/$(USER) $(INTO)/Maildir/.notmuch
	@for dir in $(EMPTYDIRS); do mkdir -p $(INTO)/$$dir; done
	@chmod 600 msmtprc
	@chmod 700 gnupg
	$(ECHO) Installed into $(INTO)

clean :
	$(ECHO) Cleaning from $(INTO)
	@crontab -r
	$(RM) $(BUILD) $(INSTALLED)

update :
	@git submodule foreach 'git checkout master && git pull'
	@$(MAKE)

$(INTO)/.% : %
	@[ ! -e $@ ] || [ -h $@ ] || mv -f $@ $@.bak
	$(LN) $(PWD)/$< $@

/var/spool/cron/$(USER) : crontab
	@crontab crontab

fortune/%.dat : fortune/%
	@echo "Compiling $@"
	@strfile -s $(basename $@)

vim/bundle/vimproc/autoload/vimproc_linux64.so :
	cd vim/bundle/vimproc && make

$(INTO)/Maildir/.notmuch: notmuch
	mkdir -p $(INTO)/Maildir
	@[ ! -e $@ ] || [ -h $@ ] || mv -f $@ $@.bak
	$(LN) $(PWD)/$< $@

%.spl : %
	@vim -u NONE -c':mkspell! $< | :q'

.PHONY: build install clean
