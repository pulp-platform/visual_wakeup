// Copyright 2025 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE.solderpad for details.
// SPDX-License-Identifier: SHL-0.51
//
// Sergio Mazzola <smazzola@iis.ee.ethz.ch>

`include "axi/typedef.svh"
`include "reqrsp_interface/typedef.svh"

package wl_pkg;

  /////////////////////
  // Hardware config //
  /////////////////////

  // Top-level config
  localparam int unsigned AddrWidth = 32;
  localparam int unsigned DataWidth = 32;
  localparam logic [AddrWidth-1:0] BaseAddress = '0;

  // Bootrom
  localparam int BootromNumWords = 32;
  localparam int BootromNumBytes = BootromNumWords * (DataWidth / 8);
  localparam int BootromAddrWidth = (BootromNumBytes > 1) ? $clog2(BootromNumBytes) : 1;

  // Core Instruction memory
  localparam int InstrMemNumWords = 128;
  localparam int InstrMemNumBytes = InstrMemNumWords * (DataWidth / 8);
  localparam int InstrMemAddrWidth = (InstrMemNumBytes > 1) ? $clog2(InstrMemNumBytes) : 1;

  // Core Data memory
  localparam int DataMemNumWords = 128;
  localparam int DataMemNumBytes = DataMemNumWords * (DataWidth / 8);
  localparam int DataMemAddrWidth = (DataMemNumBytes > 1) ? $clog2(DataMemNumBytes) : 1;

  // CSRs
  localparam int CsrNumRegs = 1;
  localparam int CsrNumBytes = CsrNumRegs * (DataWidth / 8);

  // HWPE Config
  localparam int HwpeDataWidthFact = 8;
  localparam int HwpeDataWidth = DataWidth * HwpeDataWidthFact;
  localparam int HwpeCfgNumBytes = 32'h0000_1000;
  // check: hwpe-datamover-example/rtl/datamover_package.sv
  // Activation memory is private to HWPE (not addressable by the core, so not in memory map)
  localparam int ActMemNumBanks = 16;
  localparam int ActMemNumBankWords = 128;
  localparam int ActMemWordWidth = DataWidth;

  ///////////
  // Types //
  ///////////

  // AXI widths
  localparam int unsigned AxiAddrWidth = AddrWidth;
  localparam int unsigned AxiDataWidth = DataWidth;
  localparam int unsigned AxiWideDataWidth = DataWidth * HwpeDataWidthFact;
  localparam int unsigned AxiSlvIdWidth = 2;
  localparam int unsigned AxiUserWidth = 1;

  // AXI types
  typedef logic [AxiAddrWidth-1:0]      axi_addr_t;
  typedef logic [AxiDataWidth-1:0]      axi_lite_data_t;
  typedef logic [AxiWideDataWidth-1:0]   axi_wide_data_t;
  typedef logic [AxiDataWidth/8-1:0]    axi_lite_strb_t;
  typedef logic [AxiWideDataWidth/8-1:0] axi_wide_strb_t;
  typedef logic [AxiSlvIdWidth-1:0]     axi_id_t;
  typedef logic [AxiUserWidth-1:0]      axi_user_t;
  // AXI Lite bus types
  // defines: axi_lite_req_t, axi_lite_resp_t
  `AXI_LITE_TYPEDEF_ALL(axi_lite, axi_addr_t, axi_lite_data_t, axi_lite_strb_t)
  // AXI bus types
  // defines: axi_req_t, axi_resp_t
  `AXI_TYPEDEF_ALL(axi, axi_addr_t, axi_id_t, axi_wide_data_t, axi_wide_strb_t, axi_user_t)

  // Instruction memory
  typedef logic [InstrMemAddrWidth-1:0] instr_mem_addr_t;

  // Snitch core data interface
  typedef logic [AddrWidth-1:0] core_data_addr_t;
  typedef logic [DataWidth-1:0] core_data_data_t;
  typedef logic [DataWidth/8-1:0] core_data_strb_t;
  // declare core_data_req_t, core_data_rsp_t, core_data_req_chan_t, core_data_rsp_chan_t
  `REQRSP_TYPEDEF_ALL(core_data, core_data_addr_t, core_data_data_t, core_data_strb_t)

  // Address demux rule type
  typedef struct packed {
    int unsigned idx;
    logic [AddrWidth-1:0] base;
    logic [AddrWidth-1:0] mask;
  } addr_napot_demux_rule_t;

  ////////////////
  // Memory map //
  ////////////////

  //NOTE: Must be NAPOT!

  localparam axi_addr_t BootromBaseAddr = BaseAddress + 32'h0000_0000; // addressable from: core IF (r)
  localparam axi_addr_t BootromOffset = BootromNumBytes;

  localparam axi_addr_t InstrMemBaseAddr = BaseAddress + 32'h0001_0000; // addressable from: core IF (r), cluster bus (rw)
  localparam axi_addr_t InstrMemOffset = InstrMemNumBytes;

  localparam axi_addr_t DataMemBaseAddr = BaseAddress + 32'h0002_0000; // addressable from: core LSU, cluster bus (rw)
  localparam axi_addr_t DataMemOffset = DataMemNumBytes;

  localparam axi_addr_t CsrBaseAddr = BaseAddress + 32'h0004_0000; // addressable from: core LSU (rw)
  localparam axi_addr_t CsrOffset = CsrNumBytes;

  localparam axi_addr_t HwpeCfgBaseAddr = BaseAddress + 32'h0008_0000; // addressable from: core LSU (rw)
  localparam axi_addr_t HwpeCfgOffset = HwpeCfgNumBytes;

endpackage
