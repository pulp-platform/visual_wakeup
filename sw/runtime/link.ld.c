// Copyright 2025 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE.apache for details.
// SPDX-License-Identifier: Apache-2.0

// Sergio Mazzola <smazzola@iis.ee.ethz.ch>

#include <addr_map.h>

ENTRY(_start)

MEMORY {
  snitch_bootrom (rx) : ORIGIN = BOOTROM_BASE, LENGTH = 128
  instr_mem      (rx) : ORIGIN = INSTR_MEM_BASE, LENGTH = 512
  data_mem       (rw) : ORIGIN = DATA_MEM_BASE, LENGTH = 512
}

SECTIONS {
  /DISCARD/ : { *(.riscv.attributes) *(.comment) }

  /* Code (only) into instruction memory */
  .text : ALIGN(4) {
    *(.text.init)
    *(.text)
    *(.text.*)
  } > instr_mem

  /* Stack = 256 bytes = 64 words */
  __stack_size = 0x100;
  /* Reserve first data_mem addresses to stack */
  . = ORIGIN(data_mem);
  __stack_start = .;
  . = ORIGIN(data_mem) + __stack_size;
  __stack_end = .;

  .misc : ALIGN(4) {
    /* Advance pointer within data_mem to reserve stack */
    . = __stack_size;
    __misc_start = .;
    *(.rodata)
    *(.rodata.*)
    *(.data)
    *(.data.*)
    *(.srodata)
    *(.srodata.*)
    *(.sdata)
    *(.sdata.*)
    __misc_end = .;
  } > data_mem

  /* Zeroed memory into data_mem */
  .bss : {
    __bss_start = .;
    *(.bss)
    *(.bss.*)
    *(.sbss)
    *(.sbss.*)
    __bss_end = .;
    __data_mem_alloc_base = ALIGN(4);
  } > data_mem

  /* GP and SP setup */
  __global_pointer$ = ORIGIN(data_mem) + 0x100;
  /* Initialize stack pointer to the end of first bank of data_mem */
  __stack_pointer$ = __stack_end;

  /* Further addresses */
  __bootrom_start = ORIGIN(snitch_bootrom);
  __bootrom_end = ORIGIN(snitch_bootrom) + LENGTH(snitch_bootrom);
  __instr_mem_start = ORIGIN(instr_mem);
  __instr_mem_end = ORIGIN(instr_mem) + LENGTH(instr_mem);
  __data_mem_start = ORIGIN(data_mem);
  __data_mem_end = ORIGIN(data_mem) + LENGTH(data_mem);
}
