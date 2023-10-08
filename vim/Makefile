include ../Makefile.include

TAGFILES=$(addsuffix tags,$(wildcard .vim/pack/*/start/*/doc/))
SPELLFILES=.vim/spell/en.utf-8.add.spl

build: $(TAGFILES) $(SPELLFILES)

install:
	@mkdir -p $(HOME)/.cache/vim/hist
	@mkdir -p $(HOME)/.cache/vim/undo

clean:
	@rm -f $(TAGFILES) $(SPELLFILES)

%/doc/tags : %/doc
	@vim -u NONE -c':helptags $< | :q'

%.spl : %
	@vim -u NONE -c':mkspell! $< | :q'