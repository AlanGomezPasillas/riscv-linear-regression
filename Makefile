# RISC-V 64-bit Assembly Linear Regression (RV64G)
# Copyright (C) 2026 Alan Gomez Pasillas
# SPDX-License-Identifier: GPL-2.0

DATA_DIR = data
DATA_CSV ?= $(DATA_DIR)/example-simple-regression.csv
CONVERT  = $(DATA_DIR)/csv-to-riscv-src.sh
DATA_SRC = $(DATA_DIR)/dataset.s

SRC_DIR  = src/rv64g
SRC_MAIN = $(SRC_DIR)/main.s
OBJ		 = $(SRC_DIR)/main.o
TARGET	 = linear_regression

OBJDUMP  = riscv64-linux-gnu-objdump
AS		 = riscv64-linux-gnu-as
LD		 = riscv64-linux-gnu-ld
QEMU	 = qemu-riscv64
GDB		 = gdb-multiarch

ASFLAGS  = -march=rv64g -mabi=lp64d -g

QEMU_PORT= 6060

all: $(TARGET)

$(DATA_SRC): $(DATA_CSV) $(CONVERT)
	bash $(CONVERT) $(DATA_CSV) > $(DATA_SRC)

$(OBJ): $(SRC_MAIN) $(DATA_SRC)
	$(AS) $(ASFLAGS) $(SRC_MAIN) -o $(OBJ)

$(TARGET): $(OBJ)
	$(LD) $(OBJ) -o $(TARGET)

disasm: $(TARGET)
	$(OBJDUMP) -d $(TARGET)

debug: $(TARGET)
	@echo "Starting QEMU gdbserver on port $(QEMU_PORT)..."
	@$(QEMU) -g $(QEMU_PORT) $(TARGET) & \
	QEMU_PID=$$!; \
	sleep 0.5; \
	$(GDB) -ex "target remote localhost:$(QEMU_PORT)" \
		   -ex "layout asm" \
		   -ex "break _start" \
		   $(TARGET); \
	kill "$$QEMU_PID" 2>/dev/null || true

clean:
	rm -f $(OBJ) $(TARGET) $(DATA_SRC)

.PHONY: all disasm debug clean
