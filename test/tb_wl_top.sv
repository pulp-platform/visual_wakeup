// Copyright 2025 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE.solderpad for details.
// SPDX-License-Identifier: SHL-0.51
//
// Sergio Mazzola <smazzola@iis.ee.ethz.ch>

`include "axi/assign.svh"

module tb_wl_top
  import wl_pkg::*;
#()();

  //////////////////////
  // Testbench config //
  //////////////////////

  localparam time ClkPeriod = 10ns;
  localparam time TbTA = 2ns;
  localparam time TbTT = 8ns;

  localparam int ActMemNumBytesInit = 2048;

  //
  //  s_clk                             .--------.    .------------------- axi_lite_drv2xbar
  // s_rst_n                            |        |    |                   (axi_lite_tb_driver)
  //  s_irq                             |      __v____v__  (masters)
  //    |                               |     | AXI Lite |
  //    |                               |     | Tb Xbar  |
  //  __v__                             |     |__________| (slaves)
  // |     |--- AXI Lite master --------'        |    |                        _______________
  // | DUT |<-- AXI Lite slave ------------------'    '------[ Adapter ]----> | Tb Sim memory |
  // |_____|<-- AXI slave ---------.                                          |_______________|
  //    |                          |
  //    |                          |
  //    v                    axi_tb2dut_req
  //  s_eoc                  axi_tb2dut_rsp
  //                         (axi_tb_driver)
  //                        

  ////////////////////////////
  // Clock/reset generation //
  ////////////////////////////

  logic s_clk;
  logic s_rst_n;

  clk_rst_gen #(
      .ClkPeriod ( ClkPeriod ),
      .RstClkCycles ( 5 )
  ) i_clk_gen (
      .clk_o ( s_clk ),
      .rst_no( s_rst_n )
  );

  ////////////////////////
  // AXI Lite Tb driver //
  ////////////////////////

  // AXI Lite testbench master driver
  AXI_LITE #(
    .AXI_ADDR_WIDTH ( AxiLiteAddrWidth ),
    .AXI_DATA_WIDTH ( AxiLiteDataWidth )
  ) axi_lite_drv2xbar ();

  AXI_LITE_DV #(
    .AXI_ADDR_WIDTH ( AxiLiteAddrWidth ),
    .AXI_DATA_WIDTH ( AxiLiteDataWidth )
  ) axi_lite_drv2xbar_dv (s_clk);

  `AXI_LITE_ASSIGN(axi_lite_drv2xbar, axi_lite_drv2xbar_dv)

  axi_test::axi_lite_driver #(
    .AW( AxiLiteAddrWidth ),
    .DW( AxiLiteDataWidth ),
    .TA ( TbTA ),
    .TT ( TbTT )
  ) axi_lite_tb_driver = new(axi_lite_drv2xbar_dv);

  // Specialized AXI Lite function that sends AW and W transactions in the same cycle
  // (normally you would first handshake AW, then W), because the AXI2mem adapter used
  // for the instruction and data memories expects it in this way
  task axi_lite_send_aw_w (
    // AXI driver
    input axi_test::axi_lite_driver #(
      .AW ( AxiLiteAddrWidth ),
      .DW ( AxiLiteDataWidth ),
      .TA ( TbTA ),
      .TT ( TbTT )
    ) axi_drv,
    // AW
    input logic [AxiLiteAddrWidth-1:0] addr,
    input axi_pkg::prot_t              prot,
    // W
    input logic [AxiLiteDataWidth-1:0]   data,
    input logic [AxiLiteDataWidth/8-1:0] strb
  );
    axi_drv.axi.aw_addr  <= #axi_drv.TA addr;
    axi_drv.axi.aw_prot  <= #axi_drv.TA prot;
    axi_drv.axi.aw_valid <= #axi_drv.TA 1;
    axi_drv.axi.w_data  <= #axi_drv.TA data;
    axi_drv.axi.w_strb  <= #axi_drv.TA strb;
    axi_drv.axi.w_valid <= #axi_drv.TA 1;
    axi_drv.cycle_start();
    while (axi_drv.axi.w_ready != 1) begin axi_drv.cycle_end(); axi_drv.cycle_start(); end
    axi_drv.cycle_end();
    axi_drv.axi.aw_addr  <= #axi_drv.TA '0;
    axi_drv.axi.aw_prot  <= #axi_drv.TA '0;
    axi_drv.axi.aw_valid <= #axi_drv.TA 0;
    axi_drv.axi.w_data  <= #axi_drv.TA '0;
    axi_drv.axi.w_strb  <= #axi_drv.TA '0;
    axi_drv.axi.w_valid <= #axi_drv.TA 0;
  endtask

  ////////////////////////
  // DUT AXI Lite buses //
  ////////////////////////

  // AXI Lite master port of DUT
  AXI_LITE #(
    .AXI_ADDR_WIDTH ( AxiLiteAddrWidth ),
    .AXI_DATA_WIDTH ( AxiLiteDataWidth )
  ) axi_lite_dut2tb ();

  axi_lite_req_t axi_lite_dut2tb_req;
  axi_lite_resp_t axi_lite_dut2tb_rsp;

  `AXI_LITE_ASSIGN_FROM_REQ(axi_lite_dut2tb, axi_lite_dut2tb_req)
  `AXI_LITE_ASSIGN_TO_RESP(axi_lite_dut2tb_rsp, axi_lite_dut2tb)

  // AXI Lite slave port of DUT
  AXI_LITE #(
    .AXI_ADDR_WIDTH ( AxiLiteAddrWidth ),
    .AXI_DATA_WIDTH ( AxiLiteDataWidth )
  ) axi_lite_tb2dut ();

  axi_lite_req_t axi_lite_tb2dut_req;
  axi_lite_resp_t axi_lite_tb2dut_rsp;
  
  `AXI_LITE_ASSIGN_TO_REQ(axi_lite_tb2dut_req, axi_lite_tb2dut)
  `AXI_LITE_ASSIGN_FROM_RESP(axi_lite_tb2dut, axi_lite_tb2dut_rsp)

  ////////////////////
  // AXI Sim memory //
  ////////////////////

  AXI_LITE #(
    .AXI_ADDR_WIDTH ( AxiLiteAddrWidth ),
    .AXI_DATA_WIDTH ( AxiLiteDataWidth )
  ) axi_lite_xbar2mem ();

  AXI_BUS #(
    .AXI_ADDR_WIDTH ( AxiLiteAddrWidth ),
    .AXI_DATA_WIDTH ( AxiLiteDataWidth ),
    .AXI_ID_WIDTH ( 32'd1 ),
    .AXI_USER_WIDTH ( 32'd1 )
  ) axi_xbar2mem ();

  axi_lite_to_axi_intf #(
    .AXI_DATA_WIDTH ( AxiLiteDataWidth )
  ) i_sim_mem_axilite_to_axi (
    .in ( axi_lite_xbar2mem ),
    .slv_aw_cache_i ( '0 ),
    .slv_ar_cache_i ( '0 ),
    .out ( axi_xbar2mem )
  );

  //NOTE: As defined in TbXbarAddrMap, the memory range of the Tb sim memory is fragmented.
  //      In particular, the addressed of the sim memory between `wl_pkg::InstrMemBaseAddr`
  //      and `wl_pkg::DataMemBaseAddr + wl_pkg::DataMemOffset` cannot be accessed. A remap
  //      would fix this but since the sim memory is infinite, a remap is not necessary and
  //      would complicate debugging.

  axi_sim_mem_intf #(
    .AXI_ADDR_WIDTH ( AxiLiteAddrWidth ),
    .AXI_DATA_WIDTH ( AxiLiteDataWidth ),
    .AXI_ID_WIDTH ( 32'd1 ),
    .AXI_USER_WIDTH ( 32'd1 ),
    .APPL_DELAY ( TbTA ),
    .ACQ_DELAY ( TbTT )
  ) i_tb_sim_mem (
    .clk_i ( s_clk ),
    .rst_ni ( s_rst_n ),
    .axi_slv ( axi_xbar2mem ),
    .mon_w_valid_o ( /* Unconnected */ ),
    .mon_w_addr_o ( /* Unconnected */ ),
    .mon_w_data_o ( /* Unconnected */ ),
    .mon_w_id_o ( /* Unconnected */ ),
    .mon_w_user_o ( /* Unconnected */ ),
    .mon_w_beat_count_o ( /* Unconnected */ ),
    .mon_w_last_o ( /* Unconnected */ ),
    .mon_r_valid_o ( /* Unconnected */ ),
    .mon_r_addr_o ( /* Unconnected */ ),
    .mon_r_data_o ( /* Unconnected */ ),
    .mon_r_id_o ( /* Unconnected */ ),
    .mon_r_user_o ( /* Unconnected */ ),
    .mon_r_beat_count_o ( /* Unconnected */ ),
    .mon_r_last_o ( /* Unconnected */ )
  );

  //////////
  // Xbar //
  //////////

  /* Masters */
  // 0. from AXI Lite master driver of testbench
  // 1. from AXI Lite master port of DUT
  localparam int unsigned TbXbarNumMasters = 2;

  /* Slaves */
  // 0. to testbench memory
  // 1. to AXI Lite slave port of DUT
  localparam int unsigned TbXbarNumSlaves = 2;

  // Routing rules
  localparam int unsigned TbXbarNumRules = TbXbarNumSlaves + 1; // +1 for "everything above DUT"
  typedef axi_pkg::xbar_rule_32_t tb_xbar_rule_t;
  localparam tb_xbar_rule_t [TbXbarNumRules-1:0] TbXbarAddrMap = '{
    '{ // Tb sim memory (everything above DUT memory)
        idx: 32'd0, // to Tb sim memory
        start_addr: wl_pkg::DataMemBaseAddr + wl_pkg::DataMemOffset,
        end_addr: 32'hFFFF_FFFF
    },
    '{ // DUT memory range
        idx: 32'd1, // route to AXI Lite slave port of DUT
        // Only pick the range actually addressable from outside
        start_addr: wl_pkg::InstrMemBaseAddr,
        end_addr: wl_pkg::DataMemBaseAddr + wl_pkg::DataMemOffset
    },
    '{ // Tb sim memory (everything below DUT memory)
        idx: 32'd0, // to Tb sim memory
        start_addr: 32'h0000_0000,
        end_addr: wl_pkg::InstrMemBaseAddr
    }
  };

  // Xbar config
  localparam axi_pkg::xbar_cfg_t TbXbarCfg = '{
    NoSlvPorts:     TbXbarNumMasters,
    NoMstPorts:     TbXbarNumSlaves,
    MaxMstTrans:    32'd5,
    MaxSlvTrans:    32'd2,
    FallThrough:    1'b0,
    // Cut all channels of all slave ports to prevent
    // combinational loop with the insides of the DUT
    LatencyMode:    axi_pkg::CUT_SLV_PORTS,
    PipelineStages: 32'd0,
    AxiAddrWidth:   AxiLiteAddrWidth,
    AxiDataWidth:   AxiLiteDataWidth,
    NoAddrRules:    TbXbarNumRules,
    default:        '0
  };

  // Xbar masters
  AXI_LITE #(
    .AXI_ADDR_WIDTH ( AxiLiteAddrWidth ),
    .AXI_DATA_WIDTH ( AxiLiteDataWidth )
  ) tb_xbar_in [TbXbarNumMasters-1:0] ();
  // 0. from AXI Lite master driver of testbench
  `AXI_LITE_ASSIGN(tb_xbar_in[0], axi_lite_drv2xbar)
  // 1. from AXI Lite master port of DUT
  `AXI_LITE_ASSIGN(tb_xbar_in[1], axi_lite_dut2tb)

  // Xbar slaves
  AXI_LITE #(
    .AXI_ADDR_WIDTH ( AxiLiteAddrWidth ),
    .AXI_DATA_WIDTH ( AxiLiteDataWidth )
  ) tb_xbar_out [TbXbarNumSlaves-1:0] ();
  // 0. to testbench memory
  `AXI_LITE_ASSIGN(axi_lite_xbar2mem, tb_xbar_out[0])
  // 1. to AXI Lite slave port of DUT
  `AXI_LITE_ASSIGN(axi_lite_tb2dut, tb_xbar_out[1])

  axi_lite_xbar_intf #(
    .Cfg ( TbXbarCfg ),
    .rule_t ( tb_xbar_rule_t )
  ) i_tbxbar (
    .clk_i ( s_clk ),
    .rst_ni ( s_rst_n ),
    .test_i ( 1'b0 ),
    .slv_ports ( tb_xbar_in ),
    .mst_ports ( tb_xbar_out ),
    .addr_map_i ( TbXbarAddrMap ),
    // disable default master port for all slave ports
    .en_default_mst_port_i ( '0 ),
    .default_mst_port_i ( '0 )
  );

  ////////////////////////////
  // AXI Tb driver (sensor) //
  ////////////////////////////

  // AXI master bus for sensor
  AXI_BUS #(
    .AXI_ADDR_WIDTH ( AxiAddrWidth ),
    .AXI_DATA_WIDTH ( AxiDataWidth ),
    .AXI_ID_WIDTH   ( AxiSlvIdWidth ),
    .AXI_USER_WIDTH ( AxiUserWidth )
  ) axi_tb2dut ();

  axi_req_t axi_tb2dut_req;
  axi_resp_t axi_tb2dut_rsp;

  `AXI_ASSIGN_TO_REQ(axi_tb2dut_req, axi_tb2dut)
  `AXI_ASSIGN_FROM_RESP(axi_tb2dut, axi_tb2dut_rsp)

  // AXI driver for sensor
  AXI_BUS_DV #(
    .AXI_ADDR_WIDTH ( AxiAddrWidth ),
    .AXI_DATA_WIDTH ( AxiDataWidth ),
    .AXI_ID_WIDTH   ( AxiSlvIdWidth ),
    .AXI_USER_WIDTH ( AxiUserWidth )
  ) axi_tb2dut_dv (s_clk);

  `AXI_ASSIGN(axi_tb2dut, axi_tb2dut_dv)

  axi_test::axi_driver #(
    .AW ( AxiAddrWidth ),
    .DW ( AxiDataWidth ),
    .IW ( AxiSlvIdWidth ),
    .UW ( AxiUserWidth ),
    .TA ( TbTA ),
    .TT ( TbTT )
  ) axi_tb_driver = new(axi_tb2dut_dv);

  typedef axi_test::axi_ax_beat #(.AW(AxiAddrWidth), .IW(AxiSlvIdWidth), .UW(AxiUserWidth)) aw_beat_t;
  typedef axi_test::axi_w_beat #(.DW(AxiDataWidth), .UW(AxiUserWidth)) w_beat_t;
  typedef axi_test::axi_b_beat #(.IW(AxiSlvIdWidth), .UW(AxiUserWidth)) b_beat_t;

  /////////
  // Dut //
  /////////

  logic s_irq;
  logic [DataWidth-1:0] s_eoc;

  `ifdef TARGET_ASIC wl_top_wrap `else wl_top `endif
    #() dut (
      .clk_i ( s_clk ),
      .rst_ni ( s_rst_n ),
      .axi_lite_slv_req_i ( axi_lite_tb2dut_req ),
      .axi_lite_slv_rsp_o ( axi_lite_tb2dut_rsp ),
      .axi_lite_mst_req_o ( axi_lite_dut2tb_req ),
      .axi_lite_mst_rsp_i ( axi_lite_dut2tb_rsp ),
      .irq_i ( s_irq ),
      .eoc_o ( s_eoc ),
      .axi_slv_req_i ( axi_tb2dut_req ),
      .axi_slv_rsp_o ( axi_tb2dut_rsp )
    );

  //////////
  // Test //
  //////////

  initial begin
    int file, ret;
    int w_num;
    string app_base, instr_mem_bin, data_mem_bin;
    logic [AddrWidth-1:0] address;
    logic [DataWidth-1:0] data;
    automatic axi_pkg::resp_t resp;
    automatic logic rand_success;

    /* Reset */

    // Reset master-side AXI Lite
    axi_lite_tb_driver.reset_master();
    // Reset remaining tb-driven signals
    s_irq = 1'b0;
    // Reset sensor AXI interface
    axi_tb_driver.reset_master();

    // Wait for reset to be released
    @(posedge s_rst_n);

    fork
      begin
        // Retrieve binary names starting from app basename
        // binary name specified with the `+bin=...` argument
        if (!$value$plusargs("bin=%s", app_base)) begin
          $fatal(1, "[TB] ERROR: No +bin=... argument specified");
        end
        instr_mem_bin = {app_base, ".instr_mem.bin"};
        data_mem_bin = {app_base, ".data_mem.bin"};

        /*  Preload instruction memory */

        $display("[TB] Flashing instruction memory from: %s", instr_mem_bin);
        file = $fopen(instr_mem_bin, "rb");
        if (!file) begin
          $fatal(1, "[TB] ERROR: Failed to open %s", instr_mem_bin);
        end

        w_num = 0;
        address = InstrMemBaseAddr;
        while (!$feof(file)) begin
          // Expects packed binary file
          ret = $fread(data, file);
          if (ret == 0) begin
            continue;
          end else if (ret != 4) begin
            $fatal("[TB] ERROR: Partial read (%0d bytes), aborting", ret);
          end
          // Reverse endianness (byte swap)
          data = {data[7:0], data[15:8], data[23:16], data[31:24]};
          // Send AXI Lite transaction
          axi_lite_send_aw_w(axi_lite_tb_driver, address, axi_pkg::prot_t'('0), data, '1);
          axi_lite_tb_driver.recv_b(resp);
          w_num++;
          address +=4 ; // go to next word
        end
        $fclose(file);

        $info("[TB] Application flash complete. %0d words loaded in instruction memory.", w_num);

        /* Preload data memory */

        $display("[TB] Flashing data memory from: %s", data_mem_bin);
        file = $fopen(data_mem_bin, "rb");
        if (!file) begin
          $fatal(1, "[TB] ERROR: Failed to open %s", data_mem_bin);
        end

        w_num = 0;
        address = DataMemBaseAddr;
        while (!$feof(file)) begin
          // Expects packed binary file
          ret = $fread(data, file);
          if (ret == 0) begin
            continue;
          end else if (ret != 4) begin
            $fatal("[TB] ERROR: Partial read (%0d bytes), aborting", ret);
          end
          // Reverse endianness (byte swap)
          data = {data[7:0], data[15:8], data[23:16], data[31:24]};
          // Send AXI Lite transaction
          axi_lite_send_aw_w(axi_lite_tb_driver, address, axi_pkg::prot_t'('0), data, '1);
          axi_lite_tb_driver.recv_b(resp);
          w_num++;
          address +=4 ; // go to next word
        end
        $fclose(file);

        $info("[TB] Data flash complete. %0d words loaded in SPM.", w_num);

        // Reset AXI Lite interface again
        axi_lite_tb_driver.reset_master();
        @(posedge s_clk);
      end
      begin

        automatic aw_beat_t aw_beat = new();
        automatic w_beat_t w_beat = new();
        automatic b_beat_t b_beat = new();

        /* Preload activation memory */

        $display("[TB] Flashing activation memory with random data.");

        // Exploit AXI interface dedicated to sensor

        aw_beat.ax_id    = '0;
        aw_beat.ax_addr  = '0; // start from address 0 of activation memory
        aw_beat.ax_len   = ActMemNumBytesInit/(AxiDataWidth/8) - 1; // number of beats required - 1
        aw_beat.ax_size  = $clog2(AxiDataWidth/8); // port width
        aw_beat.ax_burst = 2'b01; // INCR burst
        axi_tb_driver.send_aw(aw_beat);

        for (int i = 0; i < ActMemNumBytesInit/(AxiDataWidth/8); i++) begin
          // Generate random data for activation memory
          rand_success = std::randomize(w_beat.w_data); assert(rand_success);
          w_beat.w_strb = '1; // write all bytes
          if (i == ActMemNumBytesInit/(AxiDataWidth/8) - 1) begin
            w_beat.w_last = 1'b1; // last beat
          end else begin
            w_beat.w_last = 1'b0;
          end
          w_beat.w_user = '0;
          axi_tb_driver.send_w(w_beat);
        end
        // Wait for the last beat to be acknowledged
        axi_tb_driver.recv_b(b_beat);

        $info("[TB] Activation memory flash complete. %0d bytes loaded in SPM.", ActMemNumBytesInit);

        axi_tb_driver.reset_master();
        @(posedge s_clk);
      end
    join

    /* Start program execution */

    // Wait for Snitch to complete bootrom execution
    // (Snitch goes into wfi when bootrom execution is completed)
    `ifndef TARGET_ASIC
      //TODO: What happens if we launch interrupt before bootrom is done?
      //TODO: This is purely behavioral, will not work for asic target
      if (!dut.i_core_subsystem.i_snitch.wfi_q) begin
        $display("[TB] Waiting for bootrom to complete...");
        @(posedge dut.i_core_subsystem.i_snitch.wfi_q);
      end
    `endif
    repeat (5) @(posedge s_clk);
    // Send wake-up meip interrupt
    s_irq = #TbTA 1'b1;
    @(posedge s_clk);
    s_irq = #TbTA 1'b0;

    /* Wait for EOC register */

    $timeformat(-9, 2, " ns", 0);
    while (1) begin
      @(posedge s_clk);
      #TbTT;
      if (s_eoc[0] == 1'b1) begin
        data = {s_eoc[DataWidth-1], s_eoc[DataWidth-1:1]}; // Return value (usually 8 bits): shift right 1 and sign extend
        $display("[TB] EOC: Simulation ended at %t (retval = %0d, 0x%8x).", $time, data, data);
        if (data != 0) begin
          $error("[TB] ERROR! Non-zero return value detected.");
        end else begin
          $display("[TB] Test passed!");
        end
        $finish(data);
      end
    end
end


endmodule
