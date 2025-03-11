// Copyright 2025 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE.apache for details.
// SPDX-License-Identifier: Apache-2.0
//
// Sergio Mazzola <smazzola@iis.ee.ethz.ch>

/*
 * Test the HWPE Datamover.
 */

#include <stdint.h>
#include <stddef.h>

#include <addr_map.h>
#include <hwpe_datamover.h>

#define ARRAY_LEN (512)
#define WORD_SIZE (sizeof(uint32_t)) // size of a word in bytes

#define X_ADDR (0x00000000) // beginning of the private Activation memory
#define Y_ADDR (X_ADDR + ARRAY_LEN * WORD_SIZE) // advance ARRAY_LEN words (i.e., write just after X array)

//NOTE: This test does not provide data for the HWPE memory to work with, because
// the core does not have access to that memory. The array at X_ADDR provided in the
// following configuration must be initialized in another way (e.g., from the testbench)

int main(void) {

    DATAMOVER_WRITE_CMD(DATAMOVER_SOFT_CLEAR, DATAMOVER_SOFT_CLEAR_ALL);
    asm volatile ("nop");
    asm volatile ("nop");

    // set up datamover
    DATAMOVER_WRITE_REG(DATAMOVER_REG_IN_PTR,        X_ADDR);
    DATAMOVER_WRITE_REG(DATAMOVER_REG_OUT_PTR,       Y_ADDR);
    DATAMOVER_WRITE_REG(DATAMOVER_REG_TOT_LEN,       ARRAY_LEN*WORD_SIZE / DATAMOVER_BW_BYTE);
    DATAMOVER_WRITE_REG(DATAMOVER_REG_IN_D0_LEN,     ARRAY_LEN*WORD_SIZE / DATAMOVER_BW_BYTE);
    DATAMOVER_WRITE_REG(DATAMOVER_REG_IN_D0_STRIDE,  DATAMOVER_BW_BYTE);
    DATAMOVER_WRITE_REG(DATAMOVER_REG_IN_D1_LEN,     0);
    DATAMOVER_WRITE_REG(DATAMOVER_REG_IN_D1_STRIDE,  0);
    DATAMOVER_WRITE_REG(DATAMOVER_REG_IN_D2_STRIDE,  0);
    DATAMOVER_WRITE_REG(DATAMOVER_REG_OUT_D0_LEN,    ARRAY_LEN*WORD_SIZE / DATAMOVER_BW_BYTE);
    DATAMOVER_WRITE_REG(DATAMOVER_REG_OUT_D0_STRIDE, DATAMOVER_BW_BYTE);
    DATAMOVER_WRITE_REG(DATAMOVER_REG_OUT_D1_LEN,    0);
    DATAMOVER_WRITE_REG(DATAMOVER_REG_OUT_D1_STRIDE, 0);
    DATAMOVER_WRITE_REG(DATAMOVER_REG_OUT_D2_STRIDE, 0);

    // commit and trigger datamover operation
    DATAMOVER_WRITE_CMD(DATAMOVER_COMMIT_AND_TRIGGER, DATAMOVER_TRIGGER_CMD);

    DATAMOVER_BUSYWAIT();

	return 0;
}
