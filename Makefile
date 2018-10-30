INTO := $(HOME)

all : build

include Makefile.$(shell hostname | cut -d. -f1)

INSTALL := \
    $(INSTALL) \
    .abook/abookrc \
    .agignore \
    .bash_logout \
    .bash_profile \
    .bashrc \
    .crawlrc \
    .gdbinit \
    .gitconfig \
    .gitignore \
    .gnupg/gpg.conf \
    .inputrc \
    .ledgerrc \
    .less \
    .mailcap \
    .mpdconf \
    .msmtprc \
    .muttrc \
    .ncmpcpp/bindings \
    .nethackrc \
    .perlcriticrc \
    .profile \
    .proverc \
    .replyrc \
    .screenrc \
    .ssh/cao_key \
    .ssh/config \
    .tigrc \
    .tmux.conf \
    .vimrc \
    .zlogout \
    .zshcomplete \
    .zshinput \
    .zshrc \
    .bin \
    .dzil \
    .fortune \
    .sh \
    .terminfo \
    .tex \
    .vim \
    .weechat \
    .zsh

EMPTYDIRS := \
    $(EMPTYDIRS) \
    .cache/mutt/headers \
    .cache/mutt/bodies \
    .cache/vim/hist \
    .cache/vim/undo \

INSTALL_CUSTOM := \
    $(INSTALL_CUSTOM)

BUILD := \
    $(BUILD) \
    $(addsuffix .dat,$(filter-out %.dat,$(wildcard fortune/*))) \
    $(addsuffix tags,$(wildcard vim/pack/*/start/*/doc/)) \
    vim/spell/en.utf-8.add.spl \
    less

INSTALLED_SYMLINKS := \
    $(patsubst %,$(INTO)/%,$(INSTALL)) \
    $(INSTALL_CUSTOM)

INSTALLED_DIRS := \
    $(patsubst %,$(INTO)/%,$(EMPTYDIRS))

INSTALLED := \
    $(INSTALLED_SYMLINKS) \
    $(INSTALLED_DIRS)

ECHO      = @echo
LN        = @ln -sf
MKDIR     = @mkdir -p
RM        = @rm -f
RMDIR     = @rmdir -p

# named targets

build : submodules $(BUILD)

submodules :
	@git submodule update --init --recursive

install :: all $(INSTALLED)
	@chmod 600 msmtprc
	@chmod 700 gnupg
	$(ECHO) Installed into $(INTO)

clean ::
	$(ECHO) Cleaning from $(INTO)
	$(RM) $(BUILD)
	$(RM) $(INSTALLED_SYMLINKS)
	$(RMDIR) $(INSTALLED_DIRS)

update :
	@git submodule foreach '(if [ $$path == "vim/pack/filetype/start/perl" ]; then git checkout dev; else git checkout master; fi) && git pull'

versions :
	@git submodule foreach -q 'printf "%-53s" " $$path" && GIT_PAGER=cat git show -s --format=format:%cI%n $$sha1'

updates :
	@git submodule foreach -q 'if [ $$path == "vim/pack/filetype/start/perl" ]; then if [ $$(git rev-parse dev) != $$sha1 ]; then git lg dev...$$sha1; fi; else if [ $$(git rev-parse master) != $$sha1 ]; then git lg master...$$sha1; fi; fi'

.PHONY: submodules build install clean update versions updates

# installation targets

$(patsubst %,$(INTO)/%,$(EMPTYDIRS)) :
	$(MKDIR) $@

$(patsubst %,$(INTO)/%,$(INSTALL)) : $(INTO)/.% : %
	@[ ! -e $@ ] || [ -h $@ ] || mv -f $@ $@.bak
	$(MKDIR) $(dir $@)
	$(LN) $(PWD)/$< $@

# build targets

fortune/%.dat : fortune/%
	$(ECHO) "Compiling $@"
	@strfile -s $(basename $@)

%/doc/tags: %/doc
	@vim -u NONE -c':helptags $< | :q'

%.spl : %
	@vim -u NONE -c':mkspell! $< | :q'

less : lesskey
	lesskey -o $@ $<
