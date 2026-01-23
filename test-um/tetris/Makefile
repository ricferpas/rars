default: all

GCC_RISCV=riscv64-unknown-linux-gnu-gcc

all: tetris tetris-riscv.s tetris-riscv2rars.s

tetris: tetris.c rars-runtime.c rars-runtime.h keyio.c keyio.h
	gcc -Wall -g -O2 -o $@ tetris.c rars-runtime.c keyio.c

tetris-riscv.s: tetris.c
	$(GCC_RISCV) -O2 -fno-section-anchors -fno-inline -fomit-frame-pointer -fverbose-asm -march=rv32imfd -mabi=ilp32 -S -DRISCV2RARS $^ -o $@

tetris-riscv2rars.s: tetris-riscv.s
	riscv2rars --output=$@ $^

clean:
	rm -f tetris tetris-riscv.s tetris-riscv2rars.s

.PHONY: default all clean
