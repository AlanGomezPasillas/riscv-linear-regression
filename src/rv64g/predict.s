# RISC-V Gradient Descent Linear Regression
# Copyright (C) 2026  Alan Gomez Pasillas
# SPDX-License-Identifier: GPL-2.0

.section .text
.globl predict

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
