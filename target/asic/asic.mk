# Copyright 2025 ETH Zurich and University of Bologna.
# Solderpad Hardware License, Version 0.51, see LICENSE.solderpad for details.
# SPDX-License-Identifier: SHL-0.51
#
# Sergio Mazzola <smazzola@iis.ee.ethz.ch>

WL_ASIC_DIR = $(WL_ROOT)/target/asic

# Top-level
asic_top_level ?= wl_top
asic_sim_tb ?= tb_wl_top

ASIC_SRC_FILES = $(WL_HW_DIR)/snitch_bootrom.sv $(shell find {$(WL_HW_DIR),$(WL_ASIC_DIR)/sourcecode} -type f)

asic_sim_netlist ?=
ASIC_SIM_SRC_FILES = $(shell find $(WL_TEST_DIR) -type f) $(asic_sim_netlist)
