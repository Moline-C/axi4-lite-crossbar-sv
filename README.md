# axi4-lite-crossbar-sv

> **Status: In Progress** — actively being developed

A parameterizable, multi-initiator multi-target AXI4-Lite bus fabric implemented in SystemVerilog with formal property verification and a UVM testbench.

---

## Project Overview

AXI4-Lite is the ARM-standard protocol used to connect IP blocks inside modern SoCs — CPUs, GPUs, DMA engines, and peripherals all communicate through an interconnect fabric like this one. This project implements that fabric from scratch, verifies it formally, and validates it with a coverage-driven UVM testbench.

## Features

- Parameterizable N-initiator M-target crossbar topology
- Configurable 32/64-bit data width and address map
- Round-robin arbitration with zero-deadlock guarantee
- Full AXI4-Lite 5-channel handshake compliance (AW, W, B, AR, R)
- SystemVerilog Assertions (SVA) for formal property verification
- UVM testbench with driver, monitor, scoreboard, and coverage collector

## Project Phases

- [x] Environment setup and toolchain configuration
- [x] Phase 1 — AXI4-Lite target interface with handshaking
- [x] Phase 2 — Round-robin arbitration logic
- [x] Phase 3 — Full crossbar fabric integration and routing
- [ ] Phase 4 — Formal verification with SVA properties
- [ ] Phase 5 — UVM testbench and functional coverage

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
