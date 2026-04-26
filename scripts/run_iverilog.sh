#!/usr/bin/env bash
set -euo pipefail
iverilog -g2012 -o sim_fair_gate hardware/rtl/fair_validation_gate.v hardware/tb/tb_fair_validation_gate.v
vvp sim_fair_gate
