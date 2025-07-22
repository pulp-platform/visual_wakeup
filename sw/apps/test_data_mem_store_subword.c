// Copyright 2025 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE.apache for details.
// SPDX-License-Identifier: Apache-2.0
//
// Sergio Mazzola <smazzola@iis.ee.ethz.ch>

/*
 * Test aligned and misaligned sub-word store instructions
 * to the core's private data memory.
 */

#include <stdint.h>
#include <stddef.h>

#include <addr_map.h>

volatile const uint32_t test_rodata = 0xF0CACC1A;
extern uint32_t __data_mem_alloc_base;

int main(void) {
    volatile uint32_t x;
    volatile uint32_t y;

    /////////////////////////////
    // Aligned sub-word stores //
    /////////////////////////////

    y = 0xDEADBEEF;
	volatile uint32_t *data_mem_base_addr = (uint32_t*)(&__data_mem_alloc_base);

    // Before each test, reset the whole memory word to 0x11111111.
    // This helps ensuring that the strobe signal for write operations works properly:
    // in case of error, the word gets overwritten with the new data (y) instead of only
    // the desired sub-word.

    // Test 16-bit store (aligned)
    *((volatile uint32_t*)(data_mem_base_addr)) = 0x11111111;
    *((volatile uint16_t*)(data_mem_base_addr)) = y;
    x = 0;
    x = *((volatile uint32_t*)(data_mem_base_addr));
    if (x != 0x1111BEEF) {
        return 7;
    }
    // Test 8-bit store (aligned)
    *((volatile uint32_t*)(data_mem_base_addr)) = 0x11111111;
    *((volatile uint8_t*)(data_mem_base_addr)) = y;
    x = 0;
    x = *((volatile uint32_t*)(data_mem_base_addr));
    if (x != 0x111111EF) {
        return 8;
    }

    ////////////////////////////////
    // Misaligned sub-word stores //
    ////////////////////////////////

    // Test 16-bit store (misaligned)
    *((volatile uint32_t*)(data_mem_base_addr)) = 0x11111111;
    *((volatile uint16_t*)(data_mem_base_addr) + 1) = y;
    x = 0;
    x = *((volatile uint32_t*)(data_mem_base_addr));
    if (x != 0xBEEF1111) {
        return 9;
    }
    // Test 8-bit store (misaligned)
    *((volatile uint32_t*)(data_mem_base_addr)) = 0x11111111;
    *((volatile uint8_t*)(data_mem_base_addr) + 1) = y;
    x = 0;
    x = *((volatile uint32_t*)(data_mem_base_addr));
    if (x != 0x1111EF11) {
        return 10;
    }
    // Test 8-bit store (misaligned)
    *((volatile uint32_t*)(data_mem_base_addr)) = 0x11111111;
    *((volatile uint8_t*)(data_mem_base_addr) + 2) = y;
    x = 0;
    x = *((volatile uint32_t*)(data_mem_base_addr));
    if (x != 0x11EF1111) {
        return 11;
    }
    // Test 8-bit store (misaligned)
    *((volatile uint32_t*)(data_mem_base_addr)) = 0x11111111;
    *((volatile uint8_t*)(data_mem_base_addr) + 3) = y;
    x = 0;
    x = *((volatile uint32_t*)(data_mem_base_addr));
    if (x != 0xEF111111) {
        return 12;
    }

	return 0;
}
