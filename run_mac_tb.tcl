# Set path to ModelSim executables
set modelsim_path "/home/aaditya/intelFPGA/18.1/modelsim_ase/bin/"

# # Create and map the work library if it doesn't exist
# if {![file exists work]} {
#     exec $modelsim_path/vlib work
#     exec $modelsim_path/vmap work work
# }

# Clean previous simulation data
# exec $modelsim_path/vdel -all

# Compile the SystemVerilog files
exec $modelsim_path/vlog -work work MAC.sv
exec $modelsim_path/vlog -work work MAC_tb.sv

# Setup the simulation
exec $modelsim_path/vsim -L altera_mf_ver lpm_ver MAC_tb

# Run the simulation
run -all

# Exit ModelSim
quit
