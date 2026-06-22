# TinyMAC Reports

This directory contains selected reports and generated outputs from the TinyMAC RTL-to-GDSII project.

The goal is to keep the repository useful and readable for review, without committing full raw tool-run directories that can be large and difficult to navigate.

## Report Organization

### `synthesis/`

Contains TinyMAC v1 synthesis outputs generated with Yosys.

Tracked files:

* `tinymac_stat.rpt` - TinyMAC v1 synthesis statistics report
* `tinymac_synth.v` - TinyMAC v1 synthesized gate-level netlist

### `synthesis_v2/`

Contains TinyMAC v2 synthesis outputs generated with Yosys.

Tracked files:

* `tinymac_v2_stat.rpt` - TinyMAC v2 synthesis statistics report
* `tinymac_v2_synth.v` - TinyMAC v2 synthesized gate-level netlist
* `tinymac_v2_synthesis_summary.md` - summary of TinyMAC v2 synthesis results

### `physical/`

Contains the selected TinyMAC v1 physical-design summary from the OpenLane/OpenROAD flow.

Tracked files:

* `tinymac_openlane_summary.md` - TinyMAC v1 physical-design summary, including timing, area, DRC, LVS, antenna, and final layout result

### `physical_v2/`

Contains selected TinyMAC v2 physical-design outputs from the OpenLane/OpenROAD flow.

Tracked files:

* `tinymac_v2_physical_summary.md` - TinyMAC v2 physical-design summary
* `metrics.csv` - TinyMAC v2 OpenLane metrics table
* `metrics.json` - TinyMAC v2 OpenLane metrics data

### Timing, Area, and Power Summaries

The most important timing, area, and power numbers are documented in:

* `reports/physical/tinymac_openlane_summary.md`
* `reports/physical_v2/tinymac_v2_physical_summary.md`
* `docs/tinymac_v1_vs_v2_comparison.md`

## Why Full Raw Tool Runs Are Not Committed

OpenLane and OpenROAD generate many intermediate files during floorplanning, placement, clock tree synthesis, routing, extraction, and signoff.

The full raw run directories are intentionally ignored by Git because they can be large and noisy.

Instead, this repository tracks:

* Source RTL
* Testbenches
* Synthesis scripts
* OpenLane configuration files
* Selected synthesis reports
* Selected physical-design summaries
* Key metrics
* Final layout images
* v1 vs v2 comparison documentation

This keeps the repository clean while still showing the complete ASIC design flow and final results.
