// Copyright 2025 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE.solderpad for details.
// SPDX-License-Identifier: SHL-0.51
//
// Sergio Mazzola <smazzola@iis.ee.ethz.ch>

module core_data_demux #(
  parameter int unsigned NumPorts = 3,
  parameter type req_t = logic,
  parameter type rsp_t = logic,
  parameter int unsigned RespDepth = 1,
  parameter type rule_t = logic,
  // Dependent parameters: do not modify
  localparam int unsigned SelWidth = cf_math_pkg::idx_width(NumPorts),
  localparam int unsigned NumRules = NumPorts - 1
)(
  input  logic                 clk_i,
  input  logic                 rst_ni,
  input  rule_t [NumRules-1:0] addr_map_i,
  input  req_t                 slv_req_i,
  output rsp_t                 slv_rsp_o,
  // The arrays `mst_req_o` and `mst_rsp_i` must have the external port in the
  // last index so requests not matched by anything else are routed outside
  output req_t [NumPorts-1:0]  mst_req_o,
  input  rsp_t [NumPorts-1:0]  mst_rsp_i
);
  localparam int unsigned AddrWidth = $bits(slv_req_i.q.addr);
  typedef logic [AddrWidth-1:0] addr_t;

  logic [SelWidth-1:0] demux_sel;

  req_t [NumPorts-1:0] mst_req_demuxed;

  // Decide which entry of the address map to route the request to
  addr_decode_napot #(
    .NoIndices ( NumPorts ),
    .NoRules ( NumRules ),
    .addr_t ( addr_t ),
    .rule_t ( rule_t )
  ) i_addr_decode (
    .addr_i ( slv_req_i.q.addr ),
    .addr_map_i ( addr_map_i ),
    .idx_o ( demux_sel ),
    .dec_valid_o ( /* Unconnected */ ),
    .dec_error_o ( /* Unconnected */ ),
    // Rule to catch everything else
    .en_default_idx_i ( 1'b1 ),
    .default_idx_i ( SelWidth'(NumPorts-1) )
  );
  
  // Based on the selected index of the address map, forward the request to the slave
  reqrsp_demux #(
    .NrPorts ( NumPorts ),
    .req_t ( req_t ),
    .rsp_t ( rsp_t ),
    .RespDepth ( RespDepth ) // like Snitch
  ) i_demux (
    .clk_i ( clk_i),
    .rst_ni ( rst_ni ),
    .slv_select_i ( demux_sel ),
    .slv_req_i ( slv_req_i ),
    .slv_rsp_o ( slv_rsp_o ),
    .mst_req_o ( mst_req_demuxed ),
    .mst_rsp_i ( mst_rsp_i )
  );

  // Remap addresses before routing to the slaves
  always_comb begin : remap_addresses
    // Last port (NumPorts - 1) is the external port, do not remap and route to ext as is
    for (int unsigned i = 0; i < NumRules; i++) begin
      mst_req_o[i] = mst_req_demuxed[i];
      mst_req_o[i].q.addr = mst_req_demuxed[i].q.addr & ~(addr_map_i[i].mask);
    end
    mst_req_o[NumPorts - 1] = mst_req_demuxed[NumPorts - 1];
  end

endmodule