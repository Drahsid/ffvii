BOOT_BASENAME   := SCUS_941
KERNEL_BASENAME := kernel
COMMON_BASENAME	:= common

BASE_DIR		:= base
BUILD_DIR       := build
TOOLS_DIR       := tools

TARGET_BOOT		:= $(BUILD_DIR)/$(BOOT_BASENAME)
TARGET_KERNEL	:= $(BUILD_DIR)/$(KERNEL_BASENAME)
GAMEBIN_DIR		:= $(BOOT_BASENAME)

TEMP_DIR		:= temp

# boot loader (identical on all disks, SCUS_941.63, SCUS_941.64, SCUS_941.65)
ASM_BOOT_DIR	:= asm/boot asm/boot/data
C_BOOT_DIR		:= src/boot
ASSETS_BOOT_DIR	:= assets/boot

ASM_BOOT_DIRS	:= $(ASM_BOOT_DIR) $(ASM_BOOT_DIR)/data
C_BOOT_DIRS		:= $(C_BOOT_DIR)
BIN_BOOT_DIRS	:= $(ASSETS_BOOT_DIR)

S_BOOT_FILES	:= $(foreach dir,$(ASM_BOOT_DIRS),$(wildcard $(dir)/*.s))
C_BOOT_FILES	:= $(foreach dir,$(C_BOOT_DIRS),$(wildcard $(dir)/*.c))
BIN_BOOT_FILES	:= $(foreach dir,$(BIN_BOOT_DIRS),$(wildcard $(dir)/*.bin))

O_BOOT_FILES	:= $(foreach file,$(S_BOOT_FILES),$(BUILD_DIR)/$(file).o) \
					$(foreach file,$(C_BOOT_FILES),$(BUILD_DIR)/$(file).o) \
					$(foreach file,$(BIN_BOOT_FILES),$(BUILD_DIR)/$(file).o)

# KERNEL.bin (identical on all disks)
ASM_$(KERNEL_BASENAME)_DIR		:= asm/$(KERNEL_BASENAME)
C_$(KERNEL_BASENAME)_DIR		:= src/$(KERNEL_BASENAME)
ASSETS_$(KERNEL_BASENAME)_DIR	:= assets/$(KERNEL_BASENAME)

ASM_$(KERNEL_BASENAME)_DIRS		:= $(ASM_$(KERNEL_BASENAME)_DIR) $(ASM_$(KERNEL_BASENAME)_DIR)/data
C_$(KERNEL_BASENAME)_DIRS		:= $(C_$(KERNEL_BASENAME)_DIR)
BIN_$(KERNEL_BASENAME)_DIRS		:= $(ASSETS_$(KERNEL_BASENAME)_DIR)

S_$(KERNEL_BASENAME)_FILES		:= $(foreach dir,$(ASM_$(KERNEL_BASENAME)_DIRS),$(wildcard $(dir)/*.s))
C_$(KERNEL_BASENAME)_FILES		:= $(foreach dir,$(C_$(KERNEL_BASENAME)_DIRS),$(wildcard $(dir)/*.c))
BIN_$(KERNEL_BASENAME)_FILES	:= $(foreach dir,$(BIN_$(KERNEL_BASENAME)_DIRS),$(wildcard $(dir)/*.bin))

O_$(KERNEL_BASENAME)_FILES		:= $(foreach file,$(S_$(KERNEL_BASENAME)_FILES),$(BUILD_DIR)/$(file).o) \
									$(foreach file,$(C_$(KERNEL_BASENAME)_FILES),$(BUILD_DIR)/$(file).o) \
									$(foreach file,$(BIN_$(KERNEL_BASENAME)_FILES),$(BUILD_DIR)/$(file).o)

# common (here for example)
ASM_$(COMMON_BASENAME)_DIR		:= asm/$(COMMON_BASENAME)
C_$(COMMON_BASENAME)_DIR		:= src/$(COMMON_BASENAME)
ASSETS_$(COMMON_BASENAME)_DIR	:= assets/$(COMMON_BASENAME)

ASM_$(COMMON_BASENAME)_DIRS		:= $(ASM_$(COMMON_BASENAME)_DIR) $(ASM_$(COMMON_BASENAME)_DIR)/data
C_$(COMMON_BASENAME)_DIRS		:= $(C_$(COMMON_BASENAME)_DIR)
BIN_$(COMMON_BASENAME)_DIRS		:= $(ASSETS_$(COMMON_BASENAME)_DIR)

S_$(COMMON_BASENAME)_FILES		:= $(foreach dir,$(ASM_$(COMMON_BASENAME)_DIRS),$(wildcard $(dir)/*.s))
C_$(COMMON_BASENAME)_FILES		:= $(foreach dir,$(C_$(COMMON_BASENAME)_DIRS),$(wildcard $(dir)/*.c))
BIN_$(COMMON_BASENAME)_FILES	:= $(foreach dir,$(BIN_$(COMMON_BASENAME)_DIRS),$(wildcard $(dir)/*.bin))

O_$(COMMON_BASENAME)_FILES		:= $(foreach file,$(S_$(COMMON_BASENAME)_FILES),$(BUILD_DIR)/$(file).o) \
									$(foreach file,$(C_$(COMMON_BASENAME)_FILES),$(BUILD_DIR)/$(file).o) \
									$(foreach file,$(BIN_$(COMMON_BASENAME)_FILES),$(BUILD_DIR)/$(file).o)

# batch
ALL_ASM_DIRS	:= $(ASM_BOOT_DIRS) $(ASM_$(COMMON_BASENAME)_DIRS) #$(ASM_$(KERNEL_BASENAME)_DIRS)
ALL_C_DIRS		:= $(C_BOOT_DIRS) $(C_$(COMMON_BASENAME)_DIRS) #$(C_$(KERNEL_BASENAME)_DIRS)
ALL_BIN_DIRS	:= $(BIN_BOOT_DIRS) $(BIN_$(COMMON_BASENAME)_DIRS) #$(BIN_$(KERNEL_BASENAME)_DIRS)
ALL_ASSETS_DIRS	:= $(ASSETS_BOOT_DIR) $(ASSETS_$(COMMON_BASENAME)_DIR) #$(ASSETS_$(KERNEL_BASENAME)_DIR)

# TOOLS
PYTHON          := python3
WINE            := wine
CPP             := cpp
CROSS			:= mips-linux-gnu-
AS              := $(CROSS)as -EL
LD              := $(CROSS)ld -EL
OBJCOPY         := $(CROSS)objcopy
CC_272			:= $(TOOLS_DIR)/psyq/272/cc1 # Native 2.7.2
CC_PSYQ_36     	:= $(WINE) $(TOOLS_DIR)/psyq/3.6/CC1PSX.EXE # 2.7.2.SN.1
CC_PSYQ_41      := $(WINE) $(TOOLS_DIR)/psyq/4.1/CC1PSX.EXE	# cygnus-2.7.2-970404
CC_PSYQ_43      := $(WINE) $(TOOLS_DIR)/psyq/4.3/CC1PSX.EXE # 2.8.1 SN32
CC_PSYQ_46      := $(WINE) $(TOOLS_DIR)/psyq/4.6/CC1PSX.EXE # 2.95
CC              := $(CC_272)
SPLAT           := $(PYTHON) $(TOOLS_DIR)/splat/split.py
BCHUNK			:= bchunk
7Z				:= 7z

# Flags
OPT_FLAGS       := -O2
INCLUDE_CFLAGS	:= -Iinclude
AS_FLAGS        := -march=r3000 -mtune=r3000 -Iinclude
D_FLAGS       	:= -D_LANGUAGE_C
CC_FLAGS        := -G 0 -mips1 -mcpu=3000 -mgas -msoft-float $(OPT_FLAGS) -fgnu-linker
CPP_FLAGS       := -undef -Wall -lang-c $(DFLAGS) $(INCLUDE_CFLAGS) -nostdinc
OBJCOPY_FLAGS   := -O binary

# Rules

default: all

all: dirs $(TARGET_BOOT) check

check: $(TARGET_BOOT)
	@echo "$$(cat $(GAMEBIN_DIR)/$(BOOT_BASENAME).sha1) $<" | sha1sum --check

dirs:
	$(foreach dir,$(ALL_ASM_DIRS) $(ALL_C_DIRS) $(ALL_BIN_DIRS),$(shell mkdir -p $(BUILD_DIR)/$(dir)))

setup_diskdirs:
	mkdir -p $(TEMP_DIR)

$(TEMP_DIR)/disk101.iso: setup_diskdirs
	@echo merging disk 1...
	$(BCHUNK) $(BASE_DIR)/ffvii1.bin $(BASE_DIR)/ffvii1.cue $(TEMP_DIR)/disk1 > /dev/null

$(TEMP_DIR)/disk201.iso: setup_diskdirs
	@echo merging disk 2...
	$(BCHUNK) $(BASE_DIR)/ffvii2.bin $(BASE_DIR)/ffvii2.cue $(TEMP_DIR)/disk2  > /dev/null

$(TEMP_DIR)/disk301.iso: setup_diskdirs
	@echo merging disk 3...
	$(BCHUNK) $(BASE_DIR)/ffvii3.bin $(BASE_DIR)/ffvii3.cue $(TEMP_DIR)/disk3  > /dev/null

assets: $(TEMP_DIR)/disk101.iso $(TEMP_DIR)/disk201.iso $(TEMP_DIR)/disk301.iso
	@echo extracting assets
	$(PYTHON) extract_assets.py > /dev/null

ifeq (,$(wildcard $(GAMEBIN_DIR)/$(BOOT_BASENAME)))
setup: $(GAMEBIN_DIR)/$(BOOT_BASENAME).yaml assets
	rm -rf $(TEMP_DIR)
else
setup: $(GAMEBIN_DIR)/$(BOOT_BASENAME).yaml
endif
	$(SPLAT) $(GAMEBIN_DIR)/$(BOOT_BASENAME).yaml
#	$(SPLAT) $(GAMEBIN_DIR)/$(KERNEL_BASENAME).yaml

clean:
	rm -rf $(BUILD_DIR)

nuke:
	rm -rf asm
	rm -rf assets
	rm -rf $(BUILD_DIR)
	rm -rf $(GAMEBIN_DIR)/*auto*.txt
	rm -rf $(GAMEBIN_DIR)/*.ld

ubernuke: nuke
	rm -rf $(GAMEBIN_DIR)/common
	rm -rf $(GAMEBIN_DIR)/disk1
	rm -rf $(GAMEBIN_DIR)/disk2
	rm -rf $(GAMEBIN_DIR)/disk3

# bootloader
$(TARGET_BOOT): $(TARGET_BOOT).elf
	$(OBJCOPY) $(OBJCOPY_FLAGS) $< $@

$(TARGET_BOOT).elf: $(O_BOOT_FILES)
	$(LD) -Map $(BUILD_DIR)/$(BOOT_BASENAME).map -T $(GAMEBIN_DIR)/$(BOOT_BASENAME).ld -T $(GAMEBIN_DIR)/undefined_syms_auto.$(BOOT_BASENAME).txt -T $(GAMEBIN_DIR)/undefined_funcs_auto.$(BOOT_BASENAME).txt -T $(GAMEBIN_DIR)/undefined_syms.$(BOOT_BASENAME).txt --no-check-sections -o $@

# generate objects
$(BUILD_DIR)/%.i: %.c
	$(CPP) -P -MMD -MP -MT $@ -MF $@.d $(CPP_FLAGS) -o $@ $<

$(BUILD_DIR)/%.c.s: $(BUILD_DIR)/%.i
	$(CC) $(CC_FLAGS) -o $@ $<

$(BUILD_DIR)/%.c.o: $(BUILD_DIR)/%.c.s
	$(AS) $(AS_FLAGS) -o $@ $<

$(BUILD_DIR)/%.s.o: %.s
	$(AS) $(AS_FLAGS) -o $@ $<

$(BUILD_DIR)/%.bin.o: %.bin
	$(LD) -r -b binary -o $@ $<

### Settings
.SECONDARY:
.PHONY: all clean default
SHELL = /bin/bash -e -o pipefail
