// Copyright 2025 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE.solderpad for details.
// SPDX-License-Identifier: SHL-0.51
//
// Sergio Mazzola <smazzola@iis.ee.ethz.ch>

module adapter_mem_dw #(
  parameter int unsigned SrcDataWidth = 32,
  parameter int unsigned SrcStrbWidth = 4,
  parameter int unsigned SrcAddrWidth = 32,
  parameter int unsigned DstDataWidth = 32,
  parameter int unsigned DstStrbWidth = 4,
  parameter int unsigned DstAddrWidth = 32,
  // Dependent parameters: do not modify!
  localparam int unsigned SrcElemWidth = SrcDataWidth / SrcStrbWidth,
  localparam int unsigned DstElemWidth = DstDataWidth / DstStrbWidth
)(
  input  logic                    clk_i,
  input  logic                    rst_ni,
  input  logic                    src_req_i,
  output logic                    src_gnt_o,
  input  logic [SrcAddrWidth-1:0] src_addr_i,
  input  logic [SrcDataWidth-1:0] src_wdata_i,
  input  logic [SrcStrbWidth-1:0] src_strb_i,
  input  logic                    src_we_i,
  output logic                    src_rvalid_o,
  output logic [SrcDataWidth-1:0] src_rdata_o,
  output logic                    dst_req_o,
  input  logic                    dst_gnt_i,
  output logic [DstAddrWidth-1:0] dst_addr_o,
  output logic [DstDataWidth-1:0] dst_wdata_o,
  output logic [DstStrbWidth-1:0] dst_strb_o,
  output logic                    dst_we_o,
  input  logic                    dst_rvalid_i,
  input  logic [DstDataWidth-1:0] dst_rdata_i
);

  // Data type to split source and destination words (array of StrbWidth elements, each element of ElemWidth bits)
  typedef logic [SrcStrbWidth-1:0][SrcElemWidth-1:0] src_data_t;
  typedef logic [DstStrbWidth-1:0][DstElemWidth-1:0] dst_data_t;

  src_data_t src_wdata, src_rdata;
  dst_data_t dst_wdata, dst_rdata;

  ////////////////
  // No adapter //
  ////////////////

  // Do not generate any adapter if data and strobe widths are the same
  if (SrcDataWidth == DstDataWidth && SrcStrbWidth == DstStrbWidth) begin: gen_no_adapter
    assign dst_req_o = src_req_i;
    assign src_gnt_o = dst_gnt_i;
    assign dst_addr_o = src_addr_i;
    assign dst_wdata_o = src_wdata;
    assign dst_strb_o = src_strb_i;
    assign dst_we_o = src_we_i;
    assign src_rvalid_o = dst_rvalid_i;
    assign src_rdata_o = dst_rdata;

  /////////////////////////
  // Same element number //
  /////////////////////////

  // Data width is different but number of element is the same: the adapter degenerates to
  // only extention/truncation of each element in src word to the elements of the dst word
  end else if (SrcStrbWidth == DstStrbWidth) begin: gen_adapter

    assign dst_req_o = src_req_i;
    assign src_gnt_o = dst_gnt_i;
    assign dst_addr_o = src_addr_i;
    assign dst_strb_o = src_strb_i;
    assign dst_we_o = src_we_i;
    assign src_rvalid_o = dst_rvalid_i;

    // Pack into structures for easy element-wise assignment
    assign src_wdata = src_wdata_i;
    assign dst_rdata = dst_rdata_i;
    // Re-assign to unrolled interface signals
    assign dst_wdata_o = dst_wdata;
    assign src_rdata_o = src_rdata;

    // Assign element-wise to properly extend/truncate element by element
    generate for (genvar i = 0; i < SrcStrbWidth; i++) begin: gen_word_elem
        assign dst_wdata[i] = src_wdata[i];
        assign src_rdata[i] = dst_rdata[i];
      end
    endgenerate

  ///////////////////////////
  // Dst has more elements //
  ///////////////////////////

  // Destination has more elements than source
  end else if (SrcStrbWidth < DstStrbWidth) begin: gen_adapter
    
    assign dst_req_o = src_req_i;
    assign src_gnt_o = dst_gnt_i;
    assign dst_addr_o = src_addr_i;
    assign dst_we_o = src_we_i;
    assign src_rvalid_o = dst_rvalid_i;

    // Assign src_strb_i to lower bits, then fill with 0s
    assign dst_strb_o = {{(DstStrbWidth - SrcStrbWidth){1'b0}}, src_strb_i};

    // Pack into structures for easy element-wise assignment
    assign src_wdata = src_wdata_i;
    assign dst_rdata = dst_rdata_i;
    // Re-assign to unrolled interface signals
    assign dst_wdata_o = dst_wdata;
    assign src_rdata_o = src_rdata;

    // Assign element-wise to properly extend/truncate element by element
    generate for (genvar i = 0; i < SrcStrbWidth; i++) begin: gen_word_elem
        assign dst_wdata[i] = src_wdata[i];
        assign src_rdata[i] = dst_rdata[i];
      end
    endgenerate

  ///////////////////////////
  // Src has more elements //
  ///////////////////////////

  // Source has more elements than destination
  end else if (SrcStrbWidth > DstStrbWidth) begin: gen_error
    $fatal(1, "[adapter_mem_dw] ERROR: SrcStrbWidth > DstStrbWidth not supported.");
  end

  ////////////////
  // Assertions //
  ////////////////

  `ifdef TARGET_SIMULATION
    check_addr: assert property (
      @(posedge clk_i) disable iff ((!rst_ni) !== 1'b0) (src_addr_i < (1 << DstAddrWidth))
    ) else begin
      $error("[ASSERT FAILED] [%m] Input address exceeds memory address range (%s:%0d)", `__FILE__, `__LINE__);
    end
  `endif

endmodule
