# RISC-V 64-bit Assembly Linear Regression (RV64G)
# Copyright (C) 2026 Alan Gomez Pasillas
# SPDX-License-Identifier: GPL-2.0

# CONSTANTS
DATA_DIR = data
DATA_CSV ?= $(DATA_DIR)/example-simple-regression.csv
CONVERT  = $(DATA_DIR)/csv-to-riscv-src.sh
DATA_SRC = $(DATA_DIR)/dataset.s

SRC_DIR  = src/rv64g
SRC_MAIN = $(SRC_DIR)/main.s
OBJ_MAIN = $(SRC_DIR)/main.o
SRC_TEST = $(SRC_DIR)/tests.s
OBJ_TEST = $(SRC_DIR)/tests.o
SRC_PRED = $(SRC_DIR)/predict.s
OBJ_PRED = $(SRC_DIR)/predict.o
TARGET	 = linear-regression
TESTS	 = run-tests

OBJDUMP  = riscv64-linux-gnu-objdump
AS		 = riscv64-linux-gnu-as
LD		 = riscv64-linux-gnu-ld
QEMU	 = qemu-riscv64
GDB		 = gdb-multiarch

ASFLAGS  = -march=rv64g -mabi=lp64d -g

QEMU_PORT= 6060


all: $(TARGET) $(TESTS)

# TARGET
$(DATA_SRC): $(DATA_CSV) $(CONVERT)
	bash $(CONVERT) $(DATA_CSV) > $(DATA_SRC)

$(OBJ_MAIN): $(SRC_MAIN) $(DATA_SRC)
	$(AS) $(ASFLAGS) $(SRC_MAIN) -o $(OBJ_MAIN)

$(OBJ_PRED): $(SRC_PRED)
	$(AS) $(ASFLAGS) $(SRC_PRED) -o $(OBJ_PRED)

$(TARGET): $(OBJ_MAIN) $(OBJ_PRED)
	$(LD) $(OBJ_MAIN) $(OBJ_PRED) -o $(TARGET)

# TESTS
$(OBJ_TEST): $(SRC_TEST)
	$(AS) $(ASFLAGS) $(SRC_TEST) -o $(OBJ_TEST)

$(TESTS): $(OBJ_TEST) $(OBJ_PRED)
	$(LD) $(OBJ_TEST) $(OBJ_PRED) -o $(TESTS)

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
	rm -f $(SRC_DIR)/*.o $(TARGET) $(TESTS) $(DATA_SRC)

.PHONY: all disasm debug clean
