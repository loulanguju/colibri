#ifndef _INTERRUPT_H
#define _INTERRUPT_H

#define INT_CTL 0x20
#define INT_CTLMASK 0x21
#define INT2_CTL 0xA0
#define INT2_CTLMASK 0xA1

#define IRQ0_VECTOR 0x50 /* nice vectors to relocate IRQ0-7 to */
#define IRQ8_VECTOR 0x70 /* no need to move IRQ8-15 */

#define NR_IRQ_HOOKS 16

#define NR_IRQ_VECTORS 16

#define VECTOR(irq) (((irq) < 8 ? IRQ0_VECTOR : IRQ8_VECTOR) + ((irq) & 0x07))

typedef struct irq_hook {
  int (*handler)(struct irq_hook *);
  int irq;
} irq_hook_t;

typedef int (*irq_handler_t)(void);

// struct irq_hook_t irq_hooks[NR_IRQ_VECTORS];

void intr_init(void) __attribute__((cdecl));
void intr_handle(irq_hook_t *hook) __attribute__((cdecl));
void put_irq_handler(int irq, irq_handler_t handler) __attribute__((cdecl));
void rm_irq_handler(int irq) __attribute__((cdecl));

#endif
