// Copyright 2025 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE.solderpad for details.
// SPDX-License-Identifier: SHL-0.51
//
// Sergio Mazzola <smazzola@iis.ee.ethz.ch>

`include "axi/assign.svh"
`include "reqrsp_interface/typedef.svh"
`include "reqrsp_interface/assign.svh"

module wl_top
  import wl_pkg::*;
#()(
  input logic     clk_i,
  input logic     rst_ni,
  // AXI Lite interface (slave port)
  input  axi_lite_req_t  axi_lite_slv_req_i,
  output axi_lite_resp_t axi_lite_slv_rsp_o,
  // AXI Lite interface (master port)
  output axi_lite_req_t  axi_lite_mst_req_o,
  input  axi_lite_resp_t axi_lite_mst_rsp_i,
  // Wake-up request to core
  input logic     irq_i,
  // End of computation and return value
  output logic [AxiLiteDataWidth-1:0] eoc_o,
  // AXI interface (slave port), for sensors
  input  axi_req_t  axi_slv_req_i,
  output axi_resp_t axi_slv_rsp_o
);

  ////////////////////////
  // AXI Lite interface //
  ////////////////////////

  AXI_LITE #(
    .AXI_ADDR_WIDTH ( AxiLiteAddrWidth ),
    .AXI_DATA_WIDTH ( AxiLiteDataWidth )
  ) axi_lite_in ();

  AXI_LITE #(
    .AXI_ADDR_WIDTH ( AxiLiteAddrWidth ),
    .AXI_DATA_WIDTH ( AxiLiteDataWidth )
  ) axi_lite_out ();

  `AXI_LITE_ASSIGN_FROM_REQ(axi_lite_in, axi_lite_slv_req_i)
  `AXI_LITE_ASSIGN_TO_RESP(axi_lite_slv_rsp_o, axi_lite_in)
  `AXI_LITE_ASSIGN_TO_REQ(axi_lite_mst_req_o, axi_lite_out)
  `AXI_LITE_ASSIGN_FROM_RESP(axi_lite_out, axi_lite_mst_rsp_i)

  /////////////////
  // Cluster bus //
  /////////////////

  /* Masters */
  // 0. from external AXI narrow slave port
  // 1. from core data interface (requests demuxed to external port)
  localparam int unsigned ClusterBusNumMasters = 2;

  /* Slaves */
  // 0. to external AXI narrow master port
  // 1. to core instr memory
  // 2. to core data memory
  localparam int unsigned ClusterBusNumSlaves = 3;

  // Routing rules
  localparam int unsigned ClusterBusNumRules = ClusterBusNumSlaves + 1; // +1 for "everything above cluster"
  typedef axi_pkg::xbar_rule_32_t cluster_bus_rule_t;
  localparam cluster_bus_rule_t [ClusterBusNumRules-1:0] ClusterBusAddrMap = '{
    '{ // everything above cluster
        idx: 32'd0, // to external AXI narrow master port
        start_addr: DataMemBaseAddr + DataMemOffset,
        end_addr: 32'hFFFF_FFFF
    },
    '{ // Core data memory
        idx: 32'd2, // to core data memory
        start_addr: DataMemBaseAddr,
        end_addr: DataMemBaseAddr + DataMemOffset
    },
    '{ // Instruction memory
        idx: 32'd1, // to core instr memory
        start_addr: InstrMemBaseAddr,
        end_addr: InstrMemBaseAddr + InstrMemOffset
    },
    '{ // everything below cluster
        idx: 32'd0, // to external AXI narrow master port
        start_addr: 32'h0000_0000,
        end_addr: InstrMemBaseAddr
    }
  };

  // Cluster bus xbar config
  localparam axi_pkg::xbar_cfg_t ClusterBusXbarCfg = '{
    NoSlvPorts:     ClusterBusNumMasters,
    NoMstPorts:     ClusterBusNumSlaves,
    MaxMstTrans:    32'd5,
    MaxSlvTrans:    32'd2,
    FallThrough:    1'b0,
    LatencyMode:    axi_pkg::NO_LATENCY,
    PipelineStages: 32'd0,
    AxiAddrWidth:   AxiLiteAddrWidth,
    AxiDataWidth:   AxiLiteDataWidth,
    NoAddrRules:    ClusterBusNumRules,
    default:        '0
  };

  /* Xbar masters */

  AXI_LITE #(
    .AXI_ADDR_WIDTH ( AxiLiteAddrWidth ),
    .AXI_DATA_WIDTH ( AxiLiteDataWidth )
  ) cluster_bus_axi_lite_in [ClusterBusNumMasters-1:0] ();
  // from external AXI narrow slave port
  `AXI_LITE_ASSIGN(cluster_bus_axi_lite_in[0], axi_lite_in)
  `AXI_LITE_ASSIGN(cluster_bus_axi_lite_in[1], bus_core_data_demux_ext_axi_lite_out)

  /* Xbar slaves */

  AXI_LITE #(
    .AXI_ADDR_WIDTH ( AxiLiteAddrWidth ),
    .AXI_DATA_WIDTH ( AxiLiteDataWidth )
  ) cluster_bus_axi_lite_out [ClusterBusNumSlaves-1:0] ();
  // to external AXI narrow master port
  `AXI_LITE_ASSIGN(axi_lite_out, cluster_bus_axi_lite_out[0])
  // to core instr memory
  `AXI_LITE_ASSIGN(bus_instr_mem_axi_lite_in, cluster_bus_axi_lite_out[1])
  // to core data memory
  `AXI_LITE_ASSIGN(bus_data_mem_axi_lite_in, cluster_bus_axi_lite_out[2])

  axi_lite_xbar_intf #(
    .Cfg ( ClusterBusXbarCfg ),
    .rule_t ( cluster_bus_rule_t )
  ) i_cluster_bus_xbar (
    .clk_i ( clk_i ),
    .rst_ni ( rst_ni ),
    .test_i ( 1'b0 ),
    .slv_ports ( cluster_bus_axi_lite_in ),
    .mst_ports ( cluster_bus_axi_lite_out ),
    .addr_map_i ( ClusterBusAddrMap ),
    // disable default master port for all slave ports
    .en_default_mst_port_i ( '0 ),
    .default_mst_port_i ( '0 )
  );

  /* Assertions */

  `ifdef TARGET_SIMULATION
    initial begin
      check_datawidth: assert (AxiLiteDataWidth == DataWidth)
      else begin
        $error("[ASSERT FAILED] [%m] AxiLiteDataWidth and DataWidth must be the same", `__FILE__, `__LINE__);
      end
      check_addrwidth: assert (AxiLiteAddrWidth == AddrWidth)
      else begin
        $error("[ASSERT FAILED] [%m] AxiLiteAddrWidth and AddrWidth must be the same", `__FILE__, `__LINE__);
      end
    end
  `endif

  //////////////////////////
  // Cluster bus adapters //
  //////////////////////////
  
  /* Data memory master */

  // Adapt AXI Lite -> AXI
  AXI_LITE #(
    .AXI_ADDR_WIDTH ( AxiLiteAddrWidth ),
    .AXI_DATA_WIDTH ( AxiLiteDataWidth )
  ) bus_data_mem_axi_lite_in ();

  AXI_BUS #(
    .AXI_ADDR_WIDTH ( AxiLiteAddrWidth ),
    .AXI_DATA_WIDTH ( AxiLiteDataWidth ),
    .AXI_ID_WIDTH ( 32'd1 ),
    .AXI_USER_WIDTH ( 32'd1 )
  ) bus_data_mem_axi_in ();

  axi_lite_to_axi_intf #(
    .AXI_DATA_WIDTH ( AxiLiteDataWidth )
  ) i_bus_data_mem_axi_lite_to_axi (
    .in ( bus_data_mem_axi_lite_in ),
    .slv_aw_cache_i ( '0 ),
    .slv_ar_cache_i ( '0 ),
    .out ( bus_data_mem_axi_in )
  );

  // Adapt AXI -> reqrsp bus
  REQRSP_BUS #(
    .ADDR_WIDTH ( AxiLiteAddrWidth ),
    .DATA_WIDTH ( AxiLiteDataWidth )
  ) bus_data_mem_reqrsp_in ();

  axi_to_reqrsp_intf #(
    .AddrWidth ( AxiLiteAddrWidth ),
    .DataWidth ( AxiLiteDataWidth ),
    .IdWidth ( 32'd1 ),
    .UserWidth ( 32'd1 ),
    .BufDepth ( 32'd1 )
  ) i_bus_data_mem_axi_to_reqrsp (
    .clk_i ( clk_i ),
    .rst_ni ( rst_ni ),
    .busy_o ( /* Unconnected */ ),
    .reqrsp ( bus_data_mem_reqrsp_in ),
    .axi ( bus_data_mem_axi_in )
  );

  // Assign reqrsp bus -> req & rsp signals
  core_data_req_t bus_data_mem_req;
  core_data_rsp_t bus_data_mem_rsp;

  `REQRSP_ASSIGN_TO_REQ(bus_data_mem_req, bus_data_mem_reqrsp_in)
  `REQRSP_ASSIGN_FROM_RESP(bus_data_mem_reqrsp_in, bus_data_mem_rsp)

  // Remap address
  core_data_req_t bus_data_mem_remap_req;
  always_comb begin : bus_data_mem_addr_remap
    bus_data_mem_remap_req = bus_data_mem_req;
    bus_data_mem_remap_req.q.addr = bus_data_mem_req.q.addr & (DataMemOffset - 1);
  end
  

  /* Instruction memory master */

  // Adapt AXI Lite -> AXI
  AXI_LITE #(
    .AXI_ADDR_WIDTH ( AxiLiteAddrWidth ),
    .AXI_DATA_WIDTH ( AxiLiteDataWidth )
  ) bus_instr_mem_axi_lite_in ();

  AXI_BUS #(
    .AXI_ADDR_WIDTH ( AxiLiteAddrWidth ),
    .AXI_DATA_WIDTH ( AxiLiteDataWidth ),
    .AXI_ID_WIDTH ( 32'd1 ),
    .AXI_USER_WIDTH ( 32'd1 )
  ) bus_instr_mem_axi_in ();

  axi_lite_to_axi_intf #(
    .AXI_DATA_WIDTH ( AxiLiteDataWidth )
  ) i_bus_instr_mem_axi_lite_to_axi (
    .in ( bus_instr_mem_axi_lite_in ),
    .slv_aw_cache_i ( '0 ),
    .slv_ar_cache_i ( '0 ),
    .out ( bus_instr_mem_axi_in )
  );

  // Adapt AXI -> memory interface
  logic           bus_instr_mem_req;
  logic           bus_instr_mem_rw_gnt;
  axi_lite_addr_t bus_instr_mem_addr;
  axi_lite_data_t bus_instr_mem_w_data;
  logic           bus_instr_mem_we;
  logic           bus_instr_mem_ack;
  axi_lite_data_t bus_instr_mem_r_data;

  axi_to_mem_intf #(
    .ADDR_WIDTH ( AxiLiteAddrWidth ),
    .DATA_WIDTH ( AxiLiteDataWidth ),
    .ID_WIDTH ( 32'd1 ),
    .USER_WIDTH ( 32'd1 ),
    .NUM_BANKS ( 32'd1 ),
    .BUF_DEPTH ( 32'd1 ),
    .HIDE_STRB ( 1'b1 ),
    .OUT_FIFO_DEPTH ( 32'd1 )
  ) i_bus_instr_mem_axi_to_mem (
    .clk_i ( clk_i ),
    .rst_ni ( rst_ni ),
    .busy_o ( /* Unconnected */ ),
    .slv ( bus_instr_mem_axi_in ),
    .mem_req_o ( bus_instr_mem_req ),
    .mem_gnt_i ( bus_instr_mem_rw_gnt ),
    .mem_addr_o ( bus_instr_mem_addr ),
    .mem_wdata_o ( bus_instr_mem_w_data ),
    .mem_strb_o ( /* Unconnected */ ),
    .mem_atop_o ( /* Unconnected */ ),
    .mem_we_o ( bus_instr_mem_we ),
    .mem_rvalid_i ( bus_instr_mem_ack ),
    .mem_rdata_i ( bus_instr_mem_r_data )
  );

  logic bus_instr_mem_w_en, bus_instr_mem_r_en;
  assign bus_instr_mem_w_en = bus_instr_mem_req && bus_instr_mem_we;
  assign bus_instr_mem_r_en = bus_instr_mem_req && !bus_instr_mem_we;

  logic bus_instr_mem_w_ack;
  logic bus_instr_mem_r_valid;
  // axi_to_mem requires ack both for read and write
  assign bus_instr_mem_ack = bus_instr_mem_w_ack || bus_instr_mem_r_valid;

  // Remap address
  axi_lite_addr_t bus_instr_mem_addr_remap;
  assign bus_instr_mem_addr_remap = bus_instr_mem_addr & (InstrMemOffset - 1);

  /////////////////
  // Snitch core //
  /////////////////

  // Instruction interface
  logic [AxiLiteAddrWidth-1:0] core_instr_addr;
  logic [31:0] core_instr_data;
  logic core_instr_valid;
  logic core_instr_ready;
  // Data interface
  core_data_req_t core_data_req;
  core_data_rsp_t core_data_rsp;

  core_subsystem #(
    .AddrWidth ( AxiLiteAddrWidth ),
    .DataWidth ( AxiLiteDataWidth ),
    .BootAddr ( BootromBaseAddr ),
    .dreq_t ( core_data_req_t ),
    .drsp_t ( core_data_rsp_t )
  ) i_core_subsystem (
    .clk_i ( clk_i ),
    .rst_ni ( rst_ni ),
    .irq_meip_i ( irq_i ),
    .inst_addr_o ( core_instr_addr ),
    .inst_data_i ( core_instr_data ),
    .inst_valid_o ( core_instr_valid ),
    .inst_ready_i ( core_instr_ready ),
    .data_req_o ( core_data_req ),
    .data_rsp_i ( core_data_rsp )
  );

  /////////////////////
  // Core data demux //
  /////////////////////

  // Demux Snitch's data interface to:
  // 0. Private data memory
  // 1. Top-level CSRs
  // 2. HWPE config
  // 3. `core_data_demux` internally catches everything else routing to `core_data_demux_ext`

  localparam int CoreDataDemuxNumPorts = 4;
  core_data_req_t core_data_demux_data_mem_req, core_data_demux_csr_req, core_data_demux_hwpe_req, core_data_demux_ext_req;
  core_data_rsp_t core_data_demux_data_mem_rsp, core_data_demux_csr_rsp, core_data_demux_hwpe_rsp, core_data_demux_ext_rsp;

  // CoreDataDemuxNumPorts-2 because the last port is the external port
  // used as "catch-all" rule, routing to ext all non-matched addresses
  localparam addr_napot_demux_rule_t [CoreDataDemuxNumPorts-2:0] CoreDataDemuxAddrMap = '{
    '{ // HWPE config
        idx: 2,
        base: HwpeCfgBaseAddr,
        mask: ~(HwpeCfgOffset - 1)
    },
    '{ // Top-level CSRs
        idx: 1,
        base: CsrBaseAddr,
        mask: ~(CsrOffset - 1)
    },
    '{ // Private data memory
        idx: 0,
        base: DataMemBaseAddr,
        mask: ~(DataMemOffset - 1)
    }
  };

  core_data_demux #(
    .NumPorts ( CoreDataDemuxNumPorts ),
    .req_t ( core_data_req_t ),
    .rsp_t ( core_data_rsp_t ),
    .RespDepth ( 1 ),
    .rule_t ( addr_napot_demux_rule_t )
  ) i_core_data_demux (
    .clk_i ( clk_i ),
    .rst_ni ( rst_ni ),
    .addr_map_i ( CoreDataDemuxAddrMap ),
    .slv_req_i ( core_data_req ),
    .slv_rsp_o ( core_data_rsp ),
    // These arrays have to be the same order of CoreDataDemuxAddrMap (important: external port must be in the last index)
    .mst_req_o ( {core_data_demux_ext_req, core_data_demux_hwpe_req, core_data_demux_csr_req, core_data_demux_data_mem_req} ),
    .mst_rsp_i ( {core_data_demux_ext_rsp, core_data_demux_hwpe_rsp, core_data_demux_csr_rsp, core_data_demux_data_mem_rsp} )
  );

  //////////////////////
  // Data to ext port //
  //////////////////////

  // Core data demux reqrsp bus to external port
  REQRSP_BUS #(
    .ADDR_WIDTH ( AxiLiteAddrWidth ),
    .DATA_WIDTH ( AxiLiteDataWidth )
  ) core_data_demux_ext ();

  `REQRSP_ASSIGN_FROM_REQ(core_data_demux_ext, core_data_demux_ext_req)
  `REQRSP_ASSIGN_TO_RESP(core_data_demux_ext_rsp, core_data_demux_ext)

  // Adapt REQRSP -> AXI
  AXI_BUS #(
    .AXI_ADDR_WIDTH ( AxiLiteAddrWidth ),
    .AXI_DATA_WIDTH ( AxiLiteDataWidth ),
    .AXI_ID_WIDTH ( 32'd1 ),
    .AXI_USER_WIDTH ( 32'd1 )
  ) bus_core_data_demux_ext_axi_out ();

  reqrsp_to_axi_intf #(
    .AddrWidth ( AxiLiteAddrWidth ),
    .DataWidth ( AxiLiteDataWidth ),
    .AxiIdWidth ( 32'd1 ),
    .AxiUserWidth ( 32'd1 ),
    .ID ( 0 )
  ) i_bus_core_data_demux_ext_reqrsp_to_axi (
    .clk_i ( clk_i ),
    .rst_ni ( rst_ni ),
    .user_i ( 1'b0 ),
    .reqrsp ( core_data_demux_ext ),
    .axi ( bus_core_data_demux_ext_axi_out )
  );

  // Adapt AXI -> AXI Lite
  AXI_LITE #(
    .AXI_ADDR_WIDTH ( AxiLiteAddrWidth ),
    .AXI_DATA_WIDTH ( AxiLiteDataWidth )
  ) bus_core_data_demux_ext_axi_lite_out ();

  axi_to_axi_lite_intf #(
    .AXI_ADDR_WIDTH ( AxiLiteAddrWidth ),
    .AXI_DATA_WIDTH ( AxiLiteDataWidth ),
    .AXI_ID_WIDTH ( 32'd1 ),
    .AXI_USER_WIDTH ( 32'd1 ),
    .AXI_MAX_WRITE_TXNS ( 32'd1 ),
    .AXI_MAX_READ_TXNS ( 32'd1 ),
    .FALL_THROUGH ( 1'b1 ),
    .FULL_BW ( 0 )
  ) i_bus_core_data_demux_ext_axi_to_axi_lite (
    .clk_i ( clk_i ),
    .rst_ni ( rst_ni ),
    .testmode_i ( 1'b0 ),
    .slv ( bus_core_data_demux_ext_axi_out ),
    .mst ( bus_core_data_demux_ext_axi_lite_out )
  );

  /////////////////
  // Data memory //
  /////////////////

  // Mux data memory requests from:
  // 0. Core data interface
  // 1. External AXI Lite slave port

  core_data_req_t data_mem_muxed_req;
  core_data_rsp_t data_mem_muxed_rsp;
  
  reqrsp_mux #(
    .NrPorts ( 2 ),
    .AddrWidth ( AxiLiteAddrWidth ),
    .DataWidth ( AxiLiteDataWidth ),
    .req_t ( core_data_req_t ),
    .rsp_t ( core_data_rsp_t ),
    .RespDepth ( 1 ),
    .RegisterReq ( 0 )
  ) i_data_mem_mux (
    .clk_i ( clk_i ),
    .rst_ni ( rst_ni ),
    .slv_req_i ( {bus_data_mem_remap_req, core_data_demux_data_mem_req} ),
    .slv_rsp_o ( {bus_data_mem_rsp, core_data_demux_data_mem_rsp} ),
    .mst_req_o ( data_mem_muxed_req ),
    .mst_rsp_i ( data_mem_muxed_rsp),
    .idx_o ( /* Unconnected */ )
  );

  /* Data memory */

  core_data_mem #(
    .AddrWidth ( DataMemAddrWidth ),
    .DataWidth ( AxiLiteDataWidth ),
    .req_t ( core_data_req_t ),
    .rsp_t ( core_data_rsp_t )
  ) i_data_mem (
    .clk_i ( clk_i ),
    .rst_ni ( rst_ni ),
    .slv_req_i ( data_mem_muxed_req ),
    .slv_rsp_o ( data_mem_muxed_rsp )
  );

  /////////////////
  // Top regfile //
  /////////////////

  wl_registers #(
    .NumRegs ( CsrNumRegs ),
    .req_t ( core_data_req_t ),
    .rsp_t ( core_data_rsp_t )
  ) i_csrs (
    .clk_i ( clk_i),
    .rst_ni ( rst_ni ),
    .slv_req_i ( core_data_demux_csr_req ),
    .slv_rsp_o ( core_data_demux_csr_rsp ),
    // Exposed registers
    .eoc_o (eoc_o)
  );

  //////////////////////
  // Core instr demux //
  //////////////////////

  // Demux Snitch's instruction interface to:
  // 0. Bootrom
  // 1. Private instruction memory

  localparam int CoreInstrDemuxNumPorts = 2;
  logic [AxiLiteAddrWidth-1:0] core_instr_demux_instr_mem_addr,  core_instr_demux_bootrom_addr;
  logic                        core_instr_demux_instr_mem_valid, core_instr_demux_bootrom_valid;
  logic                 [31:0] core_instr_demux_instr_mem_data,  core_instr_demux_bootrom_data;
  logic                        core_instr_demux_instr_mem_ready, core_instr_demux_bootrom_ready;

  localparam addr_napot_demux_rule_t [CoreInstrDemuxNumPorts-1:0] CoreInstrDemuxAddrMap = '{
    '{ // to Instruction memory
        idx: 1,
        base: InstrMemBaseAddr,
        mask: ~(InstrMemOffset - 1)
    },
    '{ // to bootrom
        idx: 0,
        base: BootromBaseAddr,
        mask: ~(BootromOffset - 1)
    }
  };

  core_instr_demux #(
    .NumPorts ( CoreInstrDemuxNumPorts ),
    .AddrWidth ( AxiLiteAddrWidth ),
    .rule_t ( addr_napot_demux_rule_t )
  ) i_core_instr_demux (
    .clk_i ( clk_i ),
    .rst_ni ( rst_ni ),
    .addr_map_i ( CoreInstrDemuxAddrMap ),
    // Interface to master (i.e., the core IF)
    .slv_addr_i ( core_instr_addr ),
    .slv_valid_i ( core_instr_valid ),
    .slv_data_o ( core_instr_data ),
    .slv_ready_o ( core_instr_ready ),
    // Interface to slaves (instruction memories)
    // these arrays have to be the same order of CoreInstrDemuxAddrMap
    .mst_addr_o ( {core_instr_demux_instr_mem_addr, core_instr_demux_bootrom_addr} ),
    .mst_valid_o ( {core_instr_demux_instr_mem_valid, core_instr_demux_bootrom_valid} ),
    .mst_data_i ( {core_instr_demux_instr_mem_data, core_instr_demux_bootrom_data} ),
    .mst_ready_i ( {core_instr_demux_instr_mem_ready, core_instr_demux_bootrom_ready} )
  );

  /* Assertions */

  `ifdef TARGET_SIMULATION
    illegal_instr_addr: assert property (
      @(posedge clk_i)
      disable iff ((!rst_ni) !== 1'b0)
      (core_instr_valid |-> (
        core_instr_addr >= BootromBaseAddr && core_instr_addr < BootromBaseAddr + BootromOffset ||
        core_instr_addr >= InstrMemBaseAddr && core_instr_addr < InstrMemBaseAddr + InstrMemOffset
      ))
    )
    else begin
      $error(
        "[ASSERT FAILED] [%m] Illegal instruction address 0x%h from core IF interface (%s:%0d)",
        core_instr_addr, `__FILE__, `__LINE__
      );
    end
  `endif

  /////////////
  // Bootrom //
  /////////////

  snitch_bootrom #(
    .AddrWidth ( BootromAddrWidth )
  ) i_bootrom (
    .clk_i ( clk_i ),
    .rst_ni ( rst_ni ),
    .req_i ( core_instr_demux_bootrom_valid ),
    .addr_i ( core_instr_demux_bootrom_addr[BootromAddrWidth-1:0] ),
    .data_o ( core_instr_demux_bootrom_data )
  );
  assign core_instr_demux_bootrom_ready = core_instr_demux_bootrom_valid;

  ////////////////////////
  // Instruction memory //
  ////////////////////////

  // - Write channel is only requested from AXI lite cluster bus master
  // - Mux read channel of instruction memory from:
  //   0. Core instruction interface (priority!!!)
  //   1. External AXI narrow slave port

  logic instr_mem_muxed_r_en;
  instr_mem_addr_t instr_mem_muxed_r_addr;
  axi_lite_data_t instr_mem_muxed_r_data;
  logic instr_mem_muxed_r_valid;

  // Stream arbiter for read channel
  stream_arbiter #(
    .DATA_T ( instr_mem_addr_t ),
    .N_INP ( 2 ),
    // priority to index 0 (core instr interface)
    .ARBITER ( "prio")
  ) i_instr_mem_r_mux (
    .clk_i ( clk_i ),
    .rst_ni ( rst_ni ),
    .inp_data_i ( {bus_instr_mem_addr_remap[InstrMemAddrWidth-1:0], core_instr_demux_instr_mem_addr[InstrMemAddrWidth-1:0]} ),
    .inp_valid_i ( {bus_instr_mem_r_en, core_instr_demux_instr_mem_valid} ),
    .inp_ready_o ( {bus_instr_mem_r_valid, core_instr_demux_instr_mem_ready} ),
    .oup_data_o ( instr_mem_muxed_r_addr ),
    .oup_valid_o ( instr_mem_muxed_r_en ),
    .oup_ready_i ( instr_mem_muxed_r_valid )
  );

  assign core_instr_demux_instr_mem_data = instr_mem_muxed_r_data;
  assign bus_instr_mem_r_data = instr_mem_muxed_r_data;

  /* Instruction memory */

  core_instr_mem #(
    .AddrWidth ( InstrMemAddrWidth ),
    .DataWidth ( AxiLiteDataWidth )
  ) i_instr_mem (
    .clk_i ( clk_i ),
    .rst_ni ( rst_ni ),
    // R/W request grant (always 1 here)
    .rw_gnt_o ( bus_instr_mem_rw_gnt ),
    // Read port
    .r_en_i ( instr_mem_muxed_r_en ),
    .r_addr_i ( instr_mem_muxed_r_addr ),
    .r_data_o ( instr_mem_muxed_r_data ),
    .r_valid_o ( instr_mem_muxed_r_valid ),
    // Write port
    .w_en_i ( bus_instr_mem_w_en ),
    .w_addr_i ( bus_instr_mem_addr_remap[InstrMemAddrWidth-1:0] ),
    .w_data_i ( bus_instr_mem_w_data ),
    .w_ack_o ( bus_instr_mem_w_ack )
  );

  ////////////////////
  // HWPE subsystem //
  ////////////////////

  /* Adapt core data interface -> HWPE peripheral interface */

  // Core request
  assign periph_hwpe_if.req = core_data_demux_hwpe_req.q_valid;
  assign periph_hwpe_if.add = core_data_demux_hwpe_req.q.addr;
  assign periph_hwpe_if.wen = !core_data_demux_hwpe_req.q.write;
  assign periph_hwpe_if.be = core_data_demux_hwpe_req.q.strb;
  assign periph_hwpe_if.data = core_data_demux_hwpe_req.q.data;
  assign periph_hwpe_if.id = '0;
  // Core's unconnected signals:
  // - core_data_demux_hwpe_req.p_ready
  // - core_data_demux_hwpe_req.q.amo
  // - core_data_demux_hwpe_req.q.size

  // Core response
  assign core_data_demux_hwpe_rsp.q_ready = periph_hwpe_if.gnt;
  assign core_data_demux_hwpe_rsp.p.data = periph_hwpe_if.r_data;
  assign core_data_demux_hwpe_rsp.p_valid = periph_hwpe_if.r_valid;
  assign core_data_demux_hwpe_rsp.p.error = '0;
  // Periph bus' unconnected signals:
  // - periph_hwpe_if.r_id;


  localparam int unsigned PeriphIdWidth = 2;
  //NOTE: 2 is not needed, we only have 1 master (the core),
  //      but PeriphIdWidth = 1 creates problem due to clog2

  hwpe_ctrl_intf_periph #(
    .ID_WIDTH ( PeriphIdWidth )
  ) periph_hwpe_if (
    .clk ( clk_i )
  );

  hwpe_subsystem #(
    .DataWidth ( DataWidth ),
    .AddrWidth ( AddrWidth ),
    .HwpeDataWidthFact ( HwpeDataWidthFact ),
    .PeriphIdWidth ( PeriphIdWidth ),
    .ActMemNumBanks ( ActMemNumBanks ),
    .ActMemNumBankWords ( ActMemNumBankWords ),
    .ActMemNumElemWord ( ActMemNumElemWord ),
    .ActMemElemWidth ( ActMemElemWidth ),
    .axi_aw_chan_t ( axi_aw_chan_t ),
    .axi_w_chan_t ( axi_w_chan_t ),
    .axi_b_chan_t ( axi_b_chan_t ),
    .axi_ar_chan_t ( axi_ar_chan_t ),
    .axi_r_chan_t ( axi_r_chan_t ),
    .axi_req_t ( axi_req_t ),
    .axi_resp_t ( axi_resp_t )
  ) i_hwpe_subsystem (
    .clk_i ( clk_i ),
    .rst_ni ( rst_ni ),
    .axi_slv_req_i ( axi_slv_req_i ),
    .axi_slv_rsp_o ( axi_slv_rsp_o ),
    .periph_slave ( periph_hwpe_if )
  );

  `ifdef TARGET_SIMULATION
    initial begin
      // Peripheral bus (for HWPE control slave) has address, data, and strobe widths hardcoded
      check_hardcoded_periph_dw: assert ($bits(core_data_data_t) == 32)
      else begin
        $error("[ASSERT FAILED] [%m] core_data_data_t is %d bits (hardcoded hwpe_ctrl_intf_periph expects %d bits) (%s:%0d)", $bits(core_data_data_t), 32, `__FILE__, `__LINE__);
      end
      check_hardcoded_periph_aw: assert ($bits(core_data_addr_t) == 32)
      else begin
        $error("[ASSERT FAILED] [%m] core_data_addr_t is %d bits (hardcoded hwpe_ctrl_intf_periph expects %d bits) (%s:%0d)", $bits(core_data_addr_t), 32, `__FILE__, `__LINE__);
      end
      check_hardcoded_periph_sw: assert ($bits(core_data_strb_t) == 4)
      else begin
        $error("[ASSERT FAILED] [%m] core_data_strb_t is %d bits (hardcoded hwpe_ctrl_intf_periph expects %d bits) (%s:%0d)", $bits(core_data_addr_t), 4, `__FILE__, `__LINE__);
      end
    end
  `endif

endmodule
