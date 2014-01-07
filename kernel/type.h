#ifndef _TYPE_H
#define _TYPE_H

#define NAME_SIZE 16

typedef unsigned int vir_clicks;
typedef unsigned long phys_bytes;
typedef unsigned int phys_clicks;

typedef unsigned int vir_bytes;

struct kinfo_t {
  phys_bytes code_base;
  phys_bytes code_size;
  phys_bytes data_base;
  phys_bytes data_size;

  char release[NAME_SIZE];
  char version[NAME_SIZE];

  char name[NAME_SIZE];
};

struct machine_t {
  int processor;
  int protected;
};

#endif
