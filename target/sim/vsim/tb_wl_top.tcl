# Copyright 2025 ETH Zurich and University of Bologna.
# Solderpad Hardware License, Version 0.51, see LICENSE.solderpad for details.
# SPDX-License-Identifier: SHL-0.51
#
# Sergio Mazzola <smazzola@iis.ee.ethz.ch>

if {$GUI == 1} {
    onerror {resume}
    quietly WaveActivateNextPane {} 0
    add wave -noupdate -group {params (wl_pkg)} /wl_pkg::AddrWidth
    add wave -noupdate -group {params (wl_pkg)} /wl_pkg::DataWidth
    add wave -noupdate -group {params (wl_pkg)} /wl_pkg::BaseAddress
    add wave -noupdate -group {params (wl_pkg)} /wl_pkg::BootromNumWords
    add wave -noupdate -group {params (wl_pkg)} /wl_pkg::BootromNumBytes
    add wave -noupdate -group {params (wl_pkg)} /wl_pkg::BootromAddrWidth
    add wave -noupdate -group {params (wl_pkg)} /wl_pkg::InstrMemNumWords
    add wave -noupdate -group {params (wl_pkg)} /wl_pkg::InstrMemNumBytes
    add wave -noupdate -group {params (wl_pkg)} /wl_pkg::InstrMemAddrWidth
    add wave -noupdate -group {params (wl_pkg)} /wl_pkg::DataMemNumWords
    add wave -noupdate -group {params (wl_pkg)} /wl_pkg::DataMemNumBytes
    add wave -noupdate -group {params (wl_pkg)} /wl_pkg::DataMemAddrWidth
    add wave -noupdate -group {params (wl_pkg)} /wl_pkg::CsrNumRegs
    add wave -noupdate -group {params (wl_pkg)} /wl_pkg::CsrNumBytes
    add wave -noupdate -group {params (wl_pkg)} /wl_pkg::HwpeDataWidthFact
    add wave -noupdate -group {params (wl_pkg)} /wl_pkg::HwpeDataWidth
    add wave -noupdate -group {params (wl_pkg)} /wl_pkg::HwpeCfgNumBytes
    add wave -noupdate -group {params (wl_pkg)} /wl_pkg::ActMemNumBanks
    add wave -noupdate -group {params (wl_pkg)} /wl_pkg::ActMemNumBankWords
    add wave -noupdate -group {params (wl_pkg)} /wl_pkg::ActMemWordWidth
    add wave -noupdate -group {params (wl_pkg)} /wl_pkg::AxiAddrWidth
    add wave -noupdate -group {params (wl_pkg)} /wl_pkg::AxiDataWidth
    add wave -noupdate -group {params (wl_pkg)} /wl_pkg::AxiSlvIdWidth
    add wave -noupdate -group {params (wl_pkg)} /wl_pkg::AxiUserWidth
    add wave -noupdate -group {params (wl_pkg)} /wl_pkg::BootromBaseAddr
    add wave -noupdate -group {params (wl_pkg)} /wl_pkg::BootromOffset
    add wave -noupdate -group {params (wl_pkg)} /wl_pkg::InstrMemBaseAddr
    add wave -noupdate -group {params (wl_pkg)} /wl_pkg::InstrMemOffset
    add wave -noupdate -group {params (wl_pkg)} /wl_pkg::DataMemBaseAddr
    add wave -noupdate -group {params (wl_pkg)} /wl_pkg::DataMemOffset
    add wave -noupdate -group {params (wl_pkg)} /wl_pkg::CsrBaseAddr
    add wave -noupdate -group {params (wl_pkg)} /wl_pkg::CsrOffset
    add wave -noupdate -group {params (wl_pkg)} /wl_pkg::HwpeCfgBaseAddr
    add wave -noupdate -group {params (wl_pkg)} /wl_pkg::HwpeCfgOffset
    add wave -noupdate -group {params (wl_top)} /tb_wl_top/dut/ClusterBusNumMasters
    add wave -noupdate -group {params (wl_top)} /tb_wl_top/dut/ClusterBusNumSlaves
    add wave -noupdate -group {params (wl_top)} /tb_wl_top/dut/ClusterBusNumRules
    add wave -noupdate -group {params (wl_top)} /tb_wl_top/dut/ClusterBusAddrMap
    add wave -noupdate -group {params (wl_top)} /tb_wl_top/dut/ClusterBusXbarCfg
    add wave -noupdate -group {params (wl_top)} /tb_wl_top/dut/CoreDataDemuxNumPorts
    add wave -noupdate -group {params (wl_top)} /tb_wl_top/dut/CoreDataDemuxAddrMap
    add wave -noupdate -group {params (wl_top)} /tb_wl_top/dut/CoreInstrDemuxNumPorts
    add wave -noupdate -group {params (wl_top)} /tb_wl_top/dut/CoreInstrDemuxAddrMap
    add wave -noupdate -group {params (wl_top)} /tb_wl_top/dut/PeriphIdWidth
    add wave -noupdate -divider Interface
    add wave -noupdate /tb_wl_top/dut/clk_i
    add wave -noupdate /tb_wl_top/dut/rst_ni
    add wave -noupdate -group {wl_top itf} /tb_wl_top/dut/axi_lite_slv_req_i
    add wave -noupdate -group {wl_top itf} /tb_wl_top/dut/axi_lite_slv_rsp_o
    add wave -noupdate -group {wl_top itf} /tb_wl_top/dut/axi_lite_mst_req_o
    add wave -noupdate -group {wl_top itf} /tb_wl_top/dut/axi_lite_mst_rsp_i
    add wave -noupdate -group {wl_top itf} /tb_wl_top/dut/irq_i
    add wave -noupdate -group {wl_top itf} /tb_wl_top/dut/eoc_o
    add wave -noupdate -group {wl_top itf} /tb_wl_top/dut/axi_wide_slv_req_i
    add wave -noupdate -group {wl_top itf} /tb_wl_top/dut/axi_wide_slv_rsp_o
    add wave -noupdate -divider {Core & HWPE}
    add wave -noupdate -group i_core_subsystem /tb_wl_top/dut/i_core_subsystem/clk_i
    add wave -noupdate -group i_core_subsystem /tb_wl_top/dut/i_core_subsystem/rst_ni
    add wave -noupdate -group i_core_subsystem /tb_wl_top/dut/i_core_subsystem/irq_meip_i
    add wave -noupdate -group i_core_subsystem /tb_wl_top/dut/i_core_subsystem/inst_addr_o
    add wave -noupdate -group i_core_subsystem /tb_wl_top/dut/i_core_subsystem/inst_data_i
    add wave -noupdate -group i_core_subsystem /tb_wl_top/dut/i_core_subsystem/inst_valid_o
    add wave -noupdate -group i_core_subsystem /tb_wl_top/dut/i_core_subsystem/inst_ready_i
    add wave -noupdate -group i_core_subsystem /tb_wl_top/dut/i_core_subsystem/data_req_o
    add wave -noupdate -group i_core_subsystem /tb_wl_top/dut/i_core_subsystem/data_rsp_i
    add wave -noupdate -group i_core_subsystem /tb_wl_top/dut/i_core_subsystem/core_irq
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/clk_i
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/rst_i
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch -color Gold /tb_wl_top/dut/i_core_subsystem/i_snitch/wfi_d
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch -color Gold /tb_wl_top/dut/i_core_subsystem/i_snitch/wfi_q
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/hart_id_i
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/irq_i
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/flush_i_valid_o
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/flush_i_ready_i
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/inst_addr_o
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/inst_cacheable_o
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/inst_data_i
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/inst_valid_o
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/inst_ready_i
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/acc_qreq_o
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/acc_qvalid_o
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/acc_qready_i
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/acc_prsp_i
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/acc_pvalid_i
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/acc_pready_o
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/data_req_o
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/data_rsp_i
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/ptw_valid_o
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/ptw_ready_i
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/ptw_va_o
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/ptw_ppn_o
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/ptw_pte_i
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/ptw_is_4mega_i
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/fpu_rnd_mode_o
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/fpu_fmt_mode_o
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/fpu_status_i
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/caq_pvalid_i
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/core_events_o
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/barrier_o
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/barrier_i
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/illegal_inst
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/illegal_csr
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/interrupt
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/ecall
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/ebreak
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/zero_lsb
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/meip
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/mtip
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/msip
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/mcip
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/seip
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/stip
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/ssip
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/scip
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/interrupts_enabled
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/any_interrupt_pending
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/pc_d
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/pc_q
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/consec_pc
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/iimm
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/uimm
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/jimm
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/bimm
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/simm
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/opa
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/opb
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/adder_result
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/alu_result
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/rd
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/rs1
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/rs2
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/stall
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/lsu_stall
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/nonacc_stall
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/gpr_raddr
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/gpr_rdata
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/gpr_waddr
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/gpr_wdata
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/gpr_we
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/sb_d
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/sb_q
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/is_load
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/is_store
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/is_signed
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/is_fp_load
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/is_fp_store
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/ls_misaligned
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/ld_addr_misaligned
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/st_addr_misaligned
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/inst_addr_misaligned
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/caq_qvalid
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/caq_qready
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/caq_ena
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/itlb_valid
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/itlb_ready
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/itlb_va
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/itlb_page_fault
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/itlb_pa
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/dtlb_valid
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/dtlb_ready
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/dtlb_va
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/dtlb_page_fault
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/dtlb_pa
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/trans_ready
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/trans_active
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/itlb_trans_valid
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/dtlb_trans_valid
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/trans_active_exp
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/tlb_flush
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/ls_size
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/ls_amo
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/ld_result
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/lsu_qready
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/lsu_qvalid
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/lsu_tlb_qready
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/lsu_tlb_qvalid
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/lsu_pvalid
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/lsu_pready
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/lsu_empty
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/ls_paddr
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/lsu_rd
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/retire_load
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/retire_i
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/retire_acc
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/acc_stall
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/valid_instr
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/exception
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/alu_op
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/opa_select
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/opb_select
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/write_rd
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/uses_rd
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/next_pc
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/rd_select
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/rd_bypass
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/is_branch
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/csr_rvalue
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/csr_en
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/csr_dump
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/csr_stall_d
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/csr_stall_q
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/scratch_d
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/scratch_q
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/epc_d
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/epc_q
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/tvec_d
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/tvec_q
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/cause_d
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/cause_q
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/cause_irq_d
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/cause_irq_q
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/spp_d
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/spp_q
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/mpp_d
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/mpp_q
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/ie_d
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/ie_q
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/pie_d
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/pie_q
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/eie_d
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/eie_q
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/tie_d
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/tie_q
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/sie_d
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/sie_q
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/cie_d
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/cie_q
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/seip_d
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/seip_q
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/stip_d
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/stip_q
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/ssip_d
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/ssip_q
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/scip_d
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/scip_q
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/priv_lvl_d
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/priv_lvl_q
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/satp_d
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/satp_q
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/dcsr_d
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/dcsr_q
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/dpc_d
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/dpc_q
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/dscratch_d
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/dscratch_q
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/debug_d
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/debug_q
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/fcsr_d
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/fcsr_q
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/mseg_q
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/mseg_d
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/acc_register_rd
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/operands_ready
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/dst_ready
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/opa_ready
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/opb_ready
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/npc
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/shift_opa
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/shift_opa_reversed
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/shift_right_result
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/shift_left_result
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/shift_opa_ext
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/shift_right_result_ext
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/shift_left
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/shift_arithmetic
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/alu_opa
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/alu_opb
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/lsu_qdata
    add wave -noupdate -group i_core_subsystem -expand -group i_snitch /tb_wl_top/dut/i_core_subsystem/i_snitch/alu_writeback
    add wave -noupdate -group {core itf} /tb_wl_top/dut/core_instr_addr
    add wave -noupdate -group {core itf} /tb_wl_top/dut/core_instr_data
    add wave -noupdate -group {core itf} /tb_wl_top/dut/core_instr_valid
    add wave -noupdate -group {core itf} /tb_wl_top/dut/core_instr_ready
    add wave -noupdate -group {core itf} /tb_wl_top/dut/core_data_req
    add wave -noupdate -group {core itf} /tb_wl_top/dut/core_data_rsp
    add wave -noupdate -group {core itf} /tb_wl_top/dut/core_data_demux_data_mem_req
    add wave -noupdate -group {core itf} /tb_wl_top/dut/core_data_demux_csr_req
    add wave -noupdate -group {core itf} /tb_wl_top/dut/core_data_demux_hwpe_req
    add wave -noupdate -group {core itf} /tb_wl_top/dut/core_data_demux_data_mem_rsp
    add wave -noupdate -group {core itf} /tb_wl_top/dut/core_data_demux_csr_rsp
    add wave -noupdate -group {core itf} /tb_wl_top/dut/core_data_demux_hwpe_rsp
    add wave -noupdate -group {core itf} /tb_wl_top/dut/core_instr_demux_instr_mem_addr
    add wave -noupdate -group {core itf} /tb_wl_top/dut/core_instr_demux_bootrom_addr
    add wave -noupdate -group {core itf} /tb_wl_top/dut/core_instr_demux_instr_mem_valid
    add wave -noupdate -group {core itf} /tb_wl_top/dut/core_instr_demux_bootrom_valid
    add wave -noupdate -group {core itf} /tb_wl_top/dut/core_instr_demux_instr_mem_data
    add wave -noupdate -group {core itf} /tb_wl_top/dut/core_instr_demux_bootrom_data
    add wave -noupdate -group {core itf} /tb_wl_top/dut/core_instr_demux_instr_mem_ready
    add wave -noupdate -group {core itf} /tb_wl_top/dut/core_instr_demux_bootrom_ready
    add wave -noupdate -group i_core_data_demux /tb_wl_top/dut/i_core_data_demux/clk_i
    add wave -noupdate -group i_core_data_demux /tb_wl_top/dut/i_core_data_demux/rst_ni
    add wave -noupdate -group i_core_data_demux /tb_wl_top/dut/i_core_data_demux/addr_map_i
    add wave -noupdate -group i_core_data_demux /tb_wl_top/dut/i_core_data_demux/slv_req_i
    add wave -noupdate -group i_core_data_demux /tb_wl_top/dut/i_core_data_demux/slv_rsp_o
    add wave -noupdate -group i_core_data_demux /tb_wl_top/dut/i_core_data_demux/mst_req_o
    add wave -noupdate -group i_core_data_demux /tb_wl_top/dut/i_core_data_demux/mst_rsp_i
    add wave -noupdate -group i_core_data_demux /tb_wl_top/dut/i_core_data_demux/demux_sel
    add wave -noupdate -group i_core_data_demux /tb_wl_top/dut/i_core_data_demux/mst_req_demuxed
    add wave -noupdate -group i_core_instr_demux /tb_wl_top/dut/i_core_instr_demux/clk_i
    add wave -noupdate -group i_core_instr_demux /tb_wl_top/dut/i_core_instr_demux/rst_ni
    add wave -noupdate -group i_core_instr_demux /tb_wl_top/dut/i_core_instr_demux/addr_map_i
    add wave -noupdate -group i_core_instr_demux /tb_wl_top/dut/i_core_instr_demux/slv_addr_i
    add wave -noupdate -group i_core_instr_demux /tb_wl_top/dut/i_core_instr_demux/slv_valid_i
    add wave -noupdate -group i_core_instr_demux /tb_wl_top/dut/i_core_instr_demux/slv_data_o
    add wave -noupdate -group i_core_instr_demux /tb_wl_top/dut/i_core_instr_demux/slv_ready_o
    add wave -noupdate -group i_core_instr_demux /tb_wl_top/dut/i_core_instr_demux/mst_addr_o
    add wave -noupdate -group i_core_instr_demux /tb_wl_top/dut/i_core_instr_demux/mst_valid_o
    add wave -noupdate -group i_core_instr_demux /tb_wl_top/dut/i_core_instr_demux/mst_data_i
    add wave -noupdate -group i_core_instr_demux /tb_wl_top/dut/i_core_instr_demux/mst_ready_i
    add wave -noupdate -group i_core_instr_demux /tb_wl_top/dut/i_core_instr_demux/demux_sel
    add wave -noupdate -group i_csrs /tb_wl_top/dut/i_csrs/clk_i
    add wave -noupdate -group i_csrs /tb_wl_top/dut/i_csrs/rst_ni
    add wave -noupdate -group i_csrs /tb_wl_top/dut/i_csrs/slv_req_i
    add wave -noupdate -group i_csrs /tb_wl_top/dut/i_csrs/slv_rsp_o
    add wave -noupdate -group i_csrs -color Gold /tb_wl_top/dut/i_csrs/regfile_d
    add wave -noupdate -group i_csrs -color Gold /tb_wl_top/dut/i_csrs/regfile_q
    add wave -noupdate -group i_csrs /tb_wl_top/dut/i_csrs/rf_idx
    add wave -noupdate -group i_csrs /tb_wl_top/dut/i_csrs/curr_state
    add wave -noupdate -group i_csrs /tb_wl_top/dut/i_csrs/next_state
    add wave -noupdate -group i_csrs /tb_wl_top/dut/i_csrs/req_buf_d
    add wave -noupdate -group i_csrs /tb_wl_top/dut/i_csrs/req_buf_q
    add wave -noupdate -group i_hwpe_subsystem -group params /tb_wl_top/dut/i_hwpe_subsystem/DataWidth
    add wave -noupdate -group i_hwpe_subsystem -group params /tb_wl_top/dut/i_hwpe_subsystem/AddrWidth
    add wave -noupdate -group i_hwpe_subsystem -group params /tb_wl_top/dut/i_hwpe_subsystem/WidePortFact
    add wave -noupdate -group i_hwpe_subsystem -group params /tb_wl_top/dut/i_hwpe_subsystem/PeriphIdWidth
    add wave -noupdate -group i_hwpe_subsystem -group params /tb_wl_top/dut/i_hwpe_subsystem/ActMemNumBanks
    add wave -noupdate -group i_hwpe_subsystem -group params /tb_wl_top/dut/i_hwpe_subsystem/ActMemNumBankWords
    add wave -noupdate -group i_hwpe_subsystem -group params /tb_wl_top/dut/i_hwpe_subsystem/ActMemWordWidth
    add wave -noupdate -group i_hwpe_subsystem -group params /tb_wl_top/dut/i_hwpe_subsystem/ActMemAddrWidth
    add wave -noupdate -group i_hwpe_subsystem -group params /tb_wl_top/dut/i_hwpe_subsystem/HwpeDataWidth
    add wave -noupdate -group i_hwpe_subsystem -group params /tb_wl_top/dut/i_hwpe_subsystem/NumHwpe
    add wave -noupdate -group i_hwpe_subsystem -group params /tb_wl_top/dut/i_hwpe_subsystem/HciByteWidth
    add wave -noupdate -group i_hwpe_subsystem -group params /tb_wl_top/dut/i_hwpe_subsystem/HciIdWidth
    add wave -noupdate -group i_hwpe_subsystem -group params /tb_wl_top/dut/i_hwpe_subsystem/HCI_SIZE_hci_hwpe
    add wave -noupdate -group i_hwpe_subsystem -group params /tb_wl_top/dut/i_hwpe_subsystem/HCI_SIZE_hci_mem_routed
    add wave -noupdate -group i_hwpe_subsystem -group params /tb_wl_top/dut/i_hwpe_subsystem/HCI_SIZE_hci_mem
    add wave -noupdate -group i_hwpe_subsystem -group params /tb_wl_top/dut/i_hwpe_subsystem/HciArbConfig
    add wave -noupdate -group i_hwpe_subsystem /tb_wl_top/dut/i_hwpe_subsystem/clk_i
    add wave -noupdate -group i_hwpe_subsystem /tb_wl_top/dut/i_hwpe_subsystem/rst_ni
    for {set i 0} {$i < [examine -radix dec /tb_wl_top/dut/i_hwpe_subsystem/ActMemNumBanks]} {incr i} {
        if {[examine -nocomplain /tb_wl_top/dut/i_hwpe_subsystem/banks_gen[$i]/i_scm/MemContentxDP] != ""} {
            # SCM
            add wave -noupdate -group i_hwpe_subsystem -group activation_mem -label bank_$i /tb_wl_top/dut/i_hwpe_subsystem/banks_gen[$i]/i_scm/MemContentxDP
        } elseif {[examine -nocomplain /tb_wl_top/dut/i_hwpe_subsystem/banks_gen[$i]/i_sram/sram] != ""} {
            # SRAM
            add wave -noupdate -group i_hwpe_subsystem -group activation_mem -label bank_$i /tb_wl_top/dut/i_hwpe_subsystem/banks_gen[$i]/i_sram/sram
        }
    }
    add wave -noupdate -group i_hwpe_subsystem -group periph_slave /tb_wl_top/dut/i_hwpe_subsystem/periph_slave/clk
    add wave -noupdate -group i_hwpe_subsystem -group periph_slave /tb_wl_top/dut/i_hwpe_subsystem/periph_slave/req
    add wave -noupdate -group i_hwpe_subsystem -group periph_slave /tb_wl_top/dut/i_hwpe_subsystem/periph_slave/gnt
    add wave -noupdate -group i_hwpe_subsystem -group periph_slave /tb_wl_top/dut/i_hwpe_subsystem/periph_slave/add
    add wave -noupdate -group i_hwpe_subsystem -group periph_slave /tb_wl_top/dut/i_hwpe_subsystem/periph_slave/wen
    add wave -noupdate -group i_hwpe_subsystem -group periph_slave /tb_wl_top/dut/i_hwpe_subsystem/periph_slave/be
    add wave -noupdate -group i_hwpe_subsystem -group periph_slave /tb_wl_top/dut/i_hwpe_subsystem/periph_slave/data
    add wave -noupdate -group i_hwpe_subsystem -group periph_slave /tb_wl_top/dut/i_hwpe_subsystem/periph_slave/id
    add wave -noupdate -group i_hwpe_subsystem -group periph_slave /tb_wl_top/dut/i_hwpe_subsystem/periph_slave/r_data
    add wave -noupdate -group i_hwpe_subsystem -group periph_slave /tb_wl_top/dut/i_hwpe_subsystem/periph_slave/r_valid
    add wave -noupdate -group i_hwpe_subsystem -group periph_slave /tb_wl_top/dut/i_hwpe_subsystem/periph_slave/r_id
    add wave -noupdate -group i_hwpe_subsystem /tb_wl_top/dut/i_hwpe_subsystem/axi_wide_slv_req_i
    add wave -noupdate -group i_hwpe_subsystem /tb_wl_top/dut/i_hwpe_subsystem/axi_wide_slv_rsp_o
    add wave -noupdate -group i_hwpe_subsystem /tb_wl_top/dut/i_hwpe_subsystem/tcdm_req
    add wave -noupdate -group i_hwpe_subsystem /tb_wl_top/dut/i_hwpe_subsystem/tcdm_gnt
    add wave -noupdate -group i_hwpe_subsystem /tb_wl_top/dut/i_hwpe_subsystem/tcdm_add
    add wave -noupdate -group i_hwpe_subsystem /tb_wl_top/dut/i_hwpe_subsystem/tcdm_wen
    add wave -noupdate -group i_hwpe_subsystem /tb_wl_top/dut/i_hwpe_subsystem/tcdm_be
    add wave -noupdate -group i_hwpe_subsystem /tb_wl_top/dut/i_hwpe_subsystem/tcdm_data
    add wave -noupdate -group i_hwpe_subsystem /tb_wl_top/dut/i_hwpe_subsystem/tcdm_r_data
    add wave -noupdate -group i_hwpe_subsystem /tb_wl_top/dut/i_hwpe_subsystem/tcdm_r_valid
    add wave -noupdate -group i_hwpe_subsystem -group i_datamover_top_wrap /tb_wl_top/dut/i_hwpe_subsystem/i_datamover_top_wrap/clk_i
    add wave -noupdate -group i_hwpe_subsystem -group i_datamover_top_wrap /tb_wl_top/dut/i_hwpe_subsystem/i_datamover_top_wrap/rst_ni
    add wave -noupdate -group i_hwpe_subsystem -group i_datamover_top_wrap /tb_wl_top/dut/i_hwpe_subsystem/i_datamover_top_wrap/test_mode_i
    add wave -noupdate -group i_hwpe_subsystem -group i_datamover_top_wrap /tb_wl_top/dut/i_hwpe_subsystem/i_datamover_top_wrap/evt_o
    add wave -noupdate -group i_hwpe_subsystem -group i_datamover_top_wrap /tb_wl_top/dut/i_hwpe_subsystem/i_datamover_top_wrap/tcdm_req
    add wave -noupdate -group i_hwpe_subsystem -group i_datamover_top_wrap /tb_wl_top/dut/i_hwpe_subsystem/i_datamover_top_wrap/tcdm_gnt
    add wave -noupdate -group i_hwpe_subsystem -group i_datamover_top_wrap /tb_wl_top/dut/i_hwpe_subsystem/i_datamover_top_wrap/tcdm_add
    add wave -noupdate -group i_hwpe_subsystem -group i_datamover_top_wrap /tb_wl_top/dut/i_hwpe_subsystem/i_datamover_top_wrap/tcdm_wen
    add wave -noupdate -group i_hwpe_subsystem -group i_datamover_top_wrap /tb_wl_top/dut/i_hwpe_subsystem/i_datamover_top_wrap/tcdm_be
    add wave -noupdate -group i_hwpe_subsystem -group i_datamover_top_wrap /tb_wl_top/dut/i_hwpe_subsystem/i_datamover_top_wrap/tcdm_data
    add wave -noupdate -group i_hwpe_subsystem -group i_datamover_top_wrap /tb_wl_top/dut/i_hwpe_subsystem/i_datamover_top_wrap/tcdm_r_data
    add wave -noupdate -group i_hwpe_subsystem -group i_datamover_top_wrap /tb_wl_top/dut/i_hwpe_subsystem/i_datamover_top_wrap/tcdm_r_valid
    add wave -noupdate -group i_hwpe_subsystem -group i_datamover_top_wrap /tb_wl_top/dut/i_hwpe_subsystem/i_datamover_top_wrap/periph_req
    add wave -noupdate -group i_hwpe_subsystem -group i_datamover_top_wrap /tb_wl_top/dut/i_hwpe_subsystem/i_datamover_top_wrap/periph_gnt
    add wave -noupdate -group i_hwpe_subsystem -group i_datamover_top_wrap /tb_wl_top/dut/i_hwpe_subsystem/i_datamover_top_wrap/periph_add
    add wave -noupdate -group i_hwpe_subsystem -group i_datamover_top_wrap /tb_wl_top/dut/i_hwpe_subsystem/i_datamover_top_wrap/periph_wen
    add wave -noupdate -group i_hwpe_subsystem -group i_datamover_top_wrap /tb_wl_top/dut/i_hwpe_subsystem/i_datamover_top_wrap/periph_be
    add wave -noupdate -group i_hwpe_subsystem -group i_datamover_top_wrap /tb_wl_top/dut/i_hwpe_subsystem/i_datamover_top_wrap/periph_data
    add wave -noupdate -group i_hwpe_subsystem -group i_datamover_top_wrap /tb_wl_top/dut/i_hwpe_subsystem/i_datamover_top_wrap/periph_id
    add wave -noupdate -group i_hwpe_subsystem -group i_datamover_top_wrap /tb_wl_top/dut/i_hwpe_subsystem/i_datamover_top_wrap/periph_r_data
    add wave -noupdate -group i_hwpe_subsystem -group i_datamover_top_wrap /tb_wl_top/dut/i_hwpe_subsystem/i_datamover_top_wrap/periph_r_valid
    add wave -noupdate -group i_hwpe_subsystem -group i_datamover_top_wrap /tb_wl_top/dut/i_hwpe_subsystem/i_datamover_top_wrap/periph_r_id
    add wave -noupdate -group i_hwpe_subsystem -group i_datamover_top_wrap -group i_streamer /tb_wl_top/dut/i_hwpe_subsystem/i_datamover_top_wrap/i_datamover_top/i_streamer/clk_i
    add wave -noupdate -group i_hwpe_subsystem -group i_datamover_top_wrap -group i_streamer /tb_wl_top/dut/i_hwpe_subsystem/i_datamover_top_wrap/i_datamover_top/i_streamer/rst_ni
    add wave -noupdate -group i_hwpe_subsystem -group i_datamover_top_wrap -group i_streamer /tb_wl_top/dut/i_hwpe_subsystem/i_datamover_top_wrap/i_datamover_top/i_streamer/test_mode_i
    add wave -noupdate -group i_hwpe_subsystem -group i_datamover_top_wrap -group i_streamer /tb_wl_top/dut/i_hwpe_subsystem/i_datamover_top_wrap/i_datamover_top/i_streamer/enable_i
    add wave -noupdate -group i_hwpe_subsystem -group i_datamover_top_wrap -group i_streamer /tb_wl_top/dut/i_hwpe_subsystem/i_datamover_top_wrap/i_datamover_top/i_streamer/clear_i
    add wave -noupdate -group i_hwpe_subsystem -group i_datamover_top_wrap -group i_streamer /tb_wl_top/dut/i_hwpe_subsystem/i_datamover_top_wrap/i_datamover_top/i_streamer/ctrl_i
    add wave -noupdate -group i_hwpe_subsystem -group i_datamover_top_wrap -group i_streamer /tb_wl_top/dut/i_hwpe_subsystem/i_datamover_top_wrap/i_datamover_top/i_streamer/flags_o
    add wave -noupdate -group i_hwpe_subsystem -group i_datamover_top_wrap -group i_streamer /tb_wl_top/dut/i_hwpe_subsystem/i_datamover_top_wrap/i_datamover_top/i_streamer/tcdm_fifo_flags
    add wave -noupdate -group i_hwpe_subsystem -group i_datamover_top_wrap -group i_slave /tb_wl_top/dut/i_hwpe_subsystem/i_datamover_top_wrap/i_datamover_top/i_slave/clk_i
    add wave -noupdate -group i_hwpe_subsystem -group i_datamover_top_wrap -group i_slave /tb_wl_top/dut/i_hwpe_subsystem/i_datamover_top_wrap/i_datamover_top/i_slave/rst_ni
    add wave -noupdate -group i_hwpe_subsystem -group i_datamover_top_wrap -group i_slave /tb_wl_top/dut/i_hwpe_subsystem/i_datamover_top_wrap/i_datamover_top/i_slave/clear_o
    add wave -noupdate -group i_hwpe_subsystem -group i_datamover_top_wrap -group i_slave /tb_wl_top/dut/i_hwpe_subsystem/i_datamover_top_wrap/i_datamover_top/i_slave/ctrl_i
    add wave -noupdate -group i_hwpe_subsystem -group i_datamover_top_wrap -group i_slave /tb_wl_top/dut/i_hwpe_subsystem/i_datamover_top_wrap/i_datamover_top/i_slave/flags_o
    add wave -noupdate -group i_hwpe_subsystem -group i_datamover_top_wrap -group i_slave /tb_wl_top/dut/i_hwpe_subsystem/i_datamover_top_wrap/i_datamover_top/i_slave/reg_file
    add wave -noupdate -group i_hwpe_subsystem -group i_datamover_top_wrap -group i_slave /tb_wl_top/dut/i_hwpe_subsystem/i_datamover_top_wrap/i_datamover_top/i_slave/regfile_in
    add wave -noupdate -group i_hwpe_subsystem -group i_datamover_top_wrap -group i_slave /tb_wl_top/dut/i_hwpe_subsystem/i_datamover_top_wrap/i_datamover_top/i_slave/regfile_out
    add wave -noupdate -group i_hwpe_subsystem -group i_datamover_top_wrap -group i_slave /tb_wl_top/dut/i_hwpe_subsystem/i_datamover_top_wrap/i_datamover_top/i_slave/running_state
    add wave -noupdate -group i_hwpe_subsystem -group i_datamover_top_wrap -group i_slave /tb_wl_top/dut/i_hwpe_subsystem/i_datamover_top_wrap/i_datamover_top/i_slave/context_state
    add wave -noupdate -group i_hwpe_subsystem -group i_datamover_top_wrap -group i_slave /tb_wl_top/dut/i_hwpe_subsystem/i_datamover_top_wrap/i_datamover_top/i_slave/regfile_flags
    add wave -noupdate -group i_hwpe_subsystem -group i_datamover_top_wrap -group i_slave /tb_wl_top/dut/i_hwpe_subsystem/i_datamover_top_wrap/i_datamover_top/i_slave/offloading_core
    add wave -noupdate -group i_hwpe_subsystem -group i_datamover_top_wrap -group i_slave /tb_wl_top/dut/i_hwpe_subsystem/i_datamover_top_wrap/i_datamover_top/i_slave/pointer_context
    add wave -noupdate -group i_hwpe_subsystem -group i_datamover_top_wrap -group i_slave /tb_wl_top/dut/i_hwpe_subsystem/i_datamover_top_wrap/i_datamover_top/i_slave/running_context
    add wave -noupdate -group i_hwpe_subsystem -group i_datamover_top_wrap -group i_slave /tb_wl_top/dut/i_hwpe_subsystem/i_datamover_top_wrap/i_datamover_top/i_slave/counter_pending
    add wave -noupdate -group i_hwpe_subsystem -group i_datamover_top_wrap -group i_slave /tb_wl_top/dut/i_hwpe_subsystem/i_datamover_top_wrap/i_datamover_top/i_slave/s_enable_after
    add wave -noupdate -group i_hwpe_subsystem -group i_datamover_top_wrap -group i_slave /tb_wl_top/dut/i_hwpe_subsystem/i_datamover_top_wrap/i_datamover_top/i_slave/s_clear
    add wave -noupdate -group i_hwpe_subsystem -group i_datamover_top_wrap -group i_slave /tb_wl_top/dut/i_hwpe_subsystem/i_datamover_top_wrap/i_datamover_top/i_slave/s_clear_regfile
    add wave -noupdate -group i_hwpe_subsystem -group i_datamover_top_wrap -group i_slave /tb_wl_top/dut/i_hwpe_subsystem/i_datamover_top_wrap/i_datamover_top/i_slave/clear_regfile
    add wave -noupdate -group i_hwpe_subsystem -group i_datamover_top_wrap -group i_slave /tb_wl_top/dut/i_hwpe_subsystem/i_datamover_top_wrap/i_datamover_top/i_slave/triggered_q
    add wave -noupdate -group i_hwpe_subsystem -group i_datamover_top_wrap -group i_slave /tb_wl_top/dut/i_hwpe_subsystem/i_datamover_top_wrap/i_datamover_top/i_slave/context_addr
    add wave -noupdate -group i_hwpe_subsystem -group i_datamover_top_wrap -group i_slave /tb_wl_top/dut/i_hwpe_subsystem/i_datamover_top_wrap/i_datamover_top/i_slave/ext_access
    add wave -noupdate -group i_hwpe_subsystem -group i_datamover_top_wrap -group i_slave /tb_wl_top/dut/i_hwpe_subsystem/i_datamover_top_wrap/i_datamover_top/i_slave/ext_id_n
    add wave -noupdate -group i_hwpe_subsystem -group i_datamover_top_wrap -group i_slave /tb_wl_top/dut/i_hwpe_subsystem/i_datamover_top_wrap/i_datamover_top/i_slave/cfg_id_d
    add wave -noupdate -group i_hwpe_subsystem -group i_datamover_top_wrap -group i_slave /tb_wl_top/dut/i_hwpe_subsystem/i_datamover_top_wrap/i_datamover_top/i_slave/cfg_id_q
    add wave -noupdate -group i_hwpe_subsystem -group i_datamover_top_wrap -group i_slave /tb_wl_top/dut/i_hwpe_subsystem/i_datamover_top_wrap/i_datamover_top/i_slave/cfg_req_d
    add wave -noupdate -group i_hwpe_subsystem -group i_datamover_top_wrap -group i_slave /tb_wl_top/dut/i_hwpe_subsystem/i_datamover_top_wrap/i_datamover_top/i_slave/cfg_req_q
    add wave -noupdate -group i_hwpe_subsystem -group i_datamover_top_wrap -group i_slave -group i_regfile_latch /tb_wl_top/dut/i_hwpe_subsystem/i_datamover_top_wrap/i_datamover_top/i_slave/i_regfile/i_regfile_latch/hwpe_ctrl_regfile_latch_i/clk
    add wave -noupdate -group i_hwpe_subsystem -group i_datamover_top_wrap -group i_slave -group i_regfile_latch /tb_wl_top/dut/i_hwpe_subsystem/i_datamover_top_wrap/i_datamover_top/i_slave/i_regfile/i_regfile_latch/hwpe_ctrl_regfile_latch_i/rst_n
    add wave -noupdate -group i_hwpe_subsystem -group i_datamover_top_wrap -group i_slave -group i_regfile_latch /tb_wl_top/dut/i_hwpe_subsystem/i_datamover_top_wrap/i_datamover_top/i_slave/i_regfile/i_regfile_latch/hwpe_ctrl_regfile_latch_i/clear
    add wave -noupdate -group i_hwpe_subsystem -group i_datamover_top_wrap -group i_slave -group i_regfile_latch /tb_wl_top/dut/i_hwpe_subsystem/i_datamover_top_wrap/i_datamover_top/i_slave/i_regfile/i_regfile_latch/hwpe_ctrl_regfile_latch_i/ReadEnable
    add wave -noupdate -group i_hwpe_subsystem -group i_datamover_top_wrap -group i_slave -group i_regfile_latch /tb_wl_top/dut/i_hwpe_subsystem/i_datamover_top_wrap/i_datamover_top/i_slave/i_regfile/i_regfile_latch/hwpe_ctrl_regfile_latch_i/ReadAddr
    add wave -noupdate -group i_hwpe_subsystem -group i_datamover_top_wrap -group i_slave -group i_regfile_latch /tb_wl_top/dut/i_hwpe_subsystem/i_datamover_top_wrap/i_datamover_top/i_slave/i_regfile/i_regfile_latch/hwpe_ctrl_regfile_latch_i/ReadData
    add wave -noupdate -group i_hwpe_subsystem -group i_datamover_top_wrap -group i_slave -group i_regfile_latch /tb_wl_top/dut/i_hwpe_subsystem/i_datamover_top_wrap/i_datamover_top/i_slave/i_regfile/i_regfile_latch/hwpe_ctrl_regfile_latch_i/WriteEnable
    add wave -noupdate -group i_hwpe_subsystem -group i_datamover_top_wrap -group i_slave -group i_regfile_latch /tb_wl_top/dut/i_hwpe_subsystem/i_datamover_top_wrap/i_datamover_top/i_slave/i_regfile/i_regfile_latch/hwpe_ctrl_regfile_latch_i/WriteAddr
    add wave -noupdate -group i_hwpe_subsystem -group i_datamover_top_wrap -group i_slave -group i_regfile_latch /tb_wl_top/dut/i_hwpe_subsystem/i_datamover_top_wrap/i_datamover_top/i_slave/i_regfile/i_regfile_latch/hwpe_ctrl_regfile_latch_i/WriteData
    add wave -noupdate -group i_hwpe_subsystem -group i_datamover_top_wrap -group i_slave -group i_regfile_latch /tb_wl_top/dut/i_hwpe_subsystem/i_datamover_top_wrap/i_datamover_top/i_slave/i_regfile/i_regfile_latch/hwpe_ctrl_regfile_latch_i/WriteBE
    add wave -noupdate -group i_hwpe_subsystem -group i_datamover_top_wrap -group i_slave -group i_regfile_latch /tb_wl_top/dut/i_hwpe_subsystem/i_datamover_top_wrap/i_datamover_top/i_slave/i_regfile/i_regfile_latch/hwpe_ctrl_regfile_latch_i/MemContent
    add wave -noupdate -group i_hwpe_subsystem -group i_datamover_top_wrap -group i_slave -group i_regfile_latch /tb_wl_top/dut/i_hwpe_subsystem/i_datamover_top_wrap/i_datamover_top/i_slave/i_regfile/i_regfile_latch/hwpe_ctrl_regfile_latch_i/RAddrRegxDP
    add wave -noupdate -group i_hwpe_subsystem -group i_datamover_top_wrap -group i_slave -group i_regfile_latch /tb_wl_top/dut/i_hwpe_subsystem/i_datamover_top_wrap/i_datamover_top/i_slave/i_regfile/i_regfile_latch/hwpe_ctrl_regfile_latch_i/RAddrOneHotxD
    add wave -noupdate -group i_hwpe_subsystem -group i_datamover_top_wrap -group i_slave -group i_regfile_latch /tb_wl_top/dut/i_hwpe_subsystem/i_datamover_top_wrap/i_datamover_top/i_slave/i_regfile/i_regfile_latch/hwpe_ctrl_regfile_latch_i/WAddrOneHotxD
    add wave -noupdate -group i_hwpe_subsystem -group i_datamover_top_wrap -group i_slave -group i_regfile_latch /tb_wl_top/dut/i_hwpe_subsystem/i_datamover_top_wrap/i_datamover_top/i_slave/i_regfile/i_regfile_latch/hwpe_ctrl_regfile_latch_i/ClocksxC
    add wave -noupdate -group i_hwpe_subsystem -group i_datamover_top_wrap -group i_slave -group i_regfile_latch /tb_wl_top/dut/i_hwpe_subsystem/i_datamover_top_wrap/i_datamover_top/i_slave/i_regfile/i_regfile_latch/hwpe_ctrl_regfile_latch_i/WDataIntxD
    add wave -noupdate -group i_hwpe_subsystem -group i_datamover_top_wrap -group i_slave -group i_regfile_latch /tb_wl_top/dut/i_hwpe_subsystem/i_datamover_top_wrap/i_datamover_top/i_slave/i_regfile/i_regfile_latch/hwpe_ctrl_regfile_latch_i/clk_int
    add wave -noupdate -group i_hwpe_subsystem -group i_datamover_top_wrap -group i_slave -group i_regfile_latch /tb_wl_top/dut/i_hwpe_subsystem/i_datamover_top_wrap/i_datamover_top/i_slave/i_regfile/i_regfile_latch/hwpe_ctrl_regfile_latch_i/i
    add wave -noupdate -group i_hwpe_subsystem -group i_datamover_top_wrap -group i_slave -group i_regfile_latch /tb_wl_top/dut/i_hwpe_subsystem/i_datamover_top_wrap/i_datamover_top/i_slave/i_regfile/i_regfile_latch/hwpe_ctrl_regfile_latch_i/j
    add wave -noupdate -group i_hwpe_subsystem -group i_datamover_top_wrap -group i_slave -group i_regfile_latch /tb_wl_top/dut/i_hwpe_subsystem/i_datamover_top_wrap/i_datamover_top/i_slave/i_regfile/i_regfile_latch/hwpe_ctrl_regfile_latch_i/k
    add wave -noupdate -group i_hwpe_subsystem -group i_datamover_top_wrap -group i_slave -group i_regfile_latch /tb_wl_top/dut/i_hwpe_subsystem/i_datamover_top_wrap/i_datamover_top/i_slave/i_regfile/i_regfile_latch/hwpe_ctrl_regfile_latch_i/l
    add wave -noupdate -group i_hwpe_subsystem -group i_datamover_top_wrap -group i_slave -group i_regfile_latch /tb_wl_top/dut/i_hwpe_subsystem/i_datamover_top_wrap/i_datamover_top/i_slave/i_regfile/i_regfile_latch/hwpe_ctrl_regfile_latch_i/m
    add wave -noupdate -group i_hwpe_subsystem -group i_axi2hci /tb_wl_top/dut/i_hwpe_subsystem/i_axi2hci/clk_i
    add wave -noupdate -group i_hwpe_subsystem -group i_axi2hci /tb_wl_top/dut/i_hwpe_subsystem/i_axi2hci/rst_ni
    add wave -noupdate -group i_hwpe_subsystem -group i_axi2hci /tb_wl_top/dut/i_hwpe_subsystem/i_axi2hci/axi_slave_req_i
    add wave -noupdate -group i_hwpe_subsystem -group i_axi2hci /tb_wl_top/dut/i_hwpe_subsystem/i_axi2hci/axi_slave_resp_o
    add wave -noupdate -group i_hwpe_subsystem -group i_axi2hci /tb_wl_top/dut/i_hwpe_subsystem/i_axi2hci/mem_req
    add wave -noupdate -group i_hwpe_subsystem -group i_axi2hci /tb_wl_top/dut/i_hwpe_subsystem/i_axi2hci/mem_gnt
    add wave -noupdate -group i_hwpe_subsystem -group i_axi2hci /tb_wl_top/dut/i_hwpe_subsystem/i_axi2hci/mem_addr
    add wave -noupdate -group i_hwpe_subsystem -group i_axi2hci /tb_wl_top/dut/i_hwpe_subsystem/i_axi2hci/mem_wdata
    add wave -noupdate -group i_hwpe_subsystem -group i_axi2hci /tb_wl_top/dut/i_hwpe_subsystem/i_axi2hci/mem_strb
    add wave -noupdate -group i_hwpe_subsystem -group i_axi2hci /tb_wl_top/dut/i_hwpe_subsystem/i_axi2hci/mem_we
    add wave -noupdate -group i_hwpe_subsystem -group i_axi2hci /tb_wl_top/dut/i_hwpe_subsystem/i_axi2hci/mem_rvalid
    add wave -noupdate -group i_hwpe_subsystem -group i_axi2hci /tb_wl_top/dut/i_hwpe_subsystem/i_axi2hci/mem_rdata
    add wave -noupdate -divider Memories
    add wave -noupdate -group i_data_mem_mux /tb_wl_top/dut/i_data_mem_mux/clk_i
    add wave -noupdate -group i_data_mem_mux /tb_wl_top/dut/i_data_mem_mux/rst_ni
    add wave -noupdate -group i_data_mem_mux /tb_wl_top/dut/i_data_mem_mux/slv_req_i
    add wave -noupdate -group i_data_mem_mux /tb_wl_top/dut/i_data_mem_mux/slv_rsp_o
    add wave -noupdate -group i_data_mem_mux /tb_wl_top/dut/i_data_mem_mux/mst_req_o
    add wave -noupdate -group i_data_mem_mux /tb_wl_top/dut/i_data_mem_mux/mst_rsp_i
    add wave -noupdate -group i_data_mem_mux /tb_wl_top/dut/i_data_mem_mux/idx_o
    add wave -noupdate -group i_data_mem_mux /tb_wl_top/dut/i_data_mem_mux/req_valid_masked
    add wave -noupdate -group i_data_mem_mux /tb_wl_top/dut/i_data_mem_mux/req_ready_masked
    add wave -noupdate -group i_data_mem_mux /tb_wl_top/dut/i_data_mem_mux/idx
    add wave -noupdate -group i_data_mem_mux /tb_wl_top/dut/i_data_mem_mux/idx_rsp
    add wave -noupdate -group i_data_mem_mux /tb_wl_top/dut/i_data_mem_mux/full
    add wave -noupdate -group i_data_mem_mux /tb_wl_top/dut/i_data_mem_mux/req_payload_q
    add wave -noupdate -group i_data_mem_mux /tb_wl_top/dut/i_data_mem_mux/req_valid_q
    add wave -noupdate -group i_data_mem_mux /tb_wl_top/dut/i_data_mem_mux/req_ready_q
    add wave -noupdate -group i_data_mem_mux /tb_wl_top/dut/i_data_mem_mux/slv_rsp_q_ready
    add wave -noupdate -group i_data_mem /tb_wl_top/dut/i_data_mem/clk_i
    add wave -noupdate -group i_data_mem /tb_wl_top/dut/i_data_mem/rst_ni
    if {[examine -nocomplain /tb_wl_top/dut/i_data_mem/i_scm/MemContentxDP] != ""} {
        # SCM
        add wave -noupdate -group i_data_mem -color Gold -label {Memory content} /tb_wl_top/dut/i_data_mem/i_scm/MemContentxDP
    } elseif {[examine -nocomplain /tb_wl_top/dut/i_data_mem/i_sram/sram] != ""} {
        # SRAM
        add wave -noupdate -group i_data_mem -color Gold -label {Memory content} /tb_wl_top/dut/i_data_mem/i_sram/sram
    }
    add wave -noupdate -group i_data_mem /tb_wl_top/dut/i_data_mem/slv_req_i
    add wave -noupdate -group i_data_mem /tb_wl_top/dut/i_data_mem/slv_rsp_o
    add wave -noupdate -group i_data_mem /tb_wl_top/dut/i_data_mem/rw_idx
    add wave -noupdate -group i_data_mem /tb_wl_top/dut/i_data_mem/r_en
    add wave -noupdate -group i_data_mem /tb_wl_top/dut/i_data_mem/w_en
    add wave -noupdate -group i_data_mem /tb_wl_top/dut/i_data_mem/r_data
    add wave -noupdate -group i_data_mem /tb_wl_top/dut/i_data_mem/w_data
    add wave -noupdate -group i_data_mem /tb_wl_top/dut/i_data_mem/curr_state
    add wave -noupdate -group i_data_mem /tb_wl_top/dut/i_data_mem/next_state
    add wave -noupdate -group i_instr_mem_r_mux /tb_wl_top/dut/i_instr_mem_r_mux/clk_i
    add wave -noupdate -group i_instr_mem_r_mux /tb_wl_top/dut/i_instr_mem_r_mux/rst_ni
    add wave -noupdate -group i_instr_mem_r_mux /tb_wl_top/dut/i_instr_mem_r_mux/inp_data_i
    add wave -noupdate -group i_instr_mem_r_mux /tb_wl_top/dut/i_instr_mem_r_mux/inp_valid_i
    add wave -noupdate -group i_instr_mem_r_mux /tb_wl_top/dut/i_instr_mem_r_mux/inp_ready_o
    add wave -noupdate -group i_instr_mem_r_mux /tb_wl_top/dut/i_instr_mem_r_mux/oup_data_o
    add wave -noupdate -group i_instr_mem_r_mux /tb_wl_top/dut/i_instr_mem_r_mux/oup_valid_o
    add wave -noupdate -group i_instr_mem_r_mux /tb_wl_top/dut/i_instr_mem_r_mux/oup_ready_i
    add wave -noupdate -group i_instr_mem /tb_wl_top/dut/i_instr_mem/clk_i
    add wave -noupdate -group i_instr_mem /tb_wl_top/dut/i_instr_mem/rst_ni
    if {[examine -nocomplain /tb_wl_top/dut/i_instr_mem/i_scm/MemContentxDP] != ""} {
        # SCM
        add wave -noupdate -group i_instr_mem -color Gold -label {Memory content} /tb_wl_top/dut/i_instr_mem/i_scm/MemContentxDP
    } elseif {[examine -nocomplain /tb_wl_top/dut/i_instr_mem/i_sram/sram] != ""} {
        # SRAM
        add wave -noupdate -group i_instr_mem -color Gold -label {Memory content} /tb_wl_top/dut/i_instr_mem/i_sram/sram
    }
    add wave -noupdate -group i_instr_mem /tb_wl_top/dut/i_instr_mem/rw_gnt_o
    add wave -noupdate -group i_instr_mem /tb_wl_top/dut/i_instr_mem/r_en_i
    add wave -noupdate -group i_instr_mem /tb_wl_top/dut/i_instr_mem/r_addr_i
    add wave -noupdate -group i_instr_mem /tb_wl_top/dut/i_instr_mem/r_data_o
    add wave -noupdate -group i_instr_mem /tb_wl_top/dut/i_instr_mem/r_valid_o
    add wave -noupdate -group i_instr_mem /tb_wl_top/dut/i_instr_mem/w_en_i
    add wave -noupdate -group i_instr_mem /tb_wl_top/dut/i_instr_mem/w_addr_i
    add wave -noupdate -group i_instr_mem /tb_wl_top/dut/i_instr_mem/w_data_i
    add wave -noupdate -group i_instr_mem /tb_wl_top/dut/i_instr_mem/w_ack_o
    add wave -noupdate -group i_instr_mem /tb_wl_top/dut/i_instr_mem/r_idx
    add wave -noupdate -group i_instr_mem /tb_wl_top/dut/i_instr_mem/w_idx
    add wave -noupdate -group i_instr_mem /tb_wl_top/dut/i_instr_mem/mem_r_en
    add wave -noupdate -group i_instr_mem /tb_wl_top/dut/i_instr_mem/mem_r_idx
    add wave -noupdate -group i_instr_mem /tb_wl_top/dut/i_instr_mem/mem_r_data
    add wave -noupdate -group i_instr_mem /tb_wl_top/dut/i_instr_mem/curr_state
    add wave -noupdate -group i_instr_mem /tb_wl_top/dut/i_instr_mem/next_state
    add wave -noupdate -group i_instr_mem /tb_wl_top/dut/i_instr_mem/r_idx_q
    add wave -noupdate -group i_instr_mem /tb_wl_top/dut/i_instr_mem/pref_idx_q
    add wave -noupdate -group i_instr_mem /tb_wl_top/dut/i_instr_mem/pref_idx_d
    add wave -noupdate -group i_instr_mem /tb_wl_top/dut/i_instr_mem/rdata_bak_q
    add wave -noupdate -group i_instr_mem /tb_wl_top/dut/i_instr_mem/rdata_bak_d
    add wave -noupdate -group i_bootrom /tb_wl_top/dut/i_bootrom/clk_i
    add wave -noupdate -group i_bootrom /tb_wl_top/dut/i_bootrom/rst_ni
    add wave -noupdate -group i_bootrom /tb_wl_top/dut/i_bootrom/req_i
    add wave -noupdate -group i_bootrom /tb_wl_top/dut/i_bootrom/addr_i
    add wave -noupdate -group i_bootrom /tb_wl_top/dut/i_bootrom/data_o
    add wave -noupdate -group i_bootrom /tb_wl_top/dut/i_bootrom/word
    add wave -noupdate -divider {Cluster bus & adapters}
    add wave -noupdate -group i_cluster_bus_xbar /tb_wl_top/dut/i_cluster_bus_xbar/clk_i
    add wave -noupdate -group i_cluster_bus_xbar /tb_wl_top/dut/i_cluster_bus_xbar/rst_ni
    add wave -noupdate -group i_cluster_bus_xbar /tb_wl_top/dut/i_cluster_bus_xbar/test_i
    add wave -noupdate -group i_cluster_bus_xbar /tb_wl_top/dut/i_cluster_bus_xbar/addr_map_i
    add wave -noupdate -group i_cluster_bus_xbar /tb_wl_top/dut/i_cluster_bus_xbar/en_default_mst_port_i
    add wave -noupdate -group i_cluster_bus_xbar /tb_wl_top/dut/i_cluster_bus_xbar/default_mst_port_i
    add wave -noupdate -group i_cluster_bus_xbar /tb_wl_top/dut/i_cluster_bus_xbar/mst_reqs
    add wave -noupdate -group i_cluster_bus_xbar /tb_wl_top/dut/i_cluster_bus_xbar/mst_resps
    add wave -noupdate -group i_cluster_bus_xbar /tb_wl_top/dut/i_cluster_bus_xbar/slv_reqs
    add wave -noupdate -group i_cluster_bus_xbar /tb_wl_top/dut/i_cluster_bus_xbar/slv_resps
    add wave -noupdate -group i_bus_data_mem_axi_lite_to_axi -group in /tb_wl_top/dut/i_bus_data_mem_axi_lite_to_axi/in/aw_addr
    add wave -noupdate -group i_bus_data_mem_axi_lite_to_axi -group in /tb_wl_top/dut/i_bus_data_mem_axi_lite_to_axi/in/aw_prot
    add wave -noupdate -group i_bus_data_mem_axi_lite_to_axi -group in /tb_wl_top/dut/i_bus_data_mem_axi_lite_to_axi/in/aw_valid
    add wave -noupdate -group i_bus_data_mem_axi_lite_to_axi -group in /tb_wl_top/dut/i_bus_data_mem_axi_lite_to_axi/in/aw_ready
    add wave -noupdate -group i_bus_data_mem_axi_lite_to_axi -group in /tb_wl_top/dut/i_bus_data_mem_axi_lite_to_axi/in/w_data
    add wave -noupdate -group i_bus_data_mem_axi_lite_to_axi -group in /tb_wl_top/dut/i_bus_data_mem_axi_lite_to_axi/in/w_strb
    add wave -noupdate -group i_bus_data_mem_axi_lite_to_axi -group in /tb_wl_top/dut/i_bus_data_mem_axi_lite_to_axi/in/w_valid
    add wave -noupdate -group i_bus_data_mem_axi_lite_to_axi -group in /tb_wl_top/dut/i_bus_data_mem_axi_lite_to_axi/in/w_ready
    add wave -noupdate -group i_bus_data_mem_axi_lite_to_axi -group in /tb_wl_top/dut/i_bus_data_mem_axi_lite_to_axi/in/b_resp
    add wave -noupdate -group i_bus_data_mem_axi_lite_to_axi -group in /tb_wl_top/dut/i_bus_data_mem_axi_lite_to_axi/in/b_valid
    add wave -noupdate -group i_bus_data_mem_axi_lite_to_axi -group in /tb_wl_top/dut/i_bus_data_mem_axi_lite_to_axi/in/b_ready
    add wave -noupdate -group i_bus_data_mem_axi_lite_to_axi -group in /tb_wl_top/dut/i_bus_data_mem_axi_lite_to_axi/in/ar_addr
    add wave -noupdate -group i_bus_data_mem_axi_lite_to_axi -group in /tb_wl_top/dut/i_bus_data_mem_axi_lite_to_axi/in/ar_prot
    add wave -noupdate -group i_bus_data_mem_axi_lite_to_axi -group in /tb_wl_top/dut/i_bus_data_mem_axi_lite_to_axi/in/ar_valid
    add wave -noupdate -group i_bus_data_mem_axi_lite_to_axi -group in /tb_wl_top/dut/i_bus_data_mem_axi_lite_to_axi/in/ar_ready
    add wave -noupdate -group i_bus_data_mem_axi_lite_to_axi -group in /tb_wl_top/dut/i_bus_data_mem_axi_lite_to_axi/in/r_data
    add wave -noupdate -group i_bus_data_mem_axi_lite_to_axi -group in /tb_wl_top/dut/i_bus_data_mem_axi_lite_to_axi/in/r_resp
    add wave -noupdate -group i_bus_data_mem_axi_lite_to_axi -group in /tb_wl_top/dut/i_bus_data_mem_axi_lite_to_axi/in/r_valid
    add wave -noupdate -group i_bus_data_mem_axi_lite_to_axi -group in /tb_wl_top/dut/i_bus_data_mem_axi_lite_to_axi/in/r_ready
    add wave -noupdate -group i_bus_data_mem_axi_lite_to_axi -group out /tb_wl_top/dut/i_bus_data_mem_axi_lite_to_axi/out/aw_id
    add wave -noupdate -group i_bus_data_mem_axi_lite_to_axi -group out /tb_wl_top/dut/i_bus_data_mem_axi_lite_to_axi/out/aw_addr
    add wave -noupdate -group i_bus_data_mem_axi_lite_to_axi -group out /tb_wl_top/dut/i_bus_data_mem_axi_lite_to_axi/out/aw_len
    add wave -noupdate -group i_bus_data_mem_axi_lite_to_axi -group out /tb_wl_top/dut/i_bus_data_mem_axi_lite_to_axi/out/aw_size
    add wave -noupdate -group i_bus_data_mem_axi_lite_to_axi -group out /tb_wl_top/dut/i_bus_data_mem_axi_lite_to_axi/out/aw_burst
    add wave -noupdate -group i_bus_data_mem_axi_lite_to_axi -group out /tb_wl_top/dut/i_bus_data_mem_axi_lite_to_axi/out/aw_lock
    add wave -noupdate -group i_bus_data_mem_axi_lite_to_axi -group out /tb_wl_top/dut/i_bus_data_mem_axi_lite_to_axi/out/aw_cache
    add wave -noupdate -group i_bus_data_mem_axi_lite_to_axi -group out /tb_wl_top/dut/i_bus_data_mem_axi_lite_to_axi/out/aw_prot
    add wave -noupdate -group i_bus_data_mem_axi_lite_to_axi -group out /tb_wl_top/dut/i_bus_data_mem_axi_lite_to_axi/out/aw_qos
    add wave -noupdate -group i_bus_data_mem_axi_lite_to_axi -group out /tb_wl_top/dut/i_bus_data_mem_axi_lite_to_axi/out/aw_region
    add wave -noupdate -group i_bus_data_mem_axi_lite_to_axi -group out /tb_wl_top/dut/i_bus_data_mem_axi_lite_to_axi/out/aw_atop
    add wave -noupdate -group i_bus_data_mem_axi_lite_to_axi -group out /tb_wl_top/dut/i_bus_data_mem_axi_lite_to_axi/out/aw_user
    add wave -noupdate -group i_bus_data_mem_axi_lite_to_axi -group out /tb_wl_top/dut/i_bus_data_mem_axi_lite_to_axi/out/aw_valid
    add wave -noupdate -group i_bus_data_mem_axi_lite_to_axi -group out /tb_wl_top/dut/i_bus_data_mem_axi_lite_to_axi/out/aw_ready
    add wave -noupdate -group i_bus_data_mem_axi_lite_to_axi -group out /tb_wl_top/dut/i_bus_data_mem_axi_lite_to_axi/out/w_data
    add wave -noupdate -group i_bus_data_mem_axi_lite_to_axi -group out /tb_wl_top/dut/i_bus_data_mem_axi_lite_to_axi/out/w_strb
    add wave -noupdate -group i_bus_data_mem_axi_lite_to_axi -group out /tb_wl_top/dut/i_bus_data_mem_axi_lite_to_axi/out/w_last
    add wave -noupdate -group i_bus_data_mem_axi_lite_to_axi -group out /tb_wl_top/dut/i_bus_data_mem_axi_lite_to_axi/out/w_user
    add wave -noupdate -group i_bus_data_mem_axi_lite_to_axi -group out /tb_wl_top/dut/i_bus_data_mem_axi_lite_to_axi/out/w_valid
    add wave -noupdate -group i_bus_data_mem_axi_lite_to_axi -group out /tb_wl_top/dut/i_bus_data_mem_axi_lite_to_axi/out/w_ready
    add wave -noupdate -group i_bus_data_mem_axi_lite_to_axi -group out /tb_wl_top/dut/i_bus_data_mem_axi_lite_to_axi/out/b_id
    add wave -noupdate -group i_bus_data_mem_axi_lite_to_axi -group out /tb_wl_top/dut/i_bus_data_mem_axi_lite_to_axi/out/b_resp
    add wave -noupdate -group i_bus_data_mem_axi_lite_to_axi -group out /tb_wl_top/dut/i_bus_data_mem_axi_lite_to_axi/out/b_user
    add wave -noupdate -group i_bus_data_mem_axi_lite_to_axi -group out /tb_wl_top/dut/i_bus_data_mem_axi_lite_to_axi/out/b_valid
    add wave -noupdate -group i_bus_data_mem_axi_lite_to_axi -group out /tb_wl_top/dut/i_bus_data_mem_axi_lite_to_axi/out/b_ready
    add wave -noupdate -group i_bus_data_mem_axi_lite_to_axi -group out /tb_wl_top/dut/i_bus_data_mem_axi_lite_to_axi/out/ar_id
    add wave -noupdate -group i_bus_data_mem_axi_lite_to_axi -group out /tb_wl_top/dut/i_bus_data_mem_axi_lite_to_axi/out/ar_addr
    add wave -noupdate -group i_bus_data_mem_axi_lite_to_axi -group out /tb_wl_top/dut/i_bus_data_mem_axi_lite_to_axi/out/ar_len
    add wave -noupdate -group i_bus_data_mem_axi_lite_to_axi -group out /tb_wl_top/dut/i_bus_data_mem_axi_lite_to_axi/out/ar_size
    add wave -noupdate -group i_bus_data_mem_axi_lite_to_axi -group out /tb_wl_top/dut/i_bus_data_mem_axi_lite_to_axi/out/ar_burst
    add wave -noupdate -group i_bus_data_mem_axi_lite_to_axi -group out /tb_wl_top/dut/i_bus_data_mem_axi_lite_to_axi/out/ar_lock
    add wave -noupdate -group i_bus_data_mem_axi_lite_to_axi -group out /tb_wl_top/dut/i_bus_data_mem_axi_lite_to_axi/out/ar_cache
    add wave -noupdate -group i_bus_data_mem_axi_lite_to_axi -group out /tb_wl_top/dut/i_bus_data_mem_axi_lite_to_axi/out/ar_prot
    add wave -noupdate -group i_bus_data_mem_axi_lite_to_axi -group out /tb_wl_top/dut/i_bus_data_mem_axi_lite_to_axi/out/ar_qos
    add wave -noupdate -group i_bus_data_mem_axi_lite_to_axi -group out /tb_wl_top/dut/i_bus_data_mem_axi_lite_to_axi/out/ar_region
    add wave -noupdate -group i_bus_data_mem_axi_lite_to_axi -group out /tb_wl_top/dut/i_bus_data_mem_axi_lite_to_axi/out/ar_user
    add wave -noupdate -group i_bus_data_mem_axi_lite_to_axi -group out /tb_wl_top/dut/i_bus_data_mem_axi_lite_to_axi/out/ar_valid
    add wave -noupdate -group i_bus_data_mem_axi_lite_to_axi -group out /tb_wl_top/dut/i_bus_data_mem_axi_lite_to_axi/out/ar_ready
    add wave -noupdate -group i_bus_data_mem_axi_lite_to_axi -group out /tb_wl_top/dut/i_bus_data_mem_axi_lite_to_axi/out/r_id
    add wave -noupdate -group i_bus_data_mem_axi_lite_to_axi -group out /tb_wl_top/dut/i_bus_data_mem_axi_lite_to_axi/out/r_data
    add wave -noupdate -group i_bus_data_mem_axi_lite_to_axi -group out /tb_wl_top/dut/i_bus_data_mem_axi_lite_to_axi/out/r_resp
    add wave -noupdate -group i_bus_data_mem_axi_lite_to_axi -group out /tb_wl_top/dut/i_bus_data_mem_axi_lite_to_axi/out/r_last
    add wave -noupdate -group i_bus_data_mem_axi_lite_to_axi -group out /tb_wl_top/dut/i_bus_data_mem_axi_lite_to_axi/out/r_user
    add wave -noupdate -group i_bus_data_mem_axi_lite_to_axi -group out /tb_wl_top/dut/i_bus_data_mem_axi_lite_to_axi/out/r_valid
    add wave -noupdate -group i_bus_data_mem_axi_lite_to_axi -group out /tb_wl_top/dut/i_bus_data_mem_axi_lite_to_axi/out/r_ready
    add wave -noupdate -group i_bus_data_mem_axi_to_reqrsp -group axi /tb_wl_top/dut/i_bus_data_mem_axi_to_reqrsp/axi/aw_id
    add wave -noupdate -group i_bus_data_mem_axi_to_reqrsp -group axi /tb_wl_top/dut/i_bus_data_mem_axi_to_reqrsp/axi/aw_addr
    add wave -noupdate -group i_bus_data_mem_axi_to_reqrsp -group axi /tb_wl_top/dut/i_bus_data_mem_axi_to_reqrsp/axi/aw_len
    add wave -noupdate -group i_bus_data_mem_axi_to_reqrsp -group axi /tb_wl_top/dut/i_bus_data_mem_axi_to_reqrsp/axi/aw_size
    add wave -noupdate -group i_bus_data_mem_axi_to_reqrsp -group axi /tb_wl_top/dut/i_bus_data_mem_axi_to_reqrsp/axi/aw_burst
    add wave -noupdate -group i_bus_data_mem_axi_to_reqrsp -group axi /tb_wl_top/dut/i_bus_data_mem_axi_to_reqrsp/axi/aw_lock
    add wave -noupdate -group i_bus_data_mem_axi_to_reqrsp -group axi /tb_wl_top/dut/i_bus_data_mem_axi_to_reqrsp/axi/aw_cache
    add wave -noupdate -group i_bus_data_mem_axi_to_reqrsp -group axi /tb_wl_top/dut/i_bus_data_mem_axi_to_reqrsp/axi/aw_prot
    add wave -noupdate -group i_bus_data_mem_axi_to_reqrsp -group axi /tb_wl_top/dut/i_bus_data_mem_axi_to_reqrsp/axi/aw_qos
    add wave -noupdate -group i_bus_data_mem_axi_to_reqrsp -group axi /tb_wl_top/dut/i_bus_data_mem_axi_to_reqrsp/axi/aw_region
    add wave -noupdate -group i_bus_data_mem_axi_to_reqrsp -group axi /tb_wl_top/dut/i_bus_data_mem_axi_to_reqrsp/axi/aw_atop
    add wave -noupdate -group i_bus_data_mem_axi_to_reqrsp -group axi /tb_wl_top/dut/i_bus_data_mem_axi_to_reqrsp/axi/aw_user
    add wave -noupdate -group i_bus_data_mem_axi_to_reqrsp -group axi /tb_wl_top/dut/i_bus_data_mem_axi_to_reqrsp/axi/aw_valid
    add wave -noupdate -group i_bus_data_mem_axi_to_reqrsp -group axi /tb_wl_top/dut/i_bus_data_mem_axi_to_reqrsp/axi/aw_ready
    add wave -noupdate -group i_bus_data_mem_axi_to_reqrsp -group axi /tb_wl_top/dut/i_bus_data_mem_axi_to_reqrsp/axi/w_data
    add wave -noupdate -group i_bus_data_mem_axi_to_reqrsp -group axi /tb_wl_top/dut/i_bus_data_mem_axi_to_reqrsp/axi/w_strb
    add wave -noupdate -group i_bus_data_mem_axi_to_reqrsp -group axi /tb_wl_top/dut/i_bus_data_mem_axi_to_reqrsp/axi/w_last
    add wave -noupdate -group i_bus_data_mem_axi_to_reqrsp -group axi /tb_wl_top/dut/i_bus_data_mem_axi_to_reqrsp/axi/w_user
    add wave -noupdate -group i_bus_data_mem_axi_to_reqrsp -group axi /tb_wl_top/dut/i_bus_data_mem_axi_to_reqrsp/axi/w_valid
    add wave -noupdate -group i_bus_data_mem_axi_to_reqrsp -group axi /tb_wl_top/dut/i_bus_data_mem_axi_to_reqrsp/axi/w_ready
    add wave -noupdate -group i_bus_data_mem_axi_to_reqrsp -group axi /tb_wl_top/dut/i_bus_data_mem_axi_to_reqrsp/axi/b_id
    add wave -noupdate -group i_bus_data_mem_axi_to_reqrsp -group axi /tb_wl_top/dut/i_bus_data_mem_axi_to_reqrsp/axi/b_resp
    add wave -noupdate -group i_bus_data_mem_axi_to_reqrsp -group axi /tb_wl_top/dut/i_bus_data_mem_axi_to_reqrsp/axi/b_user
    add wave -noupdate -group i_bus_data_mem_axi_to_reqrsp -group axi /tb_wl_top/dut/i_bus_data_mem_axi_to_reqrsp/axi/b_valid
    add wave -noupdate -group i_bus_data_mem_axi_to_reqrsp -group axi /tb_wl_top/dut/i_bus_data_mem_axi_to_reqrsp/axi/b_ready
    add wave -noupdate -group i_bus_data_mem_axi_to_reqrsp -group axi /tb_wl_top/dut/i_bus_data_mem_axi_to_reqrsp/axi/ar_id
    add wave -noupdate -group i_bus_data_mem_axi_to_reqrsp -group axi /tb_wl_top/dut/i_bus_data_mem_axi_to_reqrsp/axi/ar_addr
    add wave -noupdate -group i_bus_data_mem_axi_to_reqrsp -group axi /tb_wl_top/dut/i_bus_data_mem_axi_to_reqrsp/axi/ar_len
    add wave -noupdate -group i_bus_data_mem_axi_to_reqrsp -group axi /tb_wl_top/dut/i_bus_data_mem_axi_to_reqrsp/axi/ar_size
    add wave -noupdate -group i_bus_data_mem_axi_to_reqrsp -group axi /tb_wl_top/dut/i_bus_data_mem_axi_to_reqrsp/axi/ar_burst
    add wave -noupdate -group i_bus_data_mem_axi_to_reqrsp -group axi /tb_wl_top/dut/i_bus_data_mem_axi_to_reqrsp/axi/ar_lock
    add wave -noupdate -group i_bus_data_mem_axi_to_reqrsp -group axi /tb_wl_top/dut/i_bus_data_mem_axi_to_reqrsp/axi/ar_cache
    add wave -noupdate -group i_bus_data_mem_axi_to_reqrsp -group axi /tb_wl_top/dut/i_bus_data_mem_axi_to_reqrsp/axi/ar_prot
    add wave -noupdate -group i_bus_data_mem_axi_to_reqrsp -group axi /tb_wl_top/dut/i_bus_data_mem_axi_to_reqrsp/axi/ar_qos
    add wave -noupdate -group i_bus_data_mem_axi_to_reqrsp -group axi /tb_wl_top/dut/i_bus_data_mem_axi_to_reqrsp/axi/ar_region
    add wave -noupdate -group i_bus_data_mem_axi_to_reqrsp -group axi /tb_wl_top/dut/i_bus_data_mem_axi_to_reqrsp/axi/ar_user
    add wave -noupdate -group i_bus_data_mem_axi_to_reqrsp -group axi /tb_wl_top/dut/i_bus_data_mem_axi_to_reqrsp/axi/ar_valid
    add wave -noupdate -group i_bus_data_mem_axi_to_reqrsp -group axi /tb_wl_top/dut/i_bus_data_mem_axi_to_reqrsp/axi/ar_ready
    add wave -noupdate -group i_bus_data_mem_axi_to_reqrsp -group axi /tb_wl_top/dut/i_bus_data_mem_axi_to_reqrsp/axi/r_id
    add wave -noupdate -group i_bus_data_mem_axi_to_reqrsp -group axi /tb_wl_top/dut/i_bus_data_mem_axi_to_reqrsp/axi/r_data
    add wave -noupdate -group i_bus_data_mem_axi_to_reqrsp -group axi /tb_wl_top/dut/i_bus_data_mem_axi_to_reqrsp/axi/r_resp
    add wave -noupdate -group i_bus_data_mem_axi_to_reqrsp -group axi /tb_wl_top/dut/i_bus_data_mem_axi_to_reqrsp/axi/r_last
    add wave -noupdate -group i_bus_data_mem_axi_to_reqrsp -group axi /tb_wl_top/dut/i_bus_data_mem_axi_to_reqrsp/axi/r_user
    add wave -noupdate -group i_bus_data_mem_axi_to_reqrsp -group axi /tb_wl_top/dut/i_bus_data_mem_axi_to_reqrsp/axi/r_valid
    add wave -noupdate -group i_bus_data_mem_axi_to_reqrsp -group axi /tb_wl_top/dut/i_bus_data_mem_axi_to_reqrsp/axi/r_ready
    add wave -noupdate -group i_bus_data_mem_axi_to_reqrsp -group reqrsp /tb_wl_top/dut/i_bus_data_mem_axi_to_reqrsp/reqrsp/q_addr
    add wave -noupdate -group i_bus_data_mem_axi_to_reqrsp -group reqrsp /tb_wl_top/dut/i_bus_data_mem_axi_to_reqrsp/reqrsp/q_write
    add wave -noupdate -group i_bus_data_mem_axi_to_reqrsp -group reqrsp /tb_wl_top/dut/i_bus_data_mem_axi_to_reqrsp/reqrsp/q_amo
    add wave -noupdate -group i_bus_data_mem_axi_to_reqrsp -group reqrsp /tb_wl_top/dut/i_bus_data_mem_axi_to_reqrsp/reqrsp/q_data
    add wave -noupdate -group i_bus_data_mem_axi_to_reqrsp -group reqrsp /tb_wl_top/dut/i_bus_data_mem_axi_to_reqrsp/reqrsp/q_strb
    add wave -noupdate -group i_bus_data_mem_axi_to_reqrsp -group reqrsp /tb_wl_top/dut/i_bus_data_mem_axi_to_reqrsp/reqrsp/q_size
    add wave -noupdate -group i_bus_data_mem_axi_to_reqrsp -group reqrsp /tb_wl_top/dut/i_bus_data_mem_axi_to_reqrsp/reqrsp/q_valid
    add wave -noupdate -group i_bus_data_mem_axi_to_reqrsp -group reqrsp /tb_wl_top/dut/i_bus_data_mem_axi_to_reqrsp/reqrsp/q_ready
    add wave -noupdate -group i_bus_data_mem_axi_to_reqrsp -group reqrsp /tb_wl_top/dut/i_bus_data_mem_axi_to_reqrsp/reqrsp/p_data
    add wave -noupdate -group i_bus_data_mem_axi_to_reqrsp -group reqrsp /tb_wl_top/dut/i_bus_data_mem_axi_to_reqrsp/reqrsp/p_error
    add wave -noupdate -group i_bus_data_mem_axi_to_reqrsp -group reqrsp /tb_wl_top/dut/i_bus_data_mem_axi_to_reqrsp/reqrsp/p_valid
    add wave -noupdate -group i_bus_data_mem_axi_to_reqrsp -group reqrsp /tb_wl_top/dut/i_bus_data_mem_axi_to_reqrsp/reqrsp/p_ready
    add wave -noupdate -group i_bus_instr_mem_axi_lite_to_axi -group in /tb_wl_top/dut/i_bus_instr_mem_axi_lite_to_axi/in/aw_addr
    add wave -noupdate -group i_bus_instr_mem_axi_lite_to_axi -group in /tb_wl_top/dut/i_bus_instr_mem_axi_lite_to_axi/in/aw_prot
    add wave -noupdate -group i_bus_instr_mem_axi_lite_to_axi -group in /tb_wl_top/dut/i_bus_instr_mem_axi_lite_to_axi/in/aw_valid
    add wave -noupdate -group i_bus_instr_mem_axi_lite_to_axi -group in /tb_wl_top/dut/i_bus_instr_mem_axi_lite_to_axi/in/aw_ready
    add wave -noupdate -group i_bus_instr_mem_axi_lite_to_axi -group in /tb_wl_top/dut/i_bus_instr_mem_axi_lite_to_axi/in/w_data
    add wave -noupdate -group i_bus_instr_mem_axi_lite_to_axi -group in /tb_wl_top/dut/i_bus_instr_mem_axi_lite_to_axi/in/w_strb
    add wave -noupdate -group i_bus_instr_mem_axi_lite_to_axi -group in /tb_wl_top/dut/i_bus_instr_mem_axi_lite_to_axi/in/w_valid
    add wave -noupdate -group i_bus_instr_mem_axi_lite_to_axi -group in /tb_wl_top/dut/i_bus_instr_mem_axi_lite_to_axi/in/w_ready
    add wave -noupdate -group i_bus_instr_mem_axi_lite_to_axi -group in /tb_wl_top/dut/i_bus_instr_mem_axi_lite_to_axi/in/b_resp
    add wave -noupdate -group i_bus_instr_mem_axi_lite_to_axi -group in /tb_wl_top/dut/i_bus_instr_mem_axi_lite_to_axi/in/b_valid
    add wave -noupdate -group i_bus_instr_mem_axi_lite_to_axi -group in /tb_wl_top/dut/i_bus_instr_mem_axi_lite_to_axi/in/b_ready
    add wave -noupdate -group i_bus_instr_mem_axi_lite_to_axi -group in /tb_wl_top/dut/i_bus_instr_mem_axi_lite_to_axi/in/ar_addr
    add wave -noupdate -group i_bus_instr_mem_axi_lite_to_axi -group in /tb_wl_top/dut/i_bus_instr_mem_axi_lite_to_axi/in/ar_prot
    add wave -noupdate -group i_bus_instr_mem_axi_lite_to_axi -group in /tb_wl_top/dut/i_bus_instr_mem_axi_lite_to_axi/in/ar_valid
    add wave -noupdate -group i_bus_instr_mem_axi_lite_to_axi -group in /tb_wl_top/dut/i_bus_instr_mem_axi_lite_to_axi/in/ar_ready
    add wave -noupdate -group i_bus_instr_mem_axi_lite_to_axi -group in /tb_wl_top/dut/i_bus_instr_mem_axi_lite_to_axi/in/r_data
    add wave -noupdate -group i_bus_instr_mem_axi_lite_to_axi -group in /tb_wl_top/dut/i_bus_instr_mem_axi_lite_to_axi/in/r_resp
    add wave -noupdate -group i_bus_instr_mem_axi_lite_to_axi -group in /tb_wl_top/dut/i_bus_instr_mem_axi_lite_to_axi/in/r_valid
    add wave -noupdate -group i_bus_instr_mem_axi_lite_to_axi -group in /tb_wl_top/dut/i_bus_instr_mem_axi_lite_to_axi/in/r_ready
    add wave -noupdate -group i_bus_instr_mem_axi_lite_to_axi -group out /tb_wl_top/dut/i_bus_instr_mem_axi_lite_to_axi/out/aw_id
    add wave -noupdate -group i_bus_instr_mem_axi_lite_to_axi -group out /tb_wl_top/dut/i_bus_instr_mem_axi_lite_to_axi/out/aw_addr
    add wave -noupdate -group i_bus_instr_mem_axi_lite_to_axi -group out /tb_wl_top/dut/i_bus_instr_mem_axi_lite_to_axi/out/aw_len
    add wave -noupdate -group i_bus_instr_mem_axi_lite_to_axi -group out /tb_wl_top/dut/i_bus_instr_mem_axi_lite_to_axi/out/aw_size
    add wave -noupdate -group i_bus_instr_mem_axi_lite_to_axi -group out /tb_wl_top/dut/i_bus_instr_mem_axi_lite_to_axi/out/aw_burst
    add wave -noupdate -group i_bus_instr_mem_axi_lite_to_axi -group out /tb_wl_top/dut/i_bus_instr_mem_axi_lite_to_axi/out/aw_lock
    add wave -noupdate -group i_bus_instr_mem_axi_lite_to_axi -group out /tb_wl_top/dut/i_bus_instr_mem_axi_lite_to_axi/out/aw_cache
    add wave -noupdate -group i_bus_instr_mem_axi_lite_to_axi -group out /tb_wl_top/dut/i_bus_instr_mem_axi_lite_to_axi/out/aw_prot
    add wave -noupdate -group i_bus_instr_mem_axi_lite_to_axi -group out /tb_wl_top/dut/i_bus_instr_mem_axi_lite_to_axi/out/aw_qos
    add wave -noupdate -group i_bus_instr_mem_axi_lite_to_axi -group out /tb_wl_top/dut/i_bus_instr_mem_axi_lite_to_axi/out/aw_region
    add wave -noupdate -group i_bus_instr_mem_axi_lite_to_axi -group out /tb_wl_top/dut/i_bus_instr_mem_axi_lite_to_axi/out/aw_atop
    add wave -noupdate -group i_bus_instr_mem_axi_lite_to_axi -group out /tb_wl_top/dut/i_bus_instr_mem_axi_lite_to_axi/out/aw_user
    add wave -noupdate -group i_bus_instr_mem_axi_lite_to_axi -group out /tb_wl_top/dut/i_bus_instr_mem_axi_lite_to_axi/out/aw_valid
    add wave -noupdate -group i_bus_instr_mem_axi_lite_to_axi -group out /tb_wl_top/dut/i_bus_instr_mem_axi_lite_to_axi/out/aw_ready
    add wave -noupdate -group i_bus_instr_mem_axi_lite_to_axi -group out /tb_wl_top/dut/i_bus_instr_mem_axi_lite_to_axi/out/w_data
    add wave -noupdate -group i_bus_instr_mem_axi_lite_to_axi -group out /tb_wl_top/dut/i_bus_instr_mem_axi_lite_to_axi/out/w_strb
    add wave -noupdate -group i_bus_instr_mem_axi_lite_to_axi -group out /tb_wl_top/dut/i_bus_instr_mem_axi_lite_to_axi/out/w_last
    add wave -noupdate -group i_bus_instr_mem_axi_lite_to_axi -group out /tb_wl_top/dut/i_bus_instr_mem_axi_lite_to_axi/out/w_user
    add wave -noupdate -group i_bus_instr_mem_axi_lite_to_axi -group out /tb_wl_top/dut/i_bus_instr_mem_axi_lite_to_axi/out/w_valid
    add wave -noupdate -group i_bus_instr_mem_axi_lite_to_axi -group out /tb_wl_top/dut/i_bus_instr_mem_axi_lite_to_axi/out/w_ready
    add wave -noupdate -group i_bus_instr_mem_axi_lite_to_axi -group out /tb_wl_top/dut/i_bus_instr_mem_axi_lite_to_axi/out/b_id
    add wave -noupdate -group i_bus_instr_mem_axi_lite_to_axi -group out /tb_wl_top/dut/i_bus_instr_mem_axi_lite_to_axi/out/b_resp
    add wave -noupdate -group i_bus_instr_mem_axi_lite_to_axi -group out /tb_wl_top/dut/i_bus_instr_mem_axi_lite_to_axi/out/b_user
    add wave -noupdate -group i_bus_instr_mem_axi_lite_to_axi -group out /tb_wl_top/dut/i_bus_instr_mem_axi_lite_to_axi/out/b_valid
    add wave -noupdate -group i_bus_instr_mem_axi_lite_to_axi -group out /tb_wl_top/dut/i_bus_instr_mem_axi_lite_to_axi/out/b_ready
    add wave -noupdate -group i_bus_instr_mem_axi_lite_to_axi -group out /tb_wl_top/dut/i_bus_instr_mem_axi_lite_to_axi/out/ar_id
    add wave -noupdate -group i_bus_instr_mem_axi_lite_to_axi -group out /tb_wl_top/dut/i_bus_instr_mem_axi_lite_to_axi/out/ar_addr
    add wave -noupdate -group i_bus_instr_mem_axi_lite_to_axi -group out /tb_wl_top/dut/i_bus_instr_mem_axi_lite_to_axi/out/ar_len
    add wave -noupdate -group i_bus_instr_mem_axi_lite_to_axi -group out /tb_wl_top/dut/i_bus_instr_mem_axi_lite_to_axi/out/ar_size
    add wave -noupdate -group i_bus_instr_mem_axi_lite_to_axi -group out /tb_wl_top/dut/i_bus_instr_mem_axi_lite_to_axi/out/ar_burst
    add wave -noupdate -group i_bus_instr_mem_axi_lite_to_axi -group out /tb_wl_top/dut/i_bus_instr_mem_axi_lite_to_axi/out/ar_lock
    add wave -noupdate -group i_bus_instr_mem_axi_lite_to_axi -group out /tb_wl_top/dut/i_bus_instr_mem_axi_lite_to_axi/out/ar_cache
    add wave -noupdate -group i_bus_instr_mem_axi_lite_to_axi -group out /tb_wl_top/dut/i_bus_instr_mem_axi_lite_to_axi/out/ar_prot
    add wave -noupdate -group i_bus_instr_mem_axi_lite_to_axi -group out /tb_wl_top/dut/i_bus_instr_mem_axi_lite_to_axi/out/ar_qos
    add wave -noupdate -group i_bus_instr_mem_axi_lite_to_axi -group out /tb_wl_top/dut/i_bus_instr_mem_axi_lite_to_axi/out/ar_region
    add wave -noupdate -group i_bus_instr_mem_axi_lite_to_axi -group out /tb_wl_top/dut/i_bus_instr_mem_axi_lite_to_axi/out/ar_user
    add wave -noupdate -group i_bus_instr_mem_axi_lite_to_axi -group out /tb_wl_top/dut/i_bus_instr_mem_axi_lite_to_axi/out/ar_valid
    add wave -noupdate -group i_bus_instr_mem_axi_lite_to_axi -group out /tb_wl_top/dut/i_bus_instr_mem_axi_lite_to_axi/out/ar_ready
    add wave -noupdate -group i_bus_instr_mem_axi_lite_to_axi -group out /tb_wl_top/dut/i_bus_instr_mem_axi_lite_to_axi/out/r_id
    add wave -noupdate -group i_bus_instr_mem_axi_lite_to_axi -group out /tb_wl_top/dut/i_bus_instr_mem_axi_lite_to_axi/out/r_data
    add wave -noupdate -group i_bus_instr_mem_axi_lite_to_axi -group out /tb_wl_top/dut/i_bus_instr_mem_axi_lite_to_axi/out/r_resp
    add wave -noupdate -group i_bus_instr_mem_axi_lite_to_axi -group out /tb_wl_top/dut/i_bus_instr_mem_axi_lite_to_axi/out/r_last
    add wave -noupdate -group i_bus_instr_mem_axi_lite_to_axi -group out /tb_wl_top/dut/i_bus_instr_mem_axi_lite_to_axi/out/r_user
    add wave -noupdate -group i_bus_instr_mem_axi_lite_to_axi -group out /tb_wl_top/dut/i_bus_instr_mem_axi_lite_to_axi/out/r_valid
    add wave -noupdate -group i_bus_instr_mem_axi_lite_to_axi -group out /tb_wl_top/dut/i_bus_instr_mem_axi_lite_to_axi/out/r_ready
    add wave -noupdate -group i_bus_instr_mem_axi_to_mem -group axi /tb_wl_top/dut/i_bus_instr_mem_axi_to_mem/slv/aw_id
    add wave -noupdate -group i_bus_instr_mem_axi_to_mem -group axi /tb_wl_top/dut/i_bus_instr_mem_axi_to_mem/slv/aw_addr
    add wave -noupdate -group i_bus_instr_mem_axi_to_mem -group axi /tb_wl_top/dut/i_bus_instr_mem_axi_to_mem/slv/aw_len
    add wave -noupdate -group i_bus_instr_mem_axi_to_mem -group axi /tb_wl_top/dut/i_bus_instr_mem_axi_to_mem/slv/aw_size
    add wave -noupdate -group i_bus_instr_mem_axi_to_mem -group axi /tb_wl_top/dut/i_bus_instr_mem_axi_to_mem/slv/aw_burst
    add wave -noupdate -group i_bus_instr_mem_axi_to_mem -group axi /tb_wl_top/dut/i_bus_instr_mem_axi_to_mem/slv/aw_lock
    add wave -noupdate -group i_bus_instr_mem_axi_to_mem -group axi /tb_wl_top/dut/i_bus_instr_mem_axi_to_mem/slv/aw_cache
    add wave -noupdate -group i_bus_instr_mem_axi_to_mem -group axi /tb_wl_top/dut/i_bus_instr_mem_axi_to_mem/slv/aw_prot
    add wave -noupdate -group i_bus_instr_mem_axi_to_mem -group axi /tb_wl_top/dut/i_bus_instr_mem_axi_to_mem/slv/aw_qos
    add wave -noupdate -group i_bus_instr_mem_axi_to_mem -group axi /tb_wl_top/dut/i_bus_instr_mem_axi_to_mem/slv/aw_region
    add wave -noupdate -group i_bus_instr_mem_axi_to_mem -group axi /tb_wl_top/dut/i_bus_instr_mem_axi_to_mem/slv/aw_atop
    add wave -noupdate -group i_bus_instr_mem_axi_to_mem -group axi /tb_wl_top/dut/i_bus_instr_mem_axi_to_mem/slv/aw_user
    add wave -noupdate -group i_bus_instr_mem_axi_to_mem -group axi /tb_wl_top/dut/i_bus_instr_mem_axi_to_mem/slv/aw_valid
    add wave -noupdate -group i_bus_instr_mem_axi_to_mem -group axi /tb_wl_top/dut/i_bus_instr_mem_axi_to_mem/slv/aw_ready
    add wave -noupdate -group i_bus_instr_mem_axi_to_mem -group axi /tb_wl_top/dut/i_bus_instr_mem_axi_to_mem/slv/w_data
    add wave -noupdate -group i_bus_instr_mem_axi_to_mem -group axi /tb_wl_top/dut/i_bus_instr_mem_axi_to_mem/slv/w_strb
    add wave -noupdate -group i_bus_instr_mem_axi_to_mem -group axi /tb_wl_top/dut/i_bus_instr_mem_axi_to_mem/slv/w_last
    add wave -noupdate -group i_bus_instr_mem_axi_to_mem -group axi /tb_wl_top/dut/i_bus_instr_mem_axi_to_mem/slv/w_user
    add wave -noupdate -group i_bus_instr_mem_axi_to_mem -group axi /tb_wl_top/dut/i_bus_instr_mem_axi_to_mem/slv/w_valid
    add wave -noupdate -group i_bus_instr_mem_axi_to_mem -group axi /tb_wl_top/dut/i_bus_instr_mem_axi_to_mem/slv/w_ready
    add wave -noupdate -group i_bus_instr_mem_axi_to_mem -group axi /tb_wl_top/dut/i_bus_instr_mem_axi_to_mem/slv/b_id
    add wave -noupdate -group i_bus_instr_mem_axi_to_mem -group axi /tb_wl_top/dut/i_bus_instr_mem_axi_to_mem/slv/b_resp
    add wave -noupdate -group i_bus_instr_mem_axi_to_mem -group axi /tb_wl_top/dut/i_bus_instr_mem_axi_to_mem/slv/b_user
    add wave -noupdate -group i_bus_instr_mem_axi_to_mem -group axi /tb_wl_top/dut/i_bus_instr_mem_axi_to_mem/slv/b_valid
    add wave -noupdate -group i_bus_instr_mem_axi_to_mem -group axi /tb_wl_top/dut/i_bus_instr_mem_axi_to_mem/slv/b_ready
    add wave -noupdate -group i_bus_instr_mem_axi_to_mem -group axi /tb_wl_top/dut/i_bus_instr_mem_axi_to_mem/slv/ar_id
    add wave -noupdate -group i_bus_instr_mem_axi_to_mem -group axi /tb_wl_top/dut/i_bus_instr_mem_axi_to_mem/slv/ar_addr
    add wave -noupdate -group i_bus_instr_mem_axi_to_mem -group axi /tb_wl_top/dut/i_bus_instr_mem_axi_to_mem/slv/ar_len
    add wave -noupdate -group i_bus_instr_mem_axi_to_mem -group axi /tb_wl_top/dut/i_bus_instr_mem_axi_to_mem/slv/ar_size
    add wave -noupdate -group i_bus_instr_mem_axi_to_mem -group axi /tb_wl_top/dut/i_bus_instr_mem_axi_to_mem/slv/ar_burst
    add wave -noupdate -group i_bus_instr_mem_axi_to_mem -group axi /tb_wl_top/dut/i_bus_instr_mem_axi_to_mem/slv/ar_lock
    add wave -noupdate -group i_bus_instr_mem_axi_to_mem -group axi /tb_wl_top/dut/i_bus_instr_mem_axi_to_mem/slv/ar_cache
    add wave -noupdate -group i_bus_instr_mem_axi_to_mem -group axi /tb_wl_top/dut/i_bus_instr_mem_axi_to_mem/slv/ar_prot
    add wave -noupdate -group i_bus_instr_mem_axi_to_mem -group axi /tb_wl_top/dut/i_bus_instr_mem_axi_to_mem/slv/ar_qos
    add wave -noupdate -group i_bus_instr_mem_axi_to_mem -group axi /tb_wl_top/dut/i_bus_instr_mem_axi_to_mem/slv/ar_region
    add wave -noupdate -group i_bus_instr_mem_axi_to_mem -group axi /tb_wl_top/dut/i_bus_instr_mem_axi_to_mem/slv/ar_user
    add wave -noupdate -group i_bus_instr_mem_axi_to_mem -group axi /tb_wl_top/dut/i_bus_instr_mem_axi_to_mem/slv/ar_valid
    add wave -noupdate -group i_bus_instr_mem_axi_to_mem -group axi /tb_wl_top/dut/i_bus_instr_mem_axi_to_mem/slv/ar_ready
    add wave -noupdate -group i_bus_instr_mem_axi_to_mem -group axi /tb_wl_top/dut/i_bus_instr_mem_axi_to_mem/slv/r_id
    add wave -noupdate -group i_bus_instr_mem_axi_to_mem -group axi /tb_wl_top/dut/i_bus_instr_mem_axi_to_mem/slv/r_data
    add wave -noupdate -group i_bus_instr_mem_axi_to_mem -group axi /tb_wl_top/dut/i_bus_instr_mem_axi_to_mem/slv/r_resp
    add wave -noupdate -group i_bus_instr_mem_axi_to_mem -group axi /tb_wl_top/dut/i_bus_instr_mem_axi_to_mem/slv/r_last
    add wave -noupdate -group i_bus_instr_mem_axi_to_mem -group axi /tb_wl_top/dut/i_bus_instr_mem_axi_to_mem/slv/r_user
    add wave -noupdate -group i_bus_instr_mem_axi_to_mem -group axi /tb_wl_top/dut/i_bus_instr_mem_axi_to_mem/slv/r_valid
    add wave -noupdate -group i_bus_instr_mem_axi_to_mem -group axi /tb_wl_top/dut/i_bus_instr_mem_axi_to_mem/slv/r_ready
    add wave -noupdate -group i_bus_instr_mem_axi_to_mem -group mem /tb_wl_top/dut/i_bus_instr_mem_axi_to_mem/clk_i
    add wave -noupdate -group i_bus_instr_mem_axi_to_mem -group mem /tb_wl_top/dut/i_bus_instr_mem_axi_to_mem/rst_ni
    add wave -noupdate -group i_bus_instr_mem_axi_to_mem -group mem /tb_wl_top/dut/i_bus_instr_mem_axi_to_mem/busy_o
    add wave -noupdate -group i_bus_instr_mem_axi_to_mem -group mem /tb_wl_top/dut/i_bus_instr_mem_axi_to_mem/mem_req_o
    add wave -noupdate -group i_bus_instr_mem_axi_to_mem -group mem /tb_wl_top/dut/i_bus_instr_mem_axi_to_mem/mem_gnt_i
    add wave -noupdate -group i_bus_instr_mem_axi_to_mem -group mem /tb_wl_top/dut/i_bus_instr_mem_axi_to_mem/mem_addr_o
    add wave -noupdate -group i_bus_instr_mem_axi_to_mem -group mem /tb_wl_top/dut/i_bus_instr_mem_axi_to_mem/mem_wdata_o
    add wave -noupdate -group i_bus_instr_mem_axi_to_mem -group mem /tb_wl_top/dut/i_bus_instr_mem_axi_to_mem/mem_strb_o
    add wave -noupdate -group i_bus_instr_mem_axi_to_mem -group mem /tb_wl_top/dut/i_bus_instr_mem_axi_to_mem/mem_atop_o
    add wave -noupdate -group i_bus_instr_mem_axi_to_mem -group mem /tb_wl_top/dut/i_bus_instr_mem_axi_to_mem/mem_we_o
    add wave -noupdate -group i_bus_instr_mem_axi_to_mem -group mem /tb_wl_top/dut/i_bus_instr_mem_axi_to_mem/mem_rvalid_i
    add wave -noupdate -group i_bus_instr_mem_axi_to_mem -group mem /tb_wl_top/dut/i_bus_instr_mem_axi_to_mem/mem_rdata_i
    add wave -noupdate -group i_bus_core_data_demux_ext_reqrsp_to_axi /tb_wl_top/dut/i_bus_core_data_demux_ext_reqrsp_to_axi/clk_i
    add wave -noupdate -group i_bus_core_data_demux_ext_reqrsp_to_axi /tb_wl_top/dut/i_bus_core_data_demux_ext_reqrsp_to_axi/rst_ni
    add wave -noupdate -group i_bus_core_data_demux_ext_reqrsp_to_axi /tb_wl_top/dut/i_bus_core_data_demux_ext_reqrsp_to_axi/user_i
    add wave -noupdate -group i_bus_core_data_demux_ext_reqrsp_to_axi /tb_wl_top/dut/i_bus_core_data_demux_ext_reqrsp_to_axi/reqrsp_req
    add wave -noupdate -group i_bus_core_data_demux_ext_reqrsp_to_axi /tb_wl_top/dut/i_bus_core_data_demux_ext_reqrsp_to_axi/reqrsp_rsp
    add wave -noupdate -group i_bus_core_data_demux_ext_reqrsp_to_axi /tb_wl_top/dut/i_bus_core_data_demux_ext_reqrsp_to_axi/axi_req
    add wave -noupdate -group i_bus_core_data_demux_ext_reqrsp_to_axi /tb_wl_top/dut/i_bus_core_data_demux_ext_reqrsp_to_axi/axi_rsp
    add wave -noupdate -group i_bus_core_data_demux_ext_axi_to_axi_lite /tb_wl_top/dut/i_bus_core_data_demux_ext_axi_to_axi_lite/clk_i
    add wave -noupdate -group i_bus_core_data_demux_ext_axi_to_axi_lite /tb_wl_top/dut/i_bus_core_data_demux_ext_axi_to_axi_lite/rst_ni
    add wave -noupdate -group i_bus_core_data_demux_ext_axi_to_axi_lite /tb_wl_top/dut/i_bus_core_data_demux_ext_axi_to_axi_lite/testmode_i
    add wave -noupdate -group i_bus_core_data_demux_ext_axi_to_axi_lite /tb_wl_top/dut/i_bus_core_data_demux_ext_axi_to_axi_lite/full_req
    add wave -noupdate -group i_bus_core_data_demux_ext_axi_to_axi_lite /tb_wl_top/dut/i_bus_core_data_demux_ext_axi_to_axi_lite/full_resp
    add wave -noupdate -group i_bus_core_data_demux_ext_axi_to_axi_lite /tb_wl_top/dut/i_bus_core_data_demux_ext_axi_to_axi_lite/lite_req
    add wave -noupdate -group i_bus_core_data_demux_ext_axi_to_axi_lite /tb_wl_top/dut/i_bus_core_data_demux_ext_axi_to_axi_lite/lite_resp
    TreeUpdate [SetDefaultTree]
    quietly wave cursor active 1
    configure wave -namecolwidth 332
    configure wave -valuecolwidth 100
    configure wave -justifyvalue left
    configure wave -signalnamewidth 1
    configure wave -snapdistance 10
    configure wave -datasetprefix 0
    configure wave -rowmargin 4
    configure wave -childrowmargin 2
    configure wave -gridoffset 0
    configure wave -gridperiod 1
    configure wave -griddelta 40
    configure wave -timeline 0
    configure wave -timelineunits ns
    update
    log -r /*
}

run -a
