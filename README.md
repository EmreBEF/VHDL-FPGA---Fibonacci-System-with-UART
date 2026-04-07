# VHDL FPGA – Fibonacci System with UART

## Overview
This project implements a complete digital system on FPGA using VHDL (Intel Quartus).

The system generates a 16-bit Fibonacci sequence, displays values on 7-segment displays, and communicates status through a UART interface.

## Features
- 16-bit Fibonacci sequence generator
- 4-digit 7-segment display output
- UART transmission (9600 or 19200 baud selectable)
- Overflow detection with status reporting
- Modular design (Fibonacci, display, UART, control)

## System Behavior

At each clock enable (≈1 Hz), a new Fibonacci term is generated and displayed.

- If no overflow occurs → UART sends: `'B'` (valid value)
- If overflow occurs → UART sends: `'E'` (error)

## Inputs / Outputs Mapping

### Inputs
- `CLK` → 50 MHz system clock (FPGA)
- `RAZ` → Reset (push button)
- `EN` → Enable signal (switch)
- `N[7:0]` → Number of Fibonacci terms (switches)
- `Speed` → UART baud rate selection:
  - `0` → 9600 baud
  - `1` → 19200 baud
- `StartTr` → Start transmission (push button)

### Outputs
- 7-segment displays → Current Fibonacci value (4 digits, hexadecimal)
- `Carry` → LED indicator for overflow
- `TxD` → UART transmission line

## Architecture

The system is composed of the following blocks:
- Fibonacci generator (with overflow detection)
- 7-segment decoder
- Baud rate generator (BaudGen)
- UART transmitter
- Control/assembly logic

## Project Versions

- **V1**: Functional system without clock division  
- **V2**: Integration of clock divider (≈1 Hz enable signal)  
- **V3**: Full system with UART + display + control logic  

## Tools
- VHDL
- Intel Quartus
- ModelSim
- FPGA (Cyclone V / DE2 board)

## Validation
- Functional simulation (ModelSim)
- Hardware testing on FPGA board
- UART monitoring via serial terminal

## Notes
This project focuses on synchronous digital design, modular architecture, and hardware/software interaction through serial communication.
