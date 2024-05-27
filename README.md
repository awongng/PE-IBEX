# Description

Implementation of a custom ALU (see this [repository](https://github.com/awongng/PE)) in an IBEX core.

## Modifications to original IBEX

### Files added

* [pqvalue_rtl](./pqvalue_rtl) directory : files describing our ALU extension

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
