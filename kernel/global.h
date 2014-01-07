#ifndef _GLOBAL_H
#define _GLOBAL_H

#include "type.h"
#include "interrupt.h"

extern struct machine_t machine;
extern struct kinfo_t kinfo;

extern irq_hook_t irq_hooks[NR_IRQ_VECTORS];
#endif
