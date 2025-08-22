// Copyright 2025 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE.solderpad for details.
// SPDX-License-Identifier: SHL-0.51
//
// Sergio Mazzola <smazzola@iis.ee.ethz.ch>

`include "hci_helpers.svh"

module hwpe_subsystem #(
  parameter int unsigned AddrWidth = 32,
  parameter int unsigned HwpeDataWidthFact = 4,
  parameter int unsigned PeriphIdWidth = 0,
  // Activation memory
  parameter int unsigned ActMemNumBanks = 16,
  parameter int unsigned ActMemNumBankWords = 128,
  parameter int unsigned ActMemNumElemWord = 4,
  parameter int unsigned ActMemElemWidth = 8,
  // AXI channels
  parameter type axi_aw_chan_t = logic,
  parameter type axi_w_chan_t = logic,
  parameter type axi_b_chan_t = logic,
  parameter type axi_ar_chan_t = logic,
  parameter type axi_r_chan_t = logic,
  // AXI req & resp
  parameter type axi_req_t = logic,
  parameter type axi_resp_t = logic,
  // Dependent parameters: do not modify!
  localparam int unsigned ActMemWordWidth = ActMemNumElemWord * ActMemElemWidth,
  localparam int unsigned HwpeDataWidth = ActMemWordWidth * HwpeDataWidthFact,
  localparam int unsigned ActMemAddrWidth = $clog2(ActMemNumBankWords)
)(
  input  logic clk_i,
  input  logic rst_ni,
  // Sensor interface (AXI slave)
  input  axi_req_t  axi_slv_req_i,
  output axi_resp_t axi_slv_rsp_o,
  // Peripheral slave port
  hwpe_ctrl_intf_periph.slave periph_slave
);

  ///////////////
  // Hw config //
  ///////////////

  localparam int unsigned NumHciPorts = 2; // Accelerator + Sensor interface
  localparam int unsigned HciIdWidth = NumHciPorts;

  //////////////////////////////
  // Activation mem & interco //
  //////////////////////////////

  // HWPE initiator
  localparam hci_package::hci_size_parameter_t `HCI_SIZE_PARAM(hci_initiator) = '{
    DW:  HwpeDataWidth,
    AW:  AddrWidth,
    BW:  ActMemElemWidth,
    UW:  hci_package::DEFAULT_UW,
    IW:  HciIdWidth,
    EW:  hci_package::DEFAULT_EW,
    EHW: hci_package::DEFAULT_EHW
  };
  `HCI_INTF_ARRAY(hci_initiator, clk_i, 0:1);

  // HWPE routed to mem
  localparam hci_package::hci_size_parameter_t `HCI_SIZE_PARAM(hci_mem_routed) = '{
    DW:  ActMemWordWidth,
    AW:  ActMemAddrWidth,
    BW:  ActMemElemWidth,
    UW:  hci_package::DEFAULT_UW,
    IW:  HciIdWidth,
    EW:  hci_package::DEFAULT_EW,
    EHW: hci_package::DEFAULT_EHW
  };
  `HCI_INTF_ARRAY(hci_mem_routed, clk_i, 0:ActMemNumBanks*NumHciPorts-1);

  // Activation memory target
  localparam hci_package::hci_size_parameter_t `HCI_SIZE_PARAM(hci_mem) = `HCI_SIZE_PARAM(hci_mem_routed);
  `HCI_INTF_ARRAY(hci_mem, clk_i, 0:ActMemNumBanks-1);

  /* Interconnect */

  // - 2 initiator ports (accelerator + sensor)
  // - routing of those ports to memory banks + arbitration
  // - ActMemNumBanks on the slave side

  for (genvar i = 0; i < NumHciPorts; i++) begin : gen_mem_router
    hci_router #(
      .FIFO_DEPTH ( 0 ),
      .NB_OUT_CHAN ( ActMemNumBanks ),
      .`HCI_SIZE_PARAM(in) ( `HCI_SIZE_PARAM(hci_initiator) ),
      .`HCI_SIZE_PARAM(out) ( `HCI_SIZE_PARAM(hci_mem_routed) )
    ) i_mem_router (
      .clk_i ( clk_i ),
      .rst_ni ( rst_ni ),
      .clear_i ( 1'b0 ),
      .in ( hci_initiator[i] ),
      .out ( hci_mem_routed[i*ActMemNumBanks:(i+1)*ActMemNumBanks-1] )
    );
  end

  localparam hci_package::hci_interconnect_ctrl_t HciArbConfig = '{
    arb_policy: 2'b0,
    invert_prio: 0,
    low_prio_max_stall: 8'b0
  };

  hci_arbiter_tree #(
    .NB_REQUESTS ( NumHciPorts ),
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
  // Sensor interface //
  //////////////////////

  // On HCI initiator port 1

  adapter_axi2hci #(
    .axi_aw_chan_t ( axi_aw_chan_t ),
    .axi_w_chan_t ( axi_w_chan_t ),
    .axi_b_chan_t ( axi_b_chan_t ),
    .axi_ar_chan_t ( axi_ar_chan_t ),
    .axi_r_chan_t ( axi_r_chan_t ),
    .axi_req_t ( axi_req_t ),
    .axi_resp_t ( axi_resp_t )
  ) i_axi2hci (
    .clk_i ( clk_i ),
    .rst_ni ( rst_ni ),
    .axi_slave_req_i ( axi_slv_req_i ),
    .axi_slave_resp_o ( axi_slv_rsp_o ),
    .tcdm_master ( hci_initiator[1] )
  );

  //////////
  // HWPE //
  //////////

  // On HCI initiator port 0

  datamover_top #(
    .ID ( PeriphIdWidth ),
    .BANDWIDTH ( HwpeDataWidth ),
    .NUM_ELEM_WORD ( ActMemNumElemWord ),
    .ELEM_WIDTH ( ActMemElemWidth ),
    .N_CORES ( 1 ),
    .N_CONTEXT ( 2 ),
    .MISALIGNED_ACCESSES ( 0 )
  ) i_datamover_top_wrap (
    .clk_i ( clk_i ),
    .rst_ni ( rst_ni ),
    .test_mode_i ( 1'b0 ),
    .evt_o ( /* Unconneccted */ ),
    // TCDM interface, to bind to HCI interface
    .tcdm ( hci_initiator[0] ),
    .periph ( periph_slave )
  );

  ///////////////////////
  // Activation memory //
  ///////////////////////

  for (genvar i = 0; i < ActMemNumBanks; i++) begin : gen_banks

    // With regular TCDM banks, the grant is always asserted
    assign hci_mem[i].gnt = 1'b1;

    //NOTE: For the HCI protocol, write enable is active-low

    `ifdef TARGET_WL_ACT_SCM
      // Generate standard-cell-based memory
      register_file_1r_1w_be #(
        .ADDR_WIDTH ( ActMemAddrWidth ),
        .DATA_WIDTH ( ActMemWordWidth ),
        .NUM_BYTE   ( ActMemNumElemWord )
      ) i_scm (
        .clk ( clk_i ),
        .ReadEnable ( hci_mem[i].req & hci_mem[i].wen ),
        .ReadAddr ( hci_mem[i].add[ActMemAddrWidth-1:$clog2(ActMemNumElemWord)] ),
        .ReadData ( hci_mem[i].r_data ),
        .WriteEnable ( hci_mem[i].req & ~hci_mem[i].wen ),
        .WriteAddr ( hci_mem[i].add[ActMemAddrWidth-1:$clog2(ActMemNumElemWord)] ),
        .WriteData ( hci_mem[i].data ),
        .WriteBE ( hci_mem[i].be )
      );

    `elsif TARGET_WL_ACT_SRAM
      // Generate SRAM cut
      tc_sram #(
        .NumWords ( ActMemNumBankWords ),
        .DataWidth ( DataWidth ),
        .ByteWidth ( ActMemWordWidth ),
        .NumPorts ( 32'd1 ),
        .Latency ( 32'd1 )
      ) i_sram (
        .clk_i ( clk_i ),
        .rst_ni ( rst_ni ),
        .req_i ( hci_mem[i].req ),
        .we_i ( ~hci_mem[i].wen ),
        .addr_i ( hci_mem[i].add[ActMemAddrWidth-1:$clog2(ActMemNumElemWord)] ),
        .wdata_i ( hci_mem[i].data ),
        .be_i ( hci_mem[i].be ),
        .rdata_o ( hci_mem[i].r_data )
      );

    `else
      $fatal(1, "[hwpe_subsystem] ERROR: No target memory type defined (no TARGET_WL_SCM nor TARGET_WL_SRAM)");
    `endif
  end

  ////////////////
  // Assertions //
  ////////////////

  `ifdef TARGET_SIMULATION
    initial begin
      check_hardcoded_aw: assert (AddrWidth == hci_package::DEFAULT_AW)
      else begin
        $error("[ASSERT FAILED] [%m] AddrWidth %0d (!= %0d) is not supported by datamover_top (%s:%0d)", AddrWidth, hci_package::DEFAULT_AW, `__FILE__, `__LINE__);
      end
    end
  `endif

endmodule
