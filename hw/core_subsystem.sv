// Copyright 2025 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE.solderpad for details.
// SPDX-License-Identifier: SHL-0.51
//
// Sergio Mazzola <smazzola@iis.ee.ethz.ch>

module core_subsystem #(
  parameter int unsigned AddrWidth = 32,
  parameter int unsigned DataWidth = 32,
  parameter logic [AddrWidth-1:0] BootAddr = 32'h0000_0000,
  parameter type dreq_t = logic,
  parameter type drsp_t = logic
) (
  input  logic                 clk_i,
  input  logic                 rst_ni,
  input  logic                 irq_meip_i,
  output logic [AddrWidth-1:0] inst_addr_o,
  input  logic [31:0]          inst_data_i,
  output logic                 inst_valid_o,
  input  logic                 inst_ready_i,
  output dreq_t                data_req_o,
  input  drsp_t                data_rsp_i
);

  // Snitch accelerator interface (minimal)
  typedef struct packed {
    logic [AddrWidth-1:0] addr;
    logic [3:0] id;
    logic [DataWidth-1:0] data_op;
    logic [DataWidth-1:0] data_argb;
    logic [DataWidth-1:0] data_arga;
    logic [DataWidth-1:0] data_argc;
  } core_acc_req_t;

  typedef struct packed {
    logic [3:0] id;
    logic error;
    logic [DataWidth-1:0] data;
  } core_acc_resp_t;

  // Snitch interrupts
  snitch_pkg::interrupts_t core_irq;
  always_comb begin : core_irq_binding
    core_irq = '0;
    core_irq.meip = irq_meip_i;
  end

  // Snitch core (minimal instance)
  snitch #(
    .BootAddr ( BootAddr ),
    .AddrWidth ( AddrWidth ),
    .DataWidth ( DataWidth ),
    // Memory interface
    .dreq_t ( dreq_t ),
    .drsp_t ( drsp_t ),
    .NumIntOutstandingLoads ( 1 ),
    .NumIntOutstandingMem ( 1 ),
    // Use reduced-register extension
    .RVE ( 1 ),
    // Disable all other extensions
    .Xdma ( 0 ),
    .Xssr ( 0 ),
    .FP_EN ( 0 ),
    .RVF ( 0 ),
    .RVD ( 0 ),
    .XF16 ( 0 ),
    .XF16ALT ( 0 ),
    .XF8 ( 0 ),
    .XF8ALT ( 0 ),
    .XDivSqrt ( 0 ),
    .XFVEC ( 0 ),
    .XFDOTP ( 0 ),
    .XFAUX ( 0 ),
    .Xipu ( 0 ),
    // Disable VM support
    .VMSupport ( 0 ),
    .NumDTLBEntries ( 0 ),
    .NumITLBEntries ( 0 ),
    .l0_pte_t ( logic ),
    .pa_t ( logic ),
    // No co-processor
    .acc_req_t ( core_acc_req_t ),
    .acc_resp_t ( core_acc_resp_t ),
    // No caching rules, no consistency address queue
    .CaqDepth ( 0 ),
    .CaqTagWidth ( 0 ),
    // No debug support
    .DebugSupport ( 0 )
  ) i_snitch (
    .clk_i ( clk_i ),
    .rst_i ( ~rst_ni ),
    .hart_id_i ( '0 ), // do not consider SoC's harts
    .irq_i ( core_irq ),
    //TODO: Remove support for fence
    .flush_i_valid_o ( /* Unconnected */ ),
    .flush_i_ready_i ( 1'b0 ),
    .inst_addr_o ( inst_addr_o ),
    .inst_cacheable_o ( /* Unconnected */ ),
    .inst_data_i ( inst_data_i ),
    .inst_valid_o ( inst_valid_o ),
    .inst_ready_i ( inst_ready_i ),
    .data_req_o ( data_req_o ),
    .data_rsp_i ( data_rsp_i ),
    //TODO: Remove support for co-processor?
    .acc_qreq_o ( /* Unconnected */ ),
    .acc_qvalid_o ( /* Unconnected */ ),
    .acc_qready_i ( 1'b0 ),
    .acc_prsp_i ( '0 ),
    .acc_pvalid_i ( 1'b0 ),
    .acc_pready_o ( /* Unconnected */ ),
    // Deactivate everything else
    .caq_pvalid_i ( 1'b0 ),
    .ptw_valid_o ( /* Unconnected */ ),
    .ptw_ready_i ( '0 ),
    .ptw_va_o ( /* Unconnected */ ),
    .ptw_ppn_o ( /* Unconnected */ ),
    .ptw_pte_i ( '0 ),
    .ptw_is_4mega_i ( '0 ),
    .fpu_rnd_mode_o ( /* Unconnected */ ),
    .fpu_fmt_mode_o ( /* Unconnected */ ),
    .fpu_status_i ( '0 ),
    .core_events_o ( /* Unconnected */ ),
    //TODO: Remove support for hw barriers?
    .barrier_o ( /* Unconnected */ ),
    .barrier_i ( 1'b0 )
  );

endmodule