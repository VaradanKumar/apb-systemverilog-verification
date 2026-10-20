# Reconstruction notes

- The repository structure follows the agent, environment, test, top, and DUT folders shown in the screenshots.
- `apb.f` uses relative paths rather than the screenshot's absolute home-directory paths.
- The generator contains the four visible directed transactions: write/read address 10 with data 100, then write/read address 20 with data 200.
- The scoreboard's `pass_count` counts successful read-data comparisons only, not every transfer. This is why the intended summary has two passes for four transactions.
- Some screenshots crop the beginning or end of files. Those sections were filled in using the visible names and standard SystemVerilog structure. Compare these reconstructed sections with the originals if you still have access to the source files.
- The driver waits for reset release before sending a transfer and includes a timeout for a slave that never asserts `PREADY`.
- The code has not been compiled or simulated in this environment because no supported SystemVerilog simulator was available.
