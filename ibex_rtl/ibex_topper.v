`ifdef RISCV_FORMAL
  `define RVFI
`endif

//`include "prim_assert.sv"

module ibex_topper (
  // Clock and Reset
  input  wire                         clk_i,
  input  wire                         rst_ni,

  input  wire                         test_en_i,     // enable all clock gates for testing
//  input  prim_ram_1p_pkg::ram_1p_cfg_t ram_cfg_i,

  input  wire [31:0]                  hart_id_i,
  input  wire [31:0]                  boot_addr_i,

  // Instruction memory interface
  output wire                         instr_req_o,
  input  wire                         instr_gnt_i,
  input  wire                         instr_rvalid_i,
  output wire [31:0]                  instr_addr_o,
  input  wire [31:0]                  instr_rdata_i,
  input  wire [6:0]                   instr_rdata_intg_i,
  input  wire                         instr_err_i,

  // Data memory interface
  output wire                         data_req_o,
  input  wire                         data_gnt_i,
  input  wire                         data_rvalid_i,
  output wire                         data_we_o,
  output wire [3:0]                   data_be_o,
  output wire [31:0]                  data_addr_o,
  output wire [31:0]                  data_wdata_o,
  output wire [6:0]                   data_wdata_intg_o,
  input  wire [31:0]                  data_rdata_i,
  input  wire [6:0]                   data_rdata_intg_i,
  input  wire                         data_err_i,

  // Interrupt inputs
  input  wire                         irq_software_i,
  input  wire                         irq_timer_i,
  input  wire                         irq_external_i,
  input  wire [14:0]                  irq_fast_i,
  input  wire                         irq_nm_i,       // non-maskeable interrupt

  // Scrambling Interface
  input  wire                         scramble_key_valid_i,
    //Parameters defined in ibex_pkg.sv replaced with their default values, changes made should be reflected.
    //The original lines are given under
  input  wire [128-1:0]    scramble_key_i,
  input  wire [64-1:0]  scramble_nonce_i,
    //Original lines in following comments
  //input  wire [SCRAMBLE_KEY_W-1:0]    scramble_key_i,
  //input  wire [SCRAMBLE_NONCE_W-1:0]  scramble_nonce_i,
  output wire                         scramble_req_o,

  // Debug Interface
  input  wire                         debug_req_i,
    //crash_dump_t is defined in ibex_pkg.sv
  //output crash_dump_t                  crash_dump_o,
  output wire [31:0] crash_dump_current_pc_o,
  output wire [31:0] crash_dump_next_pc_o,
  output wire [31:0] crash_dump_last_data_addr_o,
  output wire [31:0] crash_dump_exception_pc_o,
  output wire [31:0] crash_dump_exception_addr_o,
  output wire                         double_fault_seen_o,

  // RISC-V Formal Interface
  // Does not comply with the coding standards of _i/_o suffixes, but follows
  // the convention of RISC-V Formal Interface Specification.
`ifdef RVFI
  output wire                         rvfi_valid,
  output wire [63:0]                  rvfi_order,
  output wire [31:0]                  rvfi_insn,
  output wire                         rvfi_trap,
  output wire                         rvfi_halt,
  output wire                         rvfi_intr,
  output wire [ 1:0]                  rvfi_mode,
  output wire [ 1:0]                  rvfi_ixl,
  output wire [ 4:0]                  rvfi_rs1_addr,
  output wire [ 4:0]                  rvfi_rs2_addr,
  output wire [ 4:0]                  rvfi_rs3_addr,
  output wire [31:0]                  rvfi_rs1_rdata,
  output wire [31:0]                  rvfi_rs2_rdata,
  output wire [31:0]                  rvfi_rs3_rdata,
  output wire [ 4:0]                  rvfi_rd_addr,
  output wire [31:0]                  rvfi_rd_wdata,
  output wire [31:0]                  rvfi_pc_rdata,
  output wire [31:0]                  rvfi_pc_wdata,
  output wire [31:0]                  rvfi_mem_addr,
  output wire [ 3:0]                  rvfi_mem_rmask,
  output wire [ 3:0]                  rvfi_mem_wmask,
  output wire [31:0]                  rvfi_mem_rdata,
  output wire [31:0]                  rvfi_mem_wdata,
  output wire [31:0]                  rvfi_ext_mip,
  output wire                         rvfi_ext_nmi,
  output wire                         rvfi_ext_nmi_int,
  output wire                         rvfi_ext_debug_req,
  output wire                         rvfi_ext_debug_mode,
  output wire                         rvfi_ext_rf_wr_suppress,
  output wire [63:0]                  rvfi_ext_mcycle,
  output wire [31:0]                  rvfi_ext_mhpmcounters [10],
  output wire [31:0]                  rvfi_ext_mhpmcountersh [10],
  output wire                         rvfi_ext_ic_scr_key_valid,
  output wire                         rvfi_ext_irq_valid,
`endif

  // CPU Control Signals
  input  wire [4-1:0]                 fetch_enable_i,
  output wire                         alert_minor_o,
  output wire                         alert_major_internal_o,
  output wire                         alert_major_bus_o,
  output wire                         core_sleep_o,

  // DFT bypass controls
  input wire                          scan_rst_ni
);

