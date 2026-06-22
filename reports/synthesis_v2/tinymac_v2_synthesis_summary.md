# TinyMAC v2 Yosys Synthesis Summary

## Purpose

This report summarizes the generic Yosys synthesis results for TinyMAC v2 and compares them with the TinyMAC v1 synthesis baseline.

TinyMAC v1 is the completed single-cycle baseline. TinyMAC v2 is the pipelined version developed separately to reduce the long v1 timing path.

## Architecture Comparison

TinyMAC v1 datapath:

    inputs -> multipliers -> adder_tree -> result register

TinyMAC v2 datapath:

    inputs -> multipliers -> product registers -> adder_tree -> result register

The main v2 change is the addition of product pipeline registers between the multiplier stage and the adder-tree stage.

## Yosys Synthesis Flow

TinyMAC v2 synthesis uses:

    scripts/synth_v2.ys

The v2 RTL files are read from:

    rtl_v2/

The generated v2 synthesis outputs are:

    reports/synthesis_v2/tinymac_v2_stat.rpt
    reports/synthesis_v2/tinymac_v2_synth.v

Yosys completed successfully and reported 0 problems.

## v1 vs v2 Generic Synthesis Comparison

| Metric | TinyMAC v1 | TinyMAC v2 | Change |
|:---:|:---:|:---:|:---:|
| Top module | tinymac_top | tinymac_top_v2 | separate v2 top |
| Total generic cells | 1721 | 1789 | +68 |
| Flip-flops | 33 | 98 | +65 |
| Wires | 1647 | 1654 | +7 |
| Wire bits | 2034 | 2101 | +67 |
| Public wires | 43 | 49 | +6 |
| Public wire bits | 430 | 496 | +66 |
| Ports | 35 | 36 | +1 |
| Port bits | 329 | 330 | +1 |

## Flip-Flop Count Explanation

TinyMAC v1 uses 33 flip-flops:

    32 flip-flops = result register
     1 flip-flop  = v1 FSM state

TinyMAC v2 uses 98 flip-flops:

    64 flip-flops = four 16-bit product pipeline registers
    32 flip-flops = result register
     2 flip-flops = v2 FSM state

The increase in flip-flop count is the measured register cost of adding the TinyMAC v2 pipeline stage.

## Interpretation

The arithmetic behavior is unchanged:

    result = a0*b0 + a1*b1 + a2*b2 + a3*b3

The structural difference is that TinyMAC v2 stores the multiplier outputs before sending them into the adder tree.

This splits the long v1 path:

    v1 path:
    inputs -> multipliers -> adder_tree -> result register

into two shorter v2 paths:

    v2 path 1:
    inputs -> multipliers -> product registers

    v2 path 2:
    product registers -> adder_tree -> result register

## Important Note

These are generic Yosys synthesis results, not final physical implementation results.

The physical implementation results are documented separately in:

    reports/physical_v2/tinymac_v2_physical_summary.md
    docs/tinymac_v1_vs_v2_comparison.md

The synthesis result confirms that TinyMAC v2 is synthesizable, adds the intended pipeline registers, has slightly more generic cells than v1, and structurally splits the v1 critical path.
