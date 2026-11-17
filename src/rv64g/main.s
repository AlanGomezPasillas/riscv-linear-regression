# RISC-V Gradient Descent Linear Regression
# Copyright (C) 2026  Alan Gomez Pasillas
# SPDX-License-Identifier: GPL-2.0

# CONSTANTS
.equ BIAS, 0.0
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

theta: .double BIAS .zero N_FEATURES * 8
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

predict:
    fld ft0, 0(s5)
    slli t0, s3, 3
    slli t1, a0, 3
    li t2, 0

predict_loop:
    bge t2, s2, predict_end

    mul t3, t2, t0
    add t3, t3, s0
    add t3, t3, t1
    fld ft1, 0(t3)

    slli t4, t2, 3
    addi t4, t4, 8
    add t4, t4, s5
    fld ft2, 0(t4)

    fmul.d ft1, ft1, ft2
    fadd.d ft0, ft0, ft1

    addi t2, t2, 1
    j predict_loop

predict_end:
    fmv.d fa0, ft0
    ret
