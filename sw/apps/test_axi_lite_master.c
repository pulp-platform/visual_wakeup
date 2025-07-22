// Copyright 2025 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE.apache for details.
// SPDX-License-Identifier: Apache-2.0
//
// Sergio Mazzola <smazzola@iis.ee.ethz.ch>

/*
 * Test the usage of the AXI Lite master port.
 */

#include <stdint.h>
#include <stddef.h>

#include <addr_map.h>

#define TESTVALUE 0xF0CACC1A

int main(void) {
    // Pick an address outside of the memory map of Wakelet
    volatile uint32_t *ext_addr = (uint32_t *)0xAA1F0000;
    volatile uint32_t x;

    // Store a test value in the external address (generate AXI Lite write)
	*(ext_addr) = TESTVALUE;
    // Read back the value to check if the write was successful (generate AXI Lite read)
    x = *ext_addr;

    // Test
    if (x != TESTVALUE) {
        return 1;
    }
    return 0;
}
