INTO := $(HOME)

all : build

ifneq ($(USER),root)
include Makefile.$(shell hostname | cut -d. -f1)
endif

INSTALL := \
    $(INSTALL) \
    .abook/abookrc \
    .agignore \
    .bash_profile \
    .bashrc \
    .config/git/config \
    .config/git/ignore \
    .config/mpd/mpd.conf \
    .config/ncmpcpp/bindings \
    .config/sh/aliases \
    .config/sh/cdhist.sh \
    .config/sh/env \
    .config/sh/functions \
    .config/sh/fzf \
    .config/tex/jesse_essay.sty \
    .config/tex/jesse_letter.sty \
    .config/tex/jesse_macros.sty \
    .config/tex/jesse_resume.sty \
    .config/tex/jesse.sty \
    .config/tex/sarah_resume.sty \
    .config/tig/config \
    .config/zsh/local-completions \
    .config/zsh/zsh-autosuggestions \
    .config/zsh/zsh-completions \
    .config/zsh/zsh-syntax-highlighting \
    .crawlrc \
    .gdbinit \
    .inputrc \
    .less \
    .local/share/fortune \
    .mutt/choose-muttrc-type \
    .mutt/imap \
    .mutt/mailcap \
    .mutt/muttrc \
    .mutt/local \
    .nethackrc \
    .profile \
    .replyrc \
    .screenrc \
    .ssh/cao_key \
    .tmux.conf \
    .vimrc \
    .zshcomplete \
    .zshinput \
    .zshrc \
    .bin \
    .vim \

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
    $(addsuffix .dat,$(filter-out %.dat,$(wildcard local/share/fortune/*))) \
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
RMDIR     = @rmdir -p --ignore-fail-on-non-empty

# force shell instead of exec to work around
# https://savannah.gnu.org/bugs/?57962 since i have ~/.bin/git as a directory
GIT       = @:; git

# named targets

build : submodules $(BUILD)

submodules :
	$(GIT) submodule update --init --recursive

install :: all $(INSTALLED)
	@chmod 600 ssh/cao_key
	$(ECHO) Installed into $(INTO)

clean ::
	$(ECHO) Cleaning from $(INTO)
	$(RM) $(BUILD)
	$(RM) $(INSTALLED_SYMLINKS)
	$(RMDIR) $(INSTALLED_DIRS)

update :
	$(GIT) submodule foreach '(if [ $$path == "vim/pack/filetype/start/perl" ]; then git checkout dev; else git checkout master; fi) && git pull'

versions :
	$(GIT) submodule foreach -q 'printf "%-53s" " $$path" && GIT_PAGER=cat git show -s --format=format:%cI%n $$sha1'

updates :
	$(GIT) submodule foreach -q 'if [ $$path == "vim/pack/filetype/start/perl" ]; then if [ $$(git rev-parse dev) != $$sha1 ]; then git lg dev...$$sha1; fi; else if [ $$(git rev-parse master) != $$sha1 ]; then git lg master...$$sha1; fi; fi'

shfmt :
	rg --files-without-match shfmt:skip $$(rg --files-with-matches '[#]!.*sh\b|[v]im:.*ft=.*sh\b') | grep -v "$$(echo $$(git submodule foreach -q 'echo $$sm_path') | sed 's/ /\\|/g')" | xargs shfmt -w -i 4

.PHONY: submodules build install clean update versions updates shfmt

# installation targets

$(patsubst %,$(INTO)/%,$(EMPTYDIRS)) :
	$(MKDIR) $@

$(patsubst %,$(INTO)/%,$(INSTALL)) : $(INTO)/.% : %
	@[ ! -e $@ ] || [ -h $@ ] || mv -f $@ $@.bak
	$(MKDIR) $(dir $@)
	$(LN) $(PWD)/$< $@

# build targets

local/share/fortune/%.dat : local/share/fortune/%
	$(ECHO) "Compiling $@"
	@strfile -s $(basename $@)

%/doc/tags: %/doc
	@vim -u NONE -c':helptags $< | :q'

%.spl : %
	@vim -u NONE -c':mkspell! $< | :q'

less : lesskey
	lesskey -o $@ $<
