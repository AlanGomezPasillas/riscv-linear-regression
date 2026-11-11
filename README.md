# RISC-V Assembly Linear Regression

Implementation of **Simple Linear Regresion** trained with
**Finite Difference Gradient Descent** written in pure
standard **RISC-V 64-bit Assembly** adapted for Linux.

This project starts using **RISCVG** which includes floating point and
double precision units as well as multiplication and division, maybe
in some future I would be adding support for fixed precision Q16
among RISCVI and later use RVV module for vectors, I'm also
planning to implement **Multiple Linear Regression** and more.

I'm using a public domain example dataset and I made a bash script to
convert it from CSV into RISC-V code, so later I can make it
automatic for dynamic sizes.

This is an open-source project under license GPLv2.0 and I made it for
a school homework and for everyone that wants to use linear regression
with RISC-V processors and learning.
