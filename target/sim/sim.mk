# Copyright 2025 ETH Zurich and University of Bologna.
# Solderpad Hardware License, Version 0.51, see LICENSE.solderpad for details.
# SPDX-License-Identifier: SHL-0.51
#
# Sergio Mazzola <smazzola@iis.ee.ethz.ch>

VWU_SIM_DIR = $(VWU_ROOT)/target/sim

SIM_SRC_FILES = $(VWU_HW_DIR)/snitch_bootrom.sv $(shell find {$(VWU_HW_DIR),$(VWU_TEST_DIR)} -type f)

# Top-level to simulate
sim_top_level ?= tb_vwu_top

#############
# QuestaSim #
#############

# Tooling
QUESTA ?= questa-2022.3

GUI ?= 0
# must be an app in `sw/apps`
APP ?=

sim_vsim_lib ?= $(VWU_SIM_DIR)/vsim/work

SIM_QUESTA_SUPPRESS ?= -suppress 3009 -suppress 3053 -suppress 8885 -suppress 12003

# vlog compilation arguments
SIM_VWU_VLOG_ARGS ?=
SIM_VWU_VLOG_ARGS += -work $(sim_vsim_lib)
# vopt optimization arguments
SIM_VWU_VOPT_ARGS ?=
SIM_VWU_VOPT_ARGS += $(SIM_QUESTA_SUPPRESS)
# vsim simulation arguments
SIM_VWU_VSIM_ARGS ?=
SIM_VWU_VSIM_ARGS += $(SIM_QUESTA_SUPPRESS) +permissive +notimingchecks +nospecify -t 1ps
ifeq ($(GUI),0)
	SIM_VWU_VSIM_ARGS += -c
endif
ifneq ($(APP),)
	SIM_VWU_VSIM_ARGS += +bin=$(VWU_SW_DIR)/apps/$(APP)
endif

$(VWU_SIM_DIR)/vsim/compile.tcl: $(VWU_ROOT)/Bender.lock $(VWU_ROOT)/Bender.yml
	$(BENDER) script vsim $(COMMON_DEFS) $(SIM_DEFS) $(COMMON_TARGS) $(SIM_TARGS) --vlog-arg="$(SIM_VWU_VLOG_ARGS)" > $@

.PHONY: compile-vsim
compile-vsim: $(sim_vsim_lib)/.hw_compiled
$(sim_vsim_lib)/.hw_compiled: $(VWU_SIM_DIR)/vsim/compile.tcl $(VWU_ROOT)/.bender/.checkout_stamp $(SIM_SRC_FILES)
	cd $(VWU_SIM_DIR)/vsim && \
	$(QUESTA) vlib $(sim_vsim_lib) && \
	$(QUESTA) vsim -c -do 'quit -code [source $<]' && \
	date > $@

.PHONY: opt-vsim
opt-vsim: $(sim_vsim_lib)/$(sim_top_level)_optimized/.tb_opt_compiled
$(sim_vsim_lib)/$(sim_top_level)_optimized/.tb_opt_compiled: $(sim_vsim_lib)/.hw_compiled
	cd $(VWU_SIM_DIR)/vsim && \
	$(QUESTA) vopt $(SIM_VWU_VOPT_ARGS) -work $(sim_vsim_lib) $(sim_top_level) -o $(sim_top_level)_optimized +acc && \
	date > $@

.PHONY: run-vsim
run-vsim: $(sim_vsim_lib)/$(sim_top_level)_optimized/.tb_opt_compiled
	cd $(VWU_SIM_DIR)/vsim && \
	$(QUESTA) vsim $(SIM_VWU_VSIM_ARGS) -lib $(sim_vsim_lib) \
	$(sim_top_level)_optimized \
	-do 'set GUI $(GUI); source $(VWU_SIM_DIR)/vsim/tb_vwu_top.tcl'

###########
# Helpers #
###########

.PHONY: clean-sim
clean-sim:
	rm -rf $(VWU_SIM_DIR)/vsim/work
	rm -rf $(VWU_SIM_DIR)/vsim/{transcript,*.ini,*.wlf}
	rm -f $(VWU_SIM_DIR)/vsim/compile.tcl
