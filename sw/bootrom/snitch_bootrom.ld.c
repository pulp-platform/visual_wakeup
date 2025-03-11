/* Copyright 2025 ETH Zurich and University of Bologna. */
/* Licensed under the Apache License, Version 2.0, see LICENSE.apache for details. */
/* SPDX-License-Identifier: Apache-2.0 */

/* Sergio Mazzola <smazzola@iis.ee.ethz.ch> */

#include <addr_map.h>

ENTRY(_start)

MEMORY {
  snitch_bootrom (rx) : ORIGIN = BOOTROM_BASE, LENGTH = 128
}

SECTIONS {
  /DISCARD/ : { *(.riscv.attributes) *(.comment) }
  . = ORIGIN(snitch_bootrom);

  .text : ALIGN(4) {
    KEEP(*(.text*))
  } > snitch_bootrom

  ASSERT(
    SIZEOF(.text) <= 128,
    "Instructions must fit in 128-byte bootrom"
  )

  __snitch_bootrom = ORIGIN(snitch_bootrom);
}
