# TinyMAC Project Log

This document is a chronological engineering log. Earlier "Next Step" sections describe the next action at that stage of the project, not the current final project status.

## Phase 0 — Foundation Setup

**Status:** Completed  

### Objective

Prepare a professional Linux-based ASIC project environment for the TinyMAC RTL-to-GDSII physical design project.

### Completed Work

- Installed and configured WSL2 on Windows.
- Installed Ubuntu under WSL2.
- Created Linux user: `mourice`.
- Updated Ubuntu packages using `sudo apt update` and `sudo apt upgrade -y`.
- Installed basic development tools:
  - Git
  - GCC
  - Make
  - Python 3
  - pip
  - tree
  - curl / wget / unzip
- Configured Git identity using a GitHub private noreply email.
- Cleaned the GitHub profile:
  - Enabled private email protection.
  - Enabled blocking command-line pushes that expose private email.
  - Deleted an old unrelated repository.
  - Updated the GitHub profile README.
- Created the private GitHub repository:
  - `tinymac-rtl-to-gdsii`
- Created the local project structure:
  - `rtl/`
  - `tb/`
  - `sim/`
  - `openlane/`
  - `reports/`
  - `scripts/`
  - `images/`
  - `docs/`
- Added `.gitkeep` files to preserve empty directories in Git.
- Created the first `README.md`.
- Created `.gitignore`.
- Connected the local repository to GitHub.
- Pushed the first commits to GitHub.
- Verified VS Code is connected to WSL Ubuntu.
- Verified local Git status is clean and synchronized with GitHub.

### Verification

The final checks were:

```bash
pwd
# <project-root>

whoami
# <linux-user>

git status
# On branch main
# Your branch is up to date with 'origin/main'.
# nothing to commit, working tree clean
```

### Result

Phase 0 is complete. The TinyMAC project now has a clean, private, professional GitHub foundation and a working WSL/Ubuntu development environment.

### Next Phase

Phase 1 — Architecture Definition

In the next phase, we will define the TinyMAC accelerator concept, inputs, outputs, bit widths, control signals, latency, block diagram, and first architecture document.

## Phase 1 — Architecture Definition

**Status:** Completed  

### Completed Work

- Created `docs/architecture.md`.
- Defined TinyMAC v1 as a 4-element unsigned multiply-accumulate accelerator.
- Defined the main computation:

```text
result = a0*b0 + a1*b1 + a2*b2 + a3*b3
```

- Selected 8-bit unsigned input operands.
- Selected 16-bit internal product width.
- Selected 32-bit output result width.
- Defined the simple `start` / `done` control interface.
- Defined clock and reset signals:
  - `clk`
  - `rst_n`
- Created the high-level block diagram.
- Defined planned RTL modules:
  - `tinymac_top.sv`
  - `mac_unit.sv`
  - `adder_tree.sv`
  - `control_fsm.sv`
- Defined initial planned latency:
  - 1 clock cycle after `start`
- Documented pipelining as the next timing-improvement direction.
- Committed and pushed the architecture specification to GitHub.

### Current Result

The TinyMAC v1 architecture is now clearly defined and documented. The project is ready to move toward RTL module implementation.

### Next Step

Create the first RTL files under `rtl/` and begin implementing the TinyMAC datapath and control structure.

## Phase 2 — RTL Implementation

**Status:** Completed

### Completed Work

* Created the initial synthesizable SystemVerilog RTL implementation.
* Implemented `rtl/mac_unit.sv` as a combinational 8-bit by 8-bit unsigned multiplier.
* Implemented `rtl/adder_tree.sv` as a combinational adder tree for four 16-bit products.
* Implemented `rtl/control_fsm.sv` as a simple start/done controller.
* Implemented `rtl/tinymac_top.sv` as the top-level module connecting the datapath and control logic.
* Installed Verilator for RTL linting.
* Ran Verilator lint check on the full RTL design.
* Fixed end-of-file newline warnings.
* Verified that the full TinyMAC RTL passes Verilator lint with no warnings or syntax errors.
* Committed and pushed the initial TinyMAC RTL implementation to GitHub.
* Created `tb/tinymac_tb.sv` as a SystemVerilog simulation testbench.
* Added multiple directed test vectors.
* Verified the maximum-value case:

  * `255*255 + 255*255 + 255*255 + 255*255 = 260100`
