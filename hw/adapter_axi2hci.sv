// Copyright 2025 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE.solderpad for details.
// SPDX-License-Identifier: SHL-0.51
//
// Sergio Mazzola <smazzola@iis.ee.ethz.ch>

module adapter_axi2hci #(
  // AXI channels
  parameter type axi_aw_chan_t = logic,
  parameter type  axi_w_chan_t = logic,
  parameter type  axi_b_chan_t = logic,
  parameter type axi_ar_chan_t = logic,
  parameter type  axi_r_chan_t = logic,
  // AXI req/resp
  parameter type axi_req_t  = logic,
  parameter type axi_resp_t = logic
)(
  input  logic            clk_i,
  input  logic            rst_ni,
  input  axi_req_t        axi_slave_req_i,
  output axi_resp_t       axi_slave_resp_o,
  hci_core_intf.initiator tcdm_master
);
  localparam int unsigned AxiAddrWidth = $bits(axi_slave_req_i.aw.addr);
  localparam int unsigned AxiDataWidth = $bits(axi_slave_req_i.w.data);
  localparam int unsigned AxiIdWidth   = $bits(axi_slave_req_i.aw.id);
  localparam int unsigned AxiUserWidth = $bits(axi_slave_req_i.w.data);

  axi_req_t  axi_slave_req_cut;
  axi_resp_t axi_slave_resp_cut;

  // axi_to_mem requires AW and W channels to be valid at the same time
  // This is not compliant with AXI spec: we use axi_cut to patch this
  axi_cut #(
    .BypassAw ( 1'b0 ),
    .BypassW ( 1'b1 ),
    .BypassB ( 1'b1 ),
    .BypassAr ( 1'b1 ),
    .BypassR ( 1'b1 ),
    .aw_chan_t ( axi_aw_chan_t ),
    .w_chan_t ( axi_w_chan_t ),
    .b_chan_t ( axi_b_chan_t ),
    .ar_chan_t ( axi_ar_chan_t ),
    .r_chan_t ( axi_r_chan_t ),
    .axi_req_t ( axi_req_t ),
    .axi_resp_t ( axi_resp_t )
  ) i_axi_cut (
    .clk_i ( clk_i ),
    .rst_ni ( rst_ni ),
    .slv_req_i ( axi_slave_req_i ),
    .slv_resp_o ( axi_slave_resp_o ),
    .mst_req_o ( axi_slave_req_cut ),
    .mst_resp_i ( axi_slave_resp_cut )
  );

  logic                      mem_req;
  logic                      mem_gnt;
  logic [AxiAddrWidth-1:0]   mem_addr;
  logic [AxiDataWidth-1:0]   mem_wdata;
  logic [AxiDataWidth/8-1:0] mem_strb;
  logic                      mem_we;
  logic                      mem_rvalid;
  logic [AxiDataWidth-1:0]   mem_rdata;

  axi_to_mem #(
    .axi_req_t ( axi_req_t ),
    .axi_resp_t ( axi_resp_t ),
    .AddrWidth ( AxiAddrWidth ),
    .DataWidth ( AxiDataWidth ),
    .IdWidth ( AxiIdWidth ),
    .NumBanks ( 1 ),
    .BufDepth ( 1 ),
    .HideStrb ( 0 ),
    .OutFifoDepth ( 1 )
  ) i_bus_instr_mem_axi_to_mem (
    .clk_i ( clk_i ),
    .rst_ni ( rst_ni ),
    .busy_o ( /* Unconnected */ ),
    .axi_req_i ( axi_slave_req_cut ),
    .axi_resp_o ( axi_slave_resp_cut ),
    .mem_req_o ( mem_req ),
    .mem_gnt_i ( mem_gnt ),
    // Byte address in memory of the request
    .mem_addr_o ( mem_addr ),
    .mem_wdata_o ( mem_wdata ),
    .mem_strb_o ( mem_strb ),
    .mem_atop_o ( /* Unconnected */ ),
    .mem_we_o ( mem_we ),
    // This module expects always a response valid for a request regardless of r/w
    .mem_rvalid_i ( mem_rvalid ),
    /// Memory stream master, read response data.
    .mem_rdata_i ( mem_rdata )
  );

  assign tcdm_master.req      = mem_req;
  assign tcdm_master.add      = mem_addr;
  assign tcdm_master.wen      = ~mem_we;
  assign tcdm_master.data     = mem_wdata;
  assign tcdm_master.be       = mem_strb;
  assign tcdm_master.r_ready  = '1;
  assign tcdm_master.user     = '0;
  assign tcdm_master.id       = '0;
  assign tcdm_master.ecc      = '0;
  assign tcdm_master.ereq     = '0;
  assign tcdm_master.r_eready = '1;

  assign mem_gnt    = tcdm_master.gnt;
  assign mem_rdata  = tcdm_master.r_data;
  assign mem_rvalid = tcdm_master.r_valid;
  // unused from tcdm_master
  // - tcdm_master.r_user
  // - tcdm_master.r_id
  // - tcdm_master.r_opc
  // - tcdm_master.r_ecc
  // - tcdm_master.egnt
  // - tcdm_master.r_evalid

endmodule
