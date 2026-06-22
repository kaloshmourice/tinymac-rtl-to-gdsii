# TinyMAC Architecture Specification

## 1. Project Overview

TinyMAC is a small multiply-accumulate accelerator designed as a personal RTL-to-GDSII physical design project.

The accelerator computes a 4-element dot product:

```text
result = a0*b0 + a1*b1 + a2*b2 + a3*b3
```

This type of operation is common in digital signal processing, filtering, image processing, and neural network workloads.

The goal of TinyMAC is not only to implement the arithmetic operation, but to take the design through a complete ASIC-style flow:

```text
RTL → Simulation → Synthesis → Floorplan → Placement → CTS → Routing → Timing Analysis → GDSII
```

## 2. TinyMAC v1 Functional Goal

TinyMAC v1 receives four pairs of unsigned 8-bit input values.

Each pair is multiplied, and the four products are added together to produce one 32-bit result.

Input pairs:

```text
a0, b0
a1, b1
a2, b2
a3, b3
```

Computation:

```text
p0 = a0 * b0
p1 = a1 * b1
p2 = a2 * b2
p3 = a3 * b3

result = p0 + p1 + p2 + p3
```
## 3. Bit Widths

### Inputs

Each input operand is 8 bits wide:

```text
a0, a1, a2, a3: 8-bit unsigned
b0, b1, b2, b3: 8-bit unsigned
```

### Products

Each multiplication produces a 16-bit product:

```text
8-bit × 8-bit = 16-bit product
```

### Output

The final result is stored in a 32-bit output register.

Although the maximum mathematical result needs fewer than 32 bits, using 32 bits keeps the design simple, safe, and expandable for future versions.

Maximum value analysis:

```text
Maximum 8-bit unsigned value = 255

Maximum product:
255 × 255 = 65025

Maximum sum of four products:
4 × 65025 = 260100
```

260100 requires 18 bits, but TinyMAC v1 uses a 32-bit result for clarity and future expansion.
## 4. Interface Signals

TinyMAC v1 uses a simple start/done interface.

This interface is intentionally simple for the first version of the project. It allows us to focus on RTL structure, simulation, synthesis, and physical implementation before adding more complex bus protocols.

### Clock and Reset

```text
clk     : system clock
rst_n   : active-low reset
```

### Control Signals

```text
start   : input signal that starts one TinyMAC operation
done    : output signal that indicates the result is valid
```

### Data Inputs

```text
a0, a1, a2, a3 : 8-bit unsigned inputs
b0, b1, b2, b3 : 8-bit unsigned inputs
```

### Data Output

```text
result : 32-bit unsigned output
```

### Interface Summary

| Signal | Direction | Width | Description                    |
| ------ | --------: | ----: | ------------------------------ |
| clk    |     input |     1 | System clock                   |
| rst_n  |     input |     1 | Active-low reset               |
| start  |     input |     1 | Starts one TinyMAC operation   |
| done   |    output |     1 | Indicates that result is valid |
| a0     |     input |     8 | First A operand                |
| a1     |     input |     8 | Second A operand               |
| a2     |     input |     8 | Third A operand                |
| a3     |     input |     8 | Fourth A operand               |
| b0     |     input |     8 | First B operand                |
| b1     |     input |     8 | Second B operand               |
| b2     |     input |     8 | Third B operand                |
| b3     |     input |     8 | Fourth B operand               |
| result |    output |    32 | Final MAC result               |

## 5. High-Level Block Diagram

The TinyMAC v1 architecture contains a simple control path and a simple datapath.

The control path receives the `start` signal and generates the `done` signal.

The datapath performs the arithmetic operation using four multipliers, one adder tree, and one result register.

```text
           +------------------+
 start --->|   Control FSM    |----> done
           +------------------+
                    |
                    v
+------------------------------------------------+
|                  TinyMAC Core                  |
|                                                |
|  a0,b0 --> [Multiplier 0] --> p0               |
|  a1,b1 --> [Multiplier 1] --> p1               |
|  a2,b2 --> [Multiplier 2] --> p2               |
|  a3,b3 --> [Multiplier 3] --> p3               |
|                                                |
|      p0,p1,p2,p3 --> [Adder Tree]              |
|                         |                      |
|                         v                      |
|                  [Result Register]             |
+------------------------------------------------+
                         |
                         v
                      result
```

TinyMAC v1 uses a direct combinational multiplier and adder structure followed by a registered output.

## 6. Internal RTL Blocks

TinyMAC v1 is divided into small RTL modules. This makes the design easier to understand, verify, debug, and later modify.

### 6.1 Top Module

File:

```text
rtl/tinymac_top.sv
```

Responsibilities:

* Define the external TinyMAC interface.
* Connect all internal submodules.
* Register the final output.
* Connect the control logic to the datapath.

### 6.2 Multiplier Unit

File:

```text
rtl/mac_unit.sv
```

Responsibilities:

* Receive two 8-bit unsigned operands.
* Multiply them.
* Produce one 16-bit product.

### 6.3 Adder Tree

File:

```text
rtl/adder_tree.sv
```

Responsibilities:

* Receive four 16-bit products.
* Add the products together.
* Produce a 32-bit sum.

