# 🧠 Computer Systems Architecture (ASC) – Storage Management Simulator

## 📘 Overview

This project was developed as part of the **Computer Systems Architecture Laboratory (ASC)** at the **University of Bucharest, Faculty of Mathematics and Computer Science**.  
It explores **low-level system design** by simulating a minimal **Operating System Storage Manager** written entirely in **x86 Assembly**.

The objective is to build a module that manages the allocation, retrieval, deletion, and defragmentation of files within a simulated storage device — both in **one-dimensional** and **two-dimensional** memory spaces.

This work reflects the core principles of **operating systems**, **memory organization**, and **resource management** at the hardware abstraction layer.

---

## 🧩 Project Structure

├── 0x00_unidimensional/
│ ├── task0.s # One-dimensional memory implementation
│ ├── input.txt # Example test inputs
│ └── output.txt # Example expected outputs
│
├── 0x01_bidimensional/
│ ├── task1.s # Two-dimensional memory implementation
│ ├── input.txt
│ └── output.txt
│
├── README.md # Project documentation
└── Makefile # Optional build automation


---

## ⚙️ Technical Description

### 🧮 Requirement 0x00 — One-Dimensional Storage (50 points)

Implements a linear storage device of **8 MB**, divided into **8 kB blocks**.  
Each block can store data from exactly one file.  
Files must occupy **contiguous blocks**; non-contiguous allocation is invalid.

Supported operations:
- **ADD** – Add files to memory  
- **GET** – Retrieve the block interval of a file  
- **DELETE** – Remove a file from memory  
- **DEFRAGMENTATION** – Compact the memory by moving files toward lower addresses

#### Input Format

O ; number of operations
operation_code ; 1=ADD, 2=GET, 3=DELETE, 4=DEFRAGMENTATION


#### Output Format

descriptor: (start, end)


---

### 🧭 Requirement 0x01 — Two-Dimensional Storage (50 points)

Implements a **bidimensional memory space** (8 MB × 8 MB) modeled as a block matrix.  
Each file occupies a contiguous horizontal region of blocks (by rows).

Supported operations:
- **ADD**
- **GET**
- **DELETE**
- **DEFRAGMENTATION**

#### Output Format

descriptor: ((x_start, y_start), (x_end, y_end))


---

## 🧠 Example Execution

### One-Dimensional Case
```bash
nasm -f elf32 task0.s -o task0.o
ld -m elf_i386 task0.o -o task00
./task00 < input.txt

Two-Dimensional Case

nasm -f elf32 task1.s -o task1.o
ld -m elf_i386 task1.o -o task01
./task01 < input.txt
```

🔬 Implementation Insights

    The storage manager is self-contained: no high-level language or standard library calls are used.

    System calls are handled directly through interrupts and registers.

    The project enforces strict contiguity constraints — a realistic limitation inspired by early OS file systems.

    The defragmentation algorithm was designed to preserve file order while minimizing fragmentation, simulating a simplified version of disk optimization routines.

    All string data in the .data section end with a newline (\n) for consistent I/O behavior.

🏁 Educational Purpose

This project demonstrates:

Mastery of low-level memory control

Practical understanding of file system allocation strategies

Direct interaction with x86 system calls

The bridge between hardware structure and software architecture

It serves as a foundational step toward mastering operating system design and computer architecture — the true core of computer science.
