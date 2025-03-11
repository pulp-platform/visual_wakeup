// Copyright 2025 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE.solderpad for details.
// SPDX-License-Identifier: SHL-0.51
//
// Sergio Mazzola <smazzola@iis.ee.ethz.ch>

module vwu_registers #(
  parameter int unsigned NumRegs = 1,
  parameter type req_t = logic,
  parameter type rsp_t = logic,
  // Hardcoded parameters, do not modify
  localparam int unsigned DataWidth = 32
) (
  input  logic clk_i,
  input  logic rst_ni,
  input  req_t slv_req_i,
  output rsp_t slv_rsp_o,
  // Expose useful registers
  output logic [DataWidth-1:0] eoc_o
);

  localparam int unsigned IdxWidth = (NumRegs > 1) ? $clog2(NumRegs) : 1;
  localparam int unsigned BytesOffset = $clog2(DataWidth / 8);

  logic [NumRegs-1:0][DataWidth-1:0] regfile_d, regfile_q;
  logic [IdxWidth-1:0] rf_idx;

  /*
   * REGISTER MAP
   * -------------------------------------------
   *  Offset | Index | Description
   * --------|-------|--------------------------
   *    0x00 |     0 | EOC (End of computation)
   */
  assign eoc_o = regfile_q[0];

  assign rf_idx = slv_req_i.q.addr[IdxWidth+BytesOffset-1:BytesOffset];

  /* Request port */
  // slv_req_i.q.addr
  // slv_req_i.q.write
  // slv_req_i.q.amo -> unused
  // slv_req_i.q.data
  // slv_req_i.q.strb -> unused
  // slv_req_i.q.size -> unused
  // slv_req_i.q_valid
  // slv_req_i.p_ready

  /* Response port */
  // slv_rsp_o.p.data
  // slv_rsp_o.p.error -> tied to 0
  // slv_rsp_o.p_valid
  // slv_rsp_o.q_ready

  typedef enum logic {
    WAIT_REQ = 1'd0,
    WAIT_RETIRE = 1'd1
  } state_t;

  state_t curr_state, next_state;

  typedef struct packed {
    logic [IdxWidth-1:0] idx;
    logic wen;
  } req_buf_t;

  req_buf_t req_buf_d, req_buf_q;

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      curr_state <= WAIT_REQ;
      regfile_q <= '0;
      req_buf_q <= '0;
    end else begin
      curr_state <= next_state;
      regfile_q <= regfile_d;
      req_buf_q <= req_buf_d;
    end
  end

  always_comb begin
    next_state = curr_state;
    regfile_d = regfile_q;
    req_buf_d = req_buf_q;
    // outputs
    slv_rsp_o.p.data = '0;
    slv_rsp_o.p.error = '0;
    slv_rsp_o.p_valid = 1'b0;
    slv_rsp_o.q_ready = 1'b1;
    case (curr_state)
      WAIT_REQ: begin
        // request arrived from master
        if (slv_req_i.q_valid) begin
          // serve write req (will take effect in next cycle)
          if (slv_req_i.q.write) begin
            regfile_d[rf_idx] = slv_req_i.q.data;
          end
          // buffer req metadata to give resp in next cycle
          req_buf_d.idx = rf_idx;
          req_buf_d.wen = slv_req_i.q.write;
          next_state = WAIT_RETIRE;
        end
      end
      WAIT_RETIRE: begin
        slv_rsp_o.q_ready = 1'b0;
        slv_rsp_o.p_valid = 1'b1;
        // write req is already served
        // if read, keep serving until retired
        if (!req_buf_q.wen) begin
          slv_rsp_o.p.data = regfile_q[req_buf_q.idx];
        end
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
