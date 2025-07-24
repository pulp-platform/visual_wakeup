// Copyright 2025 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE.solderpad for details.
// SPDX-License-Identifier: SHL-0.51
//
// Sergio Mazzola <smazzola@iis.ee.ethz.ch>

`include "common_cells/registers.svh"

module core_instr_mem #(
  parameter int unsigned AddrWidth = 8,
  parameter int unsigned DataWidth = 32,
  // Dependent parameters: do not modify
  localparam int unsigned IdxWidth = AddrWidth - $clog2(DataWidth/8)
)(
  input  logic                 clk_i,
  input  logic                 rst_ni,
  output logic                 rw_gnt_o,
  // Read port
  input  logic                 r_en_i,
  input  logic [AddrWidth-1:0] r_addr_i,
  output logic [DataWidth-1:0] r_data_o,
  output logic                 r_valid_o,
  // Write port
  input  logic                 w_en_i,
  input  logic [AddrWidth-1:0] w_addr_i,
  input  logic [DataWidth-1:0] w_data_i,
  output logic                 w_ack_o
);

  logic [IdxWidth-1:0] r_idx;
  logic [IdxWidth-1:0] w_idx;

  // Take the IdxWidth MSBs (i.e., discard the byte offset)
  assign r_idx = r_addr_i[AddrWidth-1:AddrWidth-IdxWidth];
  assign w_idx = w_addr_i[AddrWidth-1:AddrWidth-IdxWidth];

  // If a request come, it's always granted
  assign rw_gnt_o = 1'b1;

  ////////////
  // Memory //
  ////////////

  logic                 mem_r_en;
  logic  [IdxWidth-1:0] mem_r_idx;
  logic [DataWidth-1:0] mem_r_data;

  // With SCM we have dedicated, separate ports for read and write, and they can happen in parallel.
  // SRAM has only one port, shared for read and write: we give priority to read requests, while
  // writes are masked as long as there is a read requested or in progress.

  `ifdef TARGET_WL_SCM
    // Generate standard-cell-based memory
    register_file_1r_1w #(
      .ADDR_WIDTH ( IdxWidth ),
      .DATA_WIDTH ( DataWidth )
    ) i_scm (
      .clk ( clk_i ),
      .ReadEnable ( mem_r_en ),
      .ReadAddr ( mem_r_idx ),
      .ReadData ( mem_r_data ),
      .WriteEnable ( w_en_i ),
      .WriteAddr ( w_idx ),
      .WriteData ( w_data_i )
    );

    // Write is effective as per the cycle after the request
    `FFARN(w_ack_o, w_en_i, 1'b0, clk_i, rst_ni)

    `ifdef TARGET_SIMULATION
      // Utility function to load SCM faster in purely RTL simulation.
      function void instr_mem_flash_word(input int idx, input logic [DataWidth-1:0] data);
        if (idx < 0 || idx >= (1 << IdxWidth)) begin
          $fatal(1, "[core_instr_mem] ERROR: Index %0d out of range, max %0d", idx, (1 << IdxWidth) - 1);
        end else begin
          i_scm.MemContentxDP[idx] = data;
        end
      endfunction
    `endif

  `elsif TARGET_WL_SRAM
    logic w_en_filter;
    assign w_en_filter = w_en_i & ~mem_r_en & ~r_en_i; // no read in progress or requested

    // Generate SRAM cut
    tc_sram #(
      .NumWords ( 2 ** IdxWidth ),
      .DataWidth ( DataWidth ),
      .ByteWidth ( 32'd8 ),
      .NumPorts ( 32'd1 ),
      .Latency ( 32'd1 )
    ) i_sram (
      .clk_i ( clk_i ),
      .rst_ni ( rst_ni ),
      .req_i ( mem_r_en | w_en_filter ),
      .we_i ( w_en_filter ),
      .addr_i ( mem_r_en ? mem_r_idx : w_idx ),
      .wdata_i ( w_data_i ),
      .be_i ( '1 ),
      .rdata_o ( mem_r_data )
    );

    // Write is effective as per the cycle after the request
    `FFARN(w_ack_o, w_en_filter, 1'b0, clk_i, rst_ni)

  `else
    $fatal(1, "[core_instr_mem] ERROR: No target memory type defined (no TARGET_WL_SCM nor TARGET_WL_SRAM)");
  `endif

  ///////////////////////
  // Read port control //
  ///////////////////////

  typedef enum logic {
    WAIT_REQ = 1'b0,
    READ_AND_PREF = 1'b1
  } state_t;

  state_t curr_state, next_state;
  logic [IdxWidth-1:0] r_idx_q;
  logic [IdxWidth-1:0] pref_idx_q, pref_idx_d;
  logic [DataWidth-1:0] rdata_bak_q, rdata_bak_d;

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      curr_state <= WAIT_REQ;
      pref_idx_q <= '0;
      rdata_bak_q <= '0;
      r_idx_q <= '0;
    end else begin
      curr_state <= next_state;
      pref_idx_q <= pref_idx_d;
      rdata_bak_q <= rdata_bak_d;
      r_idx_q <= r_idx; // backup previous-cycle r_idx
    end
  end

  // Next state logic
  always_comb begin
    // state
    next_state = curr_state;
    pref_idx_d = pref_idx_q;
    rdata_bak_d = rdata_bak_q;
    // outputs
    r_valid_o = 1'b0;
    r_data_o = mem_r_data;
    mem_r_en = 1'b0;
    mem_r_idx = '0;
    case (curr_state)

      // Wait for request
      WAIT_REQ: begin
        if (r_en_i) begin
          mem_r_en = 1'b1;
          mem_r_idx = r_idx;
          pref_idx_d = r_idx;
          next_state = READ_AND_PREF;
        end
      end

      // Read and prefetch
      READ_AND_PREF: begin
        // Instr address issued in previous cycle was correct
        // i.e., we have correct mem_r_data in this cycle
        if (r_idx == pref_idx_q) begin
          // read from previous cycle's address
          r_valid_o = 1'b1;
          r_data_o = mem_r_data;
          rdata_bak_d = mem_r_data;
          // address for next cycle
          mem_r_en = 1'b1;
          mem_r_idx = r_idx + 1; // guess instruction to prefetch
          pref_idx_d = r_idx + 1;
          next_state = READ_AND_PREF;
        // Make an attempt to correct prediction
        // i.e., exploit the backup rdata_bak_q in case r_idx did not change
        end else if (r_idx == r_idx_q) begin
          r_valid_o = 1'b1;
          r_data_o = rdata_bak_q;
          // address for next cycle
          mem_r_en = 1'b0; // no need to fetch more, ReadData is already on SCM interface
          next_state = READ_AND_PREF;
        // Instr address issued in previous cycle was incorrect
        // i.e., we have to issue correct one, mem_r_data will be valid in next cycle
        end else begin
          r_valid_o = 1'b0;
          mem_r_en = 1'b1;
          mem_r_idx = r_idx;
          pref_idx_d = r_idx;
          next_state = READ_AND_PREF;
        end
        // abort read if interface is not valid anymore
        if (!r_en_i) begin
          r_valid_o = 1'b0;
          next_state = WAIT_REQ;
        end
      end

      default: begin
        next_state = WAIT_REQ;
      end
    endcase
  end

  `ifdef TARGET_SIMULATION
    instr_intf_stable: assert property (
      @(posedge clk_i)
      disable iff ((!rst_ni) !== 1'b0)
      ((r_en_i && r_valid_o) ##1 (r_en_i && $stable(r_addr_i)) |-> r_valid_o && $stable(r_data_o)))
    else begin
      $error(
        "[ASSERT FAILED] [%m] Instruction interface not stable (%s:%0d)",
        `__FILE__, `__LINE__
      );
    end
  `endif

endmodule
