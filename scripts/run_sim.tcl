# --- Argument Check ---
# llength checks how many items are in the argument list
if {[llength $argv] == 0} {
    puts "Error: No testbench file specified."
    puts "Usage: vivado -mode tcl -source run_sim.tcl -tclargs <testbench_name_or_path>"
    exit 1
}

# Grab the first argument from the list (index 0)
set TB_ARG [lindex $argv 0]

# --- Resolve TB_ARG to an actual file path ---.
if {[string first "/" $TB_ARG] >= 0} {
    set TB_FILE $TB_ARG
} else {
    # strip a trailing .v if the user included one, so both
    # "tb_Full_Adder" and "tb_Full_Adder.v" work the same way
    set bare_name [file rootname $TB_ARG]

    set matches [glob -nocomplain "tb/*/${bare_name}.v" "tb/${bare_name}.v"]

    if {[llength $matches] == 0} {
        puts "Error: Could not find a testbench matching '$TB_ARG' under tb/"
        exit 1
    }

    set TB_FILE [lindex $matches 0]
}

# Extract the module name from the file path
set TOP_TB [file rootname [file tail $TB_FILE]]
set SNAPSHOT "${TOP_TB}_snapshot"

puts " Target Testbench: $TOP_TB"

# 1. Parse/Compile Verilog Files
puts "--> 1. Parsing Verilog Files..."
exec xvlog {*}[glob src/*.v] $TB_FILE

# 2. Elaborate Design
puts "--> 2. Elaborating Design..."
exec xelab -debug typical -snapshot $SNAPSHOT "work.$TOP_TB"

# 3. Launch Simulation with Waveform Viewer
puts "--> 3. Launching Vivado Waveform Viewer..."
exec xsim $SNAPSHOT -gui &

exit