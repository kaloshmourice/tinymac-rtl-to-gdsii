#============================================================
# TinyMAC Project Makefile
# Description:
#   Reusable commands for linting, simulation, synthesis, and cleanup.
#============================================================

.RECIPEPREFIX := >

# TinyMAC v1 configuration
TOP_RTL = tinymac_top
TOP_TB  = tinymac_tb

RTL = rtl/*.sv
TB  = tb/tinymac_tb.sv

SYNTH_SCRIPT = scripts/synth.ys
SYNTH_SCRIPT_V2 = scripts/synth_v2.ys

# TinyMAC v2 configuration
TOP_RTL_V2 = tinymac_top_v2
TOP_TB_V2  = tinymac_v2_tb

RTL_V2 = rtl_v2/*.sv
TB_V2  = tb_v2/tinymac_v2_tb.sv

.PHONY: lint lint-tb sim synth clean
.PHONY: lint-v2 lint-tb-v2 sim-v2 synth-v2

lint:
>verilator --lint-only -Wall --top-module $(TOP_RTL) $(RTL)

lint-tb:
>verilator --lint-only -Wall --timing --top-module $(TOP_TB) $(RTL) $(TB)

sim:
>verilator --binary --timing -Wall --top-module $(TOP_TB) $(RTL) $(TB)
>./obj_dir/V$(TOP_TB)

synth:
>yosys $(SYNTH_SCRIPT)

lint-v2:
>verilator --lint-only -Wall --top-module $(TOP_RTL_V2) $(RTL_V2)

lint-tb-v2:
>verilator --lint-only -Wall --timing --top-module $(TOP_TB_V2) $(TB_V2) $(RTL_V2)

sim-v2:
>verilator --binary --timing -Wall --top-module $(TOP_TB_V2) $(TB_V2) $(RTL_V2)
>./obj_dir/V$(TOP_TB_V2)

synth-v2:
>yosys $(SYNTH_SCRIPT_V2)

clean:
>rm -rf obj_dir
