INTO      = $(HOME)
INSTALL   = agignore \
	    bash_logout \
	    bash_profile \
	    bashrc \
	    crawlrc \
	    gdbinit \
	    gitconfig \
	    gitignore \
	    i3status.conf \
	    inputrc \
	    ledgerrc \
	    less \
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
	    runesrc \
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
	    ncmpcpp \
	    offlineimap \
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
	    $(addsuffix tags,$(wildcard vim/pack/*/start/*/doc/)) \
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

all : submodules build

submodules :
	@git submodule update --init --recursive

build : $(BUILD)

install : all $(INSTALLED) /var/spool/cron/$(USER) $(INTO)/Maildir/.notmuch
	@for dir in $(EMPTYDIRS); do mkdir -p $(INTO)/$$dir; done
	@chmod 600 msmtprc
	@chmod 700 gnupg
	$(ECHO) Installed into $(INTO)

clean :
	$(ECHO) Cleaning from $(INTO)
	@crontab -r
	$(RM) $(BUILD) $(INSTALLED)

update :
	@git submodule foreach '(if [ $$path == "vim/pack/filetype/start/perl" ]; then git checkout dev; else git checkout master; fi) && git pull'
	@$(MAKE) build

versions :
	@git submodule foreach -q 'printf "%-53s" " $$path" && GIT_PAGER=cat git show -s --format=format:%cI%n $$sha1'

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
