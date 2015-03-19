// ***************************************************************************
// ***************************************************************************
// Copyright 2015(c) Analog Devices, Inc.
//
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:
//     - Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     - Redistributions in binary form must reproduce the above copyright
//       notice, this list of conditions and the following disclaimer in
//       the documentation and/or other materials provided with the
//       distribution.
//     - Neither the name of Analog Devices, Inc. nor the names of its
//       contributors may be used to endorse or promote products derived
//       from this software without specific prior written permission.
//     - The use of this software may or may not infringe the patent rights
//       of one or more patent holders.  This license does not release you
//       from the requirement that you obtain separate licenses from these
//       patent holders to use this software.
//     - Use of the software either in source or binary form, must be run
//       on or directly connected to an Analog Devices Inc. component.
//
// THIS SOFTWARE IS PROVIDED BY ANALOG DEVICES "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
// INCLUDING, BUT NOT LIMITED TO, NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A
// PARTICULAR PURPOSE ARE DISCLAIMED.
//
// IN NO EVENT SHALL ANALOG DEVICES BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, INTELLECTUAL PROPERTY
// RIGHTS, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
// STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
// THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
// ***************************************************************************
// ***************************************************************************
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module system_top (

  DDR_addr,
  DDR_ba,
  DDR_cas_n,
  DDR_ck_n,
  DDR_ck_p,
  DDR_cke,
  DDR_cs_n,
  DDR_dm,
  DDR_dq,
  DDR_dqs_n,
  DDR_dqs_p,
  DDR_odt,
  DDR_ras_n,
  DDR_reset_n,
  DDR_we_n,

  FIXED_IO_ddr_vrn,
  FIXED_IO_ddr_vrp,
  FIXED_IO_mio,
  FIXED_IO_ps_clk,
  FIXED_IO_ps_porb,
  FIXED_IO_ps_srstb,

  gpio_bd,

  hdmi_out_clk,
  hdmi_vsync,
  hdmi_hsync,
  hdmi_data_e,
  hdmi_data,

  i2s_mclk,
  i2s_bclk,
  i2s_lrclk,
  i2s_sdata_out,
  i2s_sdata_in,

  spdif,

  iic_scl,
  iic_sda,
  iic_mux_scl,
  iic_mux_sda,

  iic_cftl_scl_io,
  iic_cftl_sda_io,

  spi0_mosi,
  spi0_miso,
  spi0_clk,
  spi0_csn,

  spi1_mosi,
  spi1_miso,
  spi1_clk,
  spi1_csn0,
  spi1_csn1,

  gpio_cftl,

  otg_vbusoc);

  inout   [14:0]  DDR_addr;
  inout   [ 2:0]  DDR_ba;
  inout           DDR_cas_n;
  inout           DDR_ck_n;
  inout           DDR_ck_p;
  inout           DDR_cke;
  inout           DDR_cs_n;
  inout   [ 3:0]  DDR_dm;
  inout   [31:0]  DDR_dq;
  inout   [ 3:0]  DDR_dqs_n;
  inout   [ 3:0]  DDR_dqs_p;
  inout           DDR_odt;
  inout           DDR_ras_n;
  inout           DDR_reset_n;
  inout           DDR_we_n;

  inout           FIXED_IO_ddr_vrn;
  inout           FIXED_IO_ddr_vrp;
  inout   [53:0]  FIXED_IO_mio;
  inout           FIXED_IO_ps_clk;
  inout           FIXED_IO_ps_porb;
  inout           FIXED_IO_ps_srstb;

  inout   [31:0]  gpio_bd;

  output          hdmi_out_clk;
  output          hdmi_vsync;
  output          hdmi_hsync;
  output          hdmi_data_e;
  output  [15:0]  hdmi_data;

  output          spdif;

  output          i2s_mclk;
  output          i2s_bclk;
  output          i2s_lrclk;
  output          i2s_sdata_out;
  input           i2s_sdata_in;

  inout           iic_scl;
  inout           iic_sda;
  inout   [ 1:0]  iic_mux_scl;
  inout   [ 1:0]  iic_mux_sda;

  inout           iic_cftl_scl_io;
  inout           iic_cftl_sda_io;

  output          spi0_mosi;
  input           spi0_miso;
  output          spi0_clk;
  output          spi0_csn;

  output          spi1_mosi;
  input           spi1_miso;
  output          spi1_clk;
  output          spi1_csn0;
  output          spi1_csn1;

  inout   [ 1:0]  gpio_cftl;

  input           otg_vbusoc;

  // internal signals

  wire    [33:0]  gpio_i;
  wire    [33:0]  gpio_o;
  wire    [33:0]  gpio_t;
  wire    [ 1:0]  iic_mux_scl_i_s;
  wire    [ 1:0]  iic_mux_scl_o_s;
  wire            iic_mux_scl_t_s;
  wire    [ 1:0]  iic_mux_sda_i_s;
  wire    [ 1:0]  iic_mux_sda_o_s;
  wire            iic_mux_sda_t_s;
  wire    [15:0]  ps_intrs;

  // instantiations

  ad_iobuf #(
    .DATA_WIDTH(32))
  i_gpio_bd (
    .dt(gpio_t[31:0]),
    .di(gpio_o[31:0]),
    .do(gpio_i[31:0]),
    .dio(gpio_bd));

 ad_iobuf #(
    .DATA_WIDTH(2))
  i_gpio_cftl (
    .dt(gpio_t[33:32]),
    .di(gpio_o[33:32]),
    .do(gpio_i[33:32]),
    .dio(gpio_cftl));

  ad_iobuf #(
    .DATA_WIDTH(2))
  i_iic_mux_scl (
    .dt({iic_mux_scl_t_s, iic_mux_scl_t_s}),
    .di(iic_mux_scl_o_s),
    .do(iic_mux_scl_i_s),
    .dio(iic_mux_scl));

  ad_iobuf #(
    .DATA_WIDTH(2))
  i_iic_mux_sda (
    .dt({iic_mux_sda_t_s, iic_mux_sda_t_s}),
    .di(iic_mux_sda_o_s),
    .do(iic_mux_sda_i_s),
    .dio(iic_mux_sda));

  system_wrapper i_system_wrapper (
    .DDR_addr (DDR_addr),
    .DDR_ba (DDR_ba),
    .DDR_cas_n (DDR_cas_n),
    .DDR_ck_n (DDR_ck_n),
    .DDR_ck_p (DDR_ck_p),
    .DDR_cke (DDR_cke),
    .DDR_cs_n (DDR_cs_n),
    .DDR_dm (DDR_dm),
    .DDR_dq (DDR_dq),
    .DDR_dqs_n (DDR_dqs_n),
    .DDR_dqs_p (DDR_dqs_p),
    .DDR_odt (DDR_odt),
    .DDR_ras_n (DDR_ras_n),
    .DDR_reset_n (DDR_reset_n),
    .DDR_we_n (DDR_we_n),
    .FIXED_IO_ddr_vrn (FIXED_IO_ddr_vrn),
    .FIXED_IO_ddr_vrp (FIXED_IO_ddr_vrp),
    .FIXED_IO_mio (FIXED_IO_mio),
    .FIXED_IO_ps_clk (FIXED_IO_ps_clk),
    .FIXED_IO_ps_porb (FIXED_IO_ps_porb),
    .FIXED_IO_ps_srstb (FIXED_IO_ps_srstb),
    .GPIO_I (gpio_i),
    .GPIO_O (gpio_o),
    .GPIO_T (gpio_t),

    .hdmi_data (hdmi_data),
    .hdmi_data_e (hdmi_data_e),
    .hdmi_hsync (hdmi_hsync),
    .hdmi_out_clk (hdmi_out_clk),
    .hdmi_vsync (hdmi_vsync),
    .i2s_bclk (i2s_bclk),
    .i2s_lrclk (i2s_lrclk),
    .i2s_mclk (i2s_mclk),
    .i2s_sdata_in (i2s_sdata_in),
    .i2s_sdata_out (i2s_sdata_out),
    .iic_cftl_scl_io(iic_cftl_scl_io),
    .iic_cftl_sda_io(iic_cftl_sda_io),
    .iic_fmc_scl_io (iic_scl),
    .iic_fmc_sda_io (iic_sda),
    .iic_mux_scl_I (iic_mux_scl_i_s),
    .iic_mux_scl_O (iic_mux_scl_o_s),
    .iic_mux_scl_T (iic_mux_scl_t_s),
    .iic_mux_sda_I (iic_mux_sda_i_s),
    .iic_mux_sda_O (iic_mux_sda_o_s),
    .iic_mux_sda_T (iic_mux_sda_t_s),
    .ps_intr_10 (ps_intrs[10]),
    .ps_intr_11 (ps_intrs[11]),
    .ps_intr_12 (ps_intrs[12]),
    .ps_intr_13 (ps_intrs[13]),
    .ps_intr_4 (ps_intrs[4]),
    .ps_intr_5 (ps_intrs[5]),
    .ps_intr_6 (ps_intrs[6]),
    .ps_intr_7 (ps_intrs[7]),
    .ps_intr_8 (ps_intrs[8]),
    .ps_intr_9 (ps_intrs[9]),
    .iic_fmc_intr(ps_intrs[11]),
    .otg_vbusoc (otg_vbusoc),
    .spi0_cftl_csn_i (1'b1),
    .spi0_cftl_csn_o (spi0_csn),
    .spi0_cftl_miso_i (spi0_miso),
    .spi0_cftl_mosi_i (1'b0),
    .spi0_cftl_mosi_o (spi0_mosi),
    .spi0_cftl_sclk_i (1'b0),
    .spi0_cftl_sclk_o (spi0_clk),
    .spi1_cftl_csn_i (1'b1),
    .spi1_cftl_csn0_o (spi1_csn0),
    .spi1_cftl_csn1_o (spi1_csn1),
    .spi1_cftl_miso_i (spi1_miso),
    .spi1_cftl_mosi_i (spi1_mosi),
    .spi1_cftl_mosi_o (spi1_mosi),
    .spi1_cftl_sclk_i (1'b0),
    .spi1_cftl_sclk_o (spi1_clk),
    .spdif (spdif));



endmodule

// ***************************************************************************
// ***************************************************************************