# Copyright 2025 ETH Zurich and University of Bologna.
# Solderpad Hardware License, Version 0.51, see LICENSE.solderpad for details.
# SPDX-License-Identifier: SHL-0.51
#
# Sergio Mazzola <smazzola@iis.ee.ethz.ch>

WL_SW_DIR = $(WL_ROOT)/sw

# Tooling
GCC_ROOT ?= $(dir $(shell which riscv32-unknown-elf-gcc))

CC      := $(GCC_ROOT)/riscv32-unknown-elf-gcc
OBJCOPY := $(GCC_ROOT)/riscv32-unknown-elf-objcopy
OBJDUMP := $(GCC_ROOT)/riscv32-unknown-elf-objdump

################################
# Hw parameters from config.mk #
################################

# Add defines to compilation
WL_SW_HWDEFS := -DDATA_MEM_NUMBYTES=$(shell expr $(DATA_MEM_NUMWORDS) \* 4)
WL_SW_HWDEFS += -DINSTR_MEM_NUMBYTES=$(shell expr $(INSTR_MEM_NUMWORDS) \* 4)

WL_SW_HWDEFS += -DACT_MEM_NUMBANKS=$(ACT_MEM_NUMBANKS)
WL_SW_HWDEFS += -DACT_MEM_NUMBANKWORDS=$(ACT_MEM_NUMBANKWORDS)
WL_SW_HWDEFS += -DACT_MEM_WORDWIDTH=$(ACT_MEM_WORDWIDTH)
WL_SW_HWDEFS += -DACT_MEM_NUMBYTES=$(shell expr $(ACT_MEM_NUMBANKS) \* $(ACT_MEM_NUMBANKWORDS) \* $(ACT_MEM_WORDWIDTH) / 8)


##########
# Set up #
##########

MARCH ?= rv32em

WL_SW_FLAGS += -DOT_PLATFORM_RV32 -march=$(MARCH) -mabi=ilp32e -mstrict-align -O2 -Wall -Wextra -static -ffunction-sections -fdata-sections -fuse-linker-plugin -flto -Wl,-flto $(WL_SW_HWDEFS)
CC_LD_FLAGS ?= $(WL_SW_FLAGS) -nostartfiles -Wl,--gc-sections
CC_FLAGS ?= $(WL_SW_FLAGS) -ggdb -mcmodel=medany -mexplicit-relocs -fno-builtin -fverbose-asm -pipe -MMD -MP

WL_SW_INCL ?= -I$(WL_SW_DIR)/runtime/include -I$(WL_SW_DIR)/hal/include
WL_SW_LIBS = 

# Other sources
LINKER_SCRIPT = $(WL_SW_DIR)/runtime/link.ld
HAL_SRC = $(wildcard $(WL_SW_DIR)/hal/*.c $(WL_SW_DIR)/hal/*.S)
HAL_OBJ = $(patsubst %.c, %.o, $(HAL_SRC:.S=))
RUNTIME_OBJ = $(HAL_OBJ) $(WL_SW_DIR)/runtime/crt0.o

# App sources
APPS_SRC ?= $(wildcard $(WL_SW_DIR)/apps/*.c $(WL_SW_DIR)/apps/*.S)
APPS_ELF = $(patsubst %.c, %.elf, $(APPS_SRC:.S=))

APPS_BIN_IMEM = $(patsubst %.elf, %.instr_mem.bin, $(APPS_ELF))
APPS_BIN_DMEM  = $(patsubst %.elf, %.data_mem.bin, $(APPS_ELF))
APPS_DUMP = $(patsubst %.elf, %.dump, $(APPS_ELF))

all-sw: $(APPS_BIN_IMEM) $(APPS_BIN_DMEM) $(APPS_DUMP)

##################
# Snitch bootrom #
##################

BOOTROM_SRC = $(wildcard $(WL_SW_DIR)/bootrom/*.S) $(WL_SW_LIBS)
BOOTROM_CC_FLAGS = $(CC_LD_FLAGS) -Os -fno-zero-initialized-in-bss -flto -fwhole-program -march=$(MARCH) -MMD -MP

$(WL_SW_DIR)/bootrom/snitch_bootrom.bin: $(WL_SW_DIR)/bootrom/snitch_bootrom.elf $(WL_SW_DIR)/bootrom/snitch_bootrom.dump
	$(OBJCOPY) -O binary $< $@

# Priority over generic %.elf rule
$(WL_SW_DIR)/bootrom/snitch_bootrom.elf: $(WL_SW_DIR)/bootrom/snitch_bootrom.ld $(BOOTROM_SRC)
	$(CC) $(WL_SW_INCL) -T$< $(BOOTROM_CC_FLAGS) -o $@ $(BOOTROM_SRC)

###############
# Compilation #
###############

.PRECIOUS: %.elf
%.elf: $(LINKER_SCRIPT) $(RUNTIME_OBJ) $(WL_SW_LIBS) %.o
	$(CC) $(WL_SW_INCL) -T$(LINKER_SCRIPT) $(CC_LD_FLAGS) -o $@ $(filter %.o,$^) $(WL_SW_LIBS)

# If available, compile %.c source
# .PRECIOUS: %.o
%.o: %.c
	$(CC) $(WL_SW_INCL) $(CC_FLAGS) -c $< -o $@

# Otherwise, compile %.S source
%.o: %.S
	$(CC) $(WL_SW_INCL) $(CC_FLAGS) -c $< -o $@

# Generate binary dump for inspection
%.dump: %.elf
	$(OBJDUMP) -D -S $< > $@

# Linker scripts
.PRECIOUS: %.ld
%.ld: %.ld.c
	$(CC) $(WL_SW_INCL) $(WL_SW_HWDEFS) -P -E $< -o $@

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
	rm -f $(WL_SW_DIR)/apps/*.{elf,bin,dump,o,d}
	rm -f $(WL_SW_DIR)/runtime/*.{o,d}
