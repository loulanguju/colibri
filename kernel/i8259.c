/**
 * name: i8259.c
 * author: loulanguju
 * time: 2013-8-29
 */
#include "interrupt.h"
#include "global.h"

#define ICW1_AT 0x11
#define ICW4_AT_SLAVE 0x01
#define ICW4_AT_MASTER  0x05
#define ICW4_PC_SLAVE   0x09
#define ICW4_PC_MASTER  0x0D

irq_hook_t irq_hooks[NR_IRQ_VECTORS];

void intr_init(void) {
  /* close interrupt */

  /* init i8259 */
  outb(INT_CTL, ICW1_AT);
  outb(INT_CTLMASK, IRQ0_VECTOR);
  outb(INT_CTLMASK, 0x04);
  outb(INT_CTLMASK, ICW4_AT_SLAVE);

  outb(INT2_CTL, ICW1_AT);
  outb(INT2_CTLMASK, IRQ8_VECTOR);
  outb(INT2_CTLMASK, 0x02);
  outb(INT2_CTLMASK, ICW4_AT_SLAVE);

  return ;
}

void put_irq_handler(int irq, irq_handler_t handler) {
  irq_hook_t *hook;

  if (irq < 0 || irq >= NR_IRQ_VECTORS) {
    kprintf("%d invalid call to put_irq_handler\n", irq);
    return ;
  }

  hook = &irq_hooks[irq];

  hook->irq = irq;
  hook->handler = handler;

  return ;
}

void rm_irq_handler(int irq) {
  irq_hook_t *hook;

  if (irq < 0 || irq >= NR_IRQ_VECTORS) {
    kprintf("%d invalid call to put_irq_handler\n", irq);
    return ;
  }

  hook = &irq_hooks[irq];

  hook->irq = 0;
  hook->handler = 0;

  return ;
}

void intr_handle(irq_hook_t *hook) {
  if (hook != 0) {
    if ((*hook->handler)(hook)) {
    }
  }
}