ibex_top top_inst (
// Clock and Reset
  .clk_i(clk_i),
  .rst_ni(rst_i),

  .test_en_i(test_en_i),     // enable all clock gates for testing
  .ram_cfg_i(ram_cfg_i),

  .hart_id_i(hart_id_i),
  .boot_addr_i(boot_addr_i),

  // Instruction memory interface
  .instr_req_o(instr_req_o),
  .instr_gnt_i(instr_gnt_i),
  .instr_rvalid_i(instr_rvalid_i),
  .instr_addr_o(instr_addr_o),
  .instr_rdata_i(instr_rdata_i),
  .instr_rdata_intg_i(instr_rdata_intg_i),
  .instr_err_i(instr_err_i),

  // Data memory interface
  .data_req_o(data_req_o),
  .data_gnt_i(data_gnt_i),
  .data_rvalid_i(data_rvalid_i),
  .data_we_o(data_we_o),
  .data_be_o(data_be_o),
  .data_addr_o(data_addr_o),
  .data_wdata_o(data_wdata_o),
  .data_wdata_intg_o(data_wdata_intg_o),
  .data_rdata_i(data_rdata_i),
  .data_rdata_intg_i(data_rdata_intg_i),
  .data_err_i(data_err_i),

  // Interrupt inputs
  .irq_software_i(irq_software_i),
  .irq_timer_i(irq_timer_i),
  .irq_external_i(irq_external_i),
  .irq_fast_i(irq_fast_i),
  .irq_nm_i(irq_nm_i),

  // Scrambling Interface
  .scramble_key_valid_i(scramble_key_valid_i),
  .scramble_key_i(scramble_key_i),
  .scramble_nonce_i(scramble_nonce_i),
  .scramble_req_o(scramble_req_o),

  // Debug Interface
  .debug_req_i(debug_req_i),
  .crash_dump_o({crash_dump_current_pc_o,crash_dump_next_pc_o,crash_dump_last_data_addr_o,crash_dump_exception_pc_o,crash_dump_exception_addr_o}),
  .double_fault_seen_o(double_fault_seen_o),

  // RISC-V Formal Interface
  // Does not comply with the coding standards of _i/_o suffixes(), but follows
  // the convention of RISC-V Formal Interface Specification.
`ifdef RVFI
  .rvfi_valid(rvfi_valid),
  .rvfi_order(rvfi_order),
  .rvfi_insn(rvfi_insn),
  .rvfi_trap(rvfi_trap),
  .rvfi_halt(rvfi_halt),
  .rvfi_intr(rvfi_intr),
  .rvfi_mode(rvfi_mode),
  .rvfi_ixl(rvfi_ixl),
  .rvfi_rs1_addr(rvfi_rs1_addr),
  .rvfi_rs2_addr(rvfi_rs2_addr),
  .rvfi_rs3_addr(rvfi_rs3_addr),
  .rvfi_rs1_rdata(rvfi_rs1_rdata),
  .rvfi_rs2_rdata(rvfi_rs2_rdata),
  .rvfi_rs3_rdata(rvfi_rs3_rdata),
  .rvfi_rd_addr(rvfi_rd_addr),
  .rvfi_rd_wdata(rvfi_rd_wdata),
  .rvfi_pc_rdata(rvfi_pc_rdata),
  .rvfi_pc_wdata(rvfi_pc_wdata),
  .rvfi_mem_addr(rvfi_mem_addr),
  .rvfi_mem_rmask(rvfi_mem_rmask),
  .rvfi_mem_wmask(rvfi_mem_wmask),
  .rvfi_mem_rdata(rvfi_mem_rdata),
  .rvfi_mem_wdata(rvfi_mem_wdata),
  .rvfi_ext_mip(rvfi_ext_mip),
  .rvfi_ext_nmi(rvfi_ext_nmi),
  .rvfi_ext_nmi_int(rvfi_ext_nmi_int),
  .rvfi_ext_debug_req(rvfi_ext_debug_req),
  .rvfi_ext_debug_mode(rvfi_ext_debug_mode),
  .rvfi_ext_rf_wr_suppress(rvfi_ext_rf_wr_suppress),
  .rvfi_ext_mcycle(rvfi_ext_mcycle),
  .rvfi_ext_mhpmcounters(rvfi_ext_mhpmcounters),
  .rvfi_ext_mhpmcountersh(rvfi_ext_mhpmcountersh),
  .rvfi_ext_ic_scr_key_valid(rvfi_ext_ic_scr_key_valid),
  .rvfi_ext_irq_valid(rvfi_ext_irq_valid),
`endif

  // CPU Control Signals
  .fetch_enable_i(fetch_enable_i),
  .alert_minor_o(alert_minor_o),
  .alert_major_internal_o(alert_major_internal_o),
  .alert_major_bus_o(alert_major_bus_o),
  .core_sleep_o(core_sleep_o),

  // DFT bypass controls
  .scan_rst_ni(scan_rst_ni)
);

endmodule
