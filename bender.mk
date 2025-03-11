# Copyright 2025 ETH Zurich and University of Bologna.
# Solderpad Hardware License, Version 0.51, see LICENSE.solderpad for details.
# SPDX-License-Identifier: SHL-0.51
#
# Sergio Mazzola <smazzola@iis.ee.ethz.ch>

# Common defines
COMMON_DEFS ?=
# Common targets for bender
COMMON_TARGS ?=
COMMON_TARGS += -t disable_pmcs # for Snitch

# Simulation defines
SIM_DEFS  ?=
# Simulation targets for bender
SIM_TARGS ?=
SIM_TARGS += -t vwu_test

# Asic defines
ASIC_DEFS ?= -D COMMON_CELLS_ASSERTS_OFF
# Asic targets for bender
ASIC_TARGS ?=
ASIC_TARGS += -t asic -t synthesis

# Asic defines
ASIC_SIM_DEFS ?= -D COMMON_CELLS_ASSERTS_OFF
# Asic targets for bender
ASIC_SIM_TARGS ?=
ASIC_SIM_TARGS += -t vwu_test -t asic -t synthesis
