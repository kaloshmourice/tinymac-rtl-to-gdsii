# TinyMAC v1 vs v2 Comparison

## Overview

TinyMAC v1 and TinyMAC v2 implement the same 4-lane unsigned multiply-accumulate function:

`result = a0*b0 + a1*b1 + a2*b2 + a3*b3`

The main architectural difference is that TinyMAC v1 uses a single-cycle datapath, while TinyMAC v2 inserts product registers between the multiplier stage and the adder-tree stage.

TinyMAC v2 was developed to improve timing closure and enable a faster clock target, while preserving the same external top-level interface.

---

## Architecture Difference

### TinyMAC v1

TinyMAC v1 datapath:

inputs -> multipliers -> adder tree -> result register

TinyMAC v1 latency:

Cycle 0: start asserted
Cycle 1: result valid and done asserted

v1 has lower latency and lower area, but the full multiply-plus-add datapath sits in one timing path.

### TinyMAC v2

TinyMAC v2 datapath:

inputs -> multipliers -> product registers -> adder tree -> result register

TinyMAC v2 latency:

Cycle 0: start asserted
Cycle 1: multiplier products registered
Cycle 2: final result registered and done asserted

v2 adds product registers, which increases latency and area, but shortens the critical combinational path and improves timing closure.

---

## Synthesis Comparison

| Metric | TinyMAC v1 | TinyMAC v2 | Change |
|:---:|:---:|:---:|:---:|
| Total generic cells | 1721 | 1789 | +68 cells |
| Flip-flops | 33 | 98 | +65 FFs |
| Top-level cells | 38 | 102 | +64 cells |
| MAC unit instances | 4 | 4 | Same |
| Adder-tree instances | 1 | 1 | Same |
| Control FSM instances | 1 | 1 | Same |

### Synthesis Interpretation

The main synthesis increase in TinyMAC v2 comes from the added product pipeline registers.

TinyMAC v1 has 33 flip-flops, mainly from the 32-bit result register and the FSM state storage.

TinyMAC v2 has 98 flip-flops because it adds product registers between the multiplier stage and the adder-tree stage.

The implemented v2 register structure is:

- 64 product-register FFs
- 32 result-register FFs
- 2 FSM-state FFs

This is the measured register cost of pipelining.

---

## Physical Design Comparison

| Metric | TinyMAC v1 | TinyMAC v2 | Change |
|:---:|:---:|:---:|:---:|
| Target clock period | 25 ns | 10.5 ns | Faster |
| Approx. frequency | 40 MHz | 95.24 MHz | ~2.38x higher |
| Setup violation count | 0 | 0 | Clean |
| Hold violation count | 0 | 0 | Clean |
| Worst setup slack | +0.9228 ns | +0.195984 ns | Both positive |
| Worst hold slack | +0.2664 ns | +0.261731 ns | Similar |
| Standard-cell count | 2301 | 2607 | +306 cells |
| Standard-cell area | 12668.4 um^2 | 15826.4 um^2 | +3158.0 um^2 |
| Die area | 49024.7 um^2 | 55955.6 um^2 | +6930.9 um^2 |
| Core area | 41758.8 um^2 | 47845.9 um^2 | +6087.1 um^2 |
| Route DRC errors | 0 | 0 | Clean |
| Magic DRC errors | 0 | 0 | Clean |
| LVS errors | 0 | 0 | Clean |
| Antenna violating nets | 0 | 0 | Clean |
| Total power | 0.007909 W | 0.004670 W | ~40.95% lower total power in v2 |

---

## Timing Result

TinyMAC v1 closed timing at 25 ns, corresponding to approximately 40 MHz.

TinyMAC v2 closed timing at 10.5 ns, corresponding to approximately 95.24 MHz.

This means TinyMAC v2 achieved approximately 2.38x higher target clock frequency than TinyMAC v1.

The improvement comes from splitting the long combinational datapath into two shorter stages using product pipeline registers.

---

## Area and Register Tradeoff

TinyMAC v2 uses more area because it adds product pipeline registers and additional control logic.

The physical standard-cell count increased from 2301 to 2607 cells.

The standard-cell area increased from 12668.4 um^2 to 15826.4 um^2.

This is a normal ASIC design tradeoff: extra registers and area are used to shorten the critical path. This improves the achievable clock frequency.

---

## Physical Signoff Comparison

| Check | TinyMAC v1 | TinyMAC v2 | Result |
|:---:|:---:|:---:|:---:|
| Setup timing violations | 0 | 0 | Both clean |
| Hold timing violations | 0 | 0 | Both clean |
| Route DRC errors | 0 | 0 | Both clean |
| Magic DRC errors | 0 | 0 | Both clean |
| LVS errors | 0 | 0 | Both clean |
| Antenna violating nets | 0 | 0 | Both clean |

Both TinyMAC versions completed physical implementation with clean timing and clean physical verification results.

---

## Visual Outputs

### TinyMAC v1 Images

- RTL schematic: images/tinymac_top_rtl.svg
- Gate-level schematic: images/tinymac_top_gate.svg
- Whole-chip layout: images/tinymac_whole_chip_layout.png

### TinyMAC v2 Images

- RTL schematic: images/tinymac_top_v2_rtl.svg
- Gate-level schematic: images/tinymac_top_v2_gate.svg
- Whole-chip layout: images/tinymac_v2_whole_chip_layout.png

These images were generated from the actual project outputs using Yosys, Graphviz, and KLayout screenshots.

---

## Final Conclusion

TinyMAC v1 is the simpler implementation.

It has lower latency, fewer flip-flops, fewer cells, and smaller physical area.

TinyMAC v2 is the higher-performance implementation.

The added product pipeline registers increase latency and area, but they also support a much faster clock target.

For compact and simple use cases, TinyMAC v1 is preferred.

For higher-frequency ASIC use cases, TinyMAC v2 is preferred.

The final result shows a clear ASIC design tradeoff between area, latency, and clock frequency.
