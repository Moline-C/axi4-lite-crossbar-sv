# axi4-lite-crossbar-sv

> **Status: In Progress** - actively being developed

A parameterizable, multi-initiator multi-target AXI4-Lite bus fabric implemented in SystemVerilog with formal property verification and a UVM testbench. 

---

## Project Overview

AXI4-Lite is the ARM-standard protocol used to connect IP blocks inside modern SoCs - CPUs, GPUs, DMA engines, and peripherals all comunicate through an interconnect fabric like this one. This project implements that fabric from scratch, verifies it formally, and validates it with coverage-drive UVM testbench.

## Features

- Parameterizable N-initiator M-target crossbar topology
- Configurable 32/64-bit data width and address map
- Round-robin arbitration with zero-deadlock guarentee
- Full AXI4-Lite 5-channel handhsake compliance (AW, W, B, AR, R)
- 40+ SystemVerilog Assertions (SVA) for formal property verification
- UVM testbench with driver, monitor, scoreboard, and coverage collector
- 95%+ functional coverage target across concurrent access scenarios

## Project Phases

- [x] Environment setup and toolchain configuration
- [ ] Phase 1 - AXI4-Lite slave interface with handshaking
- [ ] Phase 2 - Parameterizable crossbar arbitration logic
- [ ] Phase 3 - Formal verification with SVA properties
- [ ] Phase 4 - UVM testbench and functional coverage

## Tools & Technologies

| Tool | Purpose |
|------|---------|
| SystemVerilog (IEEE 1800-2017) | RTL design and verification language |
| ModelSim Intel Starter Edition | Simulation and waveform analysis |
| VS Code | Development environment |
| Git / GitHub | Version control |

## Repository Structure

axi4-lite-crossbar-sv/
├── rtl/               # synthesizable design files
├── tb/                # testbench files
├── sim/               # simulation scripts and waveform outputs
└── docs/              # diagrams and documentation

## About 

Moline Charles - University of Florida, Computer Engineering
Freshman year independent project.

---
