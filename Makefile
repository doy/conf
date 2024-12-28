ifeq ($(USER),root)
PACKAGES=$(shell cat packages.root)
else
PACKAGES=$(shell cat packages.$$(hostname))
endif

build: submodules
	@for package in $(PACKAGES); do ./build $${package}; done

install: submodules
	@for package in $(PACKAGES); do ./install $${package}; done

uninstall:
	@for package in $(PACKAGES); do ./uninstall $${package}; done

clean:
	@for package in $(PACKAGES); do ./clean $${package}; done

submodules:
	@git submodule update --init --recursive

update:
	@git submodule foreach 'git checkout master && git pull'
	@for package in $(PACKAGES); do ./clean $${package}; ./build $${package}; done

.PHONY: build install uninstall clean submodules update
