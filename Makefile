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
	    vimfx \
	    weechat \
	    zsh
INSTALLED = $(patsubst %,$(INTO)/.%,$(INSTALL))

BUILD     = bin/nethack/timettyrec \
	    $(addsuffix .dat,$(filter-out %.dat,$(wildcard fortune/*))) \
	    vim/bundle/vimproc/autoload/vimproc_linux64.so \
	    vim/spell/en.utf-8.add.spl \
	    less

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

install : build $(INSTALLED) /var/spool/cron/$(USER) $(INTO)/Maildir/.notmuch $(INTO)/.config/fish
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

less : lesskey
	lesskey -o less lesskey

$(INTO)/Maildir/.notmuch: notmuch
	mkdir -p $(INTO)/Maildir
	@[ ! -e $@ ] || [ -h $@ ] || mv -f $@ $@.bak
	$(LN) $(PWD)/$< $@

$(INTO)/.config/fish: fish
	mkdir -p $(INTO)/.config
	@[ ! -e $@ ] || [ -h $@ ] || mv -f $@ $@.bak
	$(LN) $(PWD)/$< $@

%.spl : %
	@vim -u NONE -c':mkspell! $< | :q'

.PHONY: build install clean update
