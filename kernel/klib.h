#ifndef _KLIB_H
#define _KLIB_H

#include "ktypes.h"

extern void io_hlt(void) __attribute__ ((cdecl));

extern u8_t mem_read8(u16_t segment, u16_t *offset) __attribute__((cdecl));

extern void mem_write8(u16_t segment, u16_t *offset, u8_t data) __attribute__((cdecl));

extern void outb(int port, int data) __attribute__((cdecl));

extern void int81() __attribute__((cdecl));

#endif
