// Copyright 2025 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE.apache for details.
// SPDX-License-Identifier: Apache-2.0

// Sergio Mazzola <smazzola@iis.ee.ethz.ch>

#include <addr_map.h>
#include <registers.h>

.section .text.init
.option  norvc /* generate only 32-bit instructions */
.align   2
.global  _start
.global  main

_start:
    /* Globally disable Machine and Supervisor interrupts */
    csrrc x0, mstatus, 10

    /* Init global and stack pointers from linker script */
    .option push
    .option norelax
    la t0, __global_pointer$
    mv gp, t0
    .option pop
    la t0, __stack_pointer$
    mv sp, t0

    /* Set trap vector */
    la t0, trap_vector
    csrrw x0, mtvec, t0

    /* Zero the .bss section */
    la t0, __bss_start      /* t0 = bss start address */
    la t1, __bss_end        /* t1 = bss end address   */
    sub t2, t1, t0          /* t2 = #bytes to zero    */
    li a0, 0

_zero_bss_loop:
    addi t1, t2, -16             /* <-- Use t1 (already defined register), not t3 or t4 */
    blez t2, _call_main          /* t2 <= 0? => No bss to zero                          */
    blt t1, x0, _zero_bss_rem    /* t1 < 0? => Less than 4 words left                   */
    sw a0, 0(t0)
    sw a0, 4(t0)
    sw a0, 8(t0)
    sw a0, 12(t0)
    addi t2, t2, -16
    addi t0, t0, 16
    bgt t2, x0, _zero_bss_loop   /* Still more to go */
    j _call_main

_zero_bss_rem:
    sb a0, 0(t0)
    addi t2, t2, -1
    addi t0, t0, 1
    bgt t2, x0, _zero_bss_rem

_call_main:
    call main

/* We end up here when main returns */
.global _exit
_exit:
    /* Capture main's return value, and shift left of 1 for EOC bit */
    la t0, REGISTER_EOC
    slli t1, a0, 1
    addi t1, t1, 1
    sw t1, 0(t0)
    /* Go back to bootrom (completely resets state) */
    j BOOTROM_BASE

.global trap_vector
.weak trap_vector
/* Trap handler redefined in C should handle caller-save registers to perform    */
/* a proper machine-mode exception return. By default, if interrupt arrives when */
/* not in bootrom anymore, reset to bootrom                                      */

trap_vector:
    /* Not implemented: reset */
    j BOOTROM_BASE