* Built the simulation executable using Verilator.
* Ran the TinyMAC simulation successfully.
* Verified that all test cases passed.
* Updated `.gitignore` to ignore Verilator-generated `obj_dir/` build output.


### Current Result

The TinyMAC project now has a clean initial SystemVerilog RTL implementation and a passing simulation testbench. The design has been linted and functionally verified using directed test vectors.

### Next Step

Prepare reusable simulation commands, improve project documentation, and then move toward synthesis and ASIC physical design preparation.

## Phase 3 — Simulation Automation

**Status:** Completed

### Completed Work

* Created a project `Makefile`.
* Added reusable Make targets:

  * `make lint`
  * `make lint-tb`
  * `make sim`
  * `make clean`
* Verified that `make lint` runs RTL lint successfully.
* Verified that `make lint-tb` runs RTL + testbench lint successfully.
* Verified that `make sim` builds and runs the TinyMAC simulation successfully.
* Verified that all TinyMAC simulation tests pass through the Makefile flow.
* Verified that `make clean` removes Verilator-generated build output.
* Committed and pushed the Makefile to GitHub.

### Current Result

The TinyMAC project now has a reusable simulation workflow. Instead of typing long Verilator commands manually, the project can be linted, simulated, and cleaned using simple Make commands.

### Next Step

Improve the README documentation so that another engineer can quickly understand the project, run the simulation, and review the current RTL flow.

## Phase 4 — README Improvement

**Status:** Completed

### Completed Work

* Updated `README.md` to reflect the current project progress.
* Replaced the outdated Phase 0 status with the current completed RTL flow.
* Added a clear explanation of the TinyMAC project goal.
* Documented the main TinyMAC computation:

  * `result = a0*b0 + a1*b1 + a2*b2 + a3*b3`
* Added a high-level design overview.
* Documented the RTL modules:

  * `mac_unit.sv`
  * `adder_tree.sv`
  * `control_fsm.sv`
  * `tinymac_top.sv`
* Added the repository structure.
* Added instructions for running:

  * `make lint`
  * `make lint-tb`
  * `make sim`
  * `make clean`
* Added passing simulation results.
* Added the current RTL-to-simulation project flow.
* Added planned next steps toward ASIC synthesis and physical design.
* Committed and pushed the improved README to GitHub.

### Current Result

The GitHub repository now has a professional README that explains the TinyMAC design, current RTL implementation, simulation status, automation commands, and planned ASIC physical design flow.

### Next Step

Begin synthesis preparation by setting up the initial synthesis flow and making sure the RTL is ready for ASIC implementation.

## Phase 5 — Synthesis Preparation

**Status:** In Progress

### Completed Work

* Installed Yosys in the WSL Ubuntu environment.
* Created the initial Yosys synthesis script:

  * `scripts/synth.ys`
* Configured the synthesis script to:

  * Read the SystemVerilog RTL files.
  * Set `tinymac_top` as the top-level module.
  * Check the design hierarchy.
  * Run generic synthesis.
  * Generate a synthesis statistics report.
  * Write a synthesized Verilog netlist.
* Ran the first TinyMAC synthesis successfully.
* Verified that Yosys completed with no reported design problems.
* Generated the synthesis statistics report:

  * `reports/synthesis/tinymac_stat.rpt`
* Generated the synthesized generic Verilog netlist:

  * `reports/synthesis/tinymac_synth.v`
* Reviewed the synthesis report and confirmed the expected design hierarchy:

  * `tinymac_top`
  * `adder_tree`
  * `control_fsm`
  * `mac_unit`
