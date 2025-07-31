// Copyright 2025 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE.apache for details.
// SPDX-License-Identifier: Apache-2.0
//
// Sergio Mazzola <smazzola@iis.ee.ethz.ch>

#ifndef __ADDR_MAP_H__
#define __ADDR_MAP_H__

////////////////
// Memory map //
////////////////

#define WL_BASE        0x00000000

#define BOOTROM_BASE   (WL_BASE + 0x00000000) // addressable from: core IF (r)
#define INSTR_MEM_BASE (WL_BASE + 0x00010000) // addressable from: core IF (r), cluster bus (rw)
#define DATA_MEM_BASE  (WL_BASE + 0x00020000) // addressable from: core LSU, cluster bus (rw)
#define CSR_BASE       (WL_BASE + 0x00040000) // addressable from: core LSU (rw)
#define HWPE_CFG_BASE  (WL_BASE + 0x00080000) // addressable from: core LSU (rw)

// external to memory map:
#define ACT_MEM_BASE 0x00000000 // addressable from: HWPE, AXI slave (rw)

///////////
// Sizes //
///////////
// in bytes

#define BOOTROM_OFFSET   128
#define INSTR_MEM_OFFSET INSTR_MEM_NUMBYTES
#define DATA_MEM_OFFSET  DATA_MEM_NUMBYTES
#define CSR_OFFSET       4
#define HWPE_CFG_OFFSET  0x1000

#define ACT_MEM_OFFSET   ACT_MEM_NUMBYTES

#endif // __ADDR_MAP_H__
