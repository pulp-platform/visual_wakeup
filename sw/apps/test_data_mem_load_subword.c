// Copyright 2025 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE.apache for details.
// SPDX-License-Identifier: Apache-2.0
//
// Sergio Mazzola <smazzola@iis.ee.ethz.ch>

/*
 * Test aligned and misaligned sub-word load instructions
 * from the core's private data memory.
 */

#include <stdint.h>
#include <stddef.h>

#include <addr_map.h>

volatile const uint32_t test_rodata = 0xF0CACC1A;
extern uint32_t __data_mem_alloc_base;

int main(void) {
    volatile uint32_t x;

    ////////////////////////////
    // Aligned sub-word loads //
    ////////////////////////////

    // Test 16-bit load (aligned)
    x = 0;
    x = *((uint16_t*)(&test_rodata));
    if (x != 0x0000CC1A) {
        return 1;
    }
    // Test 8-bit load (aligned)
    x = 0;
    x = *((uint8_t*)(&test_rodata));
    if (x != 0x0000001A) {
        return 2;
    }

    ///////////////////////////////
    // Misaligned sub-word loads //
    ///////////////////////////////

    // Test 16-bit load (misaligned)
    x = 0;
    x = *((uint16_t*)(&test_rodata) + 1);
    if (x != 0x0000F0CA) {
        return 3;
    }
    // Test 8-bit load (misaligned)
    x = 0;
    x = *((uint8_t*)(&test_rodata) + 1);
    if (x != 0x000000CC) {
        return 4;
    }
    // Test 8-bit load (misaligned)
    x = 0;
    x = *((uint8_t*)(&test_rodata) + 2);
    if (x != 0x000000CA) {
        return 5;
    }
    // Test 8-bit load (misaligned)
    x = 0;
    x = *((uint8_t*)(&test_rodata) + 3);
    if (x != 0x000000F0) {
        return 6;
    }

	return 0;
}
