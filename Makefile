# The Makefile for the falcon project
CFLAGS = -shared -fno-stack-protector
MAKE = exec make -$(MAKEFLAGS)
QMENU = qemu-system-i386

usage:
	@echo ""
	@echo "Master Makefile for FALCON OS project"
	@echo ""
	@echo "Usage:"
	@echo "make all		# Compiler the project"
	@echo "make run		# Run the os"
	@echo "make clean	# Remove all compiler results"
	@echo "make version	# Show the Makefile Version"

version:
	@echo ""
	@echo "Makefile for FALCON OS project"
	@echo ""
	@echo "Version 1.1.0"
	@echo ""
	@echo "Copyright (C) Loulanguju"
	@echo "All rights reserved"

all:
	cd boot && $(MAKE) $@
	cd kernel && $(MAKE) $@
	cd merge && ./merges

qmenu: all
	$(QMENU) -s -S falcon.img

run:all
	bochs

clean:
	rm -f *.o *~
	cd boot && $(MAKE) clean $@
	cd kernel && $(MAKE) clean $@
