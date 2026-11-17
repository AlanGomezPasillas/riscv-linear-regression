# RISC-V Gradient Descent Linear Regression
# Copyright (C) 2026  Alan Gomez Pasillas
# SPDX-License-Identifier: GPL-2.0

.extern predict

.equ N_FEATURES, 3
.equ N_SAMPLES, 4
.equ N_PARAMS, 4

# RODATA
.section .rodata
.balign 8

pass: .ascii "PASS\n"
no: .ascii "NO\n"
pred_msg: .ascii "Testing Predict:\n"
done_msg: .ascii "Done...\n"

x0_data: .double 1, 2, 3, 4
x1_data: .double 2, 1, 3, 2
x2_data: .double 3, 4, 1, 2
y_data: .double 15, 13, 24, 22

test_theta: .double 10, 2, 3, -1

# TEXT
.section .text
.globl _start

_start:

test_predict:
    la s0, x0_data
    la s1, y_data
    li s2, N_FEATURES
    li s3, N_SAMPLES
    la s5, test_theta
    
    li a0, 1
    la a1, pred_msg
    li a2, 17
    li a7, 64
    ecall

    li s4, 0

test_predict_loop:
    li t0, N_SAMPLES
    bge s4, t0, test_predict_end
    
    mv a0, s4
    jal ra, predict

    slli t0, s4, 3
    add t0, t0, s1
    fld fa1, 0(t0)
    
    feq.d t0, fa0, fa1
    beqz t0, print_no
    
print_pass:
    li a0, 1
    la a1, pass
    li a2, 5
    li a7, 64
    ecall

    j test_predict_next

print_no:
    li a0, 1
    la a1, no
    li a2, 3
    li a7, 64
    ecall

test_predict_next:
    addi s4, s4, 1
    j test_predict_loop

test_predict_end:
    li a0, 1
    la a1, done_msg
    li a2, 8
    li a7, 64
    ecall

exit:
    li a0, 0
    li a7, 93
    ecall
