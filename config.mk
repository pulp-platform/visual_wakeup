# Copyright 2025 ETH Zurich and University of Bologna.
# Solderpad Hardware License, Version 0.51, see LICENSE.solderpad for details.
# SPDX-License-Identifier: SHL-0.51
#
# Sergio Mazzola <smazzola@iis.ee.ethz.ch>

############
# Memories #
############

# Possible values:
# - scm: standard-cell-based memory
# - sram: SRAM cut

DATA_MEM_TYPE ?= scm
INSTR_MEM_TYPE ?= scm
ACT_MEM_TYPE ?= scm



#########################
# Parameters generation #
#########################
# Do not change from here on!

HW_CFG_DEFS :=
HW_CFG_TARGS :=

ifeq ($(DATA_MEM_TYPE), scm)
	HW_CFG_TARGS += -t wl_data_scm
else ifeq ($(DATA_MEM_TYPE), sram)
	HW_CFG_TARGS += -t wl_data_sram
else
	$(error Invalid DATA_MEM_TYPE value: $(DATA_MEM_TYPE))
endif

ifeq ($(INSTR_MEM_TYPE), scm)
	HW_CFG_TARGS += -t wl_instr_scm
else ifeq ($(INSTR_MEM_TYPE), sram)
	HW_CFG_TARGS += -t wl_instr_sram
else
	$(error Invalid INSTR_MEM_TYPE value: $(INSTR_MEM_TYPE))
endif

ifeq ($(ACT_MEM_TYPE), scm)
	HW_CFG_TARGS += -t wl_act_scm
else ifeq ($(ACT_MEM_TYPE), sram)
	HW_CFG_TARGS += -t wl_act_sram
else
	$(error Invalid ACT_MEM_TYPE value: $(ACT_MEM_TYPE))
endif
