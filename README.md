# RTL Design Toolkit

![Verilog](https://img.shields.io/badge/Verilog-RTL-blue)
![Digital Design](https://img.shields.io/badge/Digital%20Design-Logic-green)
![FPGA](https://img.shields.io/badge/FPGA-Design-orange)
![Testbench](https://img.shields.io/badge/Testbench-Self%20Checking-purple)
![Vivado](https://img.shields.io/badge/Vivado-Simulation-red)
![Icarus Verilog](https://img.shields.io/badge/Icarus%20Verilog-CI-yellow)

A growing collection of digital logic modules written in Verilog HDL, each backed
by a **self-checking testbench** and verified automatically on every push via CI.

This repository goes beyond basic RTL exercises — it follows a real verification
methodology: **reference models**, **directed + random stimulus**, and
**automated pass/fail reporting** — the same core practices used in professional
digital design verification.

---

## Available modules

| Category | Location | Contents |
|---|---|---|
| **Gates** | `src/gates/` | Primitive logic gates (AND, OR, NOT) |
| **Blocks** | `src/blocks/` | Combinational and sequential modules — multiplexers, decoders, flip-flops, counters, shift registers, adders, and more |

---

## Project structure

```
rtl-toolkit/
├── src/
│   ├── gates/          # Primitive gate modules
│   └── blocks/         # Combinational and sequential modules
├── tb/
│   ├── gates/           # Testbenches for gates
│   └── blocks/          # Testbenches for blocks
├── scripts/
│   ├── run_sim.tcl      # Vivado batch simulation
│   ├── elaborate.tcl    # Vivado RTL schematic elaboration
│   └── run_ci.sh        # Icarus Verilog CI runner
├── .github/
│   └── workflows/
│       └── verilog-ci.yml
├── Makefile
└── README.md
```

---

## Verification approach

Every testbench follows the same structure:

- **Reference model** — an independent, simple behavioral description of the
  expected output, used to catch bugs in the actual design rather than trusting
  it blindly.
- **Directed tests** — known input combinations are explicitly exercised first.
- **Random stimulus** — additional randomized inputs stress-test the design
  beyond the manually chosen cases.
- **Self-checking** — the testbench compares the DUT's output against the
  reference model automatically and reports a final `TEST PASSED` or
  `TEST FAILED` with a mismatch count, instead of requiring manual waveform
  inspection.

---

## Makefile reference

The project includes a `Makefile` that wraps both Vivado and Icarus flows.
Below is a complete reference of all available targets.

### `make all TB_FILE=<path>` — Run simulation (Vivado)

Compile and simulate a specific testbench in Vivado XSim, then open the
waveform viewer.

```bash
# Full path to the testbench file
make all TB_FILE=tb/blocks/tb_Full_Adder.v

# Or just the testbench name (auto-resolved)
make all TB_FILE=tb_jk_ff
```

Step-by-step what happens:
1. `xvlog` compiles all `src/*.v` files and the selected testbench.
2. `xelab` elaborates the snapshot.
3. `xsim -gui` launches the interactive waveform viewer.

### `make elaborate TOP=<module>` — View RTL schematic (Vivado)

Elaborate a specific top-level module and open the RTL schematic viewer.
Useful for inspecting the synthesized netlist before simulation.

```bash
# Default TOP is mux_bus (from Makefile)
make elaborate

# Specify any top-level module
make elaborate TOP=ripple_ctr
make elaborate TOP=gray_ctr
make elaborate TOP=seq_detector
```

Step-by-step what happens:
1. Reads all Verilog files from `src/`.
2. Runs `synth_design -rtl` with the specified top module.
3. Opens the Vivado schematic GUI.

### `make clean` — Remove simulation artefacts

```bash
make clean
```

Removes `xsim.dir/`, `.Xil/`, log files, and journal files produced by
Vivado and XSim.

### `make help` (or just `make`) — Usage reminder

```bash
make
```

Displays an error reminding you to supply `TB_FILE` if no target is given.

---

## Running with Icarus Verilog (open-source, no Vivado needed)

This is the same flow used by CI — no license required.

```bash
# Install Icarus Verilog
sudo apt install iverilog

# Run all testbenches
./scripts/run_ci.sh
```

The CI script (`scripts/run_ci.sh`) automatically discovers every `tb_*.v`
file under `tb/`, compiles each one together with all `src/*.v` files, runs
the simulation, and prints a final summary:

```
CI SUMMARY: 18 / 18 testbenches passed
```

If any testbench fails (compile error, runtime error, or `TEST FAILED`
assertion), the script exits with a non-zero status.

---

## Continuous Integration

Every push and pull request to `main` triggers the GitHub Actions workflow
(`.github/workflows/verilog-ci.yml`), which:

1. Installs Icarus Verilog on a fresh GitHub-hosted runner.
2. Runs every testbench via `scripts/run_ci.sh`.
3. Fails the build if any testbench reports `TEST FAILED` or hits a
   compile/runtime error.

This catches regressions immediately — if a shared change accidentally breaks
an older module, CI flags it on the very next push rather than being discovered
later.

---

## Adding a new module

1. Add the design file to `src/gates/` or `src/blocks/`.
2. Add a matching testbench to `tb/gates/` or `tb/blocks/`, named
   `tb_<module_name>.v`.
3. Follow the existing self-checking pattern — reference model, directed
   tests, random stimulus, `TEST PASSED` / `TEST FAILED` reporting.
4. Push — CI picks up the new testbench automatically, no configuration
   changes needed.

---

## Tools used

| Tool | Role |
|---|---|
| **Vivado 2025.2** | Local simulation, waveform debugging, RTL elaboration |
| **Icarus Verilog** | Lightweight open-source simulator (used in CI) |
| **GitHub Actions** | Automated testbench execution on every push |