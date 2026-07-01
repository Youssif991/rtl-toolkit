# --- Argument Check ---
# llength checks how many items are in the argument list
if {[llength $argv] == 0} {
    puts "Error: No testbench file specified."
    puts "Usage: vivado -mode tcl -source run_sim.tcl -tclargs <path_to_testbench.v>"
    exit 1
}

# Grab the first argument from the list (index 0)
set TB_FILE [lindex $argv 0]

# Extract the module name from the file path
set TOP_TB [file rootname [file tail $TB_FILE]]
set SNAPSHOT "${TOP_TB}_snapshot"

puts "======================================="
puts " Target Testbench: $TOP_TB"
puts "======================================="

# 1. Parse/Compile Verilog Files
puts "--> 1. Parsing Verilog Files..."
exec xvlog {*}[glob src/blocks/*.v] {*}[glob src/gates/*.v] $TB_FILE

# 2. Elaborate Design
puts "--> 2. Elaborating Design..."
exec xelab -debug typical -snapshot $SNAPSHOT "work.$TOP_TB"

# 3. Launch Simulation with Waveform Viewer
puts "--> 3. Launching Vivado Waveform Viewer..."
exec xsim $SNAPSHOT -gui &

exit