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

_start:
    /* Globally disable Machine and Supervisor interrupts */
    csrrc x0, mstatus, 10
    /* Point mtvec at our trap handler */
    la t0, _trap_handler
    csrw mtvec, t0
    /* Clear remaining general-purpose registers */
    li x1,  0
    li x2,  0
    li x3,  0
    li x4,  0
    li x5,  0
    li x6,  0
    li x7,  0
    li x8,  0
    li x9,  0
    li x10, 0
    li x11, 0
    li x12, 0
    li x13, 0
    li x14, 0
    li x15, 0
    /* Reset top-level EOC register (in case we ended up here from sw reset) */
    la t0, REGISTER_EOC
    sw x0, 0(t0)
    /* Re-enable Machine interrupts */
    csrs mstatus, 1 << 3
    /* Enable only the local Machine External interrupt */
    li t0, 1 << 11
    csrs mie, t0
    /* Wait for interrupt */
    wfi

boot_to_instr_mem:
    la t0, INSTR_MEM_BASE
    jr t0

_return:
    /* Should never reach here */
    j _start

_trap_handler:
    /* Assuming interrupt controller doesn't need reset                */
    /* Here interrupt is just used to synchronize: just go forward now */
    mret
