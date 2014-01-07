/**
 * name: main.c
 * author: loulanguju
 * time: 2013-8-28
 */
#include "kernel.h"
#include "klib.h"

extern void test() __attribute__ ((cdecl));

int keyborad_handler() {
  kprintf("1 enter the keyboard interrupt\n");
  return 0;
}

int mouse_handler() {
  kprintf("12 enter the mouse interrupt\n");
  return 0;
}

int timer_handler() {
  outb(0x20, 0x20);
  return 0;
}

void init_pit() {
  outb(0x0043, 0x34);
  outb(0x0040, 0x9c);
  outb(0x0040, 0x2e);
}

void main(void) {

  intr_init();

  init_pit();

  outb(0x21, 0xf8);
  outb(0xa1, 0xff);

  put_irq_handler(0, keyborad_handler);
  put_irq_handler(12, mouse_handler);
  put_irq_handler(0, timer_handler);

  kprintf("\n%s %s.%s. Copyright (c)  2013 loulanguju\n", KERNEL_NAME, KERNEL_RELEASE, KERNEL_VERSION);
  kprintf("Executing in %s mode.\n\n",  "32-bit protected");

  while (1) {// do while
  }

  return ;
}
