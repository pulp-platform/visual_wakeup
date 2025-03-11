// Copyright 2025 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE.apache for details.
// SPDX-License-Identifier: Apache-2.0
//
// Francesco Conti <f.conti@unibo.it>
// Sergio Mazzola <smazzola@iis.ee.ethz.ch>

#include <stdio.h>

#ifndef __HWPE_DATAMOVER_H__
#define __HWPE_DATAMOVER_H__

//////////////
// Hardware //
//////////////

#define WIDE_PORT_WIDTH_FACT (8) // How wider the HWPE wide port is compared to system's datawidth
#define DATAMOVER_BW_BIT (32 * WIDE_PORT_WIDTH_FACT) // bandwidth/access in bits (i.e., wide port width in bits)
#define DATAMOVER_BW_BYTE (DATAMOVER_BW_BIT / 8) // bandwidth/access in bytes (i.e., wide port width in bytes)

//////////////////
// Register map //
//////////////////

/*
 * Commands
 */

// offset wrt HWPE_CFG_BASE
#define DATAMOVER_COMMIT_AND_TRIGGER 0x00  // Trigger commit
#define DATAMOVER_ACQUIRE            0x04  // Acquire command
#define DATAMOVER_FINISHED           0x08  // Finished signal
#define DATAMOVER_STATUS             0x0c  // Status register
#define DATAMOVER_RUNNING_JOB        0x10  // Running job ID
#define DATAMOVER_SOFT_CLEAR         0x14  // Soft clear
#define DATAMOVER_SWSYNC             0x18  // Software synchronization
#define DATAMOVER_URISCY_IMEM        0x1c  // uRISCy instruction memory

// command register functions
#define DATAMOVER_WRITE_CMD(offset, value)        *(uint32_t volatile *)(HWPE_CFG_BASE + offset) = value
#define DATAMOVER_WRITE_CMD_BE(offset, value, be) *(uint8_t volatile *)(HWPE_CFG_BASE + offset + be) = value
#define DATAMOVER_READ_CMD(ret, offset)           ret = (*(uint32_t volatile *)(HWPE_CFG_BASE + offset))

#define DATAMOVER_BUSYWAIT()                      do {} while((*(int volatile *)(HWPE_CFG_BASE + DATAMOVER_STATUS)) != 0)

// commands
#define DATAMOVER_COMMIT_CMD  1
#define DATAMOVER_TRIGGER_CMD 0
#define DATAMOVER_SOFT_CLEAR_ALL   0
#define DATAMOVER_SOFT_CLEAR_STATE 1

/*
 * Job configuration
 */

#define DATAMOVER_REGISTER_OFFS      0x40   // Register base offset
#define DATAMOVER_REGISTER_CXT0_OFFS 0x80   // Context 0 offset
#define DATAMOVER_REGISTER_CXT1_OFFS 0x120  // Context 1 offset

// offset wrt HWPE_CFG_BASE + DATAMOVER_REGISTER_(OFFS|CXT0_OFFS|CXT1_OFFS)
//NOTE: All addresses/dimensions are given in bytes
#define DATAMOVER_REG_IN_PTR         0x00  // Input pointer
#define DATAMOVER_REG_OUT_PTR        0x04  // Output pointer
#define DATAMOVER_REG_TOT_LEN        0x08  // Total length
#define DATAMOVER_REG_IN_D0_LEN      0x0c  // Input dimension 0 length
#define DATAMOVER_REG_IN_D0_STRIDE   0x10  // Input dimension 0 stride
#define DATAMOVER_REG_IN_D1_LEN      0x14  // Input dimension 1 length
#define DATAMOVER_REG_IN_D1_STRIDE   0x18  // Input dimension 1 stride
#define DATAMOVER_REG_IN_D2_STRIDE   0x1c  // Input dimension 2 stride
#define DATAMOVER_REG_OUT_D0_LEN     0x20  // Output dimension 0 length
#define DATAMOVER_REG_OUT_D0_STRIDE  0x24  // Output dimension 0 stride
#define DATAMOVER_REG_OUT_D1_LEN     0x28  // Output dimension 1 length
#define DATAMOVER_REG_OUT_D1_STRIDE  0x2c  // Output dimension 1 stride
#define DATAMOVER_REG_OUT_D2_STRIDE  0x30  // Output dimension 2 stride

// job configuration functions
#define DATAMOVER_WRITE_REG(offset, value)             *(uint32_t volatile *)(HWPE_CFG_BASE + DATAMOVER_REGISTER_OFFS + offset) = value
#define DATAMOVER_WRITE_REG_BE(offset, value, be)      *(uint8_t volatile *)(HWPE_CFG_BASE + DATAMOVER_REGISTER_OFFS + offset + be) = value
#define DATAMOVER_READ_REG(ret, offset)                ret = (*(uint32_t volatile *)(HWPE_CFG_BASE + DATAMOVER_REGISTER_OFFS + offset))

#define DATAMOVER_WRITE_REG_CXT0(offset, value)        *(uint32_t volatile *)(HWPE_CFG_BASE + DATAMOVER_REGISTER_CXT0_OFFS + offset) = value
#define DATAMOVER_WRITE_REG_CXT0_BE(offset, value, be) *(uint8_t volatile *)(HWPE_CFG_BASE + DATAMOVER_REGISTER_CXT0_OFFS + offset + be) = value
#define DATAMOVER_READ_REG_CXT0(offset)                ret = (*(uint32_t volatile *)(HWPE_CFG_BASE + DATAMOVER_REGISTER_CXT0_OFFS + offset))

#define DATAMOVER_WRITE_REG_CXT1(offset, value)        *(uint32_t volatile *)(HWPE_CFG_BASE + DATAMOVER_REGISTER_CXT1_OFFS + offset) = value
#define DATAMOVER_WRITE_REG_CXT1_BE(offset, value, be) *(uint8_t volatile *)(HWPE_CFG_BASE + DATAMOVER_REGISTER_CXT1_OFFS + offset + be) = value
#define DATAMOVER_READ_REG_CXT1(offset)                ret = (*(uint32_t volatile *)(HWPE_CFG_BASE + DATAMOVER_REGISTER_CXT1_OFFS + offset))

#endif /* __HWPE_DATAMOVER_H__ */
