# --- Configuration ---
# Leave this blank so it must be passed from the terminal
TB_FILE = 

# Safety Check: Stop immediately if the user forgot to pass the file name
ifeq ($(strip $(TB_FILE)),)
$(error Error: You must specify a testbench file. Usage: make TB_FILE=tb/blocks/tb_Full_Adder.v)
endif

# Default target: Simply forwards everything to your Tcl script
all:
	vivado -mode tcl -source scripts/run_sim.tcl -tclargs $(TB_FILE)

# Clean target to sweep away directory clutter
clean:
	@echo "Cleaning up simulation files..."
	rm -rf xsim.dir/ .Xil/
	rm -f xsim*.backup.log xsim*.backup.jou
	rm -f xvlog.log xvlog.pb xelab.log xelab.pb xsim.log xsim.jou vivado*.log vivado*.jou