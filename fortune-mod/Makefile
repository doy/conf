include ../Makefile.include

build: $(addsuffix .dat,$(filter-out %.dat,$(wildcard .local/share/fortune/*)))

clean:
	@rm -f .local/share/fortune/*.dat

%.dat : %
	@strfile -s $(basename $@)
