# Visual Wake-Up

The Visual Wake-Up (VWU) domain is a minimal cluster-like infrastructure that enhances the flexibility of an Hardware PE (HWPE) accelerator with negligible impact on area cost and power consumption. The VWU features a minimal rv32e Snitch core with private instruction and data memories that can be refilled by the SoC through the AXI Lite slave interface. A AXI Lite master port can be used to configure the employed sensor. Snitch configures the integrated HWPE through a register interface, and a wide AXI slave interface refills the activation memory of the HWPE from a camera sensor. All integrated memories are latch-based.

The VWU is developed as part of the PULP project, a joint effort between ETH Zurich and the University of Bologna.

## Requirements & set-up

- RISC-V GCC toolchain (tested with `riscv32-unknown-elf-gcc (2021-10-30 PULP GCC v2.5.0) 9.2.0`): https://github.com/pulp-platform/pulp-riscv-gnu-toolchain. The make flow tries to automatically find the install path of `riscv32-unknown-elf-gcc`. Alternatively, you can specify it manually in `sw/sw.mk` or by exporting the env variable `GCC_ROOT=path/to/bin/dir`.
- Bender (tested with `bender 0.28.2`): https://github.com/pulp-platform/bender. Specified in `Makefile` or through the env variable `BENDER`.
- For RTL simulation: QuestaSim (tested with `questa-2022.3`). Specified in `target/sim/sim.mk` or through the env variable `QUESTA`.

## Getting started

### Software
Software applications to be run on the VWU can be placed in the directory `sw/apps`. Some basic tests are already provided.
To compile all applications run, from the project root:
```bash
make all-sw
```
This will first compile the bare-metal runtime of the Snitch core, and then the apps. The compilation will produce, for each app, three artifacts of interest:
- `*.dump`: the dump of the compiled elf, for inspection
- `*.instr_mem.bin`: the binary file containing the .text section of the compiled elf, that will be loaded to Snitch's instruction memory
- `*.data_mem.bin`: the binary file containing the data sections of the compiled elf, that will be loaded to Snitch's data memory

If you want to compile only one application, you can run, instead of `make all-sw`:
```bash
APP=your_app
make sw/apps/$APP.{dump,instr_mem.bin,data_mem.bin}
```

### Hardware
To run a first simulation of the VWU unit, first clone the required hardware dependencies. If prompted with different dependency versions to select, refer to the ones already specified in `Bender.lock`. From the project root:
```bash
make checkout
```

Then, generate the compilation script for QuestaSim and execute it:
```bash
make compile-vsim
```

Now that you have both software and hardware compiled, you can launch your simulation with:
```bash
APP=your_app GUI=1 make run-vsim
```
`APP` specifies the name (not the whole path) of the app that you want to run on the VWU; the compilation artifacts of the app have to be available under `sw/apps`. `GUI=1` enables QuestaSim's GUI, which is disabled by default. When enabled, the GUI is set up through the script `target/sim/vsim/tb_vwu_top.do`.

## Directory structure
- `hw`: Contains the SystemVerilog hardware description of the VWU, including the bootrom of the Snitch core, automatically generated from the code in `sw/bootrom`. You can regenerate Snitch's bootrom with `make snitch_bootrom`.
- `sw`: The SDK and applications for the VWU. It includes:
    - `runtime`: The bare-metal runtime, featuring: a linker script that groups the elf sections to correctly generate complete, independent, and lean binaries to load the instruction and data memories separately; a crt0 runtime to initialize the core's state, and the system's address map.
    - `hal`: Drivers for the devices around the Snitch core (CSRs, HWPE).
    - `bootrom`: The code implemented in Snitch's bootrom; in its current implementation, it initializes the core's register file and goes into wfi.
    - `apps`: User-defined software apps.
- `target`: The different targets of compilation, each one with its own makefile. You can, for example, place here your additional targets for different ASIC implementations and FPGA. Each target's makefile must be included in the root `Makefile`.
    - `sim`: A predefined flow for RTL simulation in QuestaSim.
    - `asic`: Placeholder for an ASIC target.
- `test`: SystemVerilog testbench and testing infrastructure for the VWU.
- `utils`: Useful scripts and tools.

## Testing and execution flow

The VWU's testbench contains 4 main components:
- a virtual AXI Lite driver connected to the VWU's AXI Lite master port
- a virtual AXI Lite driver connected to the VWU's AXI Lite slave port
- a virtual, wide AXI driver connected to the VWU's wide AXI port for the camera sensor
- the DUT, i.e., the VWU top-level

The **testbench execution flow** is the following:
1. The virtual AXI Lite master loads `$APP.instr_mem.bin` in the instruction memory
2. The virtual AXI Lite master loads `$APP.data_mem.bin` in the data memory
3. (in parallel to 1. and 2.) The virtual wide AXI master loads a parametrizable number of bytes with random content in the activation memory
4. The testbench sends an interrupt to the Snitch core, which starts fetching from the instruction memory
5. While the VWU runs, the testbench polls the exposed EOC register to detect the end of the software run
6. Finally, the testbench receives the return value and can launch another execution or terminate the simulation

Such a configuration can be used to seamlessly simulate also ASIC implementations of the VWU top-level.

The **execution flow of the VWU** is the following:
1. Just after the reset is deasserted, the Snitch core boots at the first address of the bootrom
2. The code in the bootrom initializes Snitch's register file, enable the local Machine External interrupt, and goes into wfi
3. When Snitch receives a `meip` interrupt, it jumps to the first instruction loaded in the instruction memory, starting the execution of the crt0
4. crt0 initializes stack and global pointer, resets the .bss section of the data memory, and calls `main`
5. The user-defined app is executed and, when `main` returns, crt0 stores the return value in the end-of-computation (EOC) CSR, signalling the end of the execution
6. Finally, Snitch jumps again to the beginning of the bootrom, resetting the register file and going again into a wfi

## License

Unless specified otherwise in the respective file headers, all code checked into this repository is made available under a permissive license. All hardware sources and tool scripts (all files under the directories `hw`, `target`, `test`, unless otherwise specified in their headers) are licensed under the Solderpad Hardware License 0.51 (see `LICENSE.solderpad`) or compatible licenses. 

All software sources (all files under the directories `sw`, `utils`, unless otherwise specified in their headers) are licensed under Apache 2.0 (see `LICENSE.apache`).
