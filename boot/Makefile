# name: Makefile
# author: loulanguju
# time: 2013-8-27


ASM	= exec nasm
CC	= exec gcc

all: boot monitor

boot: boot.asm
	$(ASM) boot.asm -o boot

monitor: bootmonitor.asm
	$(ASM) bootmonitor.asm -o monitor

clean:
	rm -f *.o *~
	rm -f boot monitor
