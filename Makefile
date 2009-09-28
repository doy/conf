INTO      = $(HOME)
INSTALL   = abcde.conf \
	    bash_logout \
	    bashrc \
	    conkerorrc \
	    conkyrc \
	    crawlrc \
	    gitconfig \
	    gitignore \
	    gtkrc \
	    inputrc \
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
	    irssi \
	    fortune \
	    module-setup \
	    ncmpc \
	    newsbeuter \
	    procmail \
	    re.pl \
	    services \
	    terminfo \
	    urxvt \
	    vim \
	    xmonad
INSTALLED = $(patsubst %,$(INTO)/.%,$(INSTALL))

ECHO      = @echo
LN        = @ln -sf
MKDIR     = @mkdir -p
RM        = @rm -f

build :

install : $(INSTALLED)
	$(MKDIR) $(INTO)/.ssh
	$(LN) $(PWD)/authorized_keys $(INTO)/.ssh/
	$(ECHO) Installed into $(HOME)

clean :
	$(ECHO) Cleaning from $(HOME)
	$(RM) $(INSTALLED) $(INTO)/.ssh/authorized_keys

$(INTO)/.% : %
	@[ ! -f $@ ] || readlink -q $@ || mv -f $@ $@.bak
	$(LN) $(PWD)/$< $@

.PHONY: build install clean
