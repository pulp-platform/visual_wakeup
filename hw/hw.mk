# Copyright 2025 ETH Zurich and University of Bologna.
# Solderpad Hardware License, Version 0.51, see LICENSE.solderpad for details.
# SPDX-License-Identifier: SHL-0.51
#
# Sergio Mazzola <smazzola@iis.ee.ethz.ch>

VWU_HW_DIR = $(VWU_ROOT)/hw

##################
# Snitch bootrom #
##################

.PHONY: snitch_bootrom
snitch_bootrom: $(VWU_HW_DIR)/snitch_bootrom.sv

$(VWU_HW_DIR)/snitch_bootrom.sv: $(VWU_SW_DIR)/bootrom/snitch_bootrom.bin $(VWU_UTILS_DIR)/gen_bootrom.py
	$(VWU_UTILS_DIR)/gen_bootrom.py --sv-module snitch_bootrom $< > $@
