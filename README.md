# RISC-V Assembly Linear Regression

Implementation of **Multiple Linear Regression** trained with
**Finite Difference Gradient Descent** written in pure
standard **RISC-V 64-bit Assembly** adapted for Linux.

## Features ##
- Linear Regression Implementation with GNU pipeline (no gcc)
- RISCVG version (More versions coming soon)
- Forward Finite Difference Technique
- Gradient Descent Optimizer
- CSV to RISC-V SRC converter Bash Script
- Makefile for pipeline automation
- Debug pipeline with gdb-multiarch and QEMU

## Directory Structure ##
```
riscv-linear-regression/
├── data/
│   ├── csv-to-riscv-src.sh
│   ├── dataset.s # dynamically generated from CSV
│   └── example-simple-regression.csv
├── LICENSE # GPLv2.0
├── linear_regression # Target Executable
├── Makefile
├── README.md
└── src/
    └── rv64g/
        ├── main.o
        └── main.s
```

## Dataset Format ##
Your input CSV dataset contains numerical feature values and target labels.
The conversion script transforms them into RISC-V memory directives
(`.quad` and `.double`).

Example (`example-simple-regression.csv`):

| $x$ (Feature0) | $y$ (Target) |
| :---: | :---: |
| 1.0 | 2.0 |
| ... | ... |
| 3.0 | 5.0 |

Your dataset may have multiple features.

## How to use ##
This project has Linux as its main target but it can be adapted to any
project and embedded system using RISCVG within it.

### Install Dependencies ###
For - Debian, Ubuntu, Mint, etc.:
```
sudo apt install git make binutils-riscv64-linux-gnu qemu-user gdb-multiarch
```

### Clone this Repository ###
You have to navigate to your desired directory, then:
```
git clone https://github.com/AlanGomezPasillas/riscv-linear-regression.git
```

### Setup ###

Enter to the project directory:
```
cd riscv-linear-regression
```

Place your dataset in `.csv` format inside `data/` directory.

Then execute from the root directory of this project:
```
make all
```

This will automatically convert your CSV into an
assembly source file inside `src/rv64g/`, assemble the code,
link the object file, and generate your RISC-V executable.

You can run it natively in a RISC-V CPU with:
```
./linear_regression
```

or via the QEMU user-mode emulator:
```
./qemu-riscv64 linear_regression
```

You can disassemble the code with:
```
make disasm
```

and debug interactively with:
```
make debug
```

Finally, you can clean build artifacts using:
```
make clean
```

## More Information ##

This project starts using **RISCVG** which includes floating point and
double precision units as well as multiplication and division. In the
future I plan to add support for fixed precision Q16 and later use RVV
module for vectors and maybe some compatibility with RISCVI.

I'm using a public domain example dataset and wrote a bash script to
convert it from CSV into RISC-V code for dynamic datasets.

This is an open-source project under license GPLv2.0 created for
schoolwork and for anyone who wants to use linear regression
on RISC-V processors and learn.

Feel free to contribute and open pull requests. If you need to
contact me my email is: **alangomezpasillas@gmail.com**.
I hope you find this project interesting, I made it with Love.
