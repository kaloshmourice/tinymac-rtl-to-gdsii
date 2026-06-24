# TinyMAC OpenLane Physical Design Summary

## Flow Result

TinyMAC completed a full OpenLane RTL-to-GDSII flow successfully using the SKY130 open-source PDK flow through Dockerized OpenLane/OpenROAD.

## Design

- Top module: `tinymac_top`
- Function: 4-lane unsigned 8-bit multiply-accumulate
- Equation: `result = a0*b0 + a1*b1 + a2*b2 + a3*b3`
- Registered output: `result[31:0]`
- Control: `start` / `done`
- Clock: `clk`
- Reset: active-low `rst_n`

## OpenLane Configuration

- Config file: `openlane/tinymac/config.yaml`
- Clock period: 25 ns
- Approximate target frequency: 40 MHz
- PDK family: SKY130
- Top-level OpenLane design name: `tinymac_top`

## Final Metrics

| Metric | Value |
|:---:|:---:|
| Standard-cell count | 2301 |
| Standard-cell area | 12668.4 µm² |
| Die area | 49024.7 µm² |
| Core area | 41758.8 µm² |
| Setup worst slack | +0.9228 ns |
| Setup TNS | 0 |
| Hold worst slack | +0.2664 ns |
| Hold TNS | 0 |
| Route DRC errors | 0 |
| Magic DRC errors | 0 |
| Antenna violating nets | 0 |

## Generated Final Views

The successful OpenLane run generated the following final physical-design views:

- GDS: `tinymac_top.gds`
- DEF: `tinymac_top.def`
- LEF: `tinymac_top.lef`
- ODB: `tinymac_top.odb`
- Gate-level netlist: `tinymac_top.nl.v`
- Powered netlist: `tinymac_top.pnl.v`
- SDC: `tinymac_top.sdc`
- SDF timing files
- SPEF parasitic files
- Liberty timing models
- SPICE netlist
- Metrics JSON/CSV

## Signoff Status

- DRC: Passed
- LVS: Passed
- Antenna: Passed
- Setup timing: Passed at 25 ns
- Hold timing: Passed at 25 ns

## Notes

An earlier 10 ns OpenLane run completed routing and passed DRC/LVS/Antenna, but failed setup timing in slow corners. The initial clean physical-design milestone therefore used a relaxed 25 ns clock period. This timing limitation motivated TinyMAC v2, which added pipeline registers and closed timing at 10.5 ns.


## Power Summary

| Metric | Value |
|---|---:|
| Total power | 0.007909 W |
| Internal power | 0.003602 W |
| Switching power | 0.004307 W |
| Leakage power | 0.000000014568 W |

Power was extracted from a clean v1 OpenLane rerun using the same v1 configuration.
