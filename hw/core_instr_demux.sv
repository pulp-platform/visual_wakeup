// Copyright 2025 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE.solderpad for details.
// SPDX-License-Identifier: SHL-0.51
//
// Sergio Mazzola <smazzola@iis.ee.ethz.ch>

module core_instr_demux #(
  parameter int unsigned NumPorts = 2,
  parameter int unsigned AddrWidth = 32,
  parameter type rule_t = logic,
  // Dependent parameters: do not modify
  localparam int unsigned SelWidth = cf_math_pkg::idx_width(NumPorts),
  localparam int unsigned NumRules = NumPorts
)(
  input  logic                 clk_i,
  input  logic                 rst_ni,
  input  rule_t [NumRules-1:0] addr_map_i,
  // Interface to master (i.e., the core IF)
  input  logic [AddrWidth-1:0] slv_addr_i,
  input  logic                 slv_valid_i,
  output logic [31:0]          slv_data_o,
  output logic                 slv_ready_o,
  // Interface to slaves (instruction memories)
  output logic [NumPorts-1:0][AddrWidth-1:0] mst_addr_o,
  output logic [NumPorts-1:0]                mst_valid_o,
  input  logic [NumPorts-1:0][31:0]          mst_data_i,
  input  logic [NumPorts-1:0]                mst_ready_i
);

  typedef logic [AddrWidth-1:0] addr_t;

  logic [SelWidth-1:0] demux_sel;

  // Decide which entry of the address map to route the request to
  addr_decode_napot #(
    .NoIndices ( NumPorts ),
    .NoRules ( NumRules ),
    .addr_t ( addr_t ),
    .rule_t ( rule_t )
  ) i_addr_decode (
    .addr_i ( slv_addr_i ),
    .addr_map_i ( addr_map_i ),
    .idx_o ( demux_sel ),
    .dec_valid_o ( /* Unconnected */ ),
    .dec_error_o ( /* Unconnected */ ),
    .en_default_idx_i ( 1'b1 ),
    .default_idx_i ( 1'b1 )
  );
  
  // Based on the selected index of the address map, forward the request to the slave
  always_comb begin : instr_demux
    mst_addr_o = '0;
    mst_valid_o = '0;
    slv_data_o = '0;
    slv_ready_o = 1'b0;

    for (int unsigned i = 0; i < NumPorts; i++) begin
      // Port `i` is selected to route instruction request from core
      if (demux_sel == i) begin
        // Remap the address before routing to slave
        mst_addr_o[i] = slv_addr_i & ~(addr_map_i[i].mask);
        mst_valid_o[i] = slv_valid_i;
        slv_data_o = mst_data_i[i];
        slv_ready_o = mst_ready_i[i];
      end
    end
  end

  /* Assertions */

  `ifdef TARGET_VWU_TEST
    // If an instruction request is outstanding (valid = 1, ready = 0),
    // the address must not change on any cycle until ready goes high.
    stable_instr_addr: assert property (
      @(posedge clk_i)
      disable iff ((!rst_ni) !== 1'b0)
      ($rose(slv_valid_i && !slv_ready_o) |=> $stable(slv_addr_i) until_with slv_ready_o)
    )
    else begin
      $error(
        "[ASSERT FAILED] [%m] Instruction address not stable during handshake (%s:%0d)",
        `__FILE__, `__LINE__
      );
    end
  `endif

endmodule