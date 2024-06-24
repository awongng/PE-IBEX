# Description

Implementation of a custom ALU extension (see this [repository](https://github.com/awongng/PE)) in an IBEX core. This project is incomplete, but some initial work has been done.

In order to use this project, merge and overwrite its content into the [IBEX repository](https://github.com/lowRISC/ibex).

This repository only contains RTL files, but proper integration of the custom ALU extension into the IBEX core will probably require other files to be added or modified from IBEX's repository.

## Modifications to original IBEX

### Files added

* [pqvalue_rtl](./pqvalue_rtl) directory : files describing our ALU extension
* [ibex_topper.v](./ibex_rtl/ibex_topper.v) : top module over original top module in order to use Vivado for synthesis, which doesn't accept SystemVerilog for its top module.

### Files modified

* In [ibex_rtl](./ibex_rtl) directory :
  * [ibex_pkg.sv](./ibex_rtl/ibex_pkg.sv) :
    * opcode for additional operations
      * enum type for additional operations ```pq_op_e```
      * TBD : add to regfile data selection ```rf_wd_sel_e```
  * [ibex_id_stage.sv](./ibex_rtl/ibex_id_stage.sv) :
    * Control signals for ALU extension, mostly copying and adapting ALU control signals
  * [ibex_decoder.sv](./ibex_rtl/ibex_decoder.sv) : planned
  * [ibex_ex_block.sv](./ibex_rtl/ibex_ex_block.sv) : planned

### Files removed

None yet
