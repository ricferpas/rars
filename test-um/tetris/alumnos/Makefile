default: tetris

all: tetris

tetris: tetris.c rars-runtime.c rars-runtime.h keyio.c keyio.h
	gcc -Wall -g -O2 -otetris tetris.c rars-runtime.c keyio.c

clean:
	rm -f tetris

.PHONY: default all clean
