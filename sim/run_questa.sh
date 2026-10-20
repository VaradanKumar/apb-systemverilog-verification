#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

if ! command -v vlog >/dev/null 2>&1 || ! command -v vsim >/dev/null 2>&1; then
  echo "QuestaSim commands vlog and vsim were not found on PATH." >&2
  echo "Load your Questa/ModelSim environment, then run this script again." >&2
  exit 127
fi

if [ ! -d work ]; then
  vlib work
fi
vlog -sv -f apb.f
vsim -c apb_top -do 'run -all; quit -f'
