#ifndef _CONSOLE_H
#define _CONSOLE_H

void putch(char ch) __attribute__((cdecl));
void puts(const char *str) __attribute__((cdecl));
void clear_screen(void) __attribute__((cdecl));
void move_cursor(int x, int y) __attribute__((cdecl));
void kprintf(const char *fmt, ...) __attribute__((cdecl));

#endif
