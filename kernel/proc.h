#ifndef _PROC_H
#define _PROC_H

#define NR_TASKS 40
#define NR_PROCS 125

#define PROC_NAME_LEN 8

struct proc_t {
  int p_nr;

  char name[PROC_NAME_LEN];
}

#define BEG_PROC_ADDR (&procs[0])
#define BEG_USER_ADDR (&procs[NR_TASKS])
#define END_PROC_ADDR (&procs[NR_TASKS + NRPROCS])

/*
 * process table
 */
extern struct proc_t procs[NR_TASKS + NR_PROCS];

#endif
