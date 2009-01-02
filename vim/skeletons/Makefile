BIN =
OBJ =
CC = gcc
INCLUDES =
DEFINES =
LIBS =
COMMONFLAGS = -Werror -Wall -pedantic -O0 -g -pipe
CFLAGS = -c $(INCLUDES) $(DEFINES) $(COMMONFLAGS)
LDFLAGS = $(LIBS) $(COMMONFLAGS)

$(BIN) : $(OBJ)
	$(CC) $(OBJ) $(LDFLAGS) -o $@

%.o : %.c
	$(CC) $(CFLAGS) -o $@ $<

clean :
	rm -f $(OBJ) $(BIN)

dep :
	makedepend $(INCLUDES) $(DEFINES) -Y *.c *.h > /dev/null 2>&1
	rm -f Makefile.bak

run : $(BIN)
	@./$(BIN)
:normal ggA 
:startinsert!
