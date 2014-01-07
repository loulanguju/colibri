/**
 * name: protect.h
 * author: loulanguju
 * time: 2013-8-27
 */
#ifndef _PROTECT_H
#define _PROTECT_H

#include "ktypes.h"
#include "type.h"
#include "interrupt.h"
#include "global.h"

#define GDT_SIZE (FIRST_LDT_INDEX)
#define FIRST_LDT_INDEX 15

#define IDT_SIZE (0x70 + 8)

#define SYSCALL_VECTOR 0x23

#define GDT_SELECTOR 0x08
#define CS_SELECTOR 0x08
#define DS_SELECTOR 0x10

#define INTR_PRIVILEGE 0
#define TASK_PRIVILEGE 1
#define USER_PRIVILEGE 3


/* segment descriptor for protected mode */
struct segdesc_t {
  u16_t limit_low;
  u16_t base_low;
  u8_t base_middle;
  u8_t access;
  u8_t granularity;
  u8_t base_high;
};

/* gate segment decriptor for protected mode */
struct gatedesc_t {
  u16_t offset_low;
  u16_t selector;
  u8_t pad;
  u8_t dpl_type;
  u16_t offset_high;
};

struct gdtr_t {
  u16_t limit;
  u32_t base;
};

struct idtr_t {
  u16_t limit;
  u32_t base;
};

struct segdesc_t gdt[GDT_SIZE];
struct gdtr_t gdtr;
struct gatedesc_t idt[IDT_SIZE];
struct idtr_t idtr;

void prot_init(void);
phys_bytes seg2phys(u16_t seg);

#endif

