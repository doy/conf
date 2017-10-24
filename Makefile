INTO      = $(HOME)
INSTALL   = agignore \
	    aliases \
	    bash_logout \
	    bash_profile \
	    bashrc \
	    crawlrc \
	    env \
	    functions \
	    gdbinit \
	    gitconfig \
	    gitignore \
	    i3status.conf \
	    inputrc \
	    less \
	    logout \
	    mailcap \
	    minicpanrc \
	    mpdconf \
	    msmtprc \
	    muttrc \
	    nethackrc \
	    notmuch-config \
	    offlineimaprc \
	    perlcriticrc \
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
	    xinitrc \
	    Xmodmap \
	    zlogout \
	    zshcomplete \
	    zshinput \
	    zshrc \
	    abook \
	    bin \
	    dzil \
	    fortune \
	    ginn \
	    gnupg \
	    i3 \
	    interhack \
	    mpdscribble \
	    ncmpc \
	    offlineimap \
	    peco \
	    procmail \
	    services \
	    sh \
	    ssh \
	    terminfo \
	    tex \
	    vim \
	    weechat \
	    zsh
INSTALLED = $(patsubst %,$(INTO)/.%,$(INSTALL))

BUILD     = bin/local/timettyrec \
	    $(addsuffix .dat,$(filter-out %.dat,$(wildcard fortune/*))) \
	    $(addsuffix tags,$(wildcard vim/pack/local/start/*/doc/)) \
	    vim/spell/en.utf-8.add.spl \
	    less

EMPTYDIRS = $(patsubst services/%,.log/%,$(wildcard services/*)) \
	    Maildir \
	    .cache/mutt/headers \
	    .cache/mutt/bodies \
	    .cache/mpd \
	    .cache/vim/hist \
	    .cache/vim/undo \
	    .config/mpd/playlists

ECHO      = @echo
LN        = @ln -sf
MKDIR     = @mkdir -p
RM        = @rm -f

build : submodules $(BUILD)

submodules :
	@git submodule update --init --recursive

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
	@git submodule foreach '(if [ $$name == "vim/pack/local/start/perl" ]; then git checkout dev; else git checkout master; fi) && git pull'
	@$(MAKE)

$(INTO)/.% : %
	@[ ! -e $@ ] || [ -h $@ ] || mv -f $@ $@.bak
	$(LN) $(PWD)/$< $@

/var/spool/cron/$(USER) : crontab
	@crontab crontab

fortune/%.dat : fortune/%
	@echo "Compiling $@"
	@strfile -s $(basename $@)

less : lesskey
	lesskey -o less lesskey

$(INTO)/Maildir/.notmuch: notmuch
	mkdir -p $(INTO)/Maildir
	@[ ! -e $@ ] || [ -h $@ ] || mv -f $@ $@.bak
	$(LN) $(PWD)/$< $@

%.spl : %
	@vim -u NONE -c':mkspell! $< | :q'

%/doc/tags: %/doc
	@vim -u NONE -c':helptags $< | :q'

.PHONY: build submodules install clean update
