# Copyright 2025 ETH Zurich and University of Bologna.
# Solderpad Hardware License, Version 0.51, see LICENSE.solderpad for details.
# SPDX-License-Identifier: SHL-0.51
#
# Sergio Mazzola <smazzola@iis.ee.ethz.ch>

VWU_SW_DIR = $(VWU_ROOT)/sw

# Tooling
GCC_ROOT ?= $(dir $(shell which riscv32-unknown-elf-gcc))

CC      := $(GCC_ROOT)/riscv32-unknown-elf-gcc
OBJCOPY := $(GCC_ROOT)/riscv32-unknown-elf-objcopy
OBJDUMP := $(GCC_ROOT)/riscv32-unknown-elf-objdump

##########
# Set up #
##########

MARCH ?= rv32em

VWU_SW_FLAGS += -DOT_PLATFORM_RV32 -march=$(MARCH) -mabi=ilp32e -mstrict-align -O2 -Wall -Wextra -static -ffunction-sections -fdata-sections -fuse-linker-plugin -flto -Wl,-flto
CC_LD_FLAGS ?= $(VWU_SW_FLAGS) -nostartfiles -Wl,--gc-sections
CC_FLAGS ?= $(VWU_SW_FLAGS) -ggdb -mcmodel=medany -mexplicit-relocs -fno-builtin -fverbose-asm -pipe -MMD -MP

VWU_SW_INCL ?= -I$(VWU_SW_DIR)/runtime/include -I$(VWU_SW_DIR)/hal/include
VWU_SW_LIBS = 

# Other sources
LINKER_SCRIPT = $(VWU_SW_DIR)/runtime/link.ld
HAL_SRC = $(wildcard $(VWU_SW_DIR)/hal/*.c $(VWU_SW_DIR)/hal/*.S)
HAL_OBJ = $(patsubst %.c, %.o, $(HAL_SRC:.S=))
RUNTIME_OBJ = $(HAL_OBJ) $(VWU_SW_DIR)/runtime/crt0.o

# App sources
APPS_SRC ?= $(wildcard $(VWU_SW_DIR)/apps/*.c $(VWU_SW_DIR)/apps/*.S)
APPS_ELF = $(patsubst %.c, %.elf, $(APPS_SRC:.S=))

APPS_BIN_IMEM = $(patsubst %.elf, %.instr_mem.bin, $(APPS_ELF))
APPS_BIN_DMEM  = $(patsubst %.elf, %.data_mem.bin, $(APPS_ELF))
APPS_DUMP = $(patsubst %.elf, %.dump, $(APPS_ELF))

all-sw: $(APPS_BIN_IMEM) $(APPS_BIN_DMEM) $(APPS_DUMP)

##################
# Snitch bootrom #
##################

BOOTROM_SRC = $(wildcard $(VWU_SW_DIR)/bootrom/*.S) $(VWU_SW_LIBS)
BOOTROM_CC_FLAGS = $(CC_LD_FLAGS) -Os -fno-zero-initialized-in-bss -flto -fwhole-program -march=$(MARCH) -MMD -MP

$(VWU_SW_DIR)/bootrom/snitch_bootrom.bin: $(VWU_SW_DIR)/bootrom/snitch_bootrom.elf $(VWU_SW_DIR)/bootrom/snitch_bootrom.dump
	$(OBJCOPY) -O binary $< $@

# Priority over generic %.elf rule
$(VWU_SW_DIR)/bootrom/snitch_bootrom.elf: $(VWU_SW_DIR)/bootrom/snitch_bootrom.ld $(BOOTROM_SRC)
	$(CC) $(VWU_SW_INCL) -T$< $(BOOTROM_CC_FLAGS) -o $@ $(BOOTROM_SRC)

###############
# Compilation #
###############

.PRECIOUS: %.elf
%.elf: $(LINKER_SCRIPT) $(RUNTIME_OBJ) $(VWU_SW_LIBS) %.o
	$(CC) $(VWU_SW_INCL) -T$(LINKER_SCRIPT) $(CC_LD_FLAGS) -o $@ $(filter %.o,$^) $(VWU_SW_LIBS)

# If available, compile %.c source
# .PRECIOUS: %.o
%.o: %.c
	$(CC) $(VWU_SW_INCL) $(CC_FLAGS) -c $< -o $@

# Otherwise, compile %.S source
%.o: %.S
	$(CC) $(VWU_SW_INCL) $(CC_FLAGS) -c $< -o $@

# Generate binary dump for inspection
%.dump: %.elf
	$(OBJDUMP) -D -S $< > $@

# Linker scripts
.PRECIOUS: %.ld
%.ld: %.ld.c
	$(CC) $(VWU_SW_INCL) -P -E $< -o $@

##################################
# Separate binaries for flashing #
##################################

# Create binary to flash instruction memory (only .text)
%.instr_mem.bin: %.elf
	$(OBJCOPY) --only-section=.text -O binary $< $@

# Create binary to flash data memory (data + rodata)
%.data_mem.bin: %.elf
	$(OBJCOPY) --only-section=.misc -O binary $< $@

###########
# Helpers #
###########

.PHONY: clean-sw
clean-sw:
	rm -f $(LINKER_SCRIPT)
	rm -f $(VWU_SW_DIR)/apps/*.{elf,bin,dump,o,d}
	rm -f $(VWU_SW_DIR)/runtime/*.{o,d}
