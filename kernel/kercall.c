#include "console.h"

int ker_call(int call_nr, int src, void  *m_ptr) {
  int result = 0;

  kprintf("kernel call is working.\n");
  kprintf("paras: %d %d %d\n", call_nr, src, m_ptr);
  
  return result;
}
