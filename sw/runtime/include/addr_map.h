// Copyright 2025 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE.apache for details.
// SPDX-License-Identifier: Apache-2.0
//
// Sergio Mazzola <smazzola@iis.ee.ethz.ch>

#ifndef __ADDR_MAP_H__
#define __ADDR_MAP_H__

#define VWU_BASE       0x00000000

#define BOOTROM_BASE   (VWU_BASE + 0x00000000) // addressable from: core IF (r)
#define INSTR_MEM_BASE (VWU_BASE + 0x00010000) // addressable from: core IF (r), cluster bus (rw)
#define DATA_MEM_BASE  (VWU_BASE + 0x00020000) // addressable from: core LSU, cluster bus (rw)
#define CSR_BASE       (VWU_BASE + 0x00040000) // addressable from: core LSU (rw)
#define HWPE_CFG_BASE  (VWU_BASE + 0x00080000) // addressable from: core LSU (rw)

#endif // __ADDR_MAP_H__
