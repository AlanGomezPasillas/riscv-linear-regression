# RISC-V Gradient Descent Linear Regression
# Copyright (C) 2026  Alan Gomez Pasillas
# SPDX-License-Identifier: GPL-2.0

.section .rodata
.align 3

.include "dataset.s"

delta: .double 0.00001
alpha: .double 0.01
zerof: .double 0.0

.section .text
.globl _start

_start:
    li a0, 0
    li a7, 93
    ecall
