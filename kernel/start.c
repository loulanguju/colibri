/**
 * name: start.c
 * author: loulanguju
 * time: 2013-8-29
 */
#include "ktypes.h"
#include "type.h"
#include "kernel.h"

#include <string.h>

struct machine_t machine;
struct kinfo_t kinfo;

void cstart(u16_t cs, u16_t ds) {
  /**
   * Work in protected mode.
   */
  machine.protected = 1;

  /**
   * Get the Kernel Information
   */
  kinfo.code_base = seg2phys(cs);
  kinfo.code_size = 0;
  kinfo.data_base = seg2phys(ds);
  kinfo.data_size = 0;

  /**
   * Initialize protected mode descriptors.
   */
  prot_init();

  /**
   * Get the Basic Information
   */
  strcpy(kinfo.release, KERNEL_RELEASE);
  kinfo.release[sizeof(kinfo.release) - 1] = '\0';

  strcpy(kinfo.version, KERNEL_VERSION);;
  kinfo.version[sizeof(kinfo.version) - 1] = '\0';

  strcpy(kinfo.name, KERNEL_NAME);
  kinfo.name[sizeof(kinfo.name) - 1] = '\0';

  /**
   * Get Machine Information
   */

  /*machine.processor = atoi(PROCESSOR);
  machine.protected = machine.processor >= 286;

  if (! machine.protected) { // kernel can't run in the real mode
    return ;
  } */

  // puts(kinfo.release);
  // puts(kinfo.version);
  // puts(kinfo.name);

  return ;
}
