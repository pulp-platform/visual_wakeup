// Copyright 2025 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE.solderpad for details.
// SPDX-License-Identifier: SHL-0.51
//
// Sergio Mazzola <smazzola@iis.ee.ethz.ch>

`include "hci_helpers.svh"

module hwpe_subsystem #(
  parameter int unsigned DataWidth = 32,
  parameter int unsigned AddrWidth = 32,
  parameter int unsigned WidePortFact = 4,
  parameter int unsigned PeriphIdWidth = 0,
  // Activation memory
  parameter int unsigned ActMemNumBanks = 16,
  parameter int unsigned ActMemNumBankWords = 128,
  parameter int unsigned ActMemWordWidth = DataWidth,
  // AXI channels
  parameter type axi_aw_cam_chan_t = logic,
  parameter type  axi_w_cam_chan_t = logic,
  parameter type  axi_b_cam_chan_t = logic,
  parameter type axi_ar_cam_chan_t = logic,
  parameter type  axi_r_cam_chan_t = logic,
  // AXI req & resp
  parameter type axi_cam_req_t  = logic,
  parameter type axi_cam_resp_t = logic,
  // Dependent parameters: do not modify!
  localparam int unsigned HwpeDataWidth = DataWidth * WidePortFact,
  parameter int unsigned ActMemAddrWidth = $clog2(ActMemNumBankWords) + 2 // bank 4-byte words + 2 LSBs for bytes
)(
  input  logic clk_i,
  input  logic rst_ni,
  // Camera sensor interface (AXI slave)
  input  axi_cam_req_t  axi_cam_slv_req_i,
  output axi_cam_resp_t axi_cam_slv_rsp_o,
  // Peripheral slave port
  hwpe_ctrl_intf_periph.slave periph_slave
);

  ///////////////
  // Hw config //
  ///////////////

  localparam int unsigned NumHwpe = 2; // Accelerator + Camera interface

  localparam int unsigned HciByteWidth = 8;
  localparam int unsigned HciIdWidth = 2; // HWPE + Camera port

  //////////////////////////////
  // Activation mem & interco //
  //////////////////////////////

  // HWPE initiator
  localparam hci_package::hci_size_parameter_t `HCI_SIZE_PARAM(hci_hwpe) = '{
    DW:  HwpeDataWidth,
    AW:  AddrWidth,
    BW:  HciByteWidth,
    UW:  hci_package::DEFAULT_UW,
    IW:  HciIdWidth,
    EW:  hci_package::DEFAULT_EW,
    EHW: hci_package::DEFAULT_EHW
  };
  `HCI_INTF_ARRAY(hci_hwpe, clk_i, 0:1);

  // HWPE routed to mem
  localparam hci_package::hci_size_parameter_t `HCI_SIZE_PARAM(hci_mem_routed) = '{
    DW:  ActMemWordWidth,
    AW:  ActMemAddrWidth,
    BW:  HciByteWidth,
    UW:  hci_package::DEFAULT_UW,
    IW:  HciIdWidth,
    EW:  hci_package::DEFAULT_EW,
    EHW: hci_package::DEFAULT_EHW
  };
  `HCI_INTF_ARRAY(hci_mem_routed, clk_i, 0:ActMemNumBanks*NumHwpe-1);

  // Activation memory target
  localparam hci_package::hci_size_parameter_t `HCI_SIZE_PARAM(hci_mem) = '{
    DW:  ActMemWordWidth,
    AW:  ActMemAddrWidth,
    BW:  HciByteWidth,
    UW:  hci_package::DEFAULT_UW,
    IW:  HciIdWidth,
    EW:  hci_package::DEFAULT_EW,
    EHW: hci_package::DEFAULT_EHW
  };
  `HCI_INTF_ARRAY(hci_mem, clk_i, 0:ActMemNumBanks-1);

  /* Interconnect */

  // - 2 wide ports (accelerator + camera)
  // - routing of those ports to memory banks + arbitration
  // - ActMemNumBanks on the slave side

  for (genvar i = 0; i < NumHwpe; i++) begin : gen_mem_router
    hci_router #(
      .FIFO_DEPTH ( 0 ),
      .NB_OUT_CHAN ( ActMemNumBanks ),
      .`HCI_SIZE_PARAM(in) ( `HCI_SIZE_PARAM(hci_hwpe) ),
      .`HCI_SIZE_PARAM(out) ( `HCI_SIZE_PARAM(hci_mem_routed) )
    ) i_mem_router (
      .clk_i ( clk_i ),
      .rst_ni ( rst_ni ),
      .clear_i ( 1'b0 ),
      .in ( hci_hwpe[i] ),
      .out ( hci_mem_routed[i*ActMemNumBanks:(i+1)*ActMemNumBanks-1] )
    );
  end

  localparam hci_package::hci_interconnect_ctrl_t HciArbConfig = '{
    arb_policy: 2'b0,
    invert_prio: 0,
    low_prio_max_stall: 8'b0
  };

  hci_arbiter_tree #(
    .NB_REQUESTS ( NumHwpe ),
    .NB_CHAN ( ActMemNumBanks ),
    .`HCI_SIZE_PARAM(out)( `HCI_SIZE_PARAM(hci_mem_routed) )
  ) i_mem_arbiter_tree (
    .clk_i ( clk_i ),
    .rst_ni ( rst_ni ),
    .clear_i ( 1'b0 ),
    .ctrl_i ( HciArbConfig ),
    .in ( hci_mem_routed ),
    .out ( hci_mem )
  );

  //////////////////////
  // Camera interface //
  //////////////////////

  adapter_axi2hci #(
    .axi_aw_chan_t ( axi_aw_cam_chan_t ),
    .axi_w_chan_t ( axi_w_cam_chan_t ),
    .axi_b_chan_t ( axi_b_cam_chan_t ),
    .axi_ar_chan_t ( axi_ar_cam_chan_t ),
    .axi_r_chan_t ( axi_r_cam_chan_t ),
    .axi_req_t ( axi_cam_req_t ),
    .axi_resp_t ( axi_cam_resp_t )
  ) i_axi2hci (
    .clk_i ( clk_i ),
    .rst_ni ( rst_ni ),
    .axi_slave_req_i ( axi_cam_slv_req_i ),
    .axi_slave_resp_o ( axi_cam_slv_rsp_o ),
    .tcdm_master ( hci_hwpe[1] )
  );

  //////////
  // HWPE //
  //////////

  logic [WidePortFact-1:0]                tcdm_req;
  logic [WidePortFact-1:0]                tcdm_gnt;
  logic [WidePortFact-1:0][AddrWidth-1:0] tcdm_add;
  logic [WidePortFact-1:0]                tcdm_wen;
  logic [WidePortFact-1:0][3:0]           tcdm_be;
  logic [WidePortFact-1:0][DataWidth-1:0] tcdm_data;
  logic [WidePortFact-1:0][DataWidth-1:0] tcdm_r_data;
  logic [WidePortFact-1:0]                tcdm_r_valid;

  assign hci_hwpe[0].req      = tcdm_req[0]; // req is the same for all WidePortFact ports
  assign hci_hwpe[0].add      = tcdm_add[0]; // we need only the base address of the request
  assign hci_hwpe[0].wen      = tcdm_wen[0]; // wen is the same for all ports
  assign hci_hwpe[0].r_ready  = 1'b1;
  assign hci_hwpe[0].user     = '0;
  assign hci_hwpe[0].id       = '0;
  assign hci_hwpe[0].ecc      = '0;
  assign hci_hwpe[0].ereq     = '0;
  assign hci_hwpe[0].r_eready = '0;

  generate
    for(genvar i = 0; i < WidePortFact; i++) begin: gen_multiport_bindings
      assign hci_hwpe[0].data[(i+1)*DataWidth-1:i*DataWidth] = tcdm_data[i];
      assign hci_hwpe[0].be[i*4+3:i*4] = tcdm_be[i];
      assign tcdm_r_data[i] = hci_hwpe[0].r_data[(i+1)*DataWidth-1:i*DataWidth];
      assign tcdm_gnt[i] = hci_hwpe[0].gnt;
      assign tcdm_r_valid[i] = hci_hwpe[0].r_valid;
    end
  endgenerate

  // inside datamover_top_wrap:
  // DataWidth and AddrWidth hardcoded to 32
  datamover_top_wrap #(
    .MP ( WidePortFact ),
    .ID ( PeriphIdWidth )
  ) i_datamover_top_wrap (
    .clk_i ( clk_i ),
    .rst_ni ( rst_ni ),
    .test_mode_i ( 1'b0 ),
    .evt_o ( /* Unconneccted */ ),
    // TCDM interface, to bind to HCI interface
    .tcdm_req ( tcdm_req ),
    .tcdm_gnt ( tcdm_gnt ),
    .tcdm_add ( tcdm_add ),
    .tcdm_wen ( tcdm_wen ),
    .tcdm_be ( tcdm_be ),
    .tcdm_data ( tcdm_data ),
    .tcdm_r_data ( tcdm_r_data ),
    .tcdm_r_valid ( tcdm_r_valid ),
    // Peripheral interface for config
    .periph_req ( periph_slave.req ),
    .periph_gnt ( periph_slave.gnt ),
    .periph_add ( periph_slave.add ),
    .periph_wen ( periph_slave.wen ),
    .periph_be ( periph_slave.be ),
    .periph_data ( periph_slave.data ),
    .periph_id ( periph_slave.id ),
    .periph_r_data ( periph_slave.r_data ),
    .periph_r_valid ( periph_slave.r_valid ),
    .periph_r_id ( periph_slave.r_id )
  );

  ///////////////////////
  // Activation memory //
  ///////////////////////

  for (genvar i = 0; i < ActMemNumBanks; i++) begin : banks_gen

    // With regular TCDM banks, the grant is always asseterd
    assign hci_mem[i].gnt = 1'b1;

    register_file_1r_1w_be #(
      .ADDR_WIDTH ( $clog2(ActMemNumBankWords) ),
      .DATA_WIDTH ( DataWidth ),
      .NUM_BYTE   ( DataWidth / 8 )
    ) i_scm (
      .clk ( clk_i ),
      .ReadEnable ( hci_mem[i].req & hci_mem[i].wen ),
      .ReadAddr ( hci_mem[i].add[$clog2(ActMemNumBankWords)+2-1:2] ),
      .ReadData ( hci_mem[i].r_data ),
      .WriteEnable ( hci_mem[i].req & ~hci_mem[i].wen ),
      .WriteAddr ( hci_mem[i].add[$clog2(ActMemNumBankWords)+2-1:2] ),
      .WriteData ( hci_mem[i].data ),
      .WriteBE ( hci_mem[i].be )
    );

  end

  ////////////////
  // Assertions //
  ////////////////

  `ifdef TARGET_VWU_TEST
    initial begin
      check_hardcoded_dw: assert (DataWidth == 32)
      else begin
        $error("[ASSERT FAILED] [%m] DataWidth %0d (!= %0d) is not supported by datamover_top_wrap (%s:%0d)", DataWidth, 32, `__FILE__, `__LINE__);
      end
      check_hardcoded_aw: assert (AddrWidth == 32)
      else begin
        $error("[ASSERT FAILED] [%m] AddrWidth %0d (!= %0d) is not supported by datamover_top_wrap (%s:%0d)", AddrWidth, 32, `__FILE__, `__LINE__);
      end
    end
  `endif

endmodule