* Confirmed that the synthesized design contains 33 flip-flops:

  * 32 flip-flops for the registered `result[31:0]`
  * 1 flip-flop for the FSM state
* Updated the `Makefile` with a reusable synthesis target:

  * `make synth`
* Tested `make synth` successfully.
* Committed and pushed the initial synthesis flow to GitHub.
* Installed Docker Desktop on Windows.
* Enabled Docker Desktop WSL integration for Ubuntu.
* Verified Docker availability inside the WSL Ubuntu terminal:

  * `docker --version`
* Fixed Docker socket permission access by adding the Ubuntu user to the `docker` group.
* Restarted WSL to reload the updated group permissions.
* Verified Docker functionality by running:

  * `docker run hello-world`
* Confirmed that Docker can pull and run containers successfully from WSL.
* Created a clean Python 3.12 virtual environment for OpenLane using `uv`:

  * `~/.venvs/openlane312`
* Installed OpenLane inside the Python 3.12 environment.
* Verified the OpenLane CLI:

  * `openlane --version`
* Fixed an OpenLane CLI dependency issue by pinning `click` to version `8.1.8`.
* Verified that OpenLane help output works correctly.
* Ran the Dockerized OpenLane smoke test:

  * `openlane --dockerized --smoke-test`
* Confirmed that the OpenLane Dockerized flow completed successfully.
* Confirmed that the smoke test passed DRC, LVS, antenna, setup timing, hold timing, max slew, and max capacitance checks.

### Current Result

TinyMAC now has an initial working synthesis flow and a verified physical-design tool environment. The RTL can be synthesized using Yosys, the project generates both a synthesis report and a synthesized Verilog netlist, Docker is working inside WSL, and OpenLane/OpenROAD has been verified through a successful Dockerized smoke test.


### Next Step

Continue Phase 5 by improving the synthesis flow, organizing synthesis outputs, and preparing the design for a technology-mapped ASIC flow using an open-source PDK.

## Phase 6 — TinyMAC OpenLane Physical Design Flow

**Status:** Completed  

### Completed Work

* Created the TinyMAC OpenLane design folder:

  * `openlane/tinymac/`
* Added the main OpenLane configuration file:

  * `openlane/tinymac/config.yaml`
* Added implementation timing constraints:

  * `openlane/tinymac/src/impl.sdc`
* Added signoff timing constraints:

  * `openlane/tinymac/src/signoff.sdc`
* Added a custom pin-order file:

  * `openlane/tinymac/pin_order.cfg`
* Fixed `.gitignore` so OpenLane generated run folders are ignored while source SDC files can be committed.
* Ran the first TinyMAC OpenLane flow at 10 ns.
* Confirmed that the 10 ns run reached routing and passed DRC/LVS/Antenna, but failed setup timing in slow corners.
* Relaxed the TinyMAC OpenLane clock period to 25 ns.
* Re-ran the full OpenLane RTL-to-GDSII flow successfully.
* Confirmed that the 25 ns run completed all 78 OpenLane stages.
* Confirmed final signoff status:

  * DRC: Passed
  * LVS: Passed
  * Antenna: Passed
  * Setup timing: Passed
  * Hold timing: Passed
* Generated final physical-design views including:

  * GDS
  * DEF
  * LEF
  * ODB
  * Gate-level netlist
  * Powered netlist
  * SDC
  * SDF
  * SPEF
  * Liberty timing models
  * SPICE netlist
  * Metrics JSON/CSV
* Created the physical-design summary report:

  * `reports/physical/tinymac_openlane_summary.md`
* Committed and pushed the TinyMAC OpenLane physical-design flow to GitHub.

### Final Metrics

* Clock period: 25 ns
* Approximate target frequency: 40 MHz
* Standard-cell count: 2301
* Standard-cell area: 12668.4 µm²
* Die area: 49024.7 µm²
* Core area: 41758.8 µm²
* Setup worst slack: +0.9228 ns
* Setup TNS: 0
* Hold worst slack: +0.2664 ns
* Hold TNS: 0
* Route DRC errors: 0
* Magic DRC errors: 0
* Antenna violating nets: 0

