# RISC-V Gradient Descent Linear Regression
# Copyright (C) 2026  Alan Gomez Pasillas
# SPDX-License-Identifier: GPL-2.0

.section .rodata
.align 3

epochs: .quad 0

.include "data/dataset.s"
# variables .quad
# n_samples .quad
# x0_data   .double
# ... 
# xn_data
# y_data

delta: .double 0.00001
alpha: .double 0.01


.section .text
.globl _start

_start:
    la s0, x0_data
    la s1, y_data

    la t0, variables
    ld s2, 0(t0)
    la t0, n_samples
    ld s3, 0(t0)
    la t0, epochs
    ld s4, 0(t0)
    
    la t0, alpha
    fld fs0, 0(t0)
    la t0, delta
    fld fs1, 0(t0)

    fmv.d.x fa0, x0 # m
    fmv.d.x fa1, x0 # b

train_loop:
    beqz s4, train_end

    addi s4, s4, -1
    j train_loop

train_end:
    
exit:
    li a0, 0
    li a7, 93
    ecall
