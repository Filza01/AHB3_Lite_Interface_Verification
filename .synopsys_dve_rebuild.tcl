# DVE Simulation Rebuild/Restart Options
# Saved on Mon Sep 25 19:54:15 2023
set SIMSETUP::REBUILDOPTION 1
set SIMSETUP::REBUILDCMD {vcs -lca -debug_access+all -sverilog testbench.sv design_files/*.sv}
set SIMSETUP::REBUILDDIR {}
set SIMSETUP::RESTOREBP 1
set SIMSETUP::RESTOREDUMP 1
set SIMSETUP::RESTOREFORCE 1
set SIMSETUP::RESTORESPECMAN 0
