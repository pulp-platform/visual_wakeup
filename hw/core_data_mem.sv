// Copyright 2025 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE.solderpad for details.
// SPDX-License-Identifier: SHL-0.51
//
// Sergio Mazzola <smazzola@iis.ee.ethz.ch>

`include "common_cells/registers.svh"

module core_data_mem #(
  parameter int unsigned AddrWidth = 32,
  parameter int unsigned DataWidth = 32,
  parameter type req_t = logic,
  parameter type rsp_t = logic,
  // Dependent parameters: do not modify
  localparam int unsigned IdxWidth = AddrWidth - $clog2(DataWidth/8)
)(
  input  logic clk_i,
  input  logic rst_ni,
  input  req_t slv_req_i,
  output rsp_t slv_rsp_o
);

  ////////////
  // Memory //
  ////////////

  logic [IdxWidth-1:0]    rw_idx;
  logic                   r_en, w_en;
  logic [DataWidth-1:0]   r_data, w_data;
  logic [DataWidth/8-1:0] w_be;

  // Take the IdxWidth MSBs (i.e., discard the byte offset)
  assign rw_idx = slv_req_i.q.addr[AddrWidth-1:AddrWidth-IdxWidth];

  `ifdef TARGET_WL_SCM
    // Generate standard-cell-based memory
    register_file_1r_1w_be #(
      .ADDR_WIDTH ( IdxWidth ),
      .DATA_WIDTH ( DataWidth ),
      .NUM_BYTE   ( DataWidth / 8 )
    ) i_scm (
      .clk ( clk_i ),
      .ReadEnable ( r_en ),
      .ReadAddr ( rw_idx ),
      .ReadData ( r_data ),
      .WriteEnable ( w_en ),
      .WriteAddr ( rw_idx ),
      .WriteData ( w_data ),
      .WriteBE ( w_be )
    );

    `ifdef TARGET_SIMULATION
      // Utility function to load SCM faster in purely RTL simulation.
      function void data_mem_flash_word(input int idx, input logic [DataWidth-1:0] data);
        if (idx < 0 || idx >= (1 << IdxWidth)) begin
          $fatal(1, "[core_data_mem] ERROR: Index %0d out of range, max %0d", idx, (1 << IdxWidth) - 1);
        end else begin
          i_scm.MemContentxDP[idx] = data;
        end
      endfunction
    `endif

  `elsif TARGET_WL_SRAM
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
      .req_i ( r_en | w_en ),
      .we_i ( w_en ),
      .addr_i ( rw_idx ),
      .wdata_i ( w_data ),
      .be_i ( w_be ),
      .rdata_o ( r_data )
    );

  `else
    $fatal(1, "[core_data_mem] ERROR: No target memory type defined (no TARGET_WL_SCM nor TARGET_WL_SRAM)");
  `endif

  //////////////////////////////
  // Memory interface control //
  //////////////////////////////

  /* Request port */
  // slv_req_i.q.addr
  // slv_req_i.q.write
  // slv_req_i.q.amo -> unused
  // slv_req_i.q.data
  // slv_req_i.q.strb
  // slv_req_i.q.size -> unused
  // slv_req_i.q_valid
  // slv_req_i.p_ready

  /* Response port */
  // slv_rsp_o.p.data
  // slv_rsp_o.p.error -> tied to 0
  // slv_rsp_o.p_valid
  // slv_rsp_o.q_ready

  typedef enum logic [1:0] {
    WAIT_REQ = 2'd0,
    WAIT_RETIRE_R = 2'd1,
    WAIT_RETIRE_W = 2'd2
  } state_t;

  state_t curr_state, next_state;

  `FFARN(curr_state, next_state, WAIT_REQ, clk_i, rst_ni)

  always_comb begin
    next_state = curr_state;
    // FSM outputs to data memory
    r_en = 1'b0;
    w_en = 1'b0;
    w_data = '0;
    w_be = '0;
    // FSM outputs to response port
    slv_rsp_o.p.data = '0;
    slv_rsp_o.p.error = '0;
    slv_rsp_o.p_valid = 1'b0;
    slv_rsp_o.q_ready = 1'b1; // ready to receive next request
    case (curr_state)

      WAIT_REQ: begin
        // request arrived from master
        if (slv_req_i.q_valid) begin
          // serve read or write req (will take effect in next cycle)
          if (slv_req_i.q.write) begin
            w_en = 1'b1;
            w_data = slv_req_i.q.data;
            w_be = slv_req_i.q.strb;
            // now let's wait for resp handshake
            next_state = WAIT_RETIRE_W;
          end else begin
            r_en = 1'b1;
            // now let's wait for resp handshake
            next_state = WAIT_RETIRE_R;
          end
        end
      end

      WAIT_RETIRE_R: begin
        slv_rsp_o.q_ready = 1'b0;
        slv_rsp_o.p_valid = 1'b1;
        slv_rsp_o.p.data = r_data;
        // when master is ready to retire, go back to wait
        if (slv_req_i.p_ready) begin
          next_state = WAIT_REQ;
        end
      end

      WAIT_RETIRE_W: begin
        slv_rsp_o.q_ready = 1'b0;
        slv_rsp_o.p_valid = 1'b1;
        // when master is ready to retire, go back to wait
        if (slv_req_i.p_ready) begin
          next_state = WAIT_REQ;
        end
      end

      default: begin
        next_state = WAIT_REQ;
      end
    endcase
  end

endmodule
