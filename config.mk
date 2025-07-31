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

DATA_MEM_NUMWORDS ?= 128
INSTR_MEM_NUMWORDS ?= 128

ACT_MEM_NUMBANKS ?= 16
ACT_MEM_NUMBANKWORDS ?= 128
ACT_MEM_WORDWIDTH ?= 32 # in bits

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
HW_CFG_DEFS += -D DATA_MEM_NUMWORDS=$(DATA_MEM_NUMWORDS)

ifeq ($(INSTR_MEM_TYPE), scm)
	HW_CFG_TARGS += -t wl_instr_scm
else ifeq ($(INSTR_MEM_TYPE), sram)
	HW_CFG_TARGS += -t wl_instr_sram
else
	$(error Invalid INSTR_MEM_TYPE value: $(INSTR_MEM_TYPE))
endif
HW_CFG_DEFS += -D INSTR_MEM_NUMWORDS=$(INSTR_MEM_NUMWORDS)

ifeq ($(ACT_MEM_TYPE), scm)
	HW_CFG_TARGS += -t wl_act_scm
else ifeq ($(ACT_MEM_TYPE), sram)
	HW_CFG_TARGS += -t wl_act_sram
else
	$(error Invalid ACT_MEM_TYPE value: $(ACT_MEM_TYPE))
endif
HW_CFG_DEFS += -D ACT_MEM_NUMBANKS=$(ACT_MEM_NUMBANKS)
HW_CFG_DEFS += -D ACT_MEM_NUMBANKWORDS=$(ACT_MEM_NUMBANKWORDS)
HW_CFG_DEFS += -D ACT_MEM_WORDWIDTH=$(ACT_MEM_WORDWIDTH)
