// Copyright 2025 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE.apache for details.
// SPDX-License-Identifier: Apache-2.0
//
// Sergio Mazzola <smazzola@iis.ee.ethz.ch>

/*
 * Test the core's private data memory.
 */

#include <stdint.h>
#include <stddef.h>

#include <addr_map.h>

extern uint32_t __data_mem_alloc_base;

volatile uint32_t test_bss;
volatile const uint32_t test_rodata = 0xF0CACC1A;

int main(void) {
    volatile uint32_t x;

    // Test BSS (zero-initialized data memory section)
    x = *(&test_bss);
    if (x != 0) {
        return x;
    }

    // Test read-only data section
    x = *(&test_rodata);
    if (x != 0xF0CACC1A) {
        return x;
    }

    // Addressability test of free data memory section
	uint32_t *data_mem_base_addr = (uint32_t *)(&__data_mem_alloc_base);
    // Write memory addresses
	*data_mem_base_addr = 0x5;
	*(data_mem_base_addr + 1) = 0x11;
	*(data_mem_base_addr + 2) = 0x22;
	*(data_mem_base_addr + 16) = 0x66;
	*(data_mem_base_addr + 32) = 0xFF;
    // Check if writes were successful
    x = *data_mem_base_addr;
    if (x != 0x5) {
        return x;
    }
    x = *(data_mem_base_addr + 1);
    if (x != 0x11) {
        return x;
    }
    x = *(data_mem_base_addr + 2);
    if (x != 0x22) {
        return x;
    }
    x = *(data_mem_base_addr + 16);
    if (x != 0x66) {
        return x;
    }
    x = *(data_mem_base_addr + 32);
    if (x != 0xFF) {
        return x;
    }

	return 0;
}
