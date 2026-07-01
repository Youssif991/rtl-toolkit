# 1. Create an in-memory project
create_project -in_memory -part xc7a35tcsg324-1

# 2. Read ALL Verilog files recursively from src/ and all its subfolders
# This catches src/blocks/*.v, src/gates/*.v, etc.
set verilog_files [glob -nocomplain -directory src -recursive *.v]

if {[llength $verilog_files] > 0} {
    read_verilog $verilog_files
} else {
    error "ERROR: No Verilog files found in src/ or its subdirectories!"
}

# 3. Dynamic Elaboration
# Pull the top module name from the Makefile arguments (defaults to 'mux_bus')
if { $argc > 0 } {
    set top_module [lindex $argv 0]
} else {
    set top_module "mux_bus"
}

puts "Elaborating design with top module: $top_module"
synth_design -top $top_module -rtl

# 4. Open the interactive schematic GUI
start_gui