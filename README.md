# APB SystemVerilog Verification Project

A small class-based SystemVerilog testbench for a single APB-style slave with a 32-bit address/data bus and 256 word locations. The source was reconstructed from screenshots, with portable file paths and a few defensive cleanups. Review the sources against your original files before using them in a submission or interview.

## Features

- APB interface with master, slave, and monitor clocking blocks
- Class-based generator, driver, monitor, and agent
- Mailbox-based communication between generator/driver and monitor/scoreboard
- Environment, scoreboard, and base test organized into packages
- Simple memory-mapped APB slave DUT
- Driver wait limit to detect a stuck `PREADY`
- Portable `apb.f` file list using paths relative to the repository root

## Repository layout

```text
apb-sv-verification/
├── agent/
│   ├── apb_agent_pkg.sv
│   ├── apb_agent.sv
│   ├── apb_driver.sv
│   ├── apb_generator.sv
│   ├── apb_monitor.sv
│   └── apb_transaction.sv
├── env/
│   ├── apb_env_pkg.sv
│   ├── apb_env.sv
│   └── apb_scoreboard.sv
├── test/
│   ├── apb_test_pkg.sv
│   └── apb_base_test.sv
├── top/
│   ├── apb_interface.sv
│   └── apb_top.sv
├── dut/
│   └── apb_slave_design.sv
├── sim/
│   └── run_questa.sh
├── apb.f
└── README.md
```

## Directed transactions

The generator queues four transactions:

| Order | Operation | Address (decimal) | Write data | Expected read data |
|---:|---|---:|---:|---:|
| 1 | Write | 10 | 100 | Not applicable |
| 2 | Read | 10 | Not applicable | 100 |
| 3 | Write | 20 | 200 | Not applicable |
| 4 | Read | 20 | Not applicable | 200 |

The scoreboard counts a pass for each read-data comparison that matches the reference memory. Therefore, with these four directed transfers, the expected summary is **4 transactions processed, 2 read checks passed, 0 errors**. This is an expected result from the intended test, not a simulation result verified in this environment.

## Run with QuestaSim / ModelSim

Run the commands from the repository root in a shell where `vlog`, `vsim`, and `vlib` are on `PATH`:

```bash
vlib work
vlog -sv -f apb.f
vsim -c apb_top -do 'run -all; quit -f'
```

Alternatively, run:

```bash
./sim/run_questa.sh
```

The testbench uses SystemVerilog classes, mailboxes, events, virtual interfaces, and clocking blocks. Use a simulator with support for those language features; a basic Verilog-only simulator may not support this testbench.

## Verification status

The project files and file list have been assembled, but a SystemVerilog simulator was not available in the current environment, so compilation and simulation have **not** been run here. Run the commands above and review the simulator transcript before describing the project as passing. The `.f` file intentionally replaces the original machine-specific `/home/...` paths with relative paths.

## GitHub upload

Create an empty repository on GitHub, then from this project directory run:

```bash
git init
git add .
git commit -m "Add APB SystemVerilog verification testbench"
git branch -M main
git remote add origin https://github.com/<your-username>/<repository-name>.git
git push -u origin main
```

Replace the URL with the repository URL from your GitHub account.
