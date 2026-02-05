PROGRAM_NAME=progexamen

GCC_RISCV=riscv64-unknown-linux-gnu-gcc

default: all

all: $(PROGRAM_NAME) $(PROGRAM_NAME)-riscv.s $(PROGRAM_NAME)-riscv2rars.s

$(PROGRAM_NAME): $(PROGRAM_NAME).c rars-runtime.c rars-runtime.h keyio.c keyio.h
	gcc -Wall -g -O2 -o $@ $(PROGRAM_NAME).c rars-runtime.c keyio.c

%-riscv.s: %.c
	$(GCC_RISCV) -O2 -fno-section-anchors -fno-inline -fomit-frame-pointer -fverbose-asm -march=rv32imfd -mabi=ilp32 -fno-builtin -ffreestanding -S -DRISCV2RARS $^ -o $@

%-riscv2rars.s: %-riscv.s
	riscv2rars --output=$@ $^

clean:
	rm -f $(PROGRAM_NAME) $(PROGRAM_NAME)-riscv.s $(PROGRAM_NAME)-riscv2rars.s

.PHONY: default all clean

# TODO: demo

