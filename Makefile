# Copyright 2025 ETH Zurich and University of Bologna.
# Solderpad Hardware License, Version 0.51, see LICENSE.solderpad for details.
# SPDX-License-Identifier: SHL-0.51
#
# Sergio Mazzola <smazzola@iis.ee.ethz.ch>

include bender.mk

WL_ROOT = $(shell pwd)

# Tooling
BENDER ?= bender

################
# Dependencies #
################

.PHONY: checkout
checkout: $(WL_ROOT)/.bender/.checkout_stamp

$(WL_ROOT)/.bender/.checkout_stamp: $(WL_ROOT)/Bender.lock
	$(BENDER) checkout && \
	date > $@

# $(WL_ROOT)/Bender.lock: $(WL_ROOT)/Bender.yml
# 	$(BENDER) update

###########
# Targets #
###########

include $(WL_ROOT)/utils/utils.mk
include $(WL_ROOT)/sw/sw.mk
include $(WL_ROOT)/hw/hw.mk
include $(WL_ROOT)/test/test.mk
include $(WL_ROOT)/target/sim/sim.mk

####################
# Non-free targets #
####################

ASIC_REMOTE ?= git@iis-git.ee.ethz.ch:pulp-restricted/wakelet-pd.git
ASIC_REV    ?= c06ff30e9367b48adc3047f9402477d8d84c1e18

asic-init:
	git clone $(ASIC_REMOTE) target/asic
	cd target/asic && git checkout $(ASIC_REV)

-include $(WL_ROOT)/target/asic/asic.mk
