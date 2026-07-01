# Digital-Design-Verilog-Exercises

This workspace is a hands-on Verilog HDL learning repository for digital design. It contains simple gate-level implementations, combinational circuit modules, testbenches, and Vivado project files used to simulate and verify designs.

## Folder overview

- [src](src): RTL source files for the implemented designs.
  - [src/blocks](src/blocks): reusable digital blocks such as adders, muxes, decoders, and similar modules.
  - [src/gates](src/gates): basic gate primitives like AND, OR, and NOT.
- [tb](tb): testbench files used to simulate and validate the RTL modules.
  - [tb/blocks](tb/blocks): testbenches for block-level designs.
  - [tb/gates](tb/gates): testbenches for gate-level designs.
- [scripts](scripts): helper scripts for automation and simulation tasks.

## How to run the code

<details>
<summary><strong>Linux / macOS</strong></summary>

Run a specific testbench with:

```bash
make TB_FILE=tb/blocks/tb_Priority_Encoder.v
```

You can replace the testbench path with any other file under the [tb](tb) folder.

</details>

<details>
<summary><strong>Windows</strong></summary>

Use the same command from Git Bash, WSL, or another Unix-like shell:

```bash
make TB_FILE=tb/blocks/tb_Priority_Encoder.v
```

If you are using a different shell, make sure the required tools from the [Makefile](Makefile) are available in your environment.

</details>

## Project files

- [Makefile](Makefile): build and simulation helpers.
