# RISC-V Gradient Descent Linear Regression
# Copyright (C) 2026  Alan Gomez Pasillas
# SPDX-License-Identifier: GPL-2.0

.extern predict

# CONSTANTS
.equ N_EPOCHS, 999

# RODATA
.section .rodata
.balign 8

delta: .double 0.00001
alpha: .double 0.01

.include "data/dataset.s"

# BSS
.section .bss
.balign 8

theta: .zero N_FEATURES * 8
theta_d: .zero N_PARAMS * 8

# TEXT
.section .text
.globl _start

_start:
    la s0, x0_data
    la s1, y_data

    li s2, N_FEATURES
    li s3, N_SAMPLES
    li s4, N_EPOCHS

    la s5, theta
    la s6, theta_d

    la t0, alpha
    fld fs0, 0(t0)

    la t0, delta
    fld fs1, 0(t0)

train_loop:
    beqz s4, train_end

    # jal ra, mse

    addi s4, s4, -1
    j train_loop

train_end:

exit:
    li a0, 0
    li a7, 93
    ecall