### 6.4 Control FSM

File:

```text
rtl/control_fsm.sv
```

Responsibilities:

* Wait for the `start` signal.
* Control when the result is registered.
* Generate the `done` signal when the result is valid.

## 7. Timing and Latency

TinyMAC v1 uses a simple registered-output architecture.

TinyMAC v1 latency:

```text
1 clock cycle after start
```

Basic operation:

```text
Cycle 0: start is asserted
Cycle 1: result is registered and done is asserted
```

This first version is intentionally simple. The multiplication and addition logic is combinational, and the final result is stored in a register.

Timing analysis showed that the multiplier-to-adder path was too long for a 10 ns clock target, so TinyMAC v2 was created as an improved pipelined version.

TinyMAC v2 pipelined version:

```text
Cycle 0: start
Cycle 1: products registered
Cycle 2: final sum registered and done asserted
```

This allows us to study a real physical design tradeoff:

```text
More pipeline registers → better timing
More pipeline registers → more area and latency
```

## 8. Design Philosophy

TinyMAC v1 is intentionally simple.

The goal is not to build the most complex accelerator at the beginning. The goal is to create a clean baseline design that can successfully pass through RTL simulation, synthesis, and physical implementation.

The project focuses on:

* Clean RTL structure
* Clear module separation
* Functional correctness
* Easy simulation and debugging
* Synthesis readiness
* Physical design readiness
* Timing, area, and power analysis
* Documentation of engineering tradeoffs

This baseline version allows comparison with improvements such as:

* Different clock targets
* Different utilization values
* Pipelined vs non-pipelined implementation
* Timing closure improvements
* Area and power impact

## 9. Phase 1 Deliverables

Phase 1 produced:

* `docs/architecture.md`
* A clear TinyMAC functional definition
* Defined input and output widths
* Defined control signals
* High-level block diagram
* Internal RTL module breakdown
* Initial timing and latency definition

After this document was reviewed and committed, the project moved through RTL implementation, simulation, synthesis, and physical design for both TinyMAC v1 and TinyMAC v2.

## 10. TinyMAC v2 Implemented Architecture — Pipelined Datapath

TinyMAC v2 extends the completed TinyMAC v1 baseline by adding pipeline registers into the datapath.

The main goal of TinyMAC v2 is to reduce the critical path delay and close timing at a faster clock target than TinyMAC v1.

### 10.1 Motivation

TinyMAC v1 uses a single-cycle datapath:

    inputs -> multipliers -> adder_tree -> result register

This means the multiplier logic and adder-tree logic must both complete within one clock period.

During physical implementation, TinyMAC v1 failed setup timing at a 10 ns clock period, but passed timing at 25 ns. This showed that the multiplier-to-adder datapath is the main timing limitation.

TinyMAC v2 addresses this by splitting the datapath across pipeline stages.

### 10.2 Implemented v2 Pipeline Structure

TinyMAC v2 implements the same mathematical operation as v1:

    result = a0*b0 + a1*b1 + a2*b2 + a3*b3

The difference is that the operation is split across pipeline stages.

Implemented pipeline:

    Stage 1:
    inputs -> four multipliers -> product registers

    Stage 2:
    product registers -> adder_tree -> result register

    Stage 3:
    done asserted when result is valid

High-level v2 datapath:

    a0,b0 -> multiplier -> p0_reg
    a1,b1 -> multiplier -> p1_reg
    a2,b2 -> multiplier -> p2_reg
    a3,b3 -> multiplier -> p3_reg

    p0_reg, p1_reg, p2_reg, p3_reg -> adder_tree -> result register -> result

### 10.3 Implemented Latency

TinyMAC v1 latency:

    Cycle 0: start asserted
    Cycle 1: result valid and done asserted

TinyMAC v2 latency:

    Cycle 0: start asserted
    Cycle 1: multiplier products registered
    Cycle 2: final result registered and done asserted

TinyMAC v2 therefore increases latency by one cycle, but improves timing potential by shortening the critical path.

### 10.4 Measured Tradeoff

TinyMAC v2 is not automatically better in every metric. It improves timing by adding pipeline registers, which also increases area and register count.

Measured advantages:

* Faster clock target: 10.5 ns compared with 25 ns for TinyMAC v1
* Higher estimated frequency: approximately 95.24 MHz compared with approximately 40 MHz for TinyMAC v1
* Positive setup slack after physical design
* Positive hold slack after physical design
* Clean physical signoff: DRC, LVS, and antenna checks passed

Measured costs:

* More flip-flops
* Higher latency
* Higher standard-cell count
* Higher standard-cell area
* Slightly higher power

TinyMAC v2 is preferred when higher clock frequency or throughput is more important than minimum latency and minimum area.

### 10.5 Final v1 vs v2 Comparison

The final v1 vs v2 comparison is documented in:

    docs/tinymac_v1_vs_v2_comparison.md

The comparison covers:

* Architecture
* Clock period
* Frequency
* Setup slack
* Hold slack
* Standard-cell count
* Standard-cell area
* Latency
* DRC/LVS/antenna status

This comparison explains why pipelining improves timing and what tradeoffs it introduces.
