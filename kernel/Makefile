# name: Makefile
# author; loulanguju
# time: 2013-8-27

# Commonds
ASM	= exec nasm
CC	= exec gcc $(CFLAGS)
LD	= exec ld

#CFLAGS	= -f no-stack-protector -shared
CFLAGS	= -fno-stack-protector

OBJS	= mpx386.o klib.o console_s.o \
	  start.o main.o protect.o i8259.o console_c.o \
	  kercall.o

# Macros
KERNEL_SEG	= 0x9000

all: kernel.o

kernel.o: $(OBJS)
	$(LD) -o kernel.o $(OBJS) -Ttext $(KERNEL_SEG) --oformat binary
	@perl ./module.pl kernel.o kernel

mpx386.o: mpx386.asm
	$(ASM) -f elf -o mpx386.o mpx386.asm

klib.o: klib.asm
	$(ASM) -f elf -o klib.o klib.asm

console_s.o: console.asm
	$(ASM) -f elf -o console_s.o console.asm

start.o: start.c kernel.h global.h protect.h
	$(CC) -c -o start.o start.c

main.o: main.c console.h klib.h
	$(CC) -c -o main.o main.c

protect.o: protect.c type.h global.h protect.h
	$(CC) -c -o protect.o protect.c

i8259.o: i8259.c interrupt.h
	$(CC) -c -o i8259.o i8259.c

console_c.o: console.c
	$(CC) -c -o console_c.o console.c

kercall.o: kercall.c
	$(CC) -c -o kercall.o kercall.c

clean:
	rm -f *.o *~
	rm -f kernel
