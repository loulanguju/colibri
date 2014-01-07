#include "protect.h"

extern void intr00() __attribute__((cdecl));
extern void intr01() __attribute__((cdecl));
extern void intr12() __attribute__((cdecl));
extern void k_call() __attribute__((cdecl));

struct gate_table_t {
  void (*gate)(void) __attribute__((cdecl));
  unsigned char ver_nr;
  unsigned char privilege;
};

void prot_init(void) {
  struct gate_table_t *gtp;
  static struct gate_table_t gate_table[] = {
    {intr00, 0x40, INTR_PRIVILEGE},
    {intr00, VECTOR(0), INTR_PRIVILEGE},
    {intr01, VECTOR(1), INTR_PRIVILEGE},
    {intr12, VECTOR(12), INTR_PRIVILEGE},
    {k_call, SYSCALL_VECTOR, USER_PRIVILEGE},
  };

  // kprintf("init the protect mode.\n");

  /* build interrupt gates in IDT */
  for (gtp = &gate_table[0];
       gtp < &gate_table[sizeof gate_table / sizeof gate_table[0]]; gtp++) {
    struct gatedesc_t *idp;

    idp = &idt[gtp->ver_nr];
    // kprintf("ver = %d\n", gtp->ver_nr);
    idp->offset_low = (vir_bytes) gtp->gate;
    // kprintf("gate = %x\n", gtp->gate);
    idp->selector = CS_SELECTOR;
    idp->dpl_type = 0x80 | 6 | 0x08 | (gtp->privilege << 5);
    idp->offset_high = (vir_bytes) gtp->gate >> 16;
  }

  // kprintf("%x\n", idt);

  // kprintf("hook = %d\n", sizeof gate_table[0]);

  idtr.limit = sizeof idt;
  idtr.base = idt;

  // kprintf("%d %x\n", idtr.base, idtr.limit);
  return ;
}

/**********************************************
 * phys_bytes seg2phys(u16_t seg)
 * return the base address of a segment
 **********************************************/
phys_bytes seg2phys(u16_t seg) {
  phys_bytes base;
  struct segdesc_t* segp;

  if (! machine.protected) {
    base = seg << 4;
  } else {
    segp = &gdt[seg >> 3];
    base = ((u32_t) segp->base_low << 0)
      |    ((u32_t) segp->base_middle << 16)
      |    ((u32_t) segp->base_high << 24);
  }

  return base;
}
