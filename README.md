# rtl-toolkit

A growing collection of digital logic modules in Verilog HDL, each backed by a self-checking testbench and verified automatically on every push via CI.

This isn't just a set of RTL exercises — it's built around a real verification methodology: reference models, directed + random stimulus, and automated pass/fail reporting, the same core practices used in professional digital design verification.

## What's inside

| Category | Modules |
|---|---|
| Gates | AND, OR, NOT |
| Combinational | Full Adder, 2x1 MUX, N-to-1 MUX (parameterized), 4x16 Decoder, Priority Encoder |
| Sequential | JK Flip-Flop |

Each module lives in `src/`, paired with a testbench of the same name in `tb/`.

## Verification approach

Every testbench in this repo follows the same structure:

- **Reference model** — an independent, simple behavioral description of the expected output, used to catch bugs in the actual design rather than trusting it blindly.
- **Directed tests** — all known input combinations are explicitly exercised first.
- **Random stimulus** — additional randomized inputs stress-test the design beyond the manually chosen cases.
- **Self-checking** — the testbench compares the DUT's output against the reference model automatically and reports a final `TEST PASSED` or `TEST FAILED` with a mismatch count, instead of requiring manual waveform inspection.

## Project structure

```
rtl-toolkit/
├── src/
│   ├── gates/          # AND, OR, NOT
│   └── blocks/         # combinational + sequential modules
├── tb/
│   ├── gates/           # testbenches for gates
│   └── blocks/          # testbenches for combinational + sequential modules
├── scripts/
│   ├── run_sim.tcl      # Vivado batch simulation (local development)
│   ├── elaborate.tcl    # Vivado RTL schematic elaboration
│   └── run_ci.sh        # Icarus Verilog CI runner
├── .github/
│   └── workflows/
│       └── verilog-ci.yml
└── Makefile
```

## Running locally (Vivado)

```bash
make TB_FILE=tb/blocks/tb_jk_ff.v
```

This compiles the testbench and its matching design file, elaborates the design, and launches the XSim waveform viewer.

## Running locally (Icarus Verilog)

No Vivado license needed — this is the same flow CI runs automatically.

```bash
sudo apt install iverilog
./scripts/run_ci.sh
```

This discovers every testbench in `tb/`, compiles each against its matching design file in `src/`, runs it, and reports a final pass/fail summary.

## Continuous Integration

Every push and pull request to `main` automatically triggers the CI workflow, which:

1. Installs Icarus Verilog on a fresh GitHub-hosted runner
2. Runs every testbench in the repo
3. Fails the build if any testbench reports `TEST FAILED` or hits a compile/runtime error

This means regressions are caught immediately — if a shared change accidentally breaks an older module, CI flags it on the very next push rather than being discovered later.

## Adding a new module

1. Add the design file to `src/gates/` or `src/blocks/`
2. Add a matching testbench to `tb/gates/` or `tb/blocks/`, named `tb_<module_name>.v`
3. Follow the existing self-checking pattern — reference model, directed tests, random stimulus, `TEST PASSED`/`TEST FAILED` reporting
4. Push — CI picks up the new testbench automatically, no configuration changes needed

## Tools used

- **Vivado 2025.2** — local simulation, waveform debugging, RTL elaboration
- **Icarus Verilog** — lightweight open-source simulator used in CI
- **GitHub Actions** — automated testbench execution on every push