### Current Result

TinyMAC now has a complete and verified RTL-to-GDSII physical-design flow using OpenLane/OpenROAD and the SKY130 open-source PDK flow. The design successfully reaches final layout generation with clean DRC, clean LVS, clean antenna checks, and passing setup/hold timing at a 25 ns clock period.

### Next Step

Improve the project presentation by updating the README with the successful OpenLane physical-design milestone, then inspect the final layout visually and prepare screenshots for the portfolio/project book.

## Phase 7 — Documentation and Project Presentation Polish

**Status:** In Progress  

### Completed Work

* Reviewed and polished the main `README.md`.
* Updated the README introduction to reflect that the RTL-to-GDSII flow is completed.
* Added the final TinyMAC GDS layout screenshot to the README:

  * `images/tinymac_whole_chip_layout.png`
* Improved the physical design results table and area units.
* Added `reports/physical/` to the documented repository structure.
* Added a Key Learning Outcomes section describing the main technical concepts learned through the project.
* Updated the Planned Next Steps section to focus on documentation polish and future project presentation.
* Committed and pushed the README polish to GitHub.

### Current Result

TinyMAC now has a stronger GitHub presentation. The README shows the completed RTL-to-GDSII flow, final GDS layout screenshot, physical implementation results, and key learning outcomes.

### Next Step

Continue the documentation polish by adding the completed TinyMAC v2 pipelined implementation, physical-design results, and v1 vs v2 comparison.


## Phase 8 — TinyMAC v2 Pipelined Implementation and Comparison

**Status:** Completed  

### Completed Work

* Created a separate TinyMAC v2 implementation without modifying the frozen TinyMAC v1 RTL.
* Added the v2 RTL files under `rtl_v2/`.
* Added the v2 testbench under `tb_v2/`.
* Added v2 Makefile targets for lint, testbench lint, simulation, and synthesis.
* Added the v2 Yosys synthesis script.
* Verified TinyMAC v2 using Verilator lint and simulation.
* Confirmed that all directed simulation tests passed.
* Synthesized TinyMAC v2 using Yosys.
* Implemented TinyMAC v2 through OpenLane/OpenROAD physical design.
* Generated v2 RTL, gate-level, and final layout images.
* Collected timing, area, power, and signoff results.
* Created a v1 vs v2 comparison document.
* Updated the README to present both TinyMAC v1 and TinyMAC v2.

### TinyMAC v2 Result

TinyMAC v2 successfully completed the full RTL-to-GDSII flow with clean setup timing, clean hold timing, clean DRC, clean LVS, clean antenna checks, and final GDS layout generation.

### Key v2 Metrics

* Target clock period: 10.5 ns
* Approximate target frequency: 95.24 MHz
* Standard-cell count: 2607
* Standard-cell area: 15826.4 µm²
* Die area: 55955.6 µm²
* Core area: 47845.9 µm²
* Setup worst slack: +0.195984 ns
* Hold worst slack: +0.261731 ns
* Route DRC errors: 0
* Magic DRC errors: 0
* KLayout DRC errors: 0
* LVS errors: 0
* Antenna violating nets: 0
* Total power: 0.004670 W

### v1 vs v2 Summary

TinyMAC v1 is smaller and lower latency, but closes timing at a slower 25 ns clock period. TinyMAC v2 adds pipeline registers, increases area and latency, but improves timing and closes at a faster 10.5 ns clock period.

### Current Result

The project now includes two complete ASIC implementations: a baseline single-cycle TinyMAC v1 and a pipelined TinyMAC v2. Both versions completed simulation, synthesis, OpenLane/OpenROAD physical design, and signoff checks. The repository now demonstrates a full design, optimization, and comparison workflow.

### Next Step

Review the GitHub repository presentation as a complete portfolio project, then prepare a concise LinkedIn post and CV/interview summary.
