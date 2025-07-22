# Copyright 2025 ETH Zurich and University of Bologna.
# Solderpad Hardware License, Version 0.51, see LICENSE.solderpad for details.
# SPDX-License-Identifier: SHL-0.51
#
# Sergio Mazzola <smazzola@iis.ee.ethz.ch>

WL_SIM_DIR = $(WL_ROOT)/target/sim

SIM_SRC_FILES = $(WL_HW_DIR)/snitch_bootrom.sv $(shell find {$(WL_HW_DIR),$(WL_TEST_DIR)} -type f)

# Top-level to simulate
sim_top_level ?= tb_wl_top

#############
# QuestaSim #
#############

# Tooling
QUESTA ?= questa-2022.3

GUI ?= 0
# must be an app in `sw/apps`
APP ?=

sim_vsim_lib ?= $(WL_SIM_DIR)/vsim/work

SIM_QUESTA_SUPPRESS ?= -suppress 3009 -suppress 3053 -suppress 8885 -suppress 12003

# vlog compilation arguments
SIM_WL_VLOG_ARGS ?=
SIM_WL_VLOG_ARGS += -work $(sim_vsim_lib)
# vopt optimization arguments
SIM_WL_VOPT_ARGS ?=
SIM_WL_VOPT_ARGS += $(SIM_QUESTA_SUPPRESS)
# vsim simulation arguments
SIM_WL_VSIM_ARGS ?=
SIM_WL_VSIM_ARGS += $(SIM_QUESTA_SUPPRESS) +permissive +notimingchecks +nospecify -t 1ps
ifeq ($(GUI),0)
	SIM_WL_VSIM_ARGS += -c
endif
ifneq ($(APP),)
	SIM_WL_VSIM_ARGS += +bin=$(WL_SW_DIR)/apps/$(APP)
endif

$(WL_SIM_DIR)/vsim/compile.tcl: $(WL_ROOT)/Bender.lock $(WL_ROOT)/Bender.yml
	$(BENDER) script vsim $(COMMON_DEFS) $(SIM_DEFS) $(COMMON_TARGS) $(SIM_TARGS) --vlog-arg="$(SIM_WL_VLOG_ARGS)" > $@

.PHONY: compile-vsim
compile-vsim: $(sim_vsim_lib)/.hw_compiled
$(sim_vsim_lib)/.hw_compiled: $(WL_SIM_DIR)/vsim/compile.tcl $(WL_ROOT)/.bender/.checkout_stamp $(SIM_SRC_FILES)
	cd $(WL_SIM_DIR)/vsim && \
	$(QUESTA) vlib $(sim_vsim_lib) && \
	$(QUESTA) vsim -c -do 'quit -code [source $<]' && \
	date > $@

.PHONY: opt-vsim
opt-vsim: $(sim_vsim_lib)/$(sim_top_level)_optimized/.tb_opt_compiled
$(sim_vsim_lib)/$(sim_top_level)_optimized/.tb_opt_compiled: $(sim_vsim_lib)/.hw_compiled
	cd $(WL_SIM_DIR)/vsim && \
	$(QUESTA) vopt $(SIM_WL_VOPT_ARGS) -work $(sim_vsim_lib) $(sim_top_level) -o $(sim_top_level)_optimized +acc && \
	date > $@

.PHONY: run-vsim
run-vsim: $(sim_vsim_lib)/$(sim_top_level)_optimized/.tb_opt_compiled
	cd $(WL_SIM_DIR)/vsim && \
	$(QUESTA) vsim $(SIM_WL_VSIM_ARGS) -lib $(sim_vsim_lib) \
	$(sim_top_level)_optimized \
	-do 'set GUI $(GUI); source $(WL_SIM_DIR)/vsim/tb_wl_top.tcl'

###########
# Helpers #
###########

.PHONY: clean-sim
clean-sim:
	rm -rf $(WL_SIM_DIR)/vsim/work
	rm -rf $(WL_SIM_DIR)/vsim/{transcript,*.ini,*.wlf}
	rm -f $(WL_SIM_DIR)/vsim/compile.tcl
