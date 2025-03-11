# Copyright 2025 ETH Zurich and University of Bologna.
# Solderpad Hardware License, Version 0.51, see LICENSE.solderpad for details.
# SPDX-License-Identifier: SHL-0.51
#
# Sergio Mazzola <smazzola@iis.ee.ethz.ch>

include bender.mk

VWU_ROOT = $(shell pwd)

# Tooling
BENDER ?= bender

################
# Dependencies #
################

.PHONY: checkout
checkout: $(VWU_ROOT)/.bender/.checkout_stamp

$(VWU_ROOT)/.bender/.checkout_stamp: $(VWU_ROOT)/Bender.lock
	$(BENDER) checkout && \
	date > $@

# $(VWU_ROOT)/Bender.lock: $(VWU_ROOT)/Bender.yml
# 	$(BENDER) update

###########
# Targets #
###########

include $(VWU_ROOT)/utils/utils.mk
include $(VWU_ROOT)/sw/sw.mk
include $(VWU_ROOT)/hw/hw.mk
include $(VWU_ROOT)/test/test.mk
include $(VWU_ROOT)/target/sim/sim.mk
include $(VWU_ROOT)/target/asic/asic.mk
