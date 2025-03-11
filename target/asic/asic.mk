# Copyright 2025 ETH Zurich and University of Bologna.
# Solderpad Hardware License, Version 0.51, see LICENSE.solderpad for details.
# SPDX-License-Identifier: SHL-0.51
#
# Sergio Mazzola <smazzola@iis.ee.ethz.ch>

VWU_ASIC_DIR = $(VWU_ROOT)/target/asic

# Top-level
asic_top_level ?= vwu_top
asic_sim_tb ?= tb_vwu_top

ASIC_SRC_FILES = $(VWU_HW_DIR)/snitch_bootrom.sv $(shell find {$(VWU_HW_DIR),$(VWU_ASIC_DIR)/sourcecode} -type f)

asic_sim_netlist ?=
ASIC_SIM_SRC_FILES = $(shell find $(VWU_TEST_DIR) -type f) $(asic_sim_netlist)
