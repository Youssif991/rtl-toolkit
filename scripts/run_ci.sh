#!/bin/bash
#
# run_ci.sh — Runs every testbench in tb/ against Icarus Verilog
# Used by GitHub Actions CI. Fails (non-zero exit) if ANY testbench fails.
#
# Usage: ./run_ci.sh
#

set -uo pipefail   # NOTE: not using -e, we want to run ALL testbenches even if one fails

DESIGN_FILES=$(find src -name "*.v")
TB_FILES=$(find tb -name "tb_*.v")

TOTAL=0
PASSED=0
FAILED_LIST=()

echo " Discovered design files:"
echo "$DESIGN_FILES" | sed 's/^/   /'
echo " Discovered testbenches:"
echo "$TB_FILES" | sed 's/^/   /'

for TB in $TB_FILES; do
    TOTAL=$((TOTAL+1))
    TB_NAME=$(basename "$TB" .v)
    OUT_BIN="/tmp/${TB_NAME}_sim"

    echo ""
    echo " Running: $TB_NAME"

    # Compile
    if ! iverilog -g2012 -o "$OUT_BIN" $DESIGN_FILES "$TB"; then
        echo "COMPILE ERROR: $TB_NAME"
        FAILED_LIST+=("$TB_NAME (compile error)")
        continue
    fi

    # Run and capture output
    SIM_OUTPUT=$(vvp "$OUT_BIN" 2>&1)
    echo "$SIM_OUTPUT"

    # Check result
    if echo "$SIM_OUTPUT" | grep -q "TEST FAILED"; then
        echo "FAILED: $TB_NAME"
        FAILED_LIST+=("$TB_NAME (assertion failure)")
    elif echo "$SIM_OUTPUT" | grep -qi "error"; then
        echo "FAILED: $TB_NAME (runtime error detected)"
        FAILED_LIST+=("$TB_NAME (runtime error)")
    else
        echo "PASSED: $TB_NAME"
        PASSED=$((PASSED+1))
    fi
done

echo ""
echo " CI SUMMARY: $PASSED / $TOTAL testbenches passed"

if [ ${#FAILED_LIST[@]} -ne 0 ]; then
    echo "Failed testbenches:"
    for F in "${FAILED_LIST[@]}"; do
        echo "  - $F"
    done
    exit 1
fi

exit 0