// SPDX-FileCopyrightText: 2020 Efabless Corporation
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// SPDX-License-Identifier: Apache-2.0

`default_nettype none
/*
 *-------------------------------------------------------------
 *
 * user_proj_example
 *
 * This is an example of a (trivially simple) user project,
 * showing how the user project can connect to the logic
 * analyzer, the wishbone bus, and the I/O pads.
 *
 * This project generates an integer count, which is output
 * on the user area GPIO pads (digital output only).  The
 * wishbone connection allows the project to be controlled
 * (start and stop) from the management SoC program.
 *
 * See the testbenches in directory "mprj_counter" for the
 * example programs that drive this user project.  The three
 * testbenches are "io_ports", "la_test1", and "la_test2".
 *
 *-------------------------------------------------------------
 */

module user_proj_example #(
    parameter BITS = 32
)(
`ifdef USE_POWER_PINS
    inout vccd1,	// User area 1 1.8V supply
    inout vssd1,	// User area 1 digital ground
`endif

    // Wishbone Slave ports (WB MI A)
    input wb_clk_i,
    input wb_rst_i,
    input wbs_stb_i,
    input wbs_cyc_i,
    input wbs_we_i,
    input [3:0] wbs_sel_i,
    input [31:0] wbs_dat_i,
    input [31:0] wbs_adr_i,
    output wbs_ack_o,
    output [31:0] wbs_dat_o,

    // Logic Analyzer Signals
    input  [127:0] la_data_in,
    output [127:0] la_data_out,
    input  [127:0] la_oenb,

    // IOs
    input  [`MPRJ_IO_PADS-1:0] io_in,
    output [`MPRJ_IO_PADS-1:0] io_out,
    output [`MPRJ_IO_PADS-1:0] io_oeb,

    // IRQ
    output [2:0] irq
);
    wire clk;
    wire rst;

    wire [`MPRJ_IO_PADS-1:0] io_in;
    wire [`MPRJ_IO_PADS-1:0] io_out;
    wire [`MPRJ_IO_PADS-1:0] io_oeb;

    wire [31:0] rdata; 
    wire [31:0] wdata;
    wire [BITS-1:0] count;

    wire valid;
    wire [3:0] wstrb;
    wire [31:0] la_write;

    // WB MI A
    assign valid = wbs_cyc_i && wbs_stb_i; 
    assign wstrb = wbs_sel_i & {4{wbs_we_i}};
    assign wbs_dat_o = rdata;
    assign wdata = wbs_dat_i;

    // IO
    assign io_out = count;
    assign io_oeb = {(`MPRJ_IO_PADS-1){rst}};

    // IRQ
    assign irq = 3'b000;	// Unused

    // LA
    assign la_data_out = {{(127-BITS){1'b0}}, count};
    // Assuming LA probes [63:32] are for controlling the count register  
    assign la_write = ~la_oenb[63:32] & ~{BITS{valid}};
    // Assuming LA probes [65:64] are for controlling the count clk & reset  
    assign clk = (~la_oenb[64]) ? la_data_in[64]: wb_clk_i;
    assign rst = (~la_oenb[65]) ? la_data_in[65]: wb_rst_i;

radix2_parallel dut(in_dr0s,in_dr1s,in_dr2s,in_dr3s,in_dr4s,in_dr5s,in_dr6s,in_dr7s,in_dr8s,in_dr9s,in_dr10s,in_dr11s,in_dr12s,in_dr13s,in_dr14s,in_dr15s,
in_di0s,in_di1s,in_di2s,in_di3s,in_di4s,in_di5s,in_di6s,in_di7s,in_di8s,in_di9s,in_di10s,in_di11s,in_di12s,in_di13s,in_di14s,in_di15s,
in_dr0e,in_dr1e,in_dr2e,in_dr3e,in_dr4e,in_dr5e,in_dr6e,in_dr7e,in_dr8e,in_dr9e,in_dr10e,in_dr11e,in_dr12e,in_dr13e,in_dr14e,in_dr15e,
in_di0e,in_di1e,in_di2e,in_di3e,in_di4e,in_di5e,in_di6e,in_di7e,in_di8e,in_di9e,in_di10e,in_di11e,in_di12e,in_di13e,in_di14e,in_di15e,
in_dr0,in_dr1,in_dr2,in_dr3,in_dr4,in_dr5,in_dr6,in_dr7,in_dr8,in_dr9,in_dr10,in_dr11,in_dr12,in_dr13,in_dr14,in_dr15,
in_di0,in_di1,in_di2,in_di3,in_di4,in_di5,in_di6,in_di7,in_di8,in_di9,in_di10,in_di11,in_di12,in_di13,in_di14,in_di15,
or0s,or1s,or2s,or3s,or4s,or5s,or6s,or7s,or8s,or9s,or10s,or11s,or12s,or13s,or14s,or15s,
oi0s,oi1s,oi2s,oi3s,oi4s,oi5s,oi6s,oi7s,oi8s,oi9s,oi10s,oi11s,oi12s,oi13s,oi14s,oi15s,
or0e,or1e,or2e,or3e,or4e,or5e,or6e,or7e,or8e,or9e,or10e,or11e,or12e,or13e,or14e,or15e,
oi0e,oi1e,oi2e,oi3e,oi4e,oi5e,oi6e,oi7e,oi8e,oi9e,oi10e,oi11e,oi12e,oi13e,oi14e,oi15e,
or0,or1,or2,or3,or4,or5,or6,or7,or8,or9,or10,or11,or12,or13,or14,or15,
oi0,oi1,oi2,oi3,oi4,oi5,oi6,oi7,oi8,oi9,oi10,oi11,oi12,oi13,oi14,oi15,clk,reset);

endmodule

//radix2 parallel dif fft

/*`include "dflipflop.v"
`include "dflipflop8.v"
`include "dflipflop24.v"
`include "bf2_1.v"
`include "bf2_2.v"
`include "bf2_3.v"
`include "bf2_4.v"
`include "bf2_5.v"
`include "bf2_6.v"
`include "bf2_7.v"
`include "bf2_8.v"
`include "float_adder.v"
`include "float_multi.v"
`include "recurse8.v"
`include "kgp.v"
`include "kgp_carry.v"
`include "recursive_stage1.v"
`include "recurse40.v"
`include "fulladd.v"
`include "halfadd.v"
`include "recurse.v"*/
//`include "barrel48.v"
//`include "barrel24.v"
//`include "mux48to1.v"
//`include "mux24to1.v"
//`include "mux4to1.v"

module radix2_parallel(in_dr0s,in_dr1s,in_dr2s,in_dr3s,in_dr4s,in_dr5s,in_dr6s,in_dr7s,in_dr8s,in_dr9s,in_dr10s,in_dr11s,in_dr12s,in_dr13s,in_dr14s,in_dr15s,
in_di0s,in_di1s,in_di2s,in_di3s,in_di4s,in_di5s,in_di6s,in_di7s,in_di8s,in_di9s,in_di10s,in_di11s,in_di12s,in_di13s,in_di14s,in_di15s,
in_dr0e,in_dr1e,in_dr2e,in_dr3e,in_dr4e,in_dr5e,in_dr6e,in_dr7e,in_dr8e,in_dr9e,in_dr10e,in_dr11e,in_dr12e,in_dr13e,in_dr14e,in_dr15e,
in_di0e,in_di1e,in_di2e,in_di3e,in_di4e,in_di5e,in_di6e,in_di7e,in_di8e,in_di9e,in_di10e,in_di11e,in_di12e,in_di13e,in_di14e,in_di15e,
in_dr0,in_dr1,in_dr2,in_dr3,in_dr4,in_dr5,in_dr6,in_dr7,in_dr8,in_dr9,in_dr10,in_dr11,in_dr12,in_dr13,in_dr14,in_dr15,
in_di0,in_di1,in_di2,in_di3,in_di4,in_di5,in_di6,in_di7,in_di8,in_di9,in_di10,in_di11,in_di12,in_di13,in_di14,in_di15,
or0s,or1s,or2s,or3s,or4s,or5s,or6s,or7s,or8s,or9s,or10s,or11s,or12s,or13s,or14s,or15s,
oi0s,oi1s,oi2s,oi3s,oi4s,oi5s,oi6s,oi7s,oi8s,oi9s,oi10s,oi11s,oi12s,oi13s,oi14s,oi15s,
or0e,or1e,or2e,or3e,or4e,or5e,or6e,or7e,or8e,or9e,or10e,or11e,or12e,or13e,or14e,or15e,
oi0e,oi1e,oi2e,oi3e,oi4e,oi5e,oi6e,oi7e,oi8e,oi9e,oi10e,oi11e,oi12e,oi13e,oi14e,oi15e,
or0,or1,or2,or3,or4,or5,or6,or7,or8,or9,or10,or11,or12,or13,or14,or15,
oi0,oi1,oi2,oi3,oi4,oi5,oi6,oi7,oi8,oi9,oi10,oi11,oi12,oi13,oi14,oi15,clk,reset);

input clk,reset;

input in_dr0s,in_dr1s,in_dr2s,in_dr3s,in_dr4s,in_dr5s,in_dr6s,in_dr7s,in_dr8s,in_dr9s,in_dr10s,in_dr11s,in_dr12s,in_dr13s,in_dr14s,in_dr15s,
in_di0s,in_di1s,in_di2s,in_di3s,in_di4s,in_di5s,in_di6s,in_di7s,in_di8s,in_di9s,in_di10s,in_di11s,in_di12s,in_di13s,in_di14s,in_di15s;
input [7:0] in_dr0e,in_dr1e,in_dr2e,in_dr3e,in_dr4e,in_dr5e,in_dr6e,in_dr7e,in_dr8e,in_dr9e,in_dr10e,in_dr11e,in_dr12e,in_dr13e,in_dr14e,in_dr15e,
in_di0e,in_di1e,in_di2e,in_di3e,in_di4e,in_di5e,in_di6e,in_di7e,in_di8e,in_di9e,in_di10e,in_di11e,in_di12e,in_di13e,in_di14e,in_di15e;
input [23:0] in_dr0,in_dr1,in_dr2,in_dr3,in_dr4,in_dr5,in_dr6,in_dr7,in_dr8,in_dr9,in_dr10,in_dr11,in_dr12,in_dr13,in_dr14,in_dr15,
in_di0,in_di1,in_di2,in_di3,in_di4,in_di5,in_di6,in_di7,in_di8,in_di9,in_di10,in_di11,in_di12,in_di13,in_di14,in_di15;

output or0s,or1s,or2s,or3s,or4s,or5s,or6s,or7s,or8s,or9s,or10s,or11s,or12s,or13s,or14s,or15s,
oi0s,oi1s,oi2s,oi3s,oi4s,oi5s,oi6s,oi7s,oi8s,oi9s,oi10s,oi11s,oi12s,oi13s,oi14s,oi15s;
output [7:0] or0e,or1e,or2e,or3e,or4e,or5e,or6e,or7e,or8e,or9e,or10e,or11e,or12e,or13e,or14e,or15e,
oi0e,oi1e,oi2e,oi3e,oi4e,oi5e,oi6e,oi7e,oi8e,oi9e,oi10e,oi11e,oi12e,oi13e,oi14e,oi15e;
output [23:0] or0,or1,or2,or3,or4,or5,or6,or7,or8,or9,or10,or11,or12,or13,or14,or15,
oi0,oi1,oi2,oi3,oi4,oi5,oi6,oi7,oi8,oi9,oi10,oi11,oi12,oi13,oi14,oi15;

wire dr0s,dr1s,dr2s,dr3s,dr4s,dr5s,dr6s,dr7s,dr8s,dr9s,dr10s,dr11s,dr12s,dr13s,dr14s,dr15s,
di0s,di1s,di2s,di3s,di4s,di5s,di6s,di7s,di8s,di9s,di10s,di11s,di12s,di13s,di14s,di15s;
wire [7:0] dr0e,dr1e,dr2e,dr3e,dr4e,dr5e,dr6e,dr7e,dr8e,dr9e,dr10e,dr11e,dr12e,dr13e,dr14e,dr15e,
di0e,di1e,di2e,di3e,di4e,di5e,di6e,di7e,di8e,di9e,di10e,di11e,di12e,di13e,di14e,di15e;
wire [23:0] dr0,dr1,dr2,dr3,dr4,dr5,dr6,dr7,dr8,dr9,dr10,dr11,dr12,dr13,dr14,dr15,
di0,di1,di2,di3,di4,di5,di6,di7,di8,di9,di10,di11,di12,di13,di14,di15;

dflipflop drkds00(dr0s,in_dr0s,clk,reset);
dflipflop drkds01(dr1s,in_dr1s,clk,reset);
dflipflop drkds02(dr2s,in_dr2s,clk,reset);
dflipflop drkds03(dr3s,in_dr3s,clk,reset);
dflipflop drkds04(dr4s,in_dr4s,clk,reset);
dflipflop drkds05(dr5s,in_dr5s,clk,reset);
dflipflop drkds06(dr6s,in_dr6s,clk,reset);
dflipflop drkds07(dr7s,in_dr7s,clk,reset);
dflipflop drkds08(dr8s,in_dr8s,clk,reset);
dflipflop drkds09(dr9s,in_dr9s,clk,reset);
dflipflop drkds10(dr10s,in_dr10s,clk,reset);
dflipflop drkds11(dr11s,in_dr11s,clk,reset);
dflipflop drkds12(dr12s,in_dr12s,clk,reset);
dflipflop drkds13(dr13s,in_dr13s,clk,reset);
dflipflop drkds14(dr14s,in_dr14s,clk,reset);
dflipflop drkds15(dr15s,in_dr15s,clk,reset);

dflipflop dikds00(di0s,in_di0s,clk,reset);
dflipflop dikds01(di1s,in_di1s,clk,reset);
dflipflop dikds02(di2s,in_di2s,clk,reset);
dflipflop dikds03(di3s,in_di3s,clk,reset);
dflipflop dikds04(di4s,in_di4s,clk,reset);
dflipflop dikds05(di5s,in_di5s,clk,reset);
dflipflop dikds06(di6s,in_di6s,clk,reset);
dflipflop dikds07(di7s,in_di7s,clk,reset);
dflipflop dikds08(di8s,in_di8s,clk,reset);
dflipflop dikds09(di9s,in_di9s,clk,reset);
dflipflop dikds10(di10s,in_di10s,clk,reset);
dflipflop dikds11(di11s,in_di11s,clk,reset);
dflipflop dikds12(di12s,in_di12s,clk,reset);
dflipflop dikds13(di13s,in_di13s,clk,reset);
dflipflop dikds14(di14s,in_di14s,clk,reset);
dflipflop dikds15(di15s,in_di15s,clk,reset);

dflipflop8 drkde00(dr0e,in_dr0e,clk,reset);
dflipflop8 drkde01(dr1e,in_dr1e,clk,reset);
dflipflop8 drkde02(dr2e,in_dr2e,clk,reset);
dflipflop8 drkde03(dr3e,in_dr3e,clk,reset);
dflipflop8 drkde04(dr4e,in_dr4e,clk,reset);
dflipflop8 drkde05(dr5e,in_dr5e,clk,reset);
dflipflop8 drkde06(dr6e,in_dr6e,clk,reset);
dflipflop8 drkde07(dr7e,in_dr7e,clk,reset);
dflipflop8 drkde08(dr8e,in_dr8e,clk,reset);
dflipflop8 drkde09(dr9e,in_dr9e,clk,reset);
dflipflop8 drkde10(dr10e,in_dr10e,clk,reset);
dflipflop8 drkde11(dr11e,in_dr11e,clk,reset);
dflipflop8 drkde12(dr12e,in_dr12e,clk,reset);
dflipflop8 drkde13(dr13e,in_dr13e,clk,reset);
dflipflop8 drkde14(dr14e,in_dr14e,clk,reset);
dflipflop8 drkde15(dr15e,in_dr15e,clk,reset);

dflipflop8 dikde00(di0e,in_di0e,clk,reset);
dflipflop8 dikde01(di1e,in_di1e,clk,reset);
dflipflop8 dikde02(di2e,in_di2e,clk,reset);
dflipflop8 dikde03(di3e,in_di3e,clk,reset);
dflipflop8 dikde04(di4e,in_di4e,clk,reset);
dflipflop8 dikde05(di5e,in_di5e,clk,reset);
dflipflop8 dikde06(di6e,in_di6e,clk,reset);
dflipflop8 dikde07(di7e,in_di7e,clk,reset);
dflipflop8 dikde08(di8e,in_di8e,clk,reset);
dflipflop8 dikde09(di9e,in_di9e,clk,reset);
dflipflop8 dikde10(di10e,in_di10e,clk,reset);
dflipflop8 dikde11(di11e,in_di11e,clk,reset);
dflipflop8 dikde12(di12e,in_di12e,clk,reset);
dflipflop8 dikde13(di13e,in_di13e,clk,reset);
dflipflop8 dikde14(di14e,in_di14e,clk,reset);
dflipflop8 dikde15(di15e,in_di15e,clk,reset);

dflipflop24 drkd00(dr0,in_dr0,clk,reset);
dflipflop24 drkd01(dr1,in_dr1,clk,reset);
dflipflop24 drkd02(dr2,in_dr2,clk,reset);
dflipflop24 drkd03(dr3,in_dr3,clk,reset);
dflipflop24 drkd04(dr4,in_dr4,clk,reset);
dflipflop24 drkd05(dr5,in_dr5,clk,reset);
dflipflop24 drkd06(dr6,in_dr6,clk,reset);
dflipflop24 drkd07(dr7,in_dr7,clk,reset);
dflipflop24 drkd08(dr8,in_dr8,clk,reset);
dflipflop24 drkd09(dr9,in_dr9,clk,reset);
dflipflop24 drkd10(dr10,in_dr10,clk,reset);
dflipflop24 drkd11(dr11,in_dr11,clk,reset);
dflipflop24 drkd12(dr12,in_dr12,clk,reset);
dflipflop24 drkd13(dr13,in_dr13,clk,reset);
dflipflop24 drkd14(dr14,in_dr14,clk,reset);
dflipflop24 drkd15(dr15,in_dr15,clk,reset);

dflipflop24 dikd00(di0,in_di0,clk,reset);
dflipflop24 dikd01(di1,in_di1,clk,reset);
dflipflop24 dikd02(di2,in_di2,clk,reset);
dflipflop24 dikd03(di3,in_di3,clk,reset);
dflipflop24 dikd04(di4,in_di4,clk,reset);
dflipflop24 dikd05(di5,in_di5,clk,reset);
dflipflop24 dikd06(di6,in_di6,clk,reset);
dflipflop24 dikd07(di7,in_di7,clk,reset);
dflipflop24 dikd08(di8,in_di8,clk,reset);
dflipflop24 dikd09(di9,in_di9,clk,reset);
dflipflop24 dikd10(di10,in_di10,clk,reset);
dflipflop24 dikd11(di11,in_di11,clk,reset);
dflipflop24 dikd12(di12,in_di12,clk,reset);
dflipflop24 dikd13(di13,in_di13,clk,reset);
dflipflop24 dikd14(di14,in_di14,clk,reset);
dflipflop24 dikd15(di15,in_di15,clk,reset);

//first stage of butterfly

wire doutr0s,doutr1s,doutr2s,doutr3s,doutr4s,doutr5s,doutr6s,doutr7s,doutr8s,doutr9s,doutr10s,doutr11s,doutr12s,doutr13s,doutr14s,doutr15s,
douti0s,douti1s,douti2s,douti3s,douti4s,douti5s,douti6s,douti7s,douti8s,douti9s,douti10s,douti11s,douti12s,douti13s,douti14s,douti15s;
wire [7:0] doutr0e,doutr1e,doutr2e,doutr3e,doutr4e,doutr5e,doutr6e,doutr7e,doutr8e,doutr9e,doutr10e,doutr11e,doutr12e,doutr13e,doutr14e,doutr15e,
douti0e,douti1e,douti2e,douti3e,douti4e,douti5e,douti6e,douti7e,douti8e,douti9e,douti10e,douti11e,douti12e,douti13e,douti14e,douti15e;
wire [23:0] doutr0,doutr1,doutr2,doutr3,doutr4,doutr5,doutr6,doutr7,doutr8,doutr9,doutr10,doutr11,doutr12,doutr13,doutr14,doutr15,
douti0,douti1,douti2,douti3,douti4,douti5,douti6,douti7,douti8,douti9,douti10,douti11,douti12,douti13,douti14,douti15;

bf2_1 bf1(dr0s,dr0e,dr0,dr8s,dr8e,dr8,di0s,di0e,di0,di8s,di8e,di8,doutr0s,doutr0e,doutr0,
douti0s,douti0e,douti0,doutr1s,doutr1e,doutr1,douti1s,douti1e,douti1);

bf2_2 bf2(dr1s,dr1e,dr1,dr9s,dr9e,dr9,di1s,di1e,di1,di9s,di9e,di9,doutr2s,doutr2e,doutr2,
douti2s,douti2e,douti2,doutr3s,doutr3e,doutr3,douti3s,douti3e,douti3);

bf2_3 bf3(dr2s,dr2e,dr2,dr10s,dr10e,dr10,di2s,di2e,di2,di10s,di10e,di10,doutr4s,doutr4e,doutr4,
douti4s,douti4e,douti4,doutr5s,doutr5e,doutr5,douti5s,douti5e,douti5);

bf2_4 bf4(dr3s,dr3e,dr3,dr11s,dr11e,dr11,di3s,di3e,di3,di11s,di11e,di11,doutr6s,doutr6e,doutr6,
douti6s,douti6e,douti6,doutr7s,doutr7e,doutr7,douti7s,douti7e,douti7);

bf2_5 bf5(dr4s,dr4e,dr4,dr12s,dr12e,dr12,di4s,di4e,di4,di12s,di12e,di12,doutr8s,doutr8e,doutr8,
douti8s,douti8e,douti8,doutr9s,doutr9e,doutr9,douti9s,douti9e,douti9);

bf2_6 bf6(dr5s,dr5e,dr5,dr13s,dr13e,dr13,di5s,di5e,di5,di13s,di13e,di13,doutr10s,doutr10e,doutr10,
douti10s,douti10e,douti10,doutr11s,doutr11e,doutr11,douti11s,douti11e,douti11);

bf2_7 bf7(dr6s,dr6e,dr6,dr14s,dr14e,dr14,di6s,di6e,di6,di14s,di14e,di14,doutr12s,doutr12e,doutr12,
douti12s,douti12e,douti12,doutr13s,doutr13e,doutr13,douti13s,douti13e,douti13);

bf2_8 bf8(dr7s,dr7e,dr7,dr15s,dr15e,dr15,di7s,di7e,di7,di15s,di15e,di15,doutr14s,doutr14e,doutr14,
douti14s,douti14e,douti14,doutr15s,doutr15e,doutr15,douti15s,douti15e,douti15);

wire enr0s,enr1s,enr2s,enr3s,enr4s,enr5s,enr6s,enr7s,enr8s,enr9s,enr10s,enr11s,enr12s,enr13s,enr14s,enr15s,
eni0s,eni1s,eni2s,eni3s,eni4s,eni5s,eni6s,eni7s,eni8s,eni9s,eni10s,eni11s,eni12s,eni13s,eni14s,eni15s;
wire [7:0] enr0e,enr1e,enr2e,enr3e,enr4e,enr5e,enr6e,enr7e,enr8e,enr9e,enr10e,enr11e,enr12e,enr13e,enr14e,enr15e,
eni0e,eni1e,eni2e,eni3e,eni4e,eni5e,eni6e,eni7e,eni8e,eni9e,eni10e,eni11e,eni12e,eni13e,eni14e,eni15e;
wire [23:0] enr0,enr1,enr2,enr3,enr4,enr5,enr6,enr7,enr8,enr9,enr10,enr11,enr12,enr13,enr14,enr15,
eni0,eni1,eni2,eni3,eni4,eni5,eni6,eni7,eni8,eni9,eni10,eni11,eni12,eni13,eni14,eni15;

/*dflipflop drens00(enr0s,doutr0s,clk,reset);
dflipflop drens01(enr1s,doutr1s,clk,reset);
dflipflop drens02(enr2s,doutr2s,clk,reset);
dflipflop drens03(enr3s,doutr3s,clk,reset);
dflipflop drens04(enr4s,doutr4s,clk,reset);
dflipflop drens05(enr5s,doutr5s,clk,reset);
dflipflop drens06(enr6s,doutr6s,clk,reset);
dflipflop drens07(enr7s,doutr7s,clk,reset);
dflipflop drens08(enr8s,doutr8s,clk,reset);
dflipflop drens09(enr9s,doutr9s,clk,reset);
dflipflop drens10(enr10s,doutr10s,clk,reset);
dflipflop drens11(enr11s,doutr11s,clk,reset);
dflipflop drens12(enr12s,doutr12s,clk,reset);
dflipflop drens13(enr13s,doutr13s,clk,reset);
dflipflop drens14(enr14s,doutr14s,clk,reset);
dflipflop drens15(enr15s,doutr15s,clk,reset);

dflipflop diens00(eni0s,douti0s,clk,reset);
dflipflop diens01(eni1s,douti1s,clk,reset);
dflipflop diens02(eni2s,douti2s,clk,reset);
dflipflop diens03(eni3s,douti3s,clk,reset);
dflipflop diens04(eni4s,douti4s,clk,reset);
dflipflop diens05(eni5s,douti5s,clk,reset);
dflipflop diens06(eni6s,douti6s,clk,reset);
dflipflop diens07(eni7s,douti7s,clk,reset);
dflipflop diens08(eni8s,douti8s,clk,reset);
dflipflop diens09(eni9s,douti9s,clk,reset);
dflipflop diens10(eni10s,douti10s,clk,reset);
dflipflop diens11(eni11s,douti11s,clk,reset);
dflipflop diens12(eni12s,douti12s,clk,reset);
dflipflop diens13(eni13s,douti13s,clk,reset);
dflipflop diens14(eni14s,douti14s,clk,reset);
dflipflop diens15(eni15s,douti15s,clk,reset);

dflipflop8 drene00(enr0e,doutr0e,clk,reset);
dflipflop8 drene01(enr1e,doutr1e,clk,reset);
dflipflop8 drene02(enr2e,doutr2e,clk,reset);
dflipflop8 drene03(enr3e,doutr3e,clk,reset);
dflipflop8 drene04(enr4e,doutr4e,clk,reset);
dflipflop8 drene05(enr5e,doutr5e,clk,reset);
dflipflop8 drene06(enr6e,doutr6e,clk,reset);
dflipflop8 drene07(enr7e,doutr7e,clk,reset);
dflipflop8 drene08(enr8e,doutr8e,clk,reset);
dflipflop8 drene09(enr9e,doutr9e,clk,reset);
dflipflop8 drene10(enr10e,doutr10e,clk,reset);
dflipflop8 drene11(enr11e,doutr11e,clk,reset);
dflipflop8 drene12(enr12e,doutr12e,clk,reset);
dflipflop8 drene13(enr13e,doutr13e,clk,reset);
dflipflop8 drene14(enr14e,doutr14e,clk,reset);
dflipflop8 drene15(enr15e,doutr15e,clk,reset);

dflipflop8 diene00(eni0e,douti0e,clk,reset);
dflipflop8 diene01(eni1e,douti1e,clk,reset);
dflipflop8 diene02(eni2e,douti2e,clk,reset);
dflipflop8 diene03(eni3e,douti3e,clk,reset);
dflipflop8 diene04(eni4e,douti4e,clk,reset);
dflipflop8 diene05(eni5e,douti5e,clk,reset);
dflipflop8 diene06(eni6e,douti6e,clk,reset);
dflipflop8 diene07(eni7e,douti7e,clk,reset);
dflipflop8 diene08(eni8e,douti8e,clk,reset);
dflipflop8 diene09(eni9e,douti9e,clk,reset);
dflipflop8 diene10(eni10e,douti10e,clk,reset);
dflipflop8 diene11(eni11e,douti11e,clk,reset);
dflipflop8 diene12(eni12e,douti12e,clk,reset);
dflipflop8 diene13(eni13e,douti13e,clk,reset);
dflipflop8 diene14(eni14e,douti14e,clk,reset);
dflipflop8 diene15(eni15e,douti15e,clk,reset);

dflipflop24 dren00(enr0,doutr0,clk,reset);
dflipflop24 dren01(enr1,doutr1,clk,reset);
dflipflop24 dren02(enr2,doutr2,clk,reset);
dflipflop24 dren03(enr3,doutr3,clk,reset);
dflipflop24 dren04(enr4,doutr4,clk,reset);
dflipflop24 dren05(enr5,doutr5,clk,reset);
dflipflop24 dren06(enr6,doutr6,clk,reset);
dflipflop24 dren07(enr7,doutr7,clk,reset);
dflipflop24 dren08(enr8,doutr8,clk,reset);
dflipflop24 dren09(enr9,doutr9,clk,reset);
dflipflop24 dren10(enr10,doutr10,clk,reset);
dflipflop24 dren11(enr11,doutr11,clk,reset);
dflipflop24 dren12(enr12,doutr12,clk,reset);
dflipflop24 dren13(enr13,doutr13,clk,reset);
dflipflop24 dren14(enr14,doutr14,clk,reset);
dflipflop24 dren15(enr15,doutr15,clk,reset);

dflipflop24 dien00(eni0,douti0,clk,reset);
dflipflop24 dien01(eni1,douti1,clk,reset);
dflipflop24 dien02(eni2,douti2,clk,reset);
dflipflop24 dien03(eni3,douti3,clk,reset);
dflipflop24 dien04(eni4,douti4,clk,reset);
dflipflop24 dien05(eni5,douti5,clk,reset);
dflipflop24 dien06(eni6,douti6,clk,reset);
dflipflop24 dien07(eni7,douti7,clk,reset);
dflipflop24 dien08(eni8,douti8,clk,reset);
dflipflop24 dien09(eni9,douti9,clk,reset);
dflipflop24 dien10(eni10,douti10,clk,reset);
dflipflop24 dien11(eni11,douti11,clk,reset);
dflipflop24 dien12(eni12,douti12,clk,reset);
dflipflop24 dien13(eni13,douti13,clk,reset);
dflipflop24 dien14(eni14,douti14,clk,reset);
dflipflop24 dien15(eni15,douti15,clk,reset);*/

assign enr0s=doutr0s;
assign enr1s=doutr1s;
assign enr2s=doutr2s;
assign enr3s=doutr3s;
assign enr4s=doutr4s;
assign enr5s=doutr5s;
assign enr6s=doutr6s;
assign enr7s=doutr7s;
assign enr8s=doutr8s;
assign enr9s=doutr9s;
assign enr10s=doutr10s;
assign enr11s=doutr11s;
assign enr12s=doutr12s;
assign enr13s=doutr13s;
assign enr14s=doutr14s;
assign enr15s=doutr15s;

assign eni0s=douti0s;
assign eni1s=douti1s;
assign eni2s=douti2s;
assign eni3s=douti3s;
assign eni4s=douti4s;
assign eni5s=douti5s;
assign eni6s=douti6s;
assign eni7s=douti7s;
assign eni8s=douti8s;
assign eni9s=douti9s;
assign eni10s=douti10s;
assign eni11s=douti11s;
assign eni12s=douti12s;
assign eni13s=douti13s;
assign eni14s=douti14s;
assign eni15s=douti15s;

assign enr0e=doutr0e;
assign enr1e=doutr1e;
assign enr2e=doutr2e;
assign enr3e=doutr3e;
assign enr4e=doutr4e;
assign enr5e=doutr5e;
assign enr6e=doutr6e;
assign enr7e=doutr7e;
assign enr8e=doutr8e;
assign enr9e=doutr9e;
assign enr10e=doutr10e;
assign enr11e=doutr11e;
assign enr12e=doutr12e;
assign enr13e=doutr13e;
assign enr14e=doutr14e;
assign enr15e=doutr15e;

assign eni0e=douti0e;
assign eni1e=douti1e;
assign eni2e=douti2e;
assign eni3e=douti3e;
assign eni4e=douti4e;
assign eni5e=douti5e;
assign eni6e=douti6e;
assign eni7e=douti7e;
assign eni8e=douti8e;
assign eni9e=douti9e;
assign eni10e=douti10e;
assign eni11e=douti11e;
assign eni12e=douti12e;
assign eni13e=douti13e;
assign eni14e=douti14e;
assign eni15e=douti15e;

assign enr0=doutr0;
assign enr1=doutr1;
assign enr2=doutr2;
assign enr3=doutr3;
assign enr4=doutr4;
assign enr5=doutr5;
assign enr6=doutr6;
assign enr7=doutr7;
assign enr8=doutr8;
assign enr9=doutr9;
assign enr10=doutr10;
assign enr11=doutr11;
assign enr12=doutr12;
assign enr13=doutr13;
assign enr14=doutr14;
assign enr15=doutr15;

assign eni0=douti0;
assign eni1=douti1;
assign eni2=douti2;
assign eni3=douti3;
assign eni4=douti4;
assign eni5=douti5;
assign eni6=douti6;
assign eni7=douti7;
assign eni8=douti8;
assign eni9=douti9;
assign eni10=douti10;
assign eni11=douti11;
assign eni12=douti12;
assign eni13=douti13;
assign eni14=douti14;
assign eni15=douti15;

//second stage of butterfly

wire en1r0s,en1r1s,en1r2s,en1r3s,en1r4s,en1r5s,en1r6s,en1r7s,en1r8s,en1r9s,en1r10s,en1r11s,en1r12s,en1r13s,en1r14s,en1r15s,
en1i0s,en1i1s,en1i2s,en1i3s,en1i4s,en1i5s,en1i6s,en1i7s,en1i8s,en1i9s,en1i10s,en1i11s,en1i12s,en1i13s,en1i14s,en1i15s;
wire [7:0] en1r0e,en1r1e,en1r2e,en1r3e,en1r4e,en1r5e,en1r6e,en1r7e,en1r8e,en1r9e,en1r10e,en1r11e,en1r12e,en1r13e,en1r14e,en1r15e,
en1i0e,en1i1e,en1i2e,en1i3e,en1i4e,en1i5e,en1i6e,en1i7e,en1i8e,en1i9e,en1i10e,en1i11e,en1i12e,en1i13e,en1i14e,en1i15e;
wire [23:0] en1r0,en1r1,en1r2,en1r3,en1r4,en1r5,en1r6,en1r7,en1r8,en1r9,en1r10,en1r11,en1r12,en1r13,en1r14,en1r15,
en1i0,en1i1,en1i2,en1i3,en1i4,en1i5,en1i6,en1i7,en1i8,en1i9,en1i10,en1i11,en1i12,en1i13,en1i14,en1i15;

bf2_1 bfs21(enr0s,enr0e,enr0,enr8s,enr8e,enr8,eni0s,eni0e,eni0,eni8s,eni8e,eni8,en1r0s,en1r0e,en1r0,
en1i0s,en1i0e,en1i0,en1r1s,en1r1e,en1r1,en1i1s,en1i1e,en1i1);

bf2_3 bfs22(enr2s,enr2e,enr2,enr10s,enr10e,enr10,eni2s,eni2e,eni2,eni10s,eni10e,eni10,en1r2s,en1r2e,en1r2,
en1i2s,en1i2e,en1i2,en1r3s,en1r3e,en1r3,en1i3s,en1i3e,en1i3);

bf2_5 bfs23(enr4s,enr4e,enr4,enr12s,enr12e,enr12,eni4s,eni4e,eni4,eni12s,eni12e,eni12,en1r4s,en1r4e,en1r4,
en1i4s,en1i4e,en1i4,en1r5s,en1r5e,en1r5,en1i5s,en1i5e,en1i5);

bf2_7 bfs24(enr6s,enr6e,enr6,enr14s,enr14e,enr14,eni6s,eni6e,eni6,eni14s,eni14e,eni14,en1r6s,en1r6e,en1r6,
en1i6s,en1i6e,en1i6,en1r7s,en1r7e,en1r7,en1i7s,en1i7e,en1i7);

bf2_1 bfs25(enr1s,enr1e,enr1,enr9s,enr9e,enr9,eni1s,eni1e,eni1,eni9s,eni9e,eni9,en1r8s,en1r8e,en1r8,
en1i8s,en1i8e,en1i8,en1r9s,en1r9e,en1r9,en1i9s,en1i9e,en1i9);

bf2_3 bfs26(enr3s,enr3e,enr3,enr11s,enr11e,enr11,eni3s,eni3e,eni3,eni11s,eni11e,eni11,en1r10s,en1r10e,en1r10,
en1i10s,en1i10e,en1i10,en1r11s,en1r11e,en1r11,en1i11s,en1i11e,en1i11);

bf2_5 bfs27(enr5s,enr5e,enr5,enr13s,enr13e,enr13,eni5s,eni5e,eni5,eni13s,eni13e,eni13,en1r12s,en1r12e,en1r12,
en1i12s,en1i12e,en1i12,en1r13s,en1r13e,en1r13,en1i13s,en1i13e,en1i13);

bf2_7 bfs28(enr7s,enr7e,enr7,enr15s,enr15e,enr15,eni7s,eni7e,eni7,eni15s,eni15e,eni15,en1r14s,en1r14e,en1r14,
en1i14s,en1i14e,en1i14,en1r15s,en1r15e,en1r15,en1i15s,en1i15e,en1i15);

wire en2r0s,en2r1s,en2r2s,en2r3s,en2r4s,en2r5s,en2r6s,en2r7s,en2r8s,en2r9s,en2r10s,en2r11s,en2r12s,en2r13s,en2r14s,en2r15s,
en2i0s,en2i1s,en2i2s,en2i3s,en2i4s,en2i5s,en2i6s,en2i7s,en2i8s,en2i9s,en2i10s,en2i11s,en2i12s,en2i13s,en2i14s,en2i15s;
wire [7:0] en2r0e,en2r1e,en2r2e,en2r3e,en2r4e,en2r5e,en2r6e,en2r7e,en2r8e,en2r9e,en2r10e,en2r11e,en2r12e,en2r13e,en2r14e,en2r15e,
en2i0e,en2i1e,en2i2e,en2i3e,en2i4e,en2i5e,en2i6e,en2i7e,en2i8e,en2i9e,en2i10e,en2i11e,en2i12e,en2i13e,en2i14e,en2i15e;
wire [23:0] en2r0,en2r1,en2r2,en2r3,en2r4,en2r5,en2r6,en2r7,en2r8,en2r9,en2r10,en2r11,en2r12,en2r13,en2r14,en2r15,
en2i0,en2i1,en2i2,en2i3,en2i4,en2i5,en2i6,en2i7,en2i8,en2i9,en2i10,en2i11,en2i12,en2i13,en2i14,en2i15;

/*dflipflop dren2s00(en2r0s,en1r0s,clk,reset);
dflipflop dren2s01(en2r1s,en1r1s,clk,reset);
dflipflop dren2s02(en2r2s,en1r2s,clk,reset);
dflipflop dren2s03(en2r3s,en1r3s,clk,reset);
dflipflop dren2s04(en2r4s,en1r4s,clk,reset);
dflipflop dren2s05(en2r5s,en1r5s,clk,reset);
dflipflop dren2s06(en2r6s,en1r6s,clk,reset);
dflipflop dren2s07(en2r7s,en1r7s,clk,reset);
dflipflop dren2s08(en2r8s,en1r8s,clk,reset);
dflipflop dren2s09(en2r9s,en1r9s,clk,reset);
dflipflop dren2s10(en2r10s,en1r10s,clk,reset);
dflipflop dren2s11(en2r11s,en1r11s,clk,reset);
dflipflop dren2s12(en2r12s,en1r12s,clk,reset);
dflipflop dren2s13(en2r13s,en1r13s,clk,reset);
dflipflop dren2s14(en2r14s,en1r14s,clk,reset);
dflipflop dren2s15(en2r15s,en1r15s,clk,reset);

dflipflop dien21s00(en2i0s,en1i0s,clk,reset);
dflipflop dien21s01(en2i1s,en1i1s,clk,reset);
dflipflop dien21s02(en2i2s,en1i2s,clk,reset);
dflipflop dien21s03(en2i3s,en1i3s,clk,reset);
dflipflop dien21s04(en2i4s,en1i4s,clk,reset);
dflipflop dien21s05(en2i5s,en1i5s,clk,reset);
dflipflop dien21s06(en2i6s,en1i6s,clk,reset);
dflipflop dien21s07(en2i7s,en1i7s,clk,reset);
dflipflop dien21s08(en2i8s,en1i8s,clk,reset);
dflipflop dien21s09(en2i9s,en1i9s,clk,reset);
dflipflop dien21s10(en2i10s,en1i10s,clk,reset);
dflipflop dien21s11(en2i11s,en1i11s,clk,reset);
dflipflop dien21s12(en2i12s,en1i12s,clk,reset);
dflipflop dien21s13(en2i13s,en1i13s,clk,reset);
dflipflop dien21s14(en2i14s,en1i14s,clk,reset);
dflipflop dien21s15(en2i15s,en1i15s,clk,reset);

dflipflop8 dren2e00(en2r0e,en1r0e,clk,reset);
dflipflop8 dren2e01(en2r1e,en1r1e,clk,reset);
dflipflop8 dren2e02(en2r2e,en1r2e,clk,reset);
dflipflop8 dren2e03(en2r3e,en1r3e,clk,reset);
dflipflop8 dren2e04(en2r4e,en1r4e,clk,reset);
dflipflop8 dren2e05(en2r5e,en1r5e,clk,reset);
dflipflop8 dren2e06(en2r6e,en1r6e,clk,reset);
dflipflop8 dren2e07(en2r7e,en1r7e,clk,reset);
dflipflop8 dren2e08(en2r8e,en1r8e,clk,reset);
dflipflop8 dren2e09(en2r9e,en1r9e,clk,reset);
dflipflop8 dren2e10(en2r10e,en1r10e,clk,reset);
dflipflop8 dren2e11(en2r11e,en1r11e,clk,reset);
dflipflop8 dren2e12(en2r12e,en1r12e,clk,reset);
dflipflop8 dren2e13(en2r13e,en1r13e,clk,reset);
dflipflop8 dren2e14(en2r14e,en1r14e,clk,reset);
dflipflop8 dren2e15(en2r15e,en1r15e,clk,reset);

dflipflop8 dien21e00(en2i0e,en1i0e,clk,reset);
dflipflop8 dien21e01(en2i1e,en1i1e,clk,reset);
dflipflop8 dien21e02(en2i2e,en1i2e,clk,reset);
dflipflop8 dien21e03(en2i3e,en1i3e,clk,reset);
dflipflop8 dien21e04(en2i4e,en1i4e,clk,reset);
dflipflop8 dien21e05(en2i5e,en1i5e,clk,reset);
dflipflop8 dien21e06(en2i6e,en1i6e,clk,reset);
dflipflop8 dien21e07(en2i7e,en1i7e,clk,reset);
dflipflop8 dien21e08(en2i8e,en1i8e,clk,reset);
dflipflop8 dien21e09(en2i9e,en1i9e,clk,reset);
dflipflop8 dien21e10(en2i10e,en1i10e,clk,reset);
dflipflop8 dien21e11(en2i11e,en1i11e,clk,reset);
dflipflop8 dien21e12(en2i12e,en1i12e,clk,reset);
dflipflop8 dien21e13(en2i13e,en1i13e,clk,reset);
dflipflop8 dien21e14(en2i14e,en1i14e,clk,reset);
dflipflop8 dien21e15(en2i15e,en1i15e,clk,reset);

dflipflop24 dren200(en2r0,en1r0,clk,reset);
dflipflop24 dren201(en2r1,en1r1,clk,reset);
dflipflop24 dren202(en2r2,en1r2,clk,reset);
dflipflop24 dren203(en2r3,en1r3,clk,reset);
dflipflop24 dren204(en2r4,en1r4,clk,reset);
dflipflop24 dren205(en2r5,en1r5,clk,reset);
dflipflop24 dren206(en2r6,en1r6,clk,reset);
dflipflop24 dren207(en2r7,en1r7,clk,reset);
dflipflop24 dren208(en2r8,en1r8,clk,reset);
dflipflop24 dren209(en2r9,en1r9,clk,reset);
dflipflop24 dren210(en2r10,en1r10,clk,reset);
dflipflop24 dren211(en2r11,en1r11,clk,reset);
dflipflop24 dren212(en2r12,en1r12,clk,reset);
dflipflop24 dren213(en2r13,en1r13,clk,reset);
dflipflop24 dren214(en2r14,en1r14,clk,reset);
dflipflop24 dren215(en2r15,en1r15,clk,reset);

dflipflop24 dien2100(en2i0,en1i0,clk,reset);
dflipflop24 dien2101(en2i1,en1i1,clk,reset);
dflipflop24 dien2102(en2i2,en1i2,clk,reset);
dflipflop24 dien2103(en2i3,en1i3,clk,reset);
dflipflop24 dien2104(en2i4,en1i4,clk,reset);
dflipflop24 dien2105(en2i5,en1i5,clk,reset);
dflipflop24 dien2106(en2i6,en1i6,clk,reset);
dflipflop24 dien2107(en2i7,en1i7,clk,reset);
dflipflop24 dien2108(en2i8,en1i8,clk,reset);
dflipflop24 dien2109(en2i9,en1i9,clk,reset);
dflipflop24 dien2110(en2i10,en1i10,clk,reset);
dflipflop24 dien2111(en2i11,en1i11,clk,reset);
dflipflop24 dien2112(en2i12,en1i12,clk,reset);
dflipflop24 dien2113(en2i13,en1i13,clk,reset);
dflipflop24 dien2114(en2i14,en1i14,clk,reset);
dflipflop24 dien2115(en2i15,en1i15,clk,reset);*/

assign en2r0s=en1r0s;
assign en2r1s=en1r1s;
assign en2r2s=en1r2s;
assign en2r3s=en1r3s;
assign en2r4s=en1r4s;
assign en2r5s=en1r5s;
assign en2r6s=en1r6s;
assign en2r7s=en1r7s;
assign en2r8s=en1r8s;
assign en2r9s=en1r9s;
assign en2r10s=en1r10s;
assign en2r11s=en1r11s;
assign en2r12s=en1r12s;
assign en2r13s=en1r13s;
assign en2r14s=en1r14s;
assign en2r15s=en1r15s;

assign en2i0s=en1i0s;
assign en2i1s=en1i1s;
assign en2i2s=en1i2s;
assign en2i3s=en1i3s;
assign en2i4s=en1i4s;
assign en2i5s=en1i5s;
assign en2i6s=en1i6s;
assign en2i7s=en1i7s;
assign en2i8s=en1i8s;
assign en2i9s=en1i9s;
assign en2i10s=en1i10s;
assign en2i11s=en1i11s;
assign en2i12s=en1i12s;
assign en2i13s=en1i13s;
assign en2i14s=en1i14s;
assign en2i15s=en1i15s;

assign en2r0e=en1r0e;
assign en2r1e=en1r1e;
assign en2r2e=en1r2e;
assign en2r3e=en1r3e;
assign en2r4e=en1r4e;
assign en2r5e=en1r5e;
assign en2r6e=en1r6e;
assign en2r7e=en1r7e;
assign en2r8e=en1r8e;
assign en2r9e=en1r9e;
assign en2r10e=en1r10e;
assign en2r11e=en1r11e;
assign en2r12e=en1r12e;
assign en2r13e=en1r13e;
assign en2r14e=en1r14e;
assign en2r15e=en1r15e;

assign en2i0e=en1i0e;
assign en2i1e=en1i1e;
assign en2i2e=en1i2e;
assign en2i3e=en1i3e;
assign en2i4e=en1i4e;
assign en2i5e=en1i5e;
assign en2i6e=en1i6e;
assign en2i7e=en1i7e;
assign en2i8e=en1i8e;
assign en2i9e=en1i9e;
assign en2i10e=en1i10e;
assign en2i11e=en1i11e;
assign en2i12e=en1i12e;
assign en2i13e=en1i13e;
assign en2i14e=en1i14e;
assign en2i15e=en1i15e;

assign en2r0=en1r0;
assign en2r1=en1r1;
assign en2r2=en1r2;
assign en2r3=en1r3;
assign en2r4=en1r4;
assign en2r5=en1r5;
assign en2r6=en1r6;
assign en2r7=en1r7;
assign en2r8=en1r8;
assign en2r9=en1r9;
assign en2r10=en1r10;
assign en2r11=en1r11;
assign en2r12=en1r12;
assign en2r13=en1r13;
assign en2r14=en1r14;
assign en2r15=en1r15;

assign en2i0=en1i0;
assign en2i1=en1i1;
assign en2i2=en1i2;
assign en2i3=en1i3;
assign en2i4=en1i4;
assign en2i5=en1i5;
assign en2i6=en1i6;
assign en2i7=en1i7;
assign en2i8=en1i8;
assign en2i9=en1i9;
assign en2i10=en1i10;
assign en2i11=en1i11;
assign en2i12=en1i12;
assign en2i13=en1i13;
assign en2i14=en1i14;
assign en2i15=en1i15;

wire en3r0s,en3r1s,en3r2s,en3r3s,en3r4s,en3r5s,en3r6s,en3r7s,en3r8s,en3r9s,en3r10s,en3r11s,en3r12s,en3r13s,en3r14s,en3r15s,
en3i0s,en3i1s,en3i2s,en3i3s,en3i4s,en3i5s,en3i6s,en3i7s,en3i8s,en3i9s,en3i10s,en3i11s,en3i12s,en3i13s,en3i14s,en3i15s;
wire [7:0] en3r0e,en3r1e,en3r2e,en3r3e,en3r4e,en3r5e,en3r6e,en3r7e,en3r8e,en3r9e,en3r10e,en3r11e,en3r12e,en3r13e,en3r14e,en3r15e,
en3i0e,en3i1e,en3i2e,en3i3e,en3i4e,en3i5e,en3i6e,en3i7e,en3i8e,en3i9e,en3i10e,en3i11e,en3i12e,en3i13e,en3i14e,en3i15e;
wire [23:0] en3r0,en3r1,en3r2,en3r3,en3r4,en3r5,en3r6,en3r7,en3r8,en3r9,en3r10,en3r11,en3r12,en3r13,en3r14,en3r15,
en3i0,en3i1,en3i2,en3i3,en3i4,en3i5,en3i6,en3i7,en3i8,en3i9,en3i10,en3i11,en3i12,en3i13,en3i14,en3i15;

//third stage of butterfly

bf2_1 bfs31(en2r0s,en2r0e,en2r0,en2r4s,en2r4e,en2r4,en2i0s,en2i0e,en2i0,en2i4s,en2i4e,en2i4,en3r0s,en3r0e,en3r0,
en3i0s,en3i0e,en3i0,en3r1s,en3r1e,en3r1,en3i1s,en3i1e,en3i1);

bf2_5 bfs32(en2r2s,en2r2e,en2r2,en2r6s,en2r6e,en2r6,en2i2s,en2i2e,en2i2,en2i6s,en2i6e,en2i6,en3r2s,en3r2e,en3r2,
en3i2s,en3i2e,en3i2,en3r3s,en3r3e,en3r3,en3i3s,en3i3e,en3i3);

bf2_1 bfs33(en2r1s,en2r1e,en2r1,en2r5s,en2r5e,en2r5,en2i1s,en2i1e,en2i1,en2i5s,en2i5e,en2i5,en3r4s,en3r4e,en3r4,
en3i4s,en3i4e,en3i4,en3r5s,en3r5e,en3r5,en3i5s,en3i5e,en3i5);

bf2_5 bfs34(en2r3s,en2r3e,en2r3,en2r7s,en2r7e,en2r7,en2i3s,en2i3e,en2i3,en2i7s,en2i7e,en2i7,en3r6s,en3r6e,en3r6,
en3i6s,en3i6e,en3i6,en3r7s,en3r7e,en3r7,en3i7s,en3i7e,en3i7);

bf2_1 bfs35(en2r8s,en2r8e,en2r8,en2r12s,en2r12e,en2r12,en2i8s,en2i8e,en2i8,en2i12s,en2i12e,en2i12,en3r8s,en3r8e,en3r8,
en3i8s,en3i8e,en3i8,en3r9s,en3r9e,en3r9,en3i9s,en3i9e,en3i9);

bf2_5 bfs36(en2r10s,en2r10e,en2r10,en2r14s,en2r14e,en2r14,en2i10s,en2i10e,en2i10,en2i14s,en2i14e,en2i14,en3r10s,en3r10e,en3r10,
en3i10s,en3i10e,en3i10,en3r11s,en3r11e,en3r11,en3i11s,en3i11e,en3i11);

bf2_1 bfs37(en2r9s,en2r9e,en2r9,en2r13s,en2r13e,en2r13,en2i9s,en2i9e,en2i9,en2i13s,en2i13e,en2i13,en3r12s,en3r12e,en3r12,
en3i12s,en3i12e,en3i12,en3r13s,en3r13e,en3r13,en3i13s,en3i13e,en3i13);

bf2_5 bfs38(en2r11s,en2r11e,en2r11,en2r15s,en2r15e,en2r15,en2i11s,en2i11e,en2i11,en2i15s,en2i15e,en2i15,en3r14s,en3r14e,en3r14,
en3i14s,en3i14e,en3i14,en3r15s,en3r15e,en3r15,en3i15s,en3i15e,en3i15);

wire en4r0s,en4r1s,en4r2s,en4r3s,en4r4s,en4r5s,en4r6s,en4r7s,en4r8s,en4r9s,en4r10s,en4r11s,en4r12s,en4r13s,en4r14s,en4r15s,
en4i0s,en4i1s,en4i2s,en4i3s,en4i4s,en4i5s,en4i6s,en4i7s,en4i8s,en4i9s,en4i10s,en4i11s,en4i12s,en4i13s,en4i14s,en4i15s;
wire [7:0] en4r0e,en4r1e,en4r2e,en4r3e,en4r4e,en4r5e,en4r6e,en4r7e,en4r8e,en4r9e,en4r10e,en4r11e,en4r12e,en4r13e,en4r14e,en4r15e,
en4i0e,en4i1e,en4i2e,en4i3e,en4i4e,en4i5e,en4i6e,en4i7e,en4i8e,en4i9e,en4i10e,en4i11e,en4i12e,en4i13e,en4i14e,en4i15e;
wire [23:0] en4r0,en4r1,en4r2,en4r3,en4r4,en4r5,en4r6,en4r7,en4r8,en4r9,en4r10,en4r11,en4r12,en4r13,en4r14,en4r15,
en4i0,en4i1,en4i2,en4i3,en4i4,en4i5,en4i6,en4i7,en4i8,en4i9,en4i10,en4i11,en4i12,en4i13,en4i14,en4i15;

/*dflipflop dren4s00(en4r0s,en3r0s,clk,reset);
dflipflop dren4s01(en4r1s,en3r1s,clk,reset);
dflipflop dren4s02(en4r2s,en3r2s,clk,reset);
dflipflop dren4s03(en4r3s,en3r3s,clk,reset);
dflipflop dren4s04(en4r4s,en3r4s,clk,reset);
dflipflop dren4s05(en4r5s,en3r5s,clk,reset);
dflipflop dren4s06(en4r6s,en3r6s,clk,reset);
dflipflop dren4s07(en4r7s,en3r7s,clk,reset);
dflipflop dren4s08(en4r8s,en3r8s,clk,reset);
dflipflop dren4s09(en4r9s,en3r9s,clk,reset);
dflipflop dren4s10(en4r10s,en3r10s,clk,reset);
dflipflop dren4s11(en4r11s,en3r11s,clk,reset);
dflipflop dren4s12(en4r12s,en3r12s,clk,reset);
dflipflop dren4s13(en4r13s,en3r13s,clk,reset);
dflipflop dren4s14(en4r14s,en3r14s,clk,reset);
dflipflop dren4s15(en4r15s,en3r15s,clk,reset);

dflipflop dien41s00(en4i0s,en3i0s,clk,reset);
dflipflop dien41s01(en4i1s,en3i1s,clk,reset);
dflipflop dien41s02(en4i2s,en3i2s,clk,reset);
dflipflop dien41s03(en4i3s,en3i3s,clk,reset);
dflipflop dien41s04(en4i4s,en3i4s,clk,reset);
dflipflop dien41s05(en4i5s,en3i5s,clk,reset);
dflipflop dien41s06(en4i6s,en3i6s,clk,reset);
dflipflop dien41s07(en4i7s,en3i7s,clk,reset);
dflipflop dien41s08(en4i8s,en3i8s,clk,reset);
dflipflop dien41s09(en4i9s,en3i9s,clk,reset);
dflipflop dien41s10(en4i10s,en3i10s,clk,reset);
dflipflop dien41s11(en4i11s,en3i11s,clk,reset);
dflipflop dien41s12(en4i12s,en3i12s,clk,reset);
dflipflop dien41s13(en4i13s,en3i13s,clk,reset);
dflipflop dien41s14(en4i14s,en3i14s,clk,reset);
dflipflop dien41s15(en4i15s,en3i15s,clk,reset);

dflipflop8 dren4e00(en4r0e,en3r0e,clk,reset);
dflipflop8 dren4e01(en4r1e,en3r1e,clk,reset);
dflipflop8 dren4e02(en4r2e,en3r2e,clk,reset);
dflipflop8 dren4e03(en4r3e,en3r3e,clk,reset);
dflipflop8 dren4e04(en4r4e,en3r4e,clk,reset);
dflipflop8 dren4e05(en4r5e,en3r5e,clk,reset);
dflipflop8 dren4e06(en4r6e,en3r6e,clk,reset);
dflipflop8 dren4e07(en4r7e,en3r7e,clk,reset);
dflipflop8 dren4e08(en4r8e,en3r8e,clk,reset);
dflipflop8 dren4e09(en4r9e,en3r9e,clk,reset);
dflipflop8 dren4e10(en4r10e,en3r10e,clk,reset);
dflipflop8 dren4e11(en4r11e,en3r11e,clk,reset);
dflipflop8 dren4e12(en4r12e,en3r12e,clk,reset);
dflipflop8 dren4e13(en4r13e,en3r13e,clk,reset);
dflipflop8 dren4e14(en4r14e,en3r14e,clk,reset);
dflipflop8 dren4e15(en4r15e,en3r15e,clk,reset);

dflipflop8 dien41e00(en4i0e,en3i0e,clk,reset);
dflipflop8 dien41e01(en4i1e,en3i1e,clk,reset);
dflipflop8 dien41e02(en4i2e,en3i2e,clk,reset);
dflipflop8 dien41e03(en4i3e,en3i3e,clk,reset);
dflipflop8 dien41e04(en4i4e,en3i4e,clk,reset);
dflipflop8 dien41e05(en4i5e,en3i5e,clk,reset);
dflipflop8 dien41e06(en4i6e,en3i6e,clk,reset);
dflipflop8 dien41e07(en4i7e,en3i7e,clk,reset);
dflipflop8 dien41e08(en4i8e,en3i8e,clk,reset);
dflipflop8 dien41e09(en4i9e,en3i9e,clk,reset);
dflipflop8 dien41e10(en4i10e,en3i10e,clk,reset);
dflipflop8 dien41e11(en4i11e,en3i11e,clk,reset);
dflipflop8 dien41e12(en4i12e,en3i12e,clk,reset);
dflipflop8 dien41e13(en4i13e,en3i13e,clk,reset);
dflipflop8 dien41e14(en4i14e,en3i14e,clk,reset);
dflipflop8 dien41e15(en4i15e,en3i15e,clk,reset);

dflipflop24 dren400(en4r0,en3r0,clk,reset);
dflipflop24 dren401(en4r1,en3r1,clk,reset);
dflipflop24 dren402(en4r2,en3r2,clk,reset);
dflipflop24 dren403(en4r3,en3r3,clk,reset);
dflipflop24 dren404(en4r4,en3r4,clk,reset);
dflipflop24 dren405(en4r5,en3r5,clk,reset);
dflipflop24 dren406(en4r6,en3r6,clk,reset);
dflipflop24 dren407(en4r7,en3r7,clk,reset);
dflipflop24 dren408(en4r8,en3r8,clk,reset);
dflipflop24 dren409(en4r9,en3r9,clk,reset);
dflipflop24 dren410(en4r10,en3r10,clk,reset);
dflipflop24 dren411(en4r11,en3r11,clk,reset);
dflipflop24 dren412(en4r12,en3r12,clk,reset);
dflipflop24 dren413(en4r13,en3r13,clk,reset);
dflipflop24 dren414(en4r14,en3r14,clk,reset);
dflipflop24 dren415(en4r15,en3r15,clk,reset);

dflipflop24 dien4100(en4i0,en3i0,clk,reset);
dflipflop24 dien4101(en4i1,en3i1,clk,reset);
dflipflop24 dien4102(en4i2,en3i2,clk,reset);
dflipflop24 dien4103(en4i3,en3i3,clk,reset);
dflipflop24 dien4104(en4i4,en3i4,clk,reset);
dflipflop24 dien4105(en4i5,en3i5,clk,reset);
dflipflop24 dien4106(en4i6,en3i6,clk,reset);
dflipflop24 dien4107(en4i7,en3i7,clk,reset);
dflipflop24 dien4108(en4i8,en3i8,clk,reset);
dflipflop24 dien4109(en4i9,en3i9,clk,reset);
dflipflop24 dien4110(en4i10,en3i10,clk,reset);
dflipflop24 dien4111(en4i11,en3i11,clk,reset);
dflipflop24 dien4112(en4i12,en3i12,clk,reset);
dflipflop24 dien4113(en4i13,en3i13,clk,reset);
dflipflop24 dien4114(en4i14,en3i14,clk,reset);
dflipflop24 dien4115(en4i15,en3i15,clk,reset);*/

assign en4r0s=en3r0s;
assign en4r1s=en3r1s;
assign en4r2s=en3r2s;
assign en4r3s=en3r3s;
assign en4r4s=en3r4s;
assign en4r5s=en3r5s;
assign en4r6s=en3r6s;
assign en4r7s=en3r7s;
assign en4r8s=en3r8s;
assign en4r9s=en3r9s;
assign en4r10s=en3r10s;
assign en4r11s=en3r11s;
assign en4r12s=en3r12s;
assign en4r13s=en3r13s;
assign en4r14s=en3r14s;
assign en4r15s=en3r15s;

assign en4i0s=en3i0s;
assign en4i1s=en3i1s;
assign en4i2s=en3i2s;
assign en4i3s=en3i3s;
assign en4i4s=en3i4s;
assign en4i5s=en3i5s;
assign en4i6s=en3i6s;
assign en4i7s=en3i7s;
assign en4i8s=en3i8s;
assign en4i9s=en3i9s;
assign en4i10s=en3i10s;
assign en4i11s=en3i11s;
assign en4i12s=en3i12s;
assign en4i13s=en3i13s;
assign en4i14s=en3i14s;
assign en4i15s=en3i15s;

assign en4r0e=en3r0e;
assign en4r1e=en3r1e;
assign en4r2e=en3r2e;
assign en4r3e=en3r3e;
assign en4r4e=en3r4e;
assign en4r5e=en3r5e;
assign en4r6e=en3r6e;
assign en4r7e=en3r7e;
assign en4r8e=en3r8e;
assign en4r9e=en3r9e;
assign en4r10e=en3r10e;
assign en4r11e=en3r11e;
assign en4r12e=en3r12e;
assign en4r13e=en3r13e;
assign en4r14e=en3r14e;
assign en4r15e=en3r15e;

assign en4i0e=en3i0e;
assign en4i1e=en3i1e;
assign en4i2e=en3i2e;
assign en4i3e=en3i3e;
assign en4i4e=en3i4e;
assign en4i5e=en3i5e;
assign en4i6e=en3i6e;
assign en4i7e=en3i7e;
assign en4i8e=en3i8e;
assign en4i9e=en3i9e;
assign en4i10e=en3i10e;
assign en4i11e=en3i11e;
assign en4i12e=en3i12e;
assign en4i13e=en3i13e;
assign en4i14e=en3i14e;
assign en4i15e=en3i15e;

assign en4r0=en3r0;
assign en4r1=en3r1;
assign en4r2=en3r2;
assign en4r3=en3r3;
assign en4r4=en3r4;
assign en4r5=en3r5;
assign en4r6=en3r6;
assign en4r7=en3r7;
assign en4r8=en3r8;
assign en4r9=en3r9;
assign en4r10=en3r10;
assign en4r11=en3r11;
assign en4r12=en3r12;
assign en4r13=en3r13;
assign en4r14=en3r14;
assign en4r15=en3r15;

assign en4i0=en3i0;
assign en4i1=en3i1;
assign en4i2=en3i2;
assign en4i3=en3i3;
assign en4i4=en3i4;
assign en4i5=en3i5;
assign en4i6=en3i6;
assign en4i7=en3i7;
assign en4i8=en3i8;
assign en4i9=en3i9;
assign en4i10=en3i10;
assign en4i11=en3i11;
assign en4i12=en3i12;
assign en4i13=en3i13;
assign en4i14=en3i14;
assign en4i15=en3i15;

//fourth stage of butterfly

wire en5r0s,en5r1s,en5r2s,en5r3s,en5r4s,en5r5s,en5r6s,en5r7s,en5r8s,en5r9s,en5r10s,en5r11s,en5r12s,en5r13s,en5r14s,en5r15s,
en5i0s,en5i1s,en5i2s,en5i3s,en5i4s,en5i5s,en5i6s,en5i7s,en5i8s,en5i9s,en5i10s,en5i11s,en5i12s,en5i13s,en5i14s,en5i15s;
wire [7:0] en5r0e,en5r1e,en5r2e,en5r3e,en5r4e,en5r5e,en5r6e,en5r7e,en5r8e,en5r9e,en5r10e,en5r11e,en5r12e,en5r13e,en5r14e,en5r15e,
en5i0e,en5i1e,en5i2e,en5i3e,en5i4e,en5i5e,en5i6e,en5i7e,en5i8e,en5i9e,en5i10e,en5i11e,en5i12e,en5i13e,en5i14e,en5i15e;
wire [23:0] en5r0,en5r1,en5r2,en5r3,en5r4,en5r5,en5r6,en5r7,en5r8,en5r9,en5r10,en5r11,en5r12,en5r13,en5r14,en5r15,
en5i0,en5i1,en5i2,en5i3,en5i4,en5i5,en5i6,en5i7,en5i8,en5i9,en5i10,en5i11,en5i12,en5i13,en5i14,en5i15;

bf2_1 bfs41(en4r0s,en4r0e,en4r0,en4r2s,en4r2e,en4r2,en4i0s,en4i0e,en4i0,en4i2s,en4i2e,en4i2,en5r0s,en5r0e,en5r0,
en5i0s,en5i0e,en5i0,en5r1s,en5r1e,en5r1,en5i1s,en5i1e,en5i1);

bf2_1 bfs42(en4r1s,en4r1e,en4r1,en4r3s,en4r3e,en4r3,en4i1s,en4i1e,en4i1,en4i3s,en4i3e,en4i3,en5r2s,en5r2e,en5r2,
en5i2s,en5i2e,en5i2,en5r3s,en5r3e,en5r3,en5i3s,en5i3e,en5i3);

bf2_1 bfs43(en4r4s,en4r4e,en4r4,en4r6s,en4r6e,en4r6,en4i4s,en4i4e,en4i4,en4i6s,en4i6e,en4i6,en5r4s,en5r4e,en5r4,
en5i4s,en5i4e,en5i4,en5r5s,en5r5e,en5r5,en5i5s,en5i5e,en5i5);

bf2_1 bfs44(en4r5s,en4r5e,en4r5,en4r7s,en4r7e,en4r7,en4i5s,en4i5e,en4i5,en4i7s,en4i7e,en4i7,en5r6s,en5r6e,en5r6,
en5i6s,en5i6e,en5i6,en5r7s,en5r7e,en5r7,en5i7s,en5i7e,en5i7);

bf2_1 bfs45(en4r8s,en4r8e,en4r8,en4r10s,en4r10e,en4r10,en4i8s,en4i8e,en4i8,en4i10s,en4i10e,en4i10,en5r8s,en5r8e,en5r8,
en5i8s,en5i8e,en5i8,en5r9s,en5r9e,en5r9,en5i9s,en5i9e,en5i9);

bf2_1 bfs46(en4r9s,en4r9e,en4r9,en4r11s,en4r11e,en4r11,en4i9s,en4i9e,en4i9,en4i11s,en4i11e,en4i11,en5r10s,en5r10e,en5r10,
en5i10s,en5i10e,en5i10,en5r11s,en5r11e,en5r11,en5i11s,en5i11e,en5i11);

bf2_1 bfs47(en4r12s,en4r12e,en4r12,en4r14s,en4r14e,en4r14,en4i12s,en4i12e,en4i12,en4i14s,en4i14e,en4i14,en5r12s,en5r12e,en5r12,
en5i12s,en5i12e,en5i12,en5r13s,en5r13e,en5r13,en5i13s,en5i13e,en5i13);

bf2_1 bfs48(en4r13s,en4r13e,en4r13,en4r15s,en4r15e,en4r15,en4i13s,en4i13e,en4i13,en4i15s,en4i15e,en4i15,en5r14s,en5r14e,en5r14,
en5i14s,en5i14e,en5i14,en5r15s,en5r15e,en5r15,en5i15s,en5i15e,en5i15);

wire or0s,or1s,or2s,or3s,or4s,or5s,or6s,or7s,or8s,or9s,or10s,or11s,or12s,or13s,or14s,or15s,
oi0s,oi1s,oi2s,oi3s,oi4s,oi5s,oi6s,oi7s,oi8s,oi9s,oi10s,oi11s,oi12s,oi13s,oi14s,oi15s;
wire [7:0] or0e,or1e,or2e,or3e,or4e,or5e,or6e,or7e,or8e,or9e,or10e,or11e,or12e,or13e,or14e,or15e,
oi0e,oi1e,oi2e,oi3e,oi4e,oi5e,oi6e,oi7e,oi8e,oi9e,oi10e,oi11e,oi12e,oi13e,oi14e,oi15e;
wire [23:0] or0,or1,or2,or3,or4,or5,or6,or7,or8,or9,or10,or11,or12,or13,or14,or15,
oi0,oi1,oi2,oi3,oi4,oi5,oi6,oi7,oi8,oi9,oi10,oi11,oi12,oi13,oi14,oi15;

dflipflop dros00(or0s,en5r0s,clk,reset);
dflipflop dros01(or1s,en5r1s,clk,reset);
dflipflop dros02(or2s,en5r2s,clk,reset);
dflipflop dros03(or3s,en5r3s,clk,reset);
dflipflop dros04(or4s,en5r4s,clk,reset);
dflipflop dros05(or5s,en5r5s,clk,reset);
dflipflop dros06(or6s,en5r6s,clk,reset);
dflipflop dros07(or7s,en5r7s,clk,reset);
dflipflop dros08(or8s,en5r8s,clk,reset);
dflipflop dros09(or9s,en5r9s,clk,reset);
dflipflop dros10(or10s,en5r10s,clk,reset);
dflipflop dros11(or11s,en5r11s,clk,reset);
dflipflop dros12(or12s,en5r12s,clk,reset);
dflipflop dros13(or13s,en5r13s,clk,reset);
dflipflop dros14(or14s,en5r14s,clk,reset);
dflipflop dros15(or15s,en5r15s,clk,reset);

dflipflop dio1s00(oi0s,en5i0s,clk,reset);
dflipflop dio1s01(oi1s,en5i1s,clk,reset);
dflipflop dio1s02(oi2s,en5i2s,clk,reset);
dflipflop dio1s03(oi3s,en5i3s,clk,reset);
dflipflop dio1s04(oi4s,en5i4s,clk,reset);
dflipflop dio1s05(oi5s,en5i5s,clk,reset);
dflipflop dio1s06(oi6s,en5i6s,clk,reset);
dflipflop dio1s07(oi7s,en5i7s,clk,reset);
dflipflop dio1s08(oi8s,en5i8s,clk,reset);
dflipflop dio1s09(oi9s,en5i9s,clk,reset);
dflipflop dio1s10(oi10s,en5i10s,clk,reset);
dflipflop dio1s11(oi11s,en5i11s,clk,reset);
dflipflop dio1s12(oi12s,en5i12s,clk,reset);
dflipflop dio1s13(oi13s,en5i13s,clk,reset);
dflipflop dio1s14(oi14s,en5i14s,clk,reset);
dflipflop dio1s15(oi15s,en5i15s,clk,reset);

dflipflop8 droe00(or0e,en5r0e,clk,reset);
dflipflop8 droe01(or1e,en5r1e,clk,reset);
dflipflop8 droe02(or2e,en5r2e,clk,reset);
dflipflop8 droe03(or3e,en5r3e,clk,reset);
dflipflop8 droe04(or4e,en5r4e,clk,reset);
dflipflop8 droe05(or5e,en5r5e,clk,reset);
dflipflop8 droe06(or6e,en5r6e,clk,reset);
dflipflop8 droe07(or7e,en5r7e,clk,reset);
dflipflop8 droe08(or8e,en5r8e,clk,reset);
dflipflop8 droe09(or9e,en5r9e,clk,reset);
dflipflop8 droe10(or10e,en5r10e,clk,reset);
dflipflop8 droe11(or11e,en5r11e,clk,reset);
dflipflop8 droe12(or12e,en5r12e,clk,reset);
dflipflop8 droe13(or13e,en5r13e,clk,reset);
dflipflop8 droe14(or14e,en5r14e,clk,reset);
dflipflop8 droe15(or15e,en5r15e,clk,reset);

dflipflop8 dio1e00(oi0e,en5i0e,clk,reset);
dflipflop8 dio1e01(oi1e,en5i1e,clk,reset);
dflipflop8 dio1e02(oi2e,en5i2e,clk,reset);
dflipflop8 dio1e03(oi3e,en5i3e,clk,reset);
dflipflop8 dio1e04(oi4e,en5i4e,clk,reset);
dflipflop8 dio1e05(oi5e,en5i5e,clk,reset);
dflipflop8 dio1e06(oi6e,en5i6e,clk,reset);
dflipflop8 dio1e07(oi7e,en5i7e,clk,reset);
dflipflop8 dio1e08(oi8e,en5i8e,clk,reset);
dflipflop8 dio1e09(oi9e,en5i9e,clk,reset);
dflipflop8 dio1e10(oi10e,en5i10e,clk,reset);
dflipflop8 dio1e11(oi11e,en5i11e,clk,reset);
dflipflop8 dio1e12(oi12e,en5i12e,clk,reset);
dflipflop8 dio1e13(oi13e,en5i13e,clk,reset);
dflipflop8 dio1e14(oi14e,en5i14e,clk,reset);
dflipflop8 dio1e15(oi15e,en5i15e,clk,reset);

dflipflop24 dro00(or0,en5r0,clk,reset);
dflipflop24 dro01(or1,en5r1,clk,reset);
dflipflop24 dro02(or2,en5r2,clk,reset);
dflipflop24 dro03(or3,en5r3,clk,reset);
dflipflop24 dro04(or4,en5r4,clk,reset);
dflipflop24 dro05(or5,en5r5,clk,reset);
dflipflop24 dro06(or6,en5r6,clk,reset);
dflipflop24 dro07(or7,en5r7,clk,reset);
dflipflop24 dro08(or8,en5r8,clk,reset);
dflipflop24 dro09(or9,en5r9,clk,reset);
dflipflop24 dro10(or10,en5r10,clk,reset);
dflipflop24 dro11(or11,en5r11,clk,reset);
dflipflop24 dro12(or12,en5r12,clk,reset);
dflipflop24 dro13(or13,en5r13,clk,reset);
dflipflop24 dro14(or14,en5r14,clk,reset);
dflipflop24 dro15(or15,en5r15,clk,reset);

dflipflop24 dio100(oi0,en5i0,clk,reset);
dflipflop24 dio101(oi1,en5i1,clk,reset);
dflipflop24 dio102(oi2,en5i2,clk,reset);
dflipflop24 dio103(oi3,en5i3,clk,reset);
dflipflop24 dio104(oi4,en5i4,clk,reset);
dflipflop24 dio105(oi5,en5i5,clk,reset);
dflipflop24 dio106(oi6,en5i6,clk,reset);
dflipflop24 dio107(oi7,en5i7,clk,reset);
dflipflop24 dio108(oi8,en5i8,clk,reset);
dflipflop24 dio109(oi9,en5i9,clk,reset);
dflipflop24 dio110(oi10,en5i10,clk,reset);
dflipflop24 dio111(oi11,en5i11,clk,reset);
dflipflop24 dio112(oi12,en5i12,clk,reset);
dflipflop24 dio113(oi13,en5i13,clk,reset);
dflipflop24 dio114(oi14,en5i14,clk,reset);
dflipflop24 dio115(oi15,en5i15,clk,reset);

endmodule

// D flip flop

module dflipflop(q,d,clk,reset);
output q;
input d,clk,reset;
reg q;
always@(posedge reset or negedge clk)
if(reset)
q<=1'b0;
else
q<=d;
endmodule



// D flip flop

module dflipflop8(q,d,clk,reset);
output [7:0] q;
input [7:0] d;
input clk,reset;
reg [7:0] q;
always@(posedge reset or negedge clk)
if(reset)
q<=8'b00000000;
else
q<=d;
endmodule


// D flip flop

module dflipflop24(q,d,clk,reset);
output [23:0] q;
input [23:0] d;
input clk,reset;
reg [23:0] q;
always@(posedge reset or negedge clk)
if(reset)
q<=24'b00000000;
else
q<=d;
endmodule


//Radix 2 butterfly unit (proposed using single stage)

//`include "float_adder.v"

module bf2_1(asr,aer,ar,bsr,ber,br,asi,aei,ai,bsi,bei,bi,f1sr,f1er,f1r,f1si,f1ei,f1i,f2sr,f2er,f2r,f2si,f2ei,f2i);

input asr,bsr,asi,bsi;
input [7:0] aer,ber,aei,bei;
input [23:0] ar,br,ai,bi;
output f1sr,f1si,f2sr,f2si;
output [7:0] f1er,f1ei,f2er,f2ei;
output [23:0] f1r,f1i,f2r,f2i;

float_adder f1(asr,aer,ar,bsr,ber,br,f1sr,f1er,f1r);
float_adder f2(asi,aei,ai,bsi,bei,bi,f1si,f1ei,f1i);

wire wsr,wsi;
wire [7:0] wer,wei;
wire [23:0] wr,wi;

float_adder f3(asr,aer,ar,(~bsr),ber,br,wsr,wer,wr);
float_adder f4(asi,aei,ai,(~bsi),bei,bi,wsi,wei,wi);

assign f2sr=wsr;
assign f2si=wsi;
assign f2er=wer;
assign f2ei=wei;
assign f2r=wr;
assign f2i=wi;
		
endmodule


//Radix 2 butterfly unit (proposed using single stage)

//`include "float_multi.v"

module bf2_2(asr,aer,ar,bsr,ber,br,asi,aei,ai,bsi,bei,bi,f1sr,f1er,f1r,f1si,f1ei,f1i,f2sr,f2er,f2r,f2si,f2ei,f2i);

input asr,bsr,asi,bsi;
input [7:0] aer,ber,aei,bei;
input [23:0] ar,br,ai,bi;
output f1sr,f1si,f2sr,f2si;
output [7:0] f1er,f1ei,f2er,f2ei;
output [23:0] f1r,f1i,f2r,f2i;

float_adder f1(asr,aer,ar,bsr,ber,br,f1sr,f1er,f1r); //ar+br
float_adder f2(asi,aei,ai,bsi,bei,bi,f1si,f1ei,f1i); //ai+bi

wire wsr,wsi;
wire [7:0] wer,wei;
wire [23:0] wr,wi;

float_adder f3(asr,aer,ar,(~bsr),ber,br,wsr,wer,wr); //ar-br=a
float_adder f4(asi,aei,ai,(~bsi),bei,bi,wsi,wei,wi); //ai-bi=b

wire [32:0] tr,ti;

assign tr=33'b001111110111011000111111000101000; //W16 1=0.9238+j0.3826
assign ti=33'b001111101110000111110010000100101;

//(a+jb)(c+jd))=(ac-bd)+j(ad+bc)

wire msr1,msr2,msi1,msi2;
wire [7:0] mer1,mer2,mei1,mei2;
wire [23:0] mr1,mr2,mi1,mi2;

float_multi fm1(wsr,wer,wr,tr[32],tr[31:24],tr[23:0],msr1,mer1,mr1);  //ac
float_multi fm2(wsi,wei,wi,ti[32],ti[31:24],ti[23:0],msr2,mer2,mr2);  //bd

float_multi fm3(wsr,wer,wr,ti[32],ti[31:24],ti[23:0],msi1,mei1,mi1);  //ad
float_multi fm4(wsi,wei,wi,tr[32],tr[31:24],tr[23:0],msi2,mei2,mi2);  //bc

float_adder f5(msr1,mer1,mr1,(~msr2),mer2,mr2,f2sr,f2er,f2r); //ac-bd
float_adder f6(msi1,mei1,mi1,msi2,mei2,mi2,f2si,f2ei,f2i); //ad+bc
		
endmodule


//Radix 2 butterfly unit (proposed using single stage)

module bf2_3(asr,aer,ar,bsr,ber,br,asi,aei,ai,bsi,bei,bi,f1sr,f1er,f1r,f1si,f1ei,f1i,f2sr,f2er,f2r,f2si,f2ei,f2i);

input asr,bsr,asi,bsi;
input [7:0] aer,ber,aei,bei;
input [23:0] ar,br,ai,bi;
output f1sr,f1si,f2sr,f2si;
output [7:0] f1er,f1ei,f2er,f2ei;
output [23:0] f1r,f1i,f2r,f2i;

float_adder f1(asr,aer,ar,bsr,ber,br,f1sr,f1er,f1r); //ar+br
float_adder f2(asi,aei,ai,bsi,bei,bi,f1si,f1ei,f1i); //ai+bi
wire wsr,wsi;
wire [7:0] wer,wei;
wire [23:0] wr,wi;

float_adder f3(asr,aer,ar,(~bsr),ber,br,wsr,wer,wr); //ar-br=a
float_adder f4(asi,aei,ai,(~bsi),bei,bi,wsi,wei,wi); //ai-bi=b

wire [32:0] tr,ti;

assign tr=33'b001111110101101001111110111110011; //W16 2=0.707+j0.707
assign ti=33'b001111110101101001111110111110011;

//(a+jb)(c+jd))=(ac-bd)+j(ad+bc)

wire msr1,msr2,msi1,msi2;
wire [7:0] mer1,mer2,mei1,mei2;
wire [23:0] mr1,mr2,mi1,mi2;

float_multi fm1(wsr,wer,wr,tr[32],tr[31:24],tr[23:0],msr1,mer1,mr1);  //ac
float_multi fm2(wsi,wei,wi,ti[32],ti[31:24],ti[23:0],msr2,mer2,mr2);  //bd

float_multi fm3(wsr,wer,wr,ti[32],ti[31:24],ti[23:0],msi1,mei1,mi1);  //ad
float_multi fm4(wsi,wei,wi,tr[32],tr[31:24],tr[23:0],msi2,mei2,mi2);  //bc

float_adder f5(msr1,mer1,mr1,(~msr2),mer2,mr2,f2sr,f2er,f2r); //ac-bd
float_adder f6(msi1,mei1,mi1,msi2,mei2,mi2,f2si,f2ei,f2i); //ad+bc
		
endmodule


//Radix 2 butterfly unit (proposed using single stage)

module bf2_4(asr,aer,ar,bsr,ber,br,asi,aei,ai,bsi,bei,bi,f1sr,f1er,f1r,f1si,f1ei,f1i,f2sr,f2er,f2r,f2si,f2ei,f2i);

input asr,bsr,asi,bsi;
input [7:0] aer,ber,aei,bei;
input [23:0] ar,br,ai,bi;
output f1sr,f1si,f2sr,f2si;
output [7:0] f1er,f1ei,f2er,f2ei;
output [23:0] f1r,f1i,f2r,f2i;

float_adder f1(asr,aer,ar,bsr,ber,br,f1sr,f1er,f1r); //ar+br
float_adder f2(asi,aei,ai,bsi,bei,bi,f1si,f1ei,f1i); //ai+bi
wire wsr,wsi;
wire [7:0] wer,wei;
wire [23:0] wr,wi;

float_adder f3(asr,aer,ar,(~bsr),ber,br,wsr,wer,wr); //ar-br=a
float_adder f4(asi,aei,ai,(~bsi),bei,bi,wsi,wei,wi); //ai-bi=b

wire [32:0] tr,ti;

assign tr=33'b001111101110000111110010000100101; //W16 3=0.3826+j0.9238
assign ti=33'b001111110111011000111111000101000;

//(a+jb)(c+jd))=(ac-bd)+j(ad+bc)

wire msr1,msr2,msi1,msi2;
wire [7:0] mer1,mer2,mei1,mei2;
wire [23:0] mr1,mr2,mi1,mi2;

float_multi fm1(wsr,wer,wr,tr[32],tr[31:24],tr[23:0],msr1,mer1,mr1);  //ac
float_multi fm2(wsi,wei,wi,ti[32],ti[31:24],ti[23:0],msr2,mer2,mr2);  //bd

float_multi fm3(wsr,wer,wr,ti[32],ti[31:24],ti[23:0],msi1,mei1,mi1);  //ad
float_multi fm4(wsi,wei,wi,tr[32],tr[31:24],tr[23:0],msi2,mei2,mi2);  //bc

float_adder f5(msr1,mer1,mr1,(~msr2),mer2,mr2,f2sr,f2er,f2r); //ac-bd
float_adder f6(msi1,mei1,mi1,msi2,mei2,mi2,f2si,f2ei,f2i); //ad+bc
		
endmodule



//Radix 2 butterfly unit (proposed using single stage)

module bf2_5(asr,aer,ar,bsr,ber,br,asi,aei,ai,bsi,bei,bi,f1sr,f1er,f1r,f1si,f1ei,f1i,f2sr,f2er,f2r,f2si,f2ei,f2i);

input asr,bsr,asi,bsi;
input [7:0] aer,ber,aei,bei;
input [23:0] ar,br,ai,bi;
output f1sr,f1si,f2sr,f2si;
output [7:0] f1er,f1ei,f2er,f2ei;
output [23:0] f1r,f1i,f2r,f2i;

float_adder f1(asr,aer,ar,bsr,ber,br,f1sr,f1er,f1r); //ar+br
float_adder f2(asi,aei,ai,bsi,bei,bi,f1si,f1ei,f1i); //ai+bi
wire wsr,wsi;
wire [7:0] wer,wei;
wire [23:0] wr,wi;

float_adder f3(asr,aer,ar,(~bsr),ber,br,wsr,wer,wr); //ar-br=a
float_adder f4(asi,aei,ai,(~bsi),bei,bi,wsi,wei,wi); //ai-bi=b

wire [32:0] tr,ti;

assign tr=33'b000000000000000000000000000000000; //W16 4=0+j
assign ti=33'b001111111100000000000000000000000;

//(a+jb)(c+jd))=(ac-bd)+j(ad+bc)

wire msr1,msr2,msi1,msi2;
wire [7:0] mer1,mer2,mei1,mei2;
wire [23:0] mr1,mr2,mi1,mi2;

float_multi fm1(wsr,wer,wr,tr[32],tr[31:24],tr[23:0],msr1,mer1,mr1);  //ac
float_multi fm2(wsi,wei,wi,ti[32],ti[31:24],ti[23:0],msr2,mer2,mr2);  //bd

float_multi fm3(wsr,wer,wr,ti[32],ti[31:24],ti[23:0],msi1,mei1,mi1);  //ad
float_multi fm4(wsi,wei,wi,tr[32],tr[31:24],tr[23:0],msi2,mei2,mi2);  //bc

float_adder f5(msr1,mer1,mr1,(~msr2),mer2,mr2,f2sr,f2er,f2r); //ac-bd
float_adder f6(msi1,mei1,mi1,msi2,mei2,mi2,f2si,f2ei,f2i); //ad+bc
		
endmodule


//Radix 2 butterfly unit (proposed using single stage)

module bf2_6(asr,aer,ar,bsr,ber,br,asi,aei,ai,bsi,bei,bi,f1sr,f1er,f1r,f1si,f1ei,f1i,f2sr,f2er,f2r,f2si,f2ei,f2i);

input asr,bsr,asi,bsi;
input [7:0] aer,ber,aei,bei;
input [23:0] ar,br,ai,bi;
output f1sr,f1si,f2sr,f2si;
output [7:0] f1er,f1ei,f2er,f2ei;
output [23:0] f1r,f1i,f2r,f2i;

float_adder f1(asr,aer,ar,bsr,ber,br,f1sr,f1er,f1r); //ar+br
float_adder f2(asi,aei,ai,bsi,bei,bi,f1si,f1ei,f1i); //ai+bi

wire wsr,wsi;
wire [7:0] wer,wei;
wire [23:0] wr,wi;

float_adder f3(asr,aer,ar,(~bsr),ber,br,wsr,wer,wr); //ar-br=a
float_adder f4(asi,aei,ai,(~bsi),bei,bi,wsi,wei,wi); //ai-bi=b

wire [32:0] tr,ti;

assign tr=33'b101111101110000111110010000100101; //W16 5=-0.3826+j0.9238
assign ti=33'b001111110111011000111111000101000;

//(a+jb)(c+jd))=(ac-bd)+j(ad+bc)

wire msr1,msr2,msi1,msi2;
wire [7:0] mer1,mer2,mei1,mei2;
wire [23:0] mr1,mr2,mi1,mi2;

float_multi fm1(wsr,wer,wr,tr[32],tr[31:24],tr[23:0],msr1,mer1,mr1);  //ac
float_multi fm2(wsi,wei,wi,ti[32],ti[31:24],ti[23:0],msr2,mer2,mr2);  //bd

float_multi fm3(wsr,wer,wr,ti[32],ti[31:24],ti[23:0],msi1,mei1,mi1);  //ad
float_multi fm4(wsi,wei,wi,tr[32],tr[31:24],tr[23:0],msi2,mei2,mi2);  //bc

float_adder f5(msr1,mer1,mr1,(~msr2),mer2,mr2,f2sr,f2er,f2r); //ac-bd
float_adder f6(msi1,mei1,mi1,msi2,mei2,mi2,f2si,f2ei,f2i); //ad+bc
		
endmodule



//Radix 2 butterfly unit (proposed using single stage)

module bf2_7(asr,aer,ar,bsr,ber,br,asi,aei,ai,bsi,bei,bi,f1sr,f1er,f1r,f1si,f1ei,f1i,f2sr,f2er,f2r,f2si,f2ei,f2i);

input asr,bsr,asi,bsi;
input [7:0] aer,ber,aei,bei;
input [23:0] ar,br,ai,bi;
output f1sr,f1si,f2sr,f2si;
output [7:0] f1er,f1ei,f2er,f2ei;
output [23:0] f1r,f1i,f2r,f2i;

float_adder f1(asr,aer,ar,bsr,ber,br,f1sr,f1er,f1r); //ar+br
float_adder f2(asi,aei,ai,bsi,bei,bi,f1si,f1ei,f1i); //ai+bi
wire wsr,wsi;
wire [7:0] wer,wei;
wire [23:0] wr,wi;

float_adder f3(asr,aer,ar,(~bsr),ber,br,wsr,wer,wr); //ar-br=a
float_adder f4(asi,aei,ai,(~bsi),bei,bi,wsi,wei,wi); //ai-bi=b

wire [32:0] tr,ti;

assign tr=33'b101111110101101001111110111110011; //W16 6=-0.707+j0.707
assign ti=33'b001111110101101001111110111110011;

//(a+jb)(c+jd))=(ac-bd)+j(ad+bc)

wire msr1,msr2,msi1,msi2;
wire [7:0] mer1,mer2,mei1,mei2;
wire [23:0] mr1,mr2,mi1,mi2;

float_multi fm1(wsr,wer,wr,tr[32],tr[31:24],tr[23:0],msr1,mer1,mr1);  //ac
float_multi fm2(wsi,wei,wi,ti[32],ti[31:24],ti[23:0],msr2,mer2,mr2);  //bd

float_multi fm3(wsr,wer,wr,ti[32],ti[31:24],ti[23:0],msi1,mei1,mi1);  //ad
float_multi fm4(wsi,wei,wi,tr[32],tr[31:24],tr[23:0],msi2,mei2,mi2);  //bc

float_adder f5(msr1,mer1,mr1,(~msr2),mer2,mr2,f2sr,f2er,f2r); //ac-bd
float_adder f6(msi1,mei1,mi1,msi2,mei2,mi2,f2si,f2ei,f2i); //ad+bc
		
endmodule





//Radix 2 butterfly unit (proposed using single stage)

module bf2_8(asr,aer,ar,bsr,ber,br,asi,aei,ai,bsi,bei,bi,f1sr,f1er,f1r,f1si,f1ei,f1i,f2sr,f2er,f2r,f2si,f2ei,f2i);

input asr,bsr,asi,bsi;
input [7:0] aer,ber,aei,bei;
input [23:0] ar,br,ai,bi;
output f1sr,f1si,f2sr,f2si;
output [7:0] f1er,f1ei,f2er,f2ei;
output [23:0] f1r,f1i,f2r,f2i;

float_adder f1(asr,aer,ar,bsr,ber,br,f1sr,f1er,f1r); //ar+br
float_adder f2(asi,aei,ai,bsi,bei,bi,f1si,f1ei,f1i); //ai+bi

wire wsr,wsi;
wire [7:0] wer,wei;
wire [23:0] wr,wi;

float_adder f3(asr,aer,ar,(~bsr),ber,br,wsr,wer,wr); //ar-br=a
float_adder f4(asi,aei,ai,(~bsi),bei,bi,wsi,wei,wi); //ai-bi=b

wire [32:0] tr,ti;

assign tr=33'b101111110111011000111111000101000; //W16 7=-0.9238+j0.3826
assign ti=33'b001111101110000111110010000100101;

//(a+jb)(c+jd))=(ac-bd)+j(ad+bc)

wire msr1,msr2,msi1,msi2;
wire [7:0] mer1,mer2,mei1,mei2;
wire [23:0] mr1,mr2,mi1,mi2;

float_multi fm1(wsr,wer,wr,tr[32],tr[31:24],tr[23:0],msr1,mer1,mr1);  //ac
float_multi fm2(wsi,wei,wi,ti[32],ti[31:24],ti[23:0],msr2,mer2,mr2);  //bd

float_multi fm3(wsr,wer,wr,ti[32],ti[31:24],ti[23:0],msi1,mei1,mi1);  //ad
float_multi fm4(wsi,wei,wi,tr[32],tr[31:24],tr[23:0],msi2,mei2,mi2);  //bc

float_adder f5(msr1,mer1,mr1,(~msr2),mer2,mr2,f2sr,f2er,f2r); //ac-bd
float_adder f6(msi1,mei1,mi1,msi2,mei2,mi2,f2si,f2ei,f2i); //ad+bc
		
endmodule



//single precision floating point adder

/*`include "barrel48.v"
`include "barrel24.v"
`include "recurse8.v"
`include "recurse.v"*/

module float_adder(nps3,npe3,np3,nps4,npe4,np4,is,ie,i);

input nps3,nps4;
input [7:0] npe3,npe4;
input [23:0] np3,np4;
output is;
output [7:0] ie;
output [23:0] i;

reg [7:0] s11,s22;
reg [23:0] oopnn,ooann;
reg [7:0] npee;

wire z11;
assign z11=nps3 ^ nps4;

always@(npe3 or npe4 or np3 or np4 or z11)
	begin
		if(npe3>npe4)
			begin
				s11=npe3-npe4;
				npee=npe3;
				s22=8'b000;
			end
		else if (npe3<npe4)
			begin
				s22=npe4-npe3;
				npee=npe4;
				s11=8'b00;
			end
		else if (z11==1'b1 && npe3==npe4 && np3==np4)
			begin
				npee=8'b00000000;
				s11=8'b00;
				s22=8'b00;
			end
		else if (npe3==npe4)
			begin
				npee=npe4;
				s11=8'b00;
				s22=8'b00;
			end		
	end

wire [23:0] ooo;
assign ooo=24'b000;	
wire [47:0] pp33,opp;

assign pp33[47:0]={np4[23:0],ooo[23:0]};

//barrel48 b211(opp,pp33,s11);	
assign opp=pp33>>s11;
wire i11;

wire [26:0] op11;
wire [23:0] op22;
assign i11= opp[21] | opp[20] | opp[19] | opp[18] | opp[17] | opp[16] | opp[15] | opp[14] | opp[13] | opp[12] | opp[11] | opp[10] | opp[9] | opp[8] | opp[7] | opp[6] | opp[5] | opp[4] | opp[3] | opp[2] | opp[1] | opp[0];
assign op11[26:0]={opp[47:22],i11};
assign op22[23:0]=op11[26:3];

wire [47:0] a11,oaa;

assign a11[47:0]={np3[23:0],ooo[23:0]};
//barrel48 b122(oaa,a11,s22); 
assign oaa=a11>>s22;
wire i22;

wire [26:0] oa11;
wire [23:0] oa22;
assign i22= oaa[21] | oaa[20] | oaa[19] | oaa[18] | oaa[17] | oaa[16] | oaa[15] | oaa[14] | oaa[13] | oaa[12] |oaa[11] | oaa[10] | oaa[9] | oaa[8] | oaa[7] | oaa[6] | oaa[5] | oaa[4] | oaa[3] | oaa[2] | oaa[1] | oaa[0];
assign oa11[26:0]={oaa[47:22],i22};
assign oa22[23:0]=oa11[26:3];

always@(op11 or op22)
	begin	
		if((op11[2]==1)&&(op11[1]==1))      //G=1,R=1,round up (add 1 to lsb)
			begin
				 oopnn=op22+1;			
			end
		else if(op11[2]==0)	//G=0 round down (no change)	
			begin
				 oopnn=op22;
			end
		else if((op11[2]==1) && (op11[1]==0) && (op11[0]==1))	//G=1,R=0,S=1,round up (add 1 to lsb)
			begin
				 oopnn=op22+1;
			end
		else if((op11[2]==1)&&(op11[1]==0)&&(op11[0]==0)&&(op11[3]==0)) //G=1,R=0,S=0,round to nearest even (leave it if lsb is 0)
			begin
				 oopnn=op22;
			end
		else if((op11[2]==1)&&(op11[1]==0)&&(op11[0]==0)&&(op11[3]==1)) //G=1,R=0,S=0,round to nearest even (add 1 to lsb if lsb is 1)
			begin
			 oopnn=op22+1;			
			end
	end
	
always@(oa11 or oa22)
	begin	
		if((oa11[2]==1)&&(oa11[1]==1))      //G=1,R=1,round up (add 1 to lsb)
			begin
				ooann=oa22+1;				
			end
		else if(oa11[2]==0)	//G=0, round down (no change)	
			begin
				 ooann=oa22;
			end
		else if((oa11[2]==1) && (oa11[1]==0) && (oa11[0]==1))	//G=1,R=0,S=1,round up (add 1 to lsb)
			begin
				 ooann=oa22+1;
			end
		else if((oa11[2]==1)&&(oa11[1]==0)&&(oa11[0]==0)&&(oa11[3]==0)) //G=1,R=0,S=0,round to nearest even (leave it if lsb is 0)
			begin
				 ooann=oa22;
			end
		else if((oa11[2]==1)&&(oa11[1]==0)&&(oa11[0]==0)&&(oa11[3]==1)) //G=1,R=0,S=0,round to nearest even (add 1 to lsb if lsb is 1)
			begin
				 ooann = oa22+1;				
			end
	end
//////////////////////	
	
wire [23:0] np2222,r11,r22;
assign np2222=(~oopnn)+1;
wire c11,c22;

///////////////////////////////////////////////////////////

wire c10,c20;
wire [31:0] r111,r222;

//cladder32 c1(r111,c10,{8'b0,ooann},{8'b0,np2222},1'b0);
//cladder32 c2(r222,c20,{8'b0,ooann},{8'b0,oopnn},1'b0);

recurse c1(r111,c10,{8'b0,ooann},{8'b0,np2222});
recurse c2(r222,c20,{8'b0,ooann},{8'b0,oopnn});

assign r11=r111[23:0];
assign r22=r222[23:0];
assign c11=r111[24];
assign c22=r222[24];

//assign {c11,r11[23:0]}={1'b0,ooann}+{1'b0,np2222};
//assign {c22,r22[23:0]}={1'b0,ooann}+{1'b0,oopnn};

/////////////////////////////////////////////////////////////

reg [23:0] pp11;
reg [7:0] pnee;
reg is;
always@(c11 or r11 or c22 or r22 or nps3 or np3 or np4 or nps4 or npe3 or npe4 or npee or z11)
	begin
	
	 if (c22==1 && z11==0 && np3!=24'b000 && np4!=24'b000)
		begin
			is=nps3;
			pnee=npee+1;
			pp11={c22,r22[23:1]};
		end
	else if (c22==0 && z11==0 && np3!=24'b000 && np4!=24'b000)   
		begin
			is=nps3;
			pnee=npee;
			pp11=r22;
		end			
	 else if (c11==0 && z11==1 && np3!=24'b000 && np4!=24'b000)
		begin
//			is=1'b1;
			is=(~nps3);
			pnee=npee;
			pp11=(~r11)+1;
		end
	else if (c11==1 && z11==1 && np3!=24'b000 && np4!=24'b000)
		begin
//			is=1'b0;
			is=nps3;
			pnee=npee;
			pp11=r11;
		end
	else if (np3!=24'b0000 && np4==24'b000)
		begin
		   	is=nps3;
			pnee=npe3;
			pp11=np3;
		end
	else if (np4!=24'b0000 && np3==24'b000)
		begin
		   	is=nps4;
			pnee=npe4;
			pp11=np4;
		end	
	else if (np4==24'b0000 && np3==24'b000)
		begin
		   	is=1'b0;
			pnee=8'b00;
			pp11=24'b00;
		end		

	end

reg [4:0] sl11;
always @(pp11)				//normalization
begin 
	if(pp11[23]==1'b1)
		begin
			sl11=5'b00000;
		end
	else if(pp11[23:22]==2'b01)
		begin
			sl11=5'b00001;              	
		end
	else if(pp11[23:21]==3'b001)
		begin
			sl11=5'b00010;
		end
	else if(pp11[23:20]==4'b0001)
		begin
			sl11=5'b00011;
		end
	else if(pp11[23:19]==5'b00001)
		begin
			sl11=5'b00100;
		end
	else if(pp11[23:18]==6'b000001)
		begin
			sl11=5'b00101;
		end
	else if(pp11[23:17]==7'b0000001)
		begin
			sl11=5'b00110;
		end
	else if(pp11[23:16]==8'b00000001)
		begin
			sl11=5'b00111;
		end
	else if(pp11[23:15]==9'b000000001)
		begin
			sl11=5'b01000;
		end
	else if(pp11[23:14]==10'b0000000001)
		begin
			sl11=5'b01001;
		end
	else if(pp11[23:13]==11'b00000000001)
		begin
			sl11=5'b01010;
		end
	else if(pp11[23:12]==12'b000000000001)
		begin
			sl11=5'b01011;
		end
	else if(pp11[23:11]==13'b0000000000001)
		begin
			sl11=5'b01100;
		end
	else if(pp11[23:10]==14'b00000000000001)
		begin
			sl11=5'b01101;
		end
	else if(pp11[23:9]==15'b000000000000001)
		begin
			sl11=5'b01110;
		end
	else if(pp11[23:8]==16'b0000000000000001)
		begin
			sl11=5'b01111;
		end
	else if(pp11[23:7]==17'b00000000000000001)
		begin
			sl11=5'b10000;
		end
	else if(pp11[23:6]==18'b000000000000000001)
		begin
			sl11=5'b10001;
		end
	else if(pp11[23:5]==19'b0000000000000000001)
		begin
			sl11=5'b10010;
		end
	else if(pp11[23:4]==20'b00000000000000000001)
		begin
			sl11=5'b10011;
		end
	else if(pp11[23:3]==21'b000000000000000000001)
		begin
			sl11=5'b10100;
		end
	else if(pp11[23:2]==22'b0000000000000000000001)
		begin
			sl11=5'b10101;
		end
	else if(pp11[23:1]==23'b00000000000000000000001)
		begin
			sl11=5'b10110;
		end
	else if(pp11[23:0]==24'b000000000000000000000001)
		begin
			sl11=5'b10111;
		end
	else if(pp11[23:0]==24'b000000000000000000000000)
		begin
			sl11=5'b00000;
		end
end 
wire [23:0] ii,i;

wire [7:0] sl3,sl2,iie;
wire c7,c8;
assign sl2=~{3'b000,sl11}; 
recurse8 r801(sl3,c7,sl2,8'b00000001);
recurse8 r811(iie,c8,pnee,sl3);
reg [7:0] ie;

//barrel24 b111(ii,pp11,sl11);
assign ii=pp11<<sl11;

always@(iie or ii)
 begin
   if(ii==24'b00000)
	ie=8'b00000;
   else
	ie=iie;
 end

assign i=ii;

endmodule



// radix2 Wallace tree based single precision floating point multiplier

//`include "recurse8.v"
/*`include "recurse40.v"
`include "fulladd.v"
`include "halfadd.v"*/

module float_multi(as,ae,a,bs,be,b,ms,me,m);
input as,bs;
input [23:0] a,b;
input [7:0] ae,be;
output ms;
output [7:0] me;
output [23:0] m;

wire [47:0] r1;
wire [47:0] r;
wire [23:0] p0;
wire [23:0] p1;
wire [23:0] p2;
wire [23:0] p3;
wire [23:0] p4;
wire [23:0] p5;
wire [23:0] p6;
wire [23:0] p7;
wire [23:0] p8;
wire [23:0] p9;
wire [23:0] p10;
wire [23:0] p11;
wire [23:0] p12;
wire [23:0] p13;
wire [23:0] p14;
wire [23:0] p15;
wire [23:0] p16;
wire [23:0] p17;
wire [23:0] p18;
wire [23:0] p19;
wire [23:0] p20;
wire [23:0] p21;
wire [23:0] p22;
wire [23:0] p23;

wire [25:0] sum1;
wire [25:0] sum2;
wire [25:0] sum3;
wire [25:0] sum4;
wire [25:0] sum5;
wire [25:0] sum6;
wire [25:0] sum7;
wire [25:0] sum8;
wire [28:0] sum9;
wire [26:0] sum10;
wire [28:0] sum11;
wire [26:0] sum12;
wire [28:0] sum13;
wire [31:0] sum14;
wire [30:0] sum15;
wire [32:0] sum16;
wire [37:0] sum18;
wire [36:0] sum19;
wire [46:0] sum20;
wire [31:0] sum21;
wire [46:0] sum22;
wire [47:0] sum23;

wire [23:0] carry1;
wire [23:0] carry2;
wire [23:0] carry3;
wire [23:0] carry4;
wire [23:0] carry5;
wire [23:0] carry6;
wire [23:0] carry7;
wire [23:0] carry8;
wire [23:0] carry9;
wire [25:0] carry10;
wire [23:0] carry11;
wire [25:0] carry12;
wire [23:0] carry13;
wire [25:0] carry14;
wire [26:0] carry15;
wire [25:0] carry16;
wire [27:0] carry18;
wire [28:0] carry19;
wire [32:0] carry20;
wire [23:0] carry21;
wire [40:0] carry22;
wire [39:0] carry23;

wire c_in0,c_in1,c_in2,c_in3,c_in4,c_in5,c_in6,c_in7,c_in8,c_in9,carry_in;
assign carry_in=1'b0;

assign p0[23:0] = b[0] ? a[23:0] : 24'b000000000000000000000000;
assign p1[23:0] = b[1] ? a[23:0] : 24'b000000000000000000000000;
assign p2[23:0] = b[2] ? a[23:0] : 24'b000000000000000000000000;
assign p3[23:0] = b[3] ? a[23:0] : 24'b000000000000000000000000;    
assign p4[23:0] = b[4] ? a[23:0] : 24'b000000000000000000000000;
assign p5[23:0] = b[5] ? a[23:0] : 24'b000000000000000000000000;
assign p6[23:0] = b[6] ? a[23:0] : 24'b000000000000000000000000;
assign p7[23:0] = b[7] ? a[23:0] : 24'b000000000000000000000000;
assign p8[23:0] = b[8] ? a[23:0] : 24'b000000000000000000000000;
assign p9[23:0] = b[9] ? a[23:0] : 24'b000000000000000000000000;
assign p10[23:0] = b[10] ? a[23:0] : 24'b000000000000000000000000;
assign p11[23:0] = b[11] ? a[23:0] : 24'b000000000000000000000000;    
assign p12[23:0] = b[12] ? a[23:0] : 24'b000000000000000000000000;
assign p13[23:0] = b[13] ? a[23:0] : 24'b000000000000000000000000;
assign p14[23:0] = b[14] ? a[23:0] : 24'b000000000000000000000000;
assign p15[23:0] = b[15] ? a[23:0] : 24'b000000000000000000000000;
assign p16[23:0] = b[16] ? a[23:0] : 24'b000000000000000000000000;
assign p17[23:0] = b[17] ? a[23:0] : 24'b000000000000000000000000;
assign p18[23:0] = b[18] ? a[23:0] : 24'b000000000000000000000000;
assign p19[23:0] = b[19] ? a[23:0] : 24'b000000000000000000000000;    
assign p20[23:0] = b[20] ? a[23:0] : 24'b000000000000000000000000;
assign p21[23:0] = b[21] ? a[23:0] : 24'b000000000000000000000000;
assign p22[23:0] = b[22] ? a[23:0] : 24'b000000000000000000000000;
assign p23[23:0] = b[23] ? a[23:0] : 24'b000000000000000000000000;

//csa 1

assign sum1[0]=p0[0];
halfadd h11(sum1[1],carry1[0],p0[1],p1[0]);
fulladd f101(sum1[2],carry1[1],p0[2],p1[1],p2[0]);
fulladd f102(sum1[3],carry1[2],p0[3],p1[2],p2[1]);
fulladd f103(sum1[4],carry1[3],p0[4],p1[3],p2[2]);
fulladd f104(sum1[5],carry1[4],p0[5],p1[4],p2[3]);
fulladd f105(sum1[6],carry1[5],p0[6],p1[5],p2[4]);
fulladd f106(sum1[7],carry1[6],p0[7],p1[6],p2[5]);
fulladd f107(sum1[8],carry1[7],p0[8],p1[7],p2[6]);
fulladd f108(sum1[9],carry1[8],p0[9],p1[8],p2[7]);
fulladd f109(sum1[10],carry1[9],p0[10],p1[9],p2[8]);
fulladd f110(sum1[11],carry1[10],p0[11],p1[10],p2[9]);
fulladd f111(sum1[12],carry1[11],p0[12],p1[11],p2[10]);
fulladd f112(sum1[13],carry1[12],p0[13],p1[12],p2[11]);
fulladd f113(sum1[14],carry1[13],p0[14],p1[13],p2[12]);
fulladd f114(sum1[15],carry1[14],p0[15],p1[14],p2[13]);
fulladd f115(sum1[16],carry1[15],p0[16],p1[15],p2[14]);
fulladd f116(sum1[17],carry1[16],p0[17],p1[16],p2[15]);
fulladd f117(sum1[18],carry1[17],p0[18],p1[17],p2[16]);
fulladd f118(sum1[19],carry1[18],p0[19],p1[18],p2[17]);
fulladd f119(sum1[20],carry1[19],p0[20],p1[19],p2[18]);
fulladd f120(sum1[21],carry1[20],p0[21],p1[20],p2[19]);
fulladd f121(sum1[22],carry1[21],p0[22],p1[21],p2[20]);
fulladd f122(sum1[23],carry1[22],p0[23],p1[22],p2[21]);
halfadd h12(sum1[24],carry1[23],p1[23],p2[22]);
assign sum1[25]=p2[23];

//csa 2

assign sum2[0]=p3[0];
halfadd h21(sum2[1],carry2[0],p3[1],p4[0]);
fulladd f201(sum2[2],carry2[1],p3[2],p4[1],p5[0]);
fulladd f202(sum2[3],carry2[2],p3[3],p4[2],p5[1]);
fulladd f203(sum2[4],carry2[3],p3[4],p4[3],p5[2]);
fulladd f204(sum2[5],carry2[4],p3[5],p4[4],p5[3]);
fulladd f205(sum2[6],carry2[5],p3[6],p4[5],p5[4]);
fulladd f206(sum2[7],carry2[6],p3[7],p4[6],p5[5]);
fulladd f207(sum2[8],carry2[7],p3[8],p4[7],p5[6]);
fulladd f208(sum2[9],carry2[8],p3[9],p4[8],p5[7]);
fulladd f209(sum2[10],carry2[9],p3[10],p4[9],p5[8]);
fulladd f210(sum2[11],carry2[10],p3[11],p4[10],p5[9]);
fulladd f211(sum2[12],carry2[11],p3[12],p4[11],p5[10]);
fulladd f212(sum2[13],carry2[12],p3[13],p4[12],p5[11]);
fulladd f213(sum2[14],carry2[13],p3[14],p4[13],p5[12]);
fulladd f214(sum2[15],carry2[14],p3[15],p4[14],p5[13]);
fulladd f215(sum2[16],carry2[15],p3[16],p4[15],p5[14]);
fulladd f216(sum2[17],carry2[16],p3[17],p4[16],p5[15]);
fulladd f217(sum2[18],carry2[17],p3[18],p4[17],p5[16]);
fulladd f218(sum2[19],carry2[18],p3[19],p4[18],p5[17]);
fulladd f219(sum2[20],carry2[19],p3[20],p4[19],p5[18]);
fulladd f220(sum2[21],carry2[20],p3[21],p4[20],p5[19]);
fulladd f221(sum2[22],carry2[21],p3[22],p4[21],p5[20]);
fulladd f222(sum2[23],carry2[22],p3[23],p4[22],p5[21]);
halfadd h22(sum2[24],carry2[23],p4[23],p5[22]);
assign sum2[25]=p5[23];

//csa 3

assign sum3[0]=p6[0];
halfadd h31(sum3[1],carry3[0],p6[1],p7[0]);
fulladd f301(sum3[2],carry3[1],p6[2],p7[1],p8[0]);
fulladd f302(sum3[3],carry3[2],p6[3],p7[2],p8[1]);
fulladd f303(sum3[4],carry3[3],p6[4],p7[3],p8[2]);
fulladd f304(sum3[5],carry3[4],p6[5],p7[4],p8[3]);
fulladd f305(sum3[6],carry3[5],p6[6],p7[5],p8[4]);
fulladd f306(sum3[7],carry3[6],p6[7],p7[6],p8[5]);
fulladd f307(sum3[8],carry3[7],p6[8],p7[7],p8[6]);
fulladd f308(sum3[9],carry3[8],p6[9],p7[8],p8[7]);
fulladd f309(sum3[10],carry3[9],p6[10],p7[9],p8[8]);
fulladd f310(sum3[11],carry3[10],p6[11],p7[10],p8[9]);
fulladd f311(sum3[12],carry3[11],p6[12],p7[11],p8[10]);
fulladd f312(sum3[13],carry3[12],p6[13],p7[12],p8[11]);
fulladd f313(sum3[14],carry3[13],p6[14],p7[13],p8[12]);
fulladd f314(sum3[15],carry3[14],p6[15],p7[14],p8[13]);
fulladd f315(sum3[16],carry3[15],p6[16],p7[15],p8[14]);
fulladd f316(sum3[17],carry3[16],p6[17],p7[16],p8[15]);
fulladd f317(sum3[18],carry3[17],p6[18],p7[17],p8[16]);
fulladd f318(sum3[19],carry3[18],p6[19],p7[18],p8[17]);
fulladd f319(sum3[20],carry3[19],p6[20],p7[19],p8[18]);
fulladd f320(sum3[21],carry3[20],p6[21],p7[20],p8[19]);
fulladd f321(sum3[22],carry3[21],p6[22],p7[21],p8[20]);
fulladd f322(sum3[23],carry3[22],p6[23],p7[22],p8[21]);
halfadd h32(sum3[24],carry3[23],p7[23],p8[22]);
assign sum3[25]=p8[23];

//csa 4

assign sum4[0]=p9[0];
halfadd h41(sum4[1],carry4[0],p9[1],p10[0]);
fulladd f401(sum4[2],carry4[1],p9[2],p10[1],p11[0]);
fulladd f402(sum4[3],carry4[2],p9[3],p10[2],p11[1]);
fulladd f403(sum4[4],carry4[3],p9[4],p10[3],p11[2]);
fulladd f404(sum4[5],carry4[4],p9[5],p10[4],p11[3]);
fulladd f405(sum4[6],carry4[5],p9[6],p10[5],p11[4]);
fulladd f406(sum4[7],carry4[6],p9[7],p10[6],p11[5]);
fulladd f407(sum4[8],carry4[7],p9[8],p10[7],p11[6]);
fulladd f408(sum4[9],carry4[8],p9[9],p10[8],p11[7]);
fulladd f409(sum4[10],carry4[9],p9[10],p10[9],p11[8]);
fulladd f410(sum4[11],carry4[10],p9[11],p10[10],p11[9]);
fulladd f411(sum4[12],carry4[11],p9[12],p10[11],p11[10]);
fulladd f412(sum4[13],carry4[12],p9[13],p10[12],p11[11]);
fulladd f413(sum4[14],carry4[13],p9[14],p10[13],p11[12]);
fulladd f414(sum4[15],carry4[14],p9[15],p10[14],p11[13]);
fulladd f415(sum4[16],carry4[15],p9[16],p10[15],p11[14]);
fulladd f416(sum4[17],carry4[16],p9[17],p10[16],p11[15]);
fulladd f417(sum4[18],carry4[17],p9[18],p10[17],p11[16]);
fulladd f418(sum4[19],carry4[18],p9[19],p10[18],p11[17]);
fulladd f419(sum4[20],carry4[19],p9[20],p10[19],p11[18]);
fulladd f420(sum4[21],carry4[20],p9[21],p10[20],p11[19]);
fulladd f421(sum4[22],carry4[21],p9[22],p10[21],p11[20]);
fulladd f422(sum4[23],carry4[22],p9[23],p10[22],p11[21]);
halfadd h42(sum4[24],carry4[23],p10[23],p11[22]);
assign sum4[25]=p11[23];

//csa 5

assign sum5[0]=p12[0];
halfadd h51(sum5[1],carry5[0],p12[1],p13[0]);
fulladd f501(sum5[2],carry5[1],p12[2],p13[1],p14[0]);
fulladd f502(sum5[3],carry5[2],p12[3],p13[2],p14[1]);
fulladd f503(sum5[4],carry5[3],p12[4],p13[3],p14[2]);
fulladd f504(sum5[5],carry5[4],p12[5],p13[4],p14[3]);
fulladd f505(sum5[6],carry5[5],p12[6],p13[5],p14[4]);
fulladd f506(sum5[7],carry5[6],p12[7],p13[6],p14[5]);
fulladd f507(sum5[8],carry5[7],p12[8],p13[7],p14[6]);
fulladd f508(sum5[9],carry5[8],p12[9],p13[8],p14[7]);
fulladd f509(sum5[10],carry5[9],p12[10],p13[9],p14[8]);
fulladd f510(sum5[11],carry5[10],p12[11],p13[10],p14[9]);
fulladd f511(sum5[12],carry5[11],p12[12],p13[11],p14[10]);
fulladd f512(sum5[13],carry5[12],p12[13],p13[12],p14[11]);
fulladd f513(sum5[14],carry5[13],p12[14],p13[13],p14[12]);
fulladd f514(sum5[15],carry5[14],p12[15],p13[14],p14[13]);
fulladd f515(sum5[16],carry5[15],p12[16],p13[15],p14[14]);
fulladd f516(sum5[17],carry5[16],p12[17],p13[16],p14[15]);
fulladd f517(sum5[18],carry5[17],p12[18],p13[17],p14[16]);
fulladd f518(sum5[19],carry5[18],p12[19],p13[18],p14[17]);
fulladd f519(sum5[20],carry5[19],p12[20],p13[19],p14[18]);
fulladd f520(sum5[21],carry5[20],p12[21],p13[20],p14[19]);
fulladd f521(sum5[22],carry5[21],p12[22],p13[21],p14[20]);
fulladd f522(sum5[23],carry5[22],p12[23],p13[22],p14[21]);
halfadd h52(sum5[24],carry5[23],p13[23],p14[22]);
assign sum5[25]=p14[23];

//csa 6

assign sum6[0]=p15[0];
halfadd h61(sum6[1],carry6[0],p15[1],p16[0]);
fulladd f601(sum6[2],carry6[1],p15[2],p16[1],p17[0]);
fulladd f602(sum6[3],carry6[2],p15[3],p16[2],p17[1]);
fulladd f603(sum6[4],carry6[3],p15[4],p16[3],p17[2]);
fulladd f604(sum6[5],carry6[4],p15[5],p16[4],p17[3]);
fulladd f605(sum6[6],carry6[5],p15[6],p16[5],p17[4]);
fulladd f606(sum6[7],carry6[6],p15[7],p16[6],p17[5]);
fulladd f607(sum6[8],carry6[7],p15[8],p16[7],p17[6]);
fulladd f608(sum6[9],carry6[8],p15[9],p16[8],p17[7]);
fulladd f609(sum6[10],carry6[9],p15[10],p16[9],p17[8]);
fulladd f610(sum6[11],carry6[10],p15[11],p16[10],p17[9]);
fulladd f611(sum6[12],carry6[11],p15[12],p16[11],p17[10]);
fulladd f612(sum6[13],carry6[12],p15[13],p16[12],p17[11]);
fulladd f613(sum6[14],carry6[13],p15[14],p16[13],p17[12]);
fulladd f614(sum6[15],carry6[14],p15[15],p16[14],p17[13]);
fulladd f615(sum6[16],carry6[15],p15[16],p16[15],p17[14]);
fulladd f616(sum6[17],carry6[16],p15[17],p16[16],p17[15]);
fulladd f617(sum6[18],carry6[17],p15[18],p16[17],p17[16]);
fulladd f618(sum6[19],carry6[18],p15[19],p16[18],p17[17]);
fulladd f619(sum6[20],carry6[19],p15[20],p16[19],p17[18]);
fulladd f620(sum6[21],carry6[20],p15[21],p16[20],p17[19]);
fulladd f621(sum6[22],carry6[21],p15[22],p16[21],p17[20]);
fulladd f622(sum6[23],carry6[22],p15[23],p16[22],p17[21]);
halfadd h62(sum6[24],carry6[23],p16[23],p17[22]);
assign sum6[25]=p17[23];

//csa 7

assign sum7[0]=p18[0];
halfadd h71(sum7[1],carry7[0],p18[1],p19[0]);
fulladd f701(sum7[2],carry7[1],p18[2],p19[1],p20[0]);
fulladd f702(sum7[3],carry7[2],p18[3],p19[2],p20[1]);
fulladd f703(sum7[4],carry7[3],p18[4],p19[3],p20[2]);
fulladd f704(sum7[5],carry7[4],p18[5],p19[4],p20[3]);
fulladd f705(sum7[6],carry7[5],p18[6],p19[5],p20[4]);
fulladd f706(sum7[7],carry7[6],p18[7],p19[6],p20[5]);
fulladd f707(sum7[8],carry7[7],p18[8],p19[7],p20[6]);
fulladd f708(sum7[9],carry7[8],p18[9],p19[8],p20[7]);
fulladd f709(sum7[10],carry7[9],p18[10],p19[9],p20[8]);
fulladd f710(sum7[11],carry7[10],p18[11],p19[10],p20[9]);
fulladd f711(sum7[12],carry7[11],p18[12],p19[11],p20[10]);
fulladd f712(sum7[13],carry7[12],p18[13],p19[12],p20[11]);
fulladd f713(sum7[14],carry7[13],p18[14],p19[13],p20[12]);
fulladd f714(sum7[15],carry7[14],p18[15],p19[14],p20[13]);
fulladd f715(sum7[16],carry7[15],p18[16],p19[15],p20[14]);
fulladd f716(sum7[17],carry7[16],p18[17],p19[16],p20[15]);
fulladd f717(sum7[18],carry7[17],p18[18],p19[17],p20[16]);
fulladd f718(sum7[19],carry7[18],p18[19],p19[18],p20[17]);
fulladd f719(sum7[20],carry7[19],p18[20],p19[19],p20[18]);
fulladd f720(sum7[21],carry7[20],p18[21],p19[20],p20[19]);
fulladd f721(sum7[22],carry7[21],p18[22],p19[21],p20[20]);
fulladd f722(sum7[23],carry7[22],p18[23],p19[22],p20[21]);
halfadd h72(sum7[24],carry7[23],p19[23],p20[22]);
assign sum7[25]=p20[23];

//csa 8

assign sum8[0]=p21[0];
halfadd h81(sum8[1],carry8[0],p21[1],p22[0]);
fulladd f801(sum8[2],carry8[1],p21[2],p22[1],p23[0]);
fulladd f802(sum8[3],carry8[2],p21[3],p22[2],p23[1]);
fulladd f803(sum8[4],carry8[3],p21[4],p22[3],p23[2]);
fulladd f804(sum8[5],carry8[4],p21[5],p22[4],p23[3]);
fulladd f805(sum8[6],carry8[5],p21[6],p22[5],p23[4]);
fulladd f806(sum8[7],carry8[6],p21[7],p22[6],p23[5]);
fulladd f807(sum8[8],carry8[7],p21[8],p22[7],p23[6]);
fulladd f808(sum8[9],carry8[8],p21[9],p22[8],p23[7]);
fulladd f89(sum8[10],carry8[9],p21[10],p22[9],p23[8]);
fulladd f810(sum8[11],carry8[10],p21[11],p22[10],p23[9]);
fulladd f811(sum8[12],carry8[11],p21[12],p22[11],p23[10]);
fulladd f812(sum8[13],carry8[12],p21[13],p22[12],p23[11]);
fulladd f813(sum8[14],carry8[13],p21[14],p22[13],p23[12]);
fulladd f814(sum8[15],carry8[14],p21[15],p22[14],p23[13]);
fulladd f815(sum8[16],carry8[15],p21[16],p22[15],p23[14]);
fulladd f816(sum8[17],carry8[16],p21[17],p22[16],p23[15]);
fulladd f817(sum8[18],carry8[17],p21[18],p22[17],p23[16]);
fulladd f818(sum8[19],carry8[18],p21[19],p22[18],p23[17]);
fulladd f819(sum8[20],carry8[19],p21[20],p22[19],p23[18]);
fulladd f820(sum8[21],carry8[20],p21[21],p22[20],p23[19]);
fulladd f821(sum8[22],carry8[21],p21[22],p22[21],p23[20]);
fulladd f822(sum8[23],carry8[22],p21[23],p22[22],p23[21]);
halfadd h82(sum8[24],carry8[23],p22[23],p23[22]);
assign sum8[25]=p23[23];

//csa 9

assign sum9[1:0]=sum1[1:0];
halfadd h991(sum9[2],carry9[0],sum1[2],carry1[0]);
fulladd f901(sum9[3],carry9[1],sum1[3],carry1[1],sum2[0]);
fulladd f902(sum9[4],carry9[2],sum1[4],carry1[2],sum2[1]);
fulladd f903(sum9[5],carry9[3],sum1[5],carry1[3],sum2[2]);
fulladd f904(sum9[6],carry9[4],sum1[6],carry1[4],sum2[3]);
fulladd f905(sum9[7],carry9[5],sum1[7],carry1[5],sum2[4]);
fulladd f906(sum9[8],carry9[6],sum1[8],carry1[6],sum2[5]);
fulladd f907(sum9[9],carry9[7],sum1[9],carry1[7],sum2[6]);
fulladd f908(sum9[10],carry9[8],sum1[10],carry1[8],sum2[7]);
fulladd f909(sum9[11],carry9[9],sum1[11],carry1[9],sum2[8]);
fulladd f910(sum9[12],carry9[10],sum1[12],carry1[10],sum2[9]);
fulladd f911(sum9[13],carry9[11],sum1[13],carry1[11],sum2[10]);
fulladd f912(sum9[14],carry9[12],sum1[14],carry1[12],sum2[11]);
fulladd f913(sum9[15],carry9[13],sum1[15],carry1[13],sum2[12]);
fulladd f914(sum9[16],carry9[14],sum1[16],carry1[14],sum2[13]);
fulladd f915(sum9[17],carry9[15],sum1[17],carry1[15],sum2[14]);
fulladd f916(sum9[18],carry9[16],sum1[18],carry1[16],sum2[15]);
fulladd f917(sum9[19],carry9[17],sum1[19],carry1[17],sum2[16]);
fulladd f918(sum9[20],carry9[18],sum1[20],carry1[18],sum2[17]);
fulladd f919(sum9[21],carry9[19],sum1[21],carry1[19],sum2[18]);
fulladd f920(sum9[22],carry9[20],sum1[22],carry1[20],sum2[19]);
fulladd f921(sum9[23],carry9[21],sum1[23],carry1[21],sum2[20]);
fulladd f922(sum9[24],carry9[22],sum1[24],carry1[22],sum2[21]);
fulladd f923(sum9[25],carry9[23],sum1[25],carry1[23],sum2[22]);
assign sum9[28:26]=sum2[25:23];

//csa 10

assign sum10[0]=carry2[0];
halfadd h101(sum10[1],carry10[0],sum3[0],carry2[1]);
halfadd h102(sum10[2],carry10[1],sum3[1],carry2[2]);
fulladd f1001(sum10[3],carry10[2],sum3[2],carry2[3],carry3[0]);
fulladd f1002(sum10[4],carry10[3],sum3[3],carry2[4],carry3[1]);
fulladd f1003(sum10[5],carry10[4],sum3[4],carry2[5],carry3[2]);
fulladd f1004(sum10[6],carry10[5],sum3[5],carry2[6],carry3[3]);
fulladd f1005(sum10[7],carry10[6],sum3[6],carry2[7],carry3[4]);
fulladd f1006(sum10[8],carry10[7],sum3[7],carry2[8],carry3[5]);
fulladd f1007(sum10[9],carry10[8],sum3[8],carry2[9],carry3[6]);
fulladd f1008(sum10[10],carry10[9],sum3[9],carry2[10],carry3[7]);
fulladd f1009(sum10[11],carry10[10],sum3[10],carry2[11],carry3[8]);
fulladd f1010(sum10[12],carry10[11],sum3[11],carry2[12],carry3[9]);
fulladd f1011(sum10[13],carry10[12],sum3[12],carry2[13],carry3[10]);
fulladd f1012(sum10[14],carry10[13],sum3[13],carry2[14],carry3[11]);
fulladd f1013(sum10[15],carry10[14],sum3[14],carry2[15],carry3[12]);
fulladd f1014(sum10[16],carry10[15],sum3[15],carry2[16],carry3[13]);
fulladd f1015(sum10[17],carry10[16],sum3[16],carry2[17],carry3[14]);
fulladd f1016(sum10[18],carry10[17],sum3[17],carry2[18],carry3[15]);
fulladd f1017(sum10[19],carry10[18],sum3[18],carry2[19],carry3[16]);
fulladd f1018(sum10[20],carry10[19],sum3[19],carry2[20],carry3[17]);
fulladd f1019(sum10[21],carry10[20],sum3[20],carry2[21],carry3[18]);
fulladd f1020(sum10[22],carry10[21],sum3[21],carry2[22],carry3[19]);
fulladd f1021(sum10[23],carry10[22],sum3[22],carry2[23],carry3[20]);
halfadd h103(sum10[24],carry10[23],sum3[23],carry3[21]);
halfadd h104(sum10[25],carry10[24],sum3[24],carry3[22]);
halfadd h105(sum10[26],carry10[25],sum3[25],carry3[23]);

//csa 11

assign sum11[1:0]=sum4[1:0];
halfadd h111(sum11[2],carry11[0],sum4[2],carry4[0]);
fulladd f1101(sum11[3],carry11[1],sum4[3],carry4[1],sum5[0]);
fulladd f1102(sum11[4],carry11[2],sum4[4],carry4[2],sum5[1]);
fulladd f1103(sum11[5],carry11[3],sum4[5],carry4[3],sum5[2]);
fulladd f1104(sum11[6],carry11[4],sum4[6],carry4[4],sum5[3]);
fulladd f1105(sum11[7],carry11[5],sum4[7],carry4[5],sum5[4]);
fulladd f1106(sum11[8],carry11[6],sum4[8],carry4[6],sum5[5]);
fulladd f1107(sum11[9],carry11[7],sum4[9],carry4[7],sum5[6]);
fulladd f1108(sum11[10],carry11[8],sum4[10],carry4[8],sum5[7]);
fulladd f1109(sum11[11],carry11[9],sum4[11],carry4[9],sum5[8]);
fulladd f1110(sum11[12],carry11[10],sum4[12],carry4[10],sum5[9]);
fulladd f1111(sum11[13],carry11[11],sum4[13],carry4[11],sum5[10]);
fulladd f1112(sum11[14],carry11[12],sum4[14],carry4[12],sum5[11]);
fulladd f1113(sum11[15],carry11[13],sum4[15],carry4[13],sum5[12]);
fulladd f1114(sum11[16],carry11[14],sum4[16],carry4[14],sum5[13]);
fulladd f1115(sum11[17],carry11[15],sum4[17],carry4[15],sum5[14]);
fulladd f1116(sum11[18],carry11[16],sum4[18],carry4[16],sum5[15]);
fulladd f1117(sum11[19],carry11[17],sum4[19],carry4[17],sum5[16]);
fulladd f1118(sum11[20],carry11[18],sum4[20],carry4[18],sum5[17]);
fulladd f1119(sum11[21],carry11[19],sum4[21],carry4[19],sum5[18]);
fulladd f1120(sum11[22],carry11[20],sum4[22],carry4[20],sum5[19]);
fulladd f1121(sum11[23],carry11[21],sum4[23],carry4[21],sum5[20]);
fulladd f1122(sum11[24],carry11[22],sum4[24],carry4[22],sum5[21]);
fulladd f1123(sum11[25],carry11[23],sum4[25],carry4[23],sum5[22]);
assign sum11[28:26]=sum5[25:23];

//csa 12

assign sum12[0]=carry5[0];
halfadd h121(sum12[1],carry12[0],sum6[0],carry5[1]);
halfadd h122(sum12[2],carry12[1],sum6[1],carry5[2]);
fulladd f1201(sum12[3],carry12[2],sum6[2],carry5[3],carry6[0]);
fulladd f1202(sum12[4],carry12[3],sum6[3],carry5[4],carry6[1]);
fulladd f1203(sum12[5],carry12[4],sum6[4],carry5[5],carry6[2]);
fulladd f1204(sum12[6],carry12[5],sum6[5],carry5[6],carry6[3]);
fulladd f1205(sum12[7],carry12[6],sum6[6],carry5[7],carry6[4]);
fulladd f1206(sum12[8],carry12[7],sum6[7],carry5[8],carry6[5]);
fulladd f1207(sum12[9],carry12[8],sum6[8],carry5[9],carry6[6]);
fulladd f1208(sum12[10],carry12[9],sum6[9],carry5[10],carry6[7]);
fulladd f1209(sum12[11],carry12[10],sum6[10],carry5[11],carry6[8]);
fulladd f1210(sum12[12],carry12[11],sum6[11],carry5[12],carry6[9]);
fulladd f1211(sum12[13],carry12[12],sum6[12],carry5[13],carry6[10]);
fulladd f1212(sum12[14],carry12[13],sum6[13],carry5[14],carry6[11]);
fulladd f1213(sum12[15],carry12[14],sum6[14],carry5[15],carry6[12]);
fulladd f1214(sum12[16],carry12[15],sum6[15],carry5[16],carry6[13]);
fulladd f1215(sum12[17],carry12[16],sum6[16],carry5[17],carry6[14]);
fulladd f1216(sum12[18],carry12[17],sum6[17],carry5[18],carry6[15]);
fulladd f1217(sum12[19],carry12[18],sum6[18],carry5[19],carry6[16]);
fulladd f1218(sum12[20],carry12[19],sum6[19],carry5[20],carry6[17]);
fulladd f1219(sum12[21],carry12[20],sum6[20],carry5[21],carry6[18]);
fulladd f1220(sum12[22],carry12[21],sum6[21],carry5[22],carry6[19]);
fulladd f1221(sum12[23],carry12[22],sum6[22],carry5[23],carry6[20]);
halfadd h123(sum12[24],carry12[23],sum6[23],carry6[21]);
halfadd h124(sum12[25],carry12[24],sum6[24],carry6[22]);
halfadd h125(sum12[26],carry12[25],sum6[25],carry6[23]);

//csa 13

assign sum13[1:0]=sum7[1:0];
halfadd h131(sum13[2],carry13[0],sum7[2],carry7[0]);
fulladd f131(sum13[3],carry13[1],sum7[3],carry7[1],sum8[0]);
fulladd f1302(sum13[4],carry13[2],sum7[4],carry7[2],sum8[1]);
fulladd f1303(sum13[5],carry13[3],sum7[5],carry7[3],sum8[2]);
fulladd f1304(sum13[6],carry13[4],sum7[6],carry7[4],sum8[3]);
fulladd f1305(sum13[7],carry13[5],sum7[7],carry7[5],sum8[4]);
fulladd f1306(sum13[8],carry13[6],sum7[8],carry7[6],sum8[5]);
fulladd f1307(sum13[9],carry13[7],sum7[9],carry7[7],sum8[6]);
fulladd f1308(sum13[10],carry13[8],sum7[10],carry7[8],sum8[7]);
fulladd f1309(sum13[11],carry13[9],sum7[11],carry7[9],sum8[8]);
fulladd f1310(sum13[12],carry13[10],sum7[12],carry7[10],sum8[9]);
fulladd f1311(sum13[13],carry13[11],sum7[13],carry7[11],sum8[10]);
fulladd f1312(sum13[14],carry13[12],sum7[14],carry7[12],sum8[11]);
fulladd f1313(sum13[15],carry13[13],sum7[15],carry7[13],sum8[12]);
fulladd f1314(sum13[16],carry13[14],sum7[16],carry7[14],sum8[13]);
fulladd f1315(sum13[17],carry13[15],sum7[17],carry7[15],sum8[14]);
fulladd f1316(sum13[18],carry13[16],sum7[18],carry7[16],sum8[15]);
fulladd f1317(sum13[19],carry13[17],sum7[19],carry7[17],sum8[16]);
fulladd f1318(sum13[20],carry13[18],sum7[20],carry7[18],sum8[17]);
fulladd f1319(sum13[21],carry13[19],sum7[21],carry7[19],sum8[18]);
fulladd f1320(sum13[22],carry13[20],sum7[22],carry7[20],sum8[19]);
fulladd f1321(sum13[23],carry13[21],sum7[23],carry7[21],sum8[20]);
fulladd f1322(sum13[24],carry13[22],sum7[24],carry7[22],sum8[21]);
fulladd f1323(sum13[25],carry13[23],sum7[25],carry7[23],sum8[22]);
assign sum13[28:26]=sum8[25:23];

//csa 14

assign sum14[2:0]=sum9[2:0];
halfadd h141(sum14[3],carry14[0],sum9[3],carry9[0]);
halfadd h142(sum14[4],carry14[1],sum9[4],carry9[1]);
fulladd f1401(sum14[5],carry14[2],sum9[5],carry9[2],sum10[0]);
fulladd f1402(sum14[6],carry14[3],sum9[6],carry9[3],sum10[1]);
fulladd f1403(sum14[7],carry14[4],sum9[7],carry9[4],sum10[2]);
fulladd f1404(sum14[8],carry14[5],sum9[8],carry9[5],sum10[3]);
fulladd f1405(sum14[9],carry14[6],sum9[9],carry9[6],sum10[4]);
fulladd f1406(sum14[10],carry14[7],sum9[10],carry9[7],sum10[5]);
fulladd f1407(sum14[11],carry14[8],sum9[11],carry9[8],sum10[6]);
fulladd f1408(sum14[12],carry14[9],sum9[12],carry9[9],sum10[7]);
fulladd f1409(sum14[13],carry14[10],sum9[13],carry9[10],sum10[8]);
fulladd f1410(sum14[14],carry14[11],sum9[14],carry9[11],sum10[9]);
fulladd f1411(sum14[15],carry14[12],sum9[15],carry9[12],sum10[10]);
fulladd f1412(sum14[16],carry14[13],sum9[16],carry9[13],sum10[11]);
fulladd f1413(sum14[17],carry14[14],sum9[17],carry9[14],sum10[12]);
fulladd f1414(sum14[18],carry14[15],sum9[18],carry9[15],sum10[13]);
fulladd f1415(sum14[19],carry14[16],sum9[19],carry9[16],sum10[14]);
fulladd f1416(sum14[20],carry14[17],sum9[20],carry9[17],sum10[15]);
fulladd f1417(sum14[21],carry14[18],sum9[21],carry9[18],sum10[16]);
fulladd f1418(sum14[22],carry14[19],sum9[22],carry9[19],sum10[17]);
fulladd f1419(sum14[23],carry14[20],sum9[23],carry9[20],sum10[18]);
fulladd f1420(sum14[24],carry14[21],sum9[24],carry9[21],sum10[19]);
fulladd f1421(sum14[25],carry14[22],sum9[25],carry9[22],sum10[20]);
fulladd f1422(sum14[26],carry14[23],sum9[26],carry9[23],sum10[21]);
halfadd h143(sum14[27],carry14[24],sum9[27],sum10[22]);
halfadd h144(sum14[28],carry14[25],sum9[28],sum10[23]);
assign sum14[31:29]=sum10[26:24];

//csa 15

assign sum15[1:0]=carry10[1:0];
halfadd h151(sum15[2],carry15[0],carry10[2],sum11[0]);
halfadd h152(sum15[3],carry15[1],carry10[3],sum11[1]);
halfadd h153(sum15[4],carry15[2],carry10[4],sum11[2]);
fulladd f1501(sum15[5],carry15[3],carry10[5],sum11[3],carry11[0]);
fulladd f1502(sum15[6],carry15[4],carry10[6],sum11[4],carry11[1]);
fulladd f1503(sum15[7],carry15[5],carry10[7],sum11[5],carry11[2]);
fulladd f1504(sum15[8],carry15[6],carry10[8],sum11[6],carry11[3]);
fulladd f1505(sum15[9],carry15[7],carry10[9],sum11[7],carry11[4]);
fulladd f1506(sum15[10],carry15[8],carry10[10],sum11[8],carry11[5]);
fulladd f1507(sum15[11],carry15[9],carry10[11],sum11[9],carry11[6]);
fulladd f1508(sum15[12],carry15[10],carry10[12],sum11[10],carry11[7]);
fulladd f1509(sum15[13],carry15[11],carry10[13],sum11[11],carry11[8]);
fulladd f1510(sum15[14],carry15[12],carry10[14],sum11[12],carry11[9]);
fulladd f1511(sum15[15],carry15[13],carry10[15],sum11[13],carry11[10]);
fulladd f1512(sum15[16],carry15[14],carry10[16],sum11[14],carry11[11]);
fulladd f1513(sum15[17],carry15[15],carry10[17],sum11[15],carry11[12]);
fulladd f1514(sum15[18],carry15[16],carry10[18],sum11[16],carry11[13]);
fulladd f1515(sum15[19],carry15[17],carry10[19],sum11[17],carry11[14]);
fulladd f1516(sum15[20],carry15[18],carry10[20],sum11[18],carry11[15]);
fulladd f1517(sum15[21],carry15[19],carry10[21],sum11[19],carry11[16]);
fulladd f1518(sum15[22],carry15[20],carry10[22],sum11[20],carry11[17]);
fulladd f1519(sum15[23],carry15[21],carry10[23],sum11[21],carry11[18]);
fulladd f1520(sum15[24],carry15[22],carry10[24],sum11[22],carry11[19]);
fulladd f1521(sum15[25],carry15[23],carry10[25],sum11[23],carry11[20]);
halfadd h154(sum15[26],carry15[24],sum11[24],carry11[21]);
halfadd h155(sum15[27],carry15[25],sum11[25],carry11[22]);
halfadd h156(sum15[28],carry15[26],sum11[26],carry11[23]);
assign sum15[30:29]=sum11[28:27];

//csa 16

assign sum16[1:0]=sum12[1:0];
halfadd h161(sum16[2],carry16[0],sum12[2],carry12[0]);
halfadd h162(sum16[3],carry16[1],sum12[3],carry12[1]);
fulladd f1601(sum16[4],carry16[2],sum12[4],carry12[2],sum13[0]);
fulladd f1602(sum16[5],carry16[3],sum12[5],carry12[3],sum13[1]);
fulladd f1603(sum16[6],carry16[4],sum12[6],carry12[4],sum13[2]);
fulladd f1604(sum16[7],carry16[5],sum12[7],carry12[5],sum13[3]);
fulladd f1605(sum16[8],carry16[6],sum12[8],carry12[6],sum13[4]);
fulladd f1606(sum16[9],carry16[7],sum12[9],carry12[7],sum13[5]);
fulladd f1607(sum16[10],carry16[8],sum12[10],carry12[8],sum13[6]);
fulladd f1608(sum16[11],carry16[9],sum12[11],carry12[9],sum13[7]);
fulladd f1609(sum16[12],carry16[10],sum12[12],carry12[10],sum13[8]);
fulladd f1610(sum16[13],carry16[11],sum12[13],carry12[11],sum13[9]);
fulladd f1611(sum16[14],carry16[12],sum12[14],carry12[12],sum13[10]);
fulladd f1612(sum16[15],carry16[13],sum12[15],carry12[13],sum13[11]);
fulladd f1613(sum16[16],carry16[14],sum12[16],carry12[14],sum13[12]);
fulladd f1614(sum16[17],carry16[15],sum12[17],carry12[15],sum13[13]);
fulladd f1615(sum16[18],carry16[16],sum12[18],carry12[16],sum13[14]);
fulladd f1616(sum16[19],carry16[17],sum12[19],carry12[17],sum13[15]);
fulladd f1617(sum16[20],carry16[18],sum12[20],carry12[18],sum13[16]);
fulladd f1618(sum16[21],carry16[19],sum12[21],carry12[19],sum13[17]);
fulladd f1619(sum16[22],carry16[20],sum12[22],carry12[20],sum13[18]);
fulladd f1620(sum16[23],carry16[21],sum12[23],carry12[21],sum13[19]);
fulladd f1621(sum16[24],carry16[22],sum12[24],carry12[22],sum13[20]);
fulladd f1622(sum16[25],carry16[23],sum12[25],carry12[23],sum13[21]);
fulladd f1623(sum16[26],carry16[24],sum12[26],carry12[24],sum13[22]);
halfadd h163(sum16[27],carry16[25],carry12[25],sum13[23]);
assign sum16[32:28]=sum13[28:24];

//csa 18

assign sum18[3:0]=sum14[3:0];
halfadd h181(sum18[4],carry18[0],sum14[4],carry14[0]);
halfadd h182(sum18[5],carry18[1],sum14[5],carry14[1]);
halfadd h183(sum18[6],carry18[2],sum14[6],carry14[2]);
fulladd f1801(sum18[7],carry18[3],sum14[7],carry14[3],sum15[0]);
fulladd f1802(sum18[8],carry18[4],sum14[8],carry14[4],sum15[1]);
fulladd f1803(sum18[9],carry18[5],sum14[9],carry14[5],sum15[2]);
fulladd f1804(sum18[10],carry18[6],sum14[10],carry14[6],sum15[3]);
fulladd f1805(sum18[11],carry18[7],sum14[11],carry14[7],sum15[4]);
fulladd f1806(sum18[12],carry18[8],sum14[12],carry14[8],sum15[5]);
fulladd f1807(sum18[13],carry18[9],sum14[13],carry14[9],sum15[6]);
fulladd f1808(sum18[14],carry18[10],sum14[14],carry14[10],sum15[7]);
fulladd f1809(sum18[15],carry18[11],sum14[15],carry14[11],sum15[8]);
fulladd f1810(sum18[16],carry18[12],sum14[16],carry14[12],sum15[9]);
fulladd f1811(sum18[17],carry18[13],sum14[17],carry14[13],sum15[10]);
fulladd f1812(sum18[18],carry18[14],sum14[18],carry14[14],sum15[11]);
fulladd f1813(sum18[19],carry18[15],sum14[19],carry14[15],sum15[12]);
fulladd f1814(sum18[20],carry18[16],sum14[20],carry14[16],sum15[13]);
fulladd f1815(sum18[21],carry18[17],sum14[21],carry14[17],sum15[14]);
fulladd f1816(sum18[22],carry18[18],sum14[22],carry14[18],sum15[15]);
fulladd f1817(sum18[23],carry18[19],sum14[23],carry14[19],sum15[16]);
fulladd f1818(sum18[24],carry18[20],sum14[24],carry14[20],sum15[17]);
fulladd f1819(sum18[25],carry18[21],sum14[25],carry14[21],sum15[18]);
fulladd f1820(sum18[26],carry18[22],sum14[26],carry14[22],sum15[19]);
fulladd f1821(sum18[27],carry18[23],sum14[27],carry14[23],sum15[20]);
fulladd f1822(sum18[28],carry18[24],sum14[28],carry14[24],sum15[21]);
fulladd f1823(sum18[29],carry18[25],sum14[29],carry14[25],sum15[22]);
halfadd h184(sum18[30],carry18[26],sum14[30],sum15[23]);
halfadd h185(sum18[31],carry18[27],sum14[31],sum15[24]);
assign sum18[37:32]=sum15[30:25];

//csa 19

assign sum19[3:0]=carry15[3:0];
halfadd h191(sum19[4],carry19[0],carry15[4],sum16[0]);
halfadd h192(sum19[5],carry19[1],carry15[5],sum16[1]);
halfadd h193(sum19[6],carry19[2],carry15[6],sum16[2]);
fulladd f1901(sum19[7],carry19[3],carry15[7],sum16[3],carry16[0]);
fulladd f1902(sum19[8],carry19[4],carry15[8],sum16[4],carry16[1]);
fulladd f1903(sum19[9],carry19[5],carry15[9],sum16[5],carry16[2]);
fulladd f1904(sum19[10],carry19[6],carry15[10],sum16[6],carry16[3]);
fulladd f1905(sum19[11],carry19[7],carry15[11],sum16[7],carry16[4]);
fulladd f1906(sum19[12],carry19[8],carry15[12],sum16[8],carry16[5]);
fulladd f1907(sum19[13],carry19[9],carry15[13],sum16[9],carry16[6]);
fulladd f1908(sum19[14],carry19[10],carry15[14],sum16[10],carry16[7]);
fulladd f1909(sum19[15],carry19[11],carry15[15],sum16[11],carry16[8]);
fulladd f1910(sum19[16],carry19[12],carry15[16],sum16[12],carry16[9]);
fulladd f1911(sum19[17],carry19[13],carry15[17],sum16[13],carry16[10]);
fulladd f1912(sum19[18],carry19[14],carry15[18],sum16[14],carry16[11]);
fulladd f1913(sum19[19],carry19[15],carry15[19],sum16[15],carry16[12]);
fulladd f1914(sum19[20],carry19[16],carry15[20],sum16[16],carry16[13]);
fulladd f1915(sum19[21],carry19[17],carry15[21],sum16[17],carry16[14]);
fulladd f1916(sum19[22],carry19[18],carry15[22],sum16[18],carry16[15]);
fulladd f1917(sum19[23],carry19[19],carry15[23],sum16[19],carry16[16]);
fulladd f1918(sum19[24],carry19[20],carry15[24],sum16[20],carry16[17]);
fulladd f1919(sum19[25],carry19[21],carry15[25],sum16[21],carry16[18]);
fulladd f1920(sum19[26],carry19[22],carry15[26],sum16[22],carry16[19]);
halfadd h194(sum19[27],carry19[23],sum16[23],carry16[20]);
halfadd h195(sum19[28],carry19[24],sum16[24],carry16[21]);
halfadd h196(sum19[29],carry19[25],sum16[25],carry16[22]);
halfadd h197(sum19[30],carry19[26],sum16[26],carry16[23]);
halfadd h198(sum19[31],carry19[27],sum16[27],carry16[24]);
halfadd h199(sum19[32],carry19[28],sum16[28],carry16[25]);
assign sum19[36:33]=sum16[32:29];

//csa 20

assign sum20[4:0]=sum18[4:0];
halfadd h201(sum20[5],carry20[0],sum18[5],carry18[0]);
halfadd h202(sum20[6],carry20[1],sum18[6],carry18[1]);
halfadd h203(sum20[7],carry20[2],sum18[7],carry18[2]);
halfadd h204(sum20[8],carry20[3],sum18[8],carry18[3]);
halfadd h205(sum20[9],carry20[4],sum18[9],carry18[4]);
fulladd f2001(sum20[10],carry20[5],sum18[10],carry18[5],sum19[0]);
fulladd f2002(sum20[11],carry20[6],sum18[11],carry18[6],sum19[1]);
fulladd f2003(sum20[12],carry20[7],sum18[12],carry18[7],sum19[2]);
fulladd f2004(sum20[13],carry20[8],sum18[13],carry18[8],sum19[3]);
fulladd f2005(sum20[14],carry20[9],sum18[14],carry18[9],sum19[4]);
fulladd f2006(sum20[15],carry20[10],sum18[15],carry18[10],sum19[5]);
fulladd f2007(sum20[16],carry20[11],sum18[16],carry18[11],sum19[6]);
fulladd f2008(sum20[17],carry20[12],sum18[17],carry18[12],sum19[7]);
fulladd f2009(sum20[18],carry20[13],sum18[18],carry18[13],sum19[8]);
fulladd f2010(sum20[19],carry20[14],sum18[19],carry18[14],sum19[9]);
fulladd f2011(sum20[20],carry20[15],sum18[20],carry18[15],sum19[10]);
fulladd f2012(sum20[21],carry20[16],sum18[21],carry18[16],sum19[11]);
fulladd f2013(sum20[22],carry20[17],sum18[22],carry18[17],sum19[12]);
fulladd f2014(sum20[23],carry20[18],sum18[23],carry18[18],sum19[13]);
fulladd f2015(sum20[24],carry20[19],sum18[24],carry18[19],sum19[14]);
fulladd f2016(sum20[25],carry20[20],sum18[25],carry18[20],sum19[15]);
fulladd f2017(sum20[26],carry20[21],sum18[26],carry18[21],sum19[16]);
fulladd f2018(sum20[27],carry20[22],sum18[27],carry18[22],sum19[17]);
fulladd f2019(sum20[28],carry20[23],sum18[28],carry18[23],sum19[18]);
fulladd f2020(sum20[29],carry20[24],sum18[29],carry18[24],sum19[19]);
fulladd f2021(sum20[30],carry20[25],sum18[30],carry18[25],sum19[20]);
fulladd f2022(sum20[31],carry20[26],sum18[31],carry18[26],sum19[21]);
fulladd f2023(sum20[32],carry20[27],sum18[32],carry18[27],sum19[22]);
halfadd h2026(sum20[33],carry20[28],sum18[33],sum19[23]);
halfadd h207(sum20[34],carry20[29],sum18[34],sum19[24]);
halfadd h208(sum20[35],carry20[30],sum18[35],sum19[25]);
halfadd h209(sum20[36],carry20[31],sum18[36],sum19[26]);
halfadd h2010(sum20[37],carry20[32],sum18[37],sum19[27]);
assign sum20[46:38]=sum19[36:28];

//csa 21

assign sum21[5:0]=carry19[5:0];
halfadd h211(sum21[6],carry21[0],carry19[6],carry13[0]);
halfadd h212(sum21[7],carry21[1],carry19[7],carry13[1]);
fulladd f2101(sum21[8],carry21[2],carry19[8],carry13[2],carry8[0]);
fulladd f2102(sum21[9],carry21[3],carry19[9],carry13[3],carry8[1]);
fulladd f2103(sum21[10],carry21[4],carry19[10],carry13[4],carry8[2]);
fulladd f2104(sum21[11],carry21[5],carry19[11],carry13[5],carry8[3]);
fulladd f2105(sum21[12],carry21[6],carry19[12],carry13[6],carry8[4]);
fulladd f2106(sum21[13],carry21[7],carry19[13],carry13[7],carry8[5]);
fulladd f2107(sum21[14],carry21[8],carry19[14],carry13[8],carry8[6]);
fulladd f2108(sum21[15],carry21[9],carry19[15],carry13[9],carry8[7]);
fulladd f2109(sum21[16],carry21[10],carry19[16],carry13[10],carry8[8]);
fulladd f2110(sum21[17],carry21[11],carry19[17],carry13[11],carry8[9]);
fulladd f2111(sum21[18],carry21[12],carry19[18],carry13[12],carry8[10]);
fulladd f2112(sum21[19],carry21[13],carry19[19],carry13[13],carry8[11]);
fulladd f2113(sum21[20],carry21[14],carry19[20],carry13[14],carry8[12]);
fulladd f2114(sum21[21],carry21[15],carry19[21],carry13[15],carry8[13]);
fulladd f2115(sum21[22],carry21[16],carry19[22],carry13[16],carry8[14]);
fulladd f2116(sum21[23],carry21[17],carry19[23],carry13[17],carry8[15]);
fulladd f2117(sum21[24],carry21[18],carry19[24],carry13[18],carry8[16]);
fulladd f2118(sum21[25],carry21[19],carry19[25],carry13[19],carry8[17]);
fulladd f2119(sum21[26],carry21[20],carry19[26],carry13[20],carry8[18]);
fulladd f2120(sum21[27],carry21[21],carry19[27],carry13[21],carry8[19]);
fulladd f2121(sum21[28],carry21[22],carry19[28],carry13[22],carry8[20]);
halfadd h213(sum21[29],carry21[23],carry13[23],carry8[21]);
assign sum21[31:30] = carry8[23:22];


//csa 22

assign sum22[5:0]=sum20[5:0];
halfadd h221(sum22[6],carry22[0],sum20[6],carry20[0]);
halfadd h222(sum22[7],carry22[1],sum20[7],carry20[1]);
halfadd h223(sum22[8],carry22[2],sum20[8],carry20[2]);
halfadd h224(sum22[9],carry22[3],sum20[9],carry20[3]);
halfadd h225(sum22[10],carry22[4],sum20[10],carry20[4]);
halfadd h226(sum22[11],carry22[5],sum20[11],carry20[5]);
halfadd h227(sum22[12],carry22[6],sum20[12],carry20[6]);
halfadd h228(sum22[13],carry22[7],sum20[13],carry20[7]);
halfadd h229(sum22[14],carry22[8],sum20[14],carry20[8]);
fulladd f2201(sum22[15],carry22[9],sum20[15],carry20[9],sum21[0]);
fulladd f2202(sum22[16],carry22[10],sum20[16],carry20[10],sum21[1]);
fulladd f2203(sum22[17],carry22[11],sum20[17],carry20[11],sum21[2]);
fulladd f2204(sum22[18],carry22[12],sum20[18],carry20[12],sum21[3]);
fulladd f2205(sum22[19],carry22[13],sum20[19],carry20[13],sum21[4]);
fulladd f2206(sum22[20],carry22[14],sum20[20],carry20[14],sum21[5]);
fulladd f2207(sum22[21],carry22[15],sum20[21],carry20[15],sum21[6]);
fulladd f2208(sum22[22],carry22[16],sum20[22],carry20[16],sum21[7]);
fulladd f2209(sum22[23],carry22[17],sum20[23],carry20[17],sum21[8]);
fulladd f2210(sum22[24],carry22[18],sum20[24],carry20[18],sum21[9]);
fulladd f2211(sum22[25],carry22[19],sum20[25],carry20[19],sum21[10]);
fulladd f2212(sum22[26],carry22[20],sum20[26],carry20[20],sum21[11]);
fulladd f2213(sum22[27],carry22[21],sum20[27],carry20[21],sum21[12]);
fulladd f2214(sum22[28],carry22[22],sum20[28],carry20[22],sum21[13]);
fulladd f2215(sum22[29],carry22[23],sum20[29],carry20[23],sum21[14]);
fulladd f2216(sum22[30],carry22[24],sum20[30],carry20[24],sum21[15]);
fulladd f2217(sum22[31],carry22[25],sum20[31],carry20[25],sum21[16]);
fulladd f2218(sum22[32],carry22[26],sum20[32],carry20[26],sum21[17]);
fulladd f2219(sum22[33],carry22[27],sum20[33],carry20[27],sum21[18]);
fulladd f2220(sum22[34],carry22[28],sum20[34],carry20[28],sum21[19]);
fulladd f2221(sum22[35],carry22[29],sum20[35],carry20[29],sum21[20]);
fulladd f2222(sum22[36],carry22[30],sum20[36],carry20[30],sum21[21]);
fulladd f2223(sum22[37],carry22[31],sum20[37],carry20[31],sum21[22]);
fulladd f2224(sum22[38],carry22[32],sum20[38],carry20[32],sum21[23]);
halfadd h2210(sum22[39],carry22[33],sum20[39],sum21[24]);
halfadd h2211(sum22[40],carry22[34],sum20[40],sum21[25]);
halfadd h2212(sum22[41],carry22[35],sum20[41],sum21[26]);
halfadd h2213(sum22[42],carry22[36],sum20[42],sum21[27]);
halfadd h2214(sum22[43],carry22[37],sum20[43],sum21[28]);
halfadd h2215(sum22[44],carry22[38],sum20[44],sum21[29]);
halfadd h2216(sum22[45],carry22[39],sum20[45],sum21[30]);
halfadd h2217(sum22[46],carry22[40],sum20[46],sum21[31]);

//csa 23

assign sum23[6:0]=sum22[6:0];
halfadd h231(sum23[7],carry23[0],sum22[7],carry22[0]);
halfadd h232(sum23[8],carry23[1],sum22[8],carry22[1]);
halfadd h233(sum23[9],carry23[2],sum22[9],carry22[2]);
halfadd h234(sum23[10],carry23[3],sum22[10],carry22[3]);
halfadd h235(sum23[11],carry23[4],sum22[11],carry22[4]);
halfadd h236(sum23[12],carry23[5],sum22[12],carry22[5]);
halfadd h237(sum23[13],carry23[6],sum22[13],carry22[6]);
halfadd h238(sum23[14],carry23[7],sum22[14],carry22[7]);
halfadd h239(sum23[15],carry23[8],sum22[15],carry22[8]);
halfadd h2310(sum23[16],carry23[9],sum22[16],carry22[9]);
halfadd h2311(sum23[17],carry23[10],sum22[17],carry22[10]);
halfadd h2312(sum23[18],carry23[11],sum22[18],carry22[11]);
halfadd h2313(sum23[19],carry23[12],sum22[19],carry22[12]);
halfadd h2314(sum23[20],carry23[13],sum22[20],carry22[13]);
halfadd h2315(sum23[21],carry23[14],sum22[21],carry22[14]);
fulladd f2301(sum23[22],carry23[15],sum22[22],carry22[15],carry21[0]);
fulladd f2302(sum23[23],carry23[16],sum22[23],carry22[16],carry21[1]);
fulladd f2303(sum23[24],carry23[17],sum22[24],carry22[17],carry21[2]);
fulladd f2304(sum23[25],carry23[18],sum22[25],carry22[18],carry21[3]);
fulladd f2305(sum23[26],carry23[19],sum22[26],carry22[19],carry21[4]);
fulladd f2306(sum23[27],carry23[20],sum22[27],carry22[20],carry21[5]);
fulladd f2307(sum23[28],carry23[21],sum22[28],carry22[21],carry21[6]);
fulladd f2308(sum23[29],carry23[22],sum22[29],carry22[22],carry21[7]);
fulladd f2309(sum23[30],carry23[23],sum22[30],carry22[23],carry21[8]);
fulladd f2310(sum23[31],carry23[24],sum22[31],carry22[24],carry21[9]);
fulladd f2311(sum23[32],carry23[25],sum22[32],carry22[25],carry21[10]);
fulladd f2312(sum23[33],carry23[26],sum22[33],carry22[26],carry21[11]);
fulladd f2313(sum23[34],carry23[27],sum22[34],carry22[27],carry21[12]);
fulladd f2314(sum23[35],carry23[28],sum22[35],carry22[28],carry21[13]);
fulladd f2315(sum23[36],carry23[29],sum22[36],carry22[29],carry21[14]);
fulladd f2316(sum23[37],carry23[30],sum22[37],carry22[30],carry21[15]);
fulladd f2317(sum23[38],carry23[31],sum22[38],carry22[31],carry21[16]);
fulladd f2318(sum23[39],carry23[32],sum22[39],carry22[32],carry21[17]);
fulladd f2319(sum23[40],carry23[33],sum22[40],carry22[33],carry21[18]);
fulladd f2320(sum23[41],carry23[34],sum22[41],carry22[34],carry21[19]);
fulladd f2321(sum23[42],carry23[35],sum22[42],carry22[35],carry21[20]);
fulladd f2322(sum23[43],carry23[36],sum22[43],carry22[36],carry21[21]);
fulladd f2323(sum23[44],carry23[37],sum22[44],carry22[37],carry21[22]);
fulladd f2324(sum23[45],carry23[38],sum22[45],carry22[38],carry21[23]);
halfadd h2316(sum23[46],carry23[39],sum22[46],carry22[39]);
assign sum23[47]  = carry22[40];

//cla 

assign r1[7:0]=sum23[7:0];
//cladder40 ckck40(sum23[47:8],carry23[39:0],r1[47:8],c_in9);
recurse40 ckck40(r1[47:8],c_in19,sum23[47:8],carry23[39:0]);

wire ms1;

assign ms1=as^bs;

wire [7:0] exp,exp1,exp2,exp3;
wire cr1,cr2,cr3,cr4;

recurse8 r81(exp,cr1,ae,8'b10000001);
recurse8 r82(exp1,cr2,exp,be);
recurse8 r83(exp2,cr3,ae,8'b10000010);
recurse8 r84(exp3,cr4,exp2,be);

reg [7:0] me;
reg [23:0] m;
reg ms;

always@(exp1 or exp3 or r1 or a or b or ms1)
	begin
		if(r1[47]==1'b1 && a!=24'b000 && b!=24'b0000)
			begin
				m[23:0]=r1[47:24];
				me[7:0]=exp3;
				ms=ms1;
			end
		else if(r1[47]==1'b0 && a!=24'b000 && b!=24'b0000)
			begin
				m[23:0]=r1[46:23];
				me[7:0]=exp1;
				ms=ms1;
			end
		else if (a==24'b0000 || b==24'b00000)
			begin
			   m[23:0]=24'b000;
			   me[7:0]=8'b0000;
			   ms=1'b0;
		   end
	end

endmodule



//48 bit recursive doubling technique

//`include "kgp.v"
//`include "kgp_carry.v"
//`include "recursive_stage1.v"

module recurse8(sum,carry,a,b); 

output [7:0] sum;
output  carry;
input [7:0] a,b;

wire [17:0] x;

assign x[1:0]=2'b00;  // kgp generation

kgp a00(a[0],b[0],x[3:2]);
kgp a01(a[1],b[1],x[5:4]);
kgp a02(a[2],b[2],x[7:6]);
kgp a03(a[3],b[3],x[9:8]);
kgp a04(a[4],b[4],x[11:10]);
kgp a05(a[5],b[5],x[13:12]);
kgp a06(a[6],b[6],x[15:14]);
kgp a07(a[7],b[7],x[17:16]);

wire [15:0] x1;  //recursive doubling stage 1
assign x1[1:0]=x[1:0];

recursive_stage1 s00(x[1:0],x[3:2],x1[3:2]);
recursive_stage1 s01(x[3:2],x[5:4],x1[5:4]);
recursive_stage1 s02(x[5:4],x[7:6],x1[7:6]);
recursive_stage1 s03(x[7:6],x[9:8],x1[9:8]);
recursive_stage1 s04(x[9:8],x[11:10],x1[11:10]);
recursive_stage1 s05(x[11:10],x[13:12],x1[13:12]);
recursive_stage1 s06(x[13:12],x[15:14],x1[15:14]);

wire [15:0] x2;  //recursive doubling stage2
assign x2[3:0]=x1[3:0];

recursive_stage1 s101(x1[1:0],x1[5:4],x2[5:4]);
recursive_stage1 s102(x1[3:2],x1[7:6],x2[7:6]);
recursive_stage1 s103(x1[5:4],x1[9:8],x2[9:8]);
recursive_stage1 s104(x1[7:6],x1[11:10],x2[11:10]);
recursive_stage1 s105(x1[9:8],x1[13:12],x2[13:12]);
recursive_stage1 s106(x1[11:10],x1[15:14],x2[15:14]);

wire [15:0] x3;  //recursive doubling stage3
assign x3[7:0]=x2[7:0];

recursive_stage1 s203(x2[1:0],x2[9:8],x3[9:8]);
recursive_stage1 s204(x2[3:2],x2[11:10],x3[11:10]);
recursive_stage1 s205(x2[5:4],x2[13:12],x3[13:12]);
recursive_stage1 s206(x2[7:6],x2[15:14],x3[15:14]);

// final sum and carry

assign sum[0]=a[0]^b[0]^x3[0];
assign sum[1]=a[1]^b[1]^x3[2];
assign sum[2]=a[2]^b[2]^x3[4];
assign sum[3]=a[3]^b[3]^x3[6];
assign sum[4]=a[4]^b[4]^x3[8];
assign sum[5]=a[5]^b[5]^x3[10];
assign sum[6]=a[6]^b[6]^x3[12];
assign sum[7]=a[7]^b[7]^x3[14];

kgp_carry kkc(x[17:16],x3[15:14],carry);

endmodule


//32 bit recursive doubling technique

/*`include "kgp.v"
`include "kgp_carry.v"
`include "recursive_stage1.v"*/

module recurse(sum,carry,a,b); 

output [31:0] sum;
output  carry;
input [31:0] a,b;

wire [65:0] x;

assign x[1:0]=2'b00;  // kgp generation

//assign {x[3:2]}=(a[0]==b[0])?((a[0]==1'b1)?2'b11:2'b00):2'b01;
//assign {x[5:4]}=(a[1]==b[1])?((a[1]==1'b1)?2'b11:2'b00):2'b01;
//assign {x[7:6]}=(a[2]==b[2])?((a[2]==1'b1)?2'b11:2'b00):2'b01;
//assign {x[9:8]}=(a[3]==b[3])?((a[3]==1'b1)?2'b11:2'b00):2'b01;
//assign {x[11:10]}=(a[4]==b[4])?((a[4]==1'b1)?2'b11:2'b00):2'b01;
//assign {x[13:12]}=(a[5]==b[5])?((a[5]==1'b1)?2'b11:2'b00):2'b01;
//assign {x[15:14]}=(a[6]==b[6])?((a[6]==1'b1)?2'b11:2'b00):2'b01;
//assign {x[17:16]}=(a[7]==b[7])?((a[7]==1'b1)?2'b11:2'b00):2'b01;
//assign {x[19:18]}=(a[8]==b[8])?((a[8]==1'b1)?2'b11:2'b00):2'b01;
//assign {x[21:20]}=(a[9]==b[9])?((a[9]==1'b1)?2'b11:2'b00):2'b01;
//assign {x[23:22]}=(a[10]==b[10])?((a[10]==1'b1)?2'b11:2'b00):2'b01;
//assign {x[25:24]}=(a[11]==b[11])?((a[11]==1'b1)?2'b11:2'b00):2'b01;
//assign {x[27:26]}=(a[12]==b[12])?((a[12]==1'b1)?2'b11:2'b00):2'b01;
//assign {x[29:28]}=(a[13]==b[13])?((a[13]==1'b1)?2'b11:2'b00):2'b01;
//assign {x[31:30]}=(a[14]==b[14])?((a[14]==1'b1)?2'b11:2'b00):2'b01;
//assign {x[33:32]}=(a[15]==b[15])?((a[15]==1'b1)?2'b11:2'b00):2'b01;
//assign {x[35:34]}=(a[16]==b[16])?((a[16]==1'b1)?2'b11:2'b00):2'b01;
//assign {x[37:36]}=(a[17]==b[17])?((a[17]==1'b1)?2'b11:2'b00):2'b01;
//assign {x[39:38]}=(a[18]==b[18])?((a[18]==1'b1)?2'b11:2'b00):2'b01;
//assign {x[41:40]}=(a[19]==b[19])?((a[19]==1'b1)?2'b11:2'b00):2'b01;
//assign {x[43:42]}=(a[20]==b[20])?((a[20]==1'b1)?2'b11:2'b00):2'b01;
//assign {x[45:44]}=(a[21]==b[21])?((a[21]==1'b1)?2'b11:2'b00):2'b01;
//assign {x[47:46]}=(a[22]==b[22])?((a[22]==1'b1)?2'b11:2'b00):2'b01;
//assign {x[49:48]}=(a[23]==b[23])?((a[23]==1'b1)?2'b11:2'b00):2'b01;
//assign {x[51:50]}=(a[24]==b[24])?((a[24]==1'b1)?2'b11:2'b00):2'b01;
//assign {x[53:52]}=(a[25]==b[25])?((a[25]==1'b1)?2'b11:2'b00):2'b01;
//assign {x[55:54]}=(a[26]==b[26])?((a[26]==1'b1)?2'b11:2'b00):2'b01;
//assign {x[57:56]}=(a[27]==b[27])?((a[27]==1'b1)?2'b11:2'b00):2'b01;
//assign {x[59:58]}=(a[28]==b[28])?((a[28]==1'b1)?2'b11:2'b00):2'b01;
//assign {x[61:60]}=(a[29]==b[29])?((a[29]==1'b1)?2'b11:2'b00):2'b01;
//assign {x[63:62]}=(a[30]==b[30])?((a[30]==1'b1)?2'b11:2'b00):2'b01;
//assign {x[65:64]}=(a[31]==b[31])?((a[31]==1'b1)?2'b11:2'b00):2'b01;

kgp a00(a[0],b[0],x[3:2]);
kgp a01(a[1],b[1],x[5:4]);
kgp a02(a[2],b[2],x[7:6]);
kgp a03(a[3],b[3],x[9:8]);
kgp a04(a[4],b[4],x[11:10]);
kgp a05(a[5],b[5],x[13:12]);
kgp a06(a[6],b[6],x[15:14]);
kgp a07(a[7],b[7],x[17:16]);
kgp a08(a[8],b[8],x[19:18]);
kgp a09(a[9],b[9],x[21:20]);
kgp a10(a[10],b[10],x[23:22]);
kgp a11(a[11],b[11],x[25:24]);
kgp a12(a[12],b[12],x[27:26]);
kgp a13(a[13],b[13],x[29:28]);
kgp a14(a[14],b[14],x[31:30]);
kgp a15(a[15],b[15],x[33:32]);
kgp a16(a[16],b[16],x[35:34]);
kgp a17(a[17],b[17],x[37:36]);
kgp a18(a[18],b[18],x[39:38]);
kgp a19(a[19],b[19],x[41:40]);
kgp a20(a[20],b[20],x[43:42]);
kgp a21(a[21],b[21],x[45:44]);
kgp a22(a[22],b[22],x[47:46]);
kgp a23(a[23],b[23],x[49:48]);
kgp a24(a[24],b[24],x[51:50]);
kgp a25(a[25],b[25],x[53:52]);
kgp a26(a[26],b[26],x[55:54]);
kgp a27(a[27],b[27],x[57:56]);
kgp a28(a[28],b[28],x[59:58]);
kgp a29(a[29],b[29],x[61:60]);
kgp a30(a[30],b[30],x[63:62]);
kgp a31(a[31],b[31],x[65:64]);

wire [63:0] x1;  //recursive doubling stage 1
assign x1[1:0]=x[1:0];

recursive_stage1 s00(x[1:0],x[3:2],x1[3:2]);
recursive_stage1 s01(x[3:2],x[5:4],x1[5:4]);
recursive_stage1 s02(x[5:4],x[7:6],x1[7:6]);
recursive_stage1 s03(x[7:6],x[9:8],x1[9:8]);
recursive_stage1 s04(x[9:8],x[11:10],x1[11:10]);
recursive_stage1 s05(x[11:10],x[13:12],x1[13:12]);
recursive_stage1 s06(x[13:12],x[15:14],x1[15:14]);
recursive_stage1 s07(x[15:14],x[17:16],x1[17:16]);
recursive_stage1 s08(x[17:16],x[19:18],x1[19:18]);
recursive_stage1 s09(x[19:18],x[21:20],x1[21:20]);
recursive_stage1 s10(x[21:20],x[23:22],x1[23:22]);
recursive_stage1 s11(x[23:22],x[25:24],x1[25:24]);
recursive_stage1 s12(x[25:24],x[27:26],x1[27:26]);
recursive_stage1 s13(x[27:26],x[29:28],x1[29:28]);
recursive_stage1 s14(x[29:28],x[31:30],x1[31:30]);
recursive_stage1 s15(x[31:30],x[33:32],x1[33:32]);
recursive_stage1 s16(x[33:32],x[35:34],x1[35:34]);
recursive_stage1 s17(x[35:34],x[37:36],x1[37:36]);
recursive_stage1 s18(x[37:36],x[39:38],x1[39:38]);
recursive_stage1 s19(x[39:38],x[41:40],x1[41:40]);
recursive_stage1 s20(x[41:40],x[43:42],x1[43:42]);
recursive_stage1 s21(x[43:42],x[45:44],x1[45:44]);
recursive_stage1 s22(x[45:44],x[47:46],x1[47:46]);
recursive_stage1 s23(x[47:46],x[49:48],x1[49:48]);
recursive_stage1 s24(x[49:48],x[51:50],x1[51:50]);
recursive_stage1 s25(x[51:50],x[53:52],x1[53:52]);
recursive_stage1 s26(x[53:52],x[55:54],x1[55:54]);
recursive_stage1 s27(x[55:54],x[57:56],x1[57:56]);
recursive_stage1 s28(x[57:56],x[59:58],x1[59:58]);
recursive_stage1 s29(x[59:58],x[61:60],x1[61:60]);
recursive_stage1 s30(x[61:60],x[63:62],x1[63:62]);

wire [63:0] x2;  //recursive doubling stage2
assign x2[3:0]=x1[3:0];

recursive_stage1 s101(x1[1:0],x1[5:4],x2[5:4]);
recursive_stage1 s102(x1[3:2],x1[7:6],x2[7:6]);
recursive_stage1 s103(x1[5:4],x1[9:8],x2[9:8]);
recursive_stage1 s104(x1[7:6],x1[11:10],x2[11:10]);
recursive_stage1 s105(x1[9:8],x1[13:12],x2[13:12]);
recursive_stage1 s106(x1[11:10],x1[15:14],x2[15:14]);
recursive_stage1 s107(x1[13:12],x1[17:16],x2[17:16]);
recursive_stage1 s108(x1[15:14],x1[19:18],x2[19:18]);
recursive_stage1 s109(x1[17:16],x1[21:20],x2[21:20]);
recursive_stage1 s110(x1[19:18],x1[23:22],x2[23:22]);
recursive_stage1 s111(x1[21:20],x1[25:24],x2[25:24]);
recursive_stage1 s112(x1[23:22],x1[27:26],x2[27:26]);
recursive_stage1 s113(x1[25:24],x1[29:28],x2[29:28]);
recursive_stage1 s114(x1[27:26],x1[31:30],x2[31:30]);
recursive_stage1 s115(x1[29:28],x1[33:32],x2[33:32]);
recursive_stage1 s116(x1[31:30],x1[35:34],x2[35:34]);
recursive_stage1 s117(x1[33:32],x1[37:36],x2[37:36]);
recursive_stage1 s118(x1[35:34],x1[39:38],x2[39:38]);
recursive_stage1 s119(x1[37:36],x1[41:40],x2[41:40]);
recursive_stage1 s120(x1[39:38],x1[43:42],x2[43:42]);
recursive_stage1 s121(x1[41:40],x1[45:44],x2[45:44]);
recursive_stage1 s122(x1[43:42],x1[47:46],x2[47:46]);
recursive_stage1 s123(x1[45:44],x1[49:48],x2[49:48]);
recursive_stage1 s124(x1[47:46],x1[51:50],x2[51:50]);
recursive_stage1 s125(x1[49:48],x1[53:52],x2[53:52]);
recursive_stage1 s126(x1[51:50],x1[55:54],x2[55:54]);
recursive_stage1 s127(x1[53:52],x1[57:56],x2[57:56]);
recursive_stage1 s128(x1[55:54],x1[59:58],x2[59:58]);
recursive_stage1 s129(x1[57:56],x1[61:60],x2[61:60]);
recursive_stage1 s130(x1[59:58],x1[63:62],x2[63:62]);

wire [63:0] x3;  //recursive doubling stage3
assign x3[7:0]=x2[7:0];

recursive_stage1 s203(x2[1:0],x2[9:8],x3[9:8]);
recursive_stage1 s204(x2[3:2],x2[11:10],x3[11:10]);
recursive_stage1 s205(x2[5:4],x2[13:12],x3[13:12]);
recursive_stage1 s206(x2[7:6],x2[15:14],x3[15:14]);
recursive_stage1 s207(x2[9:8],x2[17:16],x3[17:16]);
recursive_stage1 s208(x2[11:10],x2[19:18],x3[19:18]);
recursive_stage1 s209(x2[13:12],x2[21:20],x3[21:20]);
recursive_stage1 s210(x2[15:14],x2[23:22],x3[23:22]);
recursive_stage1 s211(x2[17:16],x2[25:24],x3[25:24]);
recursive_stage1 s212(x2[19:18],x2[27:26],x3[27:26]);
recursive_stage1 s213(x2[21:20],x2[29:28],x3[29:28]);
recursive_stage1 s214(x2[23:22],x2[31:30],x3[31:30]);
recursive_stage1 s215(x2[25:24],x2[33:32],x3[33:32]);
recursive_stage1 s216(x2[27:26],x2[35:34],x3[35:34]);
recursive_stage1 s217(x2[29:28],x2[37:36],x3[37:36]);
recursive_stage1 s218(x2[31:30],x2[39:38],x3[39:38]);
recursive_stage1 s219(x2[33:32],x2[41:40],x3[41:40]);
recursive_stage1 s220(x2[35:34],x2[43:42],x3[43:42]);
recursive_stage1 s221(x2[37:36],x2[45:44],x3[45:44]);
recursive_stage1 s222(x2[39:38],x2[47:46],x3[47:46]);
recursive_stage1 s223(x2[41:40],x2[49:48],x3[49:48]);
recursive_stage1 s224(x2[43:42],x2[51:50],x3[51:50]);
recursive_stage1 s225(x2[45:44],x2[53:52],x3[53:52]);
recursive_stage1 s226(x2[47:46],x2[55:54],x3[55:54]);
recursive_stage1 s227(x2[49:48],x2[57:56],x3[57:56]);
recursive_stage1 s228(x2[51:50],x2[59:58],x3[59:58]);
recursive_stage1 s229(x2[53:52],x2[61:60],x3[61:60]);
recursive_stage1 s230(x2[55:54],x2[63:62],x3[63:62]);

wire [63:0] x4;  //recursive doubling stage 4
assign x4[15:0]=x3[15:0];

recursive_stage1 s307(x3[1:0],x3[17:16],x4[17:16]);
recursive_stage1 s308(x3[3:2],x3[19:18],x4[19:18]);
recursive_stage1 s309(x3[5:4],x3[21:20],x4[21:20]);
recursive_stage1 s310(x3[7:6],x3[23:22],x4[23:22]);
recursive_stage1 s311(x3[9:8],x3[25:24],x4[25:24]);
recursive_stage1 s312(x3[11:10],x3[27:26],x4[27:26]);
recursive_stage1 s313(x3[13:12],x3[29:28],x4[29:28]);
recursive_stage1 s314(x3[15:14],x3[31:30],x4[31:30]);
recursive_stage1 s315(x3[17:16],x3[33:32],x4[33:32]);
recursive_stage1 s316(x3[19:18],x3[35:34],x4[35:34]);
recursive_stage1 s317(x3[21:20],x3[37:36],x4[37:36]);
recursive_stage1 s318(x3[23:22],x3[39:38],x4[39:38]);
recursive_stage1 s319(x3[25:24],x3[41:40],x4[41:40]);
recursive_stage1 s320(x3[27:26],x3[43:42],x4[43:42]);
recursive_stage1 s321(x3[29:28],x3[45:44],x4[45:44]);
recursive_stage1 s322(x3[31:30],x3[47:46],x4[47:46]);
recursive_stage1 s323(x3[33:32],x3[49:48],x4[49:48]);
recursive_stage1 s324(x3[35:34],x3[51:50],x4[51:50]);
recursive_stage1 s325(x3[37:36],x3[53:52],x4[53:52]);
recursive_stage1 s326(x3[39:38],x3[55:54],x4[55:54]);
recursive_stage1 s327(x3[41:40],x3[57:56],x4[57:56]);
recursive_stage1 s328(x3[43:42],x3[59:58],x4[59:58]);
recursive_stage1 s329(x3[45:44],x3[61:60],x4[61:60]);
recursive_stage1 s330(x3[47:46],x3[63:62],x4[63:62]);

wire [63:0] x5;  //recursive doubling stage 5
assign x5[31:0]=x4[31:0];

recursive_stage1 s415(x4[1:0],x4[33:32],x5[33:32]);
recursive_stage1 s416(x4[3:2],x4[35:34],x5[35:34]);
recursive_stage1 s417(x4[5:4],x4[37:36],x5[37:36]);
recursive_stage1 s418(x4[7:6],x4[39:38],x5[39:38]);
recursive_stage1 s419(x4[9:8],x4[41:40],x5[41:40]);
recursive_stage1 s420(x4[11:10],x4[43:42],x5[43:42]);
recursive_stage1 s421(x4[13:12],x4[45:44],x5[45:44]);
recursive_stage1 s422(x4[15:14],x4[47:46],x5[47:46]);
recursive_stage1 s423(x4[17:16],x4[49:48],x5[49:48]);
recursive_stage1 s424(x4[19:18],x4[51:50],x5[51:50]);
recursive_stage1 s425(x4[21:20],x4[53:52],x5[53:52]);
recursive_stage1 s426(x4[23:22],x4[55:54],x5[55:54]);
recursive_stage1 s427(x4[25:24],x4[57:56],x5[57:56]);
recursive_stage1 s428(x4[27:26],x4[59:58],x5[59:58]);
recursive_stage1 s429(x4[29:28],x4[61:60],x5[61:60]);
recursive_stage1 s430(x4[31:30],x4[63:62],x5[63:62]);

 // final sum and carry

assign sum[0]=a[0]^b[0]^x5[0];
assign sum[1]=a[1]^b[1]^x5[2];
assign sum[2]=a[2]^b[2]^x5[4];
assign sum[3]=a[3]^b[3]^x5[6];
assign sum[4]=a[4]^b[4]^x5[8];
assign sum[5]=a[5]^b[5]^x5[10];
assign sum[6]=a[6]^b[6]^x5[12];
assign sum[7]=a[7]^b[7]^x5[14];
assign sum[8]=a[8]^b[8]^x5[16];
assign sum[9]=a[9]^b[9]^x5[18];
assign sum[10]=a[10]^b[10]^x5[20];
assign sum[11]=a[11]^b[11]^x5[22];
assign sum[12]=a[12]^b[12]^x5[24];
assign sum[13]=a[13]^b[13]^x5[26];
assign sum[14]=a[14]^b[14]^x5[28];
assign sum[15]=a[15]^b[15]^x5[30];
assign sum[16]=a[16]^b[16]^x5[32];
assign sum[17]=a[17]^b[17]^x5[34];
assign sum[18]=a[18]^b[18]^x5[36];
assign sum[19]=a[19]^b[19]^x5[38];
assign sum[20]=a[20]^b[20]^x5[40];
assign sum[21]=a[21]^b[21]^x5[42];
assign sum[22]=a[22]^b[22]^x5[44];
assign sum[23]=a[23]^b[23]^x5[46];
assign sum[24]=a[24]^b[24]^x5[48];
assign sum[25]=a[25]^b[25]^x5[50];
assign sum[26]=a[26]^b[26]^x5[52];
assign sum[27]=a[27]^b[27]^x5[54];
assign sum[28]=a[28]^b[28]^x5[56];
assign sum[29]=a[29]^b[29]^x5[58];
assign sum[30]=a[30]^b[30]^x5[60];
assign sum[31]=a[31]^b[31]^x5[62];


kgp_carry kkc(x[65:64],x5[63:62],carry);

endmodule



//kgp

module kgp(a,b,y);

input a,b;
output [1:0] y;
//reg [1:0] y;

//always@(a or b)
//begin
//case({a,b})
//2'b00:y=2'b00;  //kill
//2'b11:y=2'b11;	  //generate
//2'b01:y=2'b01;	//propagate
//2'b10:y=2'b01;  //propagate
//endcase   //y[1]=ab  y[0]=a+b  
//end

assign y[0]=a | b;
assign y[1]=a & b;

endmodule



module kgp_carry(a,b,carry);

input [1:0] a,b;
output carry;
//reg carry;

//always@(a or b)
//begin
//case(a)
//2'b00:carry=1'b0;  
//2'b11:carry=1'b1;
//2'b01:carry=b[0];
//2'b10:carry=b[0];
//default:carry=1'bx;
//endcase
//end

wire carry;

wire f,g;
assign g=a[0] & a[1];
assign f=a[0] ^ a[1];

assign carry=g|(b[0] & f);

endmodule


module recursive_stage1(a,b,y);

input [1:0] a,b;
output [1:0] y;

wire [1:0] y;
wire b0;
not n1(b0,b[1]);
wire f,g0,g1;
and a1(f,b[0],b[1]);
and a2(g0,b0,b[0],a[0]);
and a3(g1,b0,b[0],a[1]);

or o1(y[0],f,g0);
or o2(y[1],f,g1);

//reg [1:0] y;
//always@(a or b)
//begin
//case(b)
//2'b00:y=2'b00;  
//2'b11:y=2'b11;
//2'b01:y=a;
//default:y=2'bx;
//endcase
//end

//always@(a or b)
//begin
//if(b==2'b00)
//	y=2'b00;  
//else if (b==2'b11)
//	y=2'b11;
//else if (b==2'b01)
//	y=a;
//end

//wire x;
//assign x=a[0] ^ b[0];
//always@(a or b or x)
//begin
//case(x)
//1'b0:y[0]=b[0];  
//1'b1:y[0]=a[0]; 
//endcase
//end
//
//always@(a or b or x)
//begin
//case(x)
//1'b0:y[1]=b[1];  
//1'b1:y[1]=a[1];
//endcase
//end


//always@(a or b)
//begin
//if (b==2'b00)
//	y=2'b00; 
//else if (b==2'b11)	
//	y=2'b11;
//else if (b==2'b01 && a==2'b00)
//	y=2'b00;
//else if (b==2'b01 && a==2'b11)
//	y=2'b11;
//else if (b==2'b01 && a==2'b01)
//	y=2'b01;
//end

endmodule


// Full Adder Module
module fulladd(sum, carry, x,y,z);

output sum,carry;
input x,y,z;

wire w;	
	assign 	 w = x ^ y;
        assign	 sum = w ^ z;
	assign 	 carry = (x & y)|(w & z);
endmodule



// half Adder Module
module halfadd(sum, carry, x,y);

output sum,carry;
input x,y;

	assign	 sum = x ^ y;
	assign 	 carry = x & y;
	
endmodule


//40 bit recursive doubling technique

//`include "kgp.v"
//`include "recursive_stage1.v"

module recurse40(sum,carry,a,b); 

output [39:0] sum;
output  carry;
input [39:0] a,b;

wire [81:0] x;

assign x[1:0]=2'b00;  // kgp generation

kgp a00(a[0],b[0],x[3:2]);
kgp a01(a[1],b[1],x[5:4]);
kgp a02(a[2],b[2],x[7:6]);
kgp a03(a[3],b[3],x[9:8]);
kgp a04(a[4],b[4],x[11:10]);
kgp a05(a[5],b[5],x[13:12]);
kgp a06(a[6],b[6],x[15:14]);
kgp a07(a[7],b[7],x[17:16]);
kgp a08(a[8],b[8],x[19:18]);
kgp a09(a[9],b[9],x[21:20]);
kgp a10(a[10],b[10],x[23:22]);
kgp a11(a[11],b[11],x[25:24]);
kgp a12(a[12],b[12],x[27:26]);
kgp a13(a[13],b[13],x[29:28]);
kgp a14(a[14],b[14],x[31:30]);
kgp a15(a[15],b[15],x[33:32]);
kgp a16(a[16],b[16],x[35:34]);
kgp a17(a[17],b[17],x[37:36]);
kgp a18(a[18],b[18],x[39:38]);
kgp a19(a[19],b[19],x[41:40]);
kgp a20(a[20],b[20],x[43:42]);
kgp a21(a[21],b[21],x[45:44]);
kgp a22(a[22],b[22],x[47:46]);
kgp a23(a[23],b[23],x[49:48]);
kgp a24(a[24],b[24],x[51:50]);
kgp a25(a[25],b[25],x[53:52]);
kgp a26(a[26],b[26],x[55:54]);
kgp a27(a[27],b[27],x[57:56]);
kgp a28(a[28],b[28],x[59:58]);
kgp a29(a[29],b[29],x[61:60]);
kgp a30(a[30],b[30],x[63:62]);
kgp a31(a[31],b[31],x[65:64]);
kgp a32(a[32],b[32],x[67:66]);
kgp a33(a[33],b[33],x[69:68]);
kgp a34(a[34],b[34],x[71:70]);
kgp a35(a[35],b[35],x[73:72]);
kgp a36(a[36],b[36],x[75:74]);
kgp a37(a[37],b[37],x[77:76]);
kgp a38(a[38],b[38],x[79:78]);
kgp a39(a[39],b[39],x[81:80]);

wire [81:0] x1;  //recursive doubling stage 1
assign x1[1:0]=x[1:0];

recursive_stage1 s00(x[1:0],x[3:2],x1[3:2]);
recursive_stage1 s01(x[3:2],x[5:4],x1[5:4]);
recursive_stage1 s02(x[5:4],x[7:6],x1[7:6]);
recursive_stage1 s03(x[7:6],x[9:8],x1[9:8]);
recursive_stage1 s04(x[9:8],x[11:10],x1[11:10]);
recursive_stage1 s05(x[11:10],x[13:12],x1[13:12]);
recursive_stage1 s06(x[13:12],x[15:14],x1[15:14]);
recursive_stage1 s07(x[15:14],x[17:16],x1[17:16]);
recursive_stage1 s08(x[17:16],x[19:18],x1[19:18]);
recursive_stage1 s09(x[19:18],x[21:20],x1[21:20]);
recursive_stage1 s10(x[21:20],x[23:22],x1[23:22]);
recursive_stage1 s11(x[23:22],x[25:24],x1[25:24]);
recursive_stage1 s12(x[25:24],x[27:26],x1[27:26]);
recursive_stage1 s13(x[27:26],x[29:28],x1[29:28]);
recursive_stage1 s14(x[29:28],x[31:30],x1[31:30]);
recursive_stage1 s15(x[31:30],x[33:32],x1[33:32]);
recursive_stage1 s16(x[33:32],x[35:34],x1[35:34]);
recursive_stage1 s17(x[35:34],x[37:36],x1[37:36]);
recursive_stage1 s18(x[37:36],x[39:38],x1[39:38]);
recursive_stage1 s19(x[39:38],x[41:40],x1[41:40]);
recursive_stage1 s20(x[41:40],x[43:42],x1[43:42]);
recursive_stage1 s21(x[43:42],x[45:44],x1[45:44]);
recursive_stage1 s22(x[45:44],x[47:46],x1[47:46]);
recursive_stage1 s23(x[47:46],x[49:48],x1[49:48]);
recursive_stage1 s24(x[49:48],x[51:50],x1[51:50]);
recursive_stage1 s25(x[51:50],x[53:52],x1[53:52]);
recursive_stage1 s26(x[53:52],x[55:54],x1[55:54]);
recursive_stage1 s27(x[55:54],x[57:56],x1[57:56]);
recursive_stage1 s28(x[57:56],x[59:58],x1[59:58]);
recursive_stage1 s29(x[59:58],x[61:60],x1[61:60]);
recursive_stage1 s30(x[61:60],x[63:62],x1[63:62]);
recursive_stage1 s31(x[63:62],x[65:64],x1[65:64]);
recursive_stage1 s32(x[65:64],x[67:66],x1[67:66]);
recursive_stage1 s33(x[67:66],x[69:68],x1[69:68]);
recursive_stage1 s34(x[69:68],x[71:70],x1[71:70]);
recursive_stage1 s35(x[71:70],x[73:72],x1[73:72]);
recursive_stage1 s36(x[73:72],x[75:74],x1[75:74]);
recursive_stage1 s37(x[75:74],x[77:76],x1[77:76]);
recursive_stage1 s38(x[77:76],x[79:78],x1[79:78]);
recursive_stage1 s39(x[79:78],x[81:80],x1[81:80]);

wire [81:0] x2;  //recursive doubling stage2
assign x2[3:0]=x1[3:0];

recursive_stage1 s101(x1[1:0],x1[5:4],x2[5:4]);
recursive_stage1 s102(x1[3:2],x1[7:6],x2[7:6]);
recursive_stage1 s103(x1[5:4],x1[9:8],x2[9:8]);
recursive_stage1 s104(x1[7:6],x1[11:10],x2[11:10]);
recursive_stage1 s105(x1[9:8],x1[13:12],x2[13:12]);
recursive_stage1 s106(x1[11:10],x1[15:14],x2[15:14]);
recursive_stage1 s107(x1[13:12],x1[17:16],x2[17:16]);
recursive_stage1 s108(x1[15:14],x1[19:18],x2[19:18]);
recursive_stage1 s109(x1[17:16],x1[21:20],x2[21:20]);
recursive_stage1 s110(x1[19:18],x1[23:22],x2[23:22]);
recursive_stage1 s111(x1[21:20],x1[25:24],x2[25:24]);
recursive_stage1 s112(x1[23:22],x1[27:26],x2[27:26]);
recursive_stage1 s113(x1[25:24],x1[29:28],x2[29:28]);
recursive_stage1 s114(x1[27:26],x1[31:30],x2[31:30]);
recursive_stage1 s115(x1[29:28],x1[33:32],x2[33:32]);
recursive_stage1 s116(x1[31:30],x1[35:34],x2[35:34]);
recursive_stage1 s117(x1[33:32],x1[37:36],x2[37:36]);
recursive_stage1 s118(x1[35:34],x1[39:38],x2[39:38]);
recursive_stage1 s119(x1[37:36],x1[41:40],x2[41:40]);
recursive_stage1 s120(x1[39:38],x1[43:42],x2[43:42]);
recursive_stage1 s121(x1[41:40],x1[45:44],x2[45:44]);
recursive_stage1 s122(x1[43:42],x1[47:46],x2[47:46]);
recursive_stage1 s123(x1[45:44],x1[49:48],x2[49:48]);
recursive_stage1 s124(x1[47:46],x1[51:50],x2[51:50]);
recursive_stage1 s125(x1[49:48],x1[53:52],x2[53:52]);
recursive_stage1 s126(x1[51:50],x1[55:54],x2[55:54]);
recursive_stage1 s127(x1[53:52],x1[57:56],x2[57:56]);
recursive_stage1 s128(x1[55:54],x1[59:58],x2[59:58]);
recursive_stage1 s129(x1[57:56],x1[61:60],x2[61:60]);
recursive_stage1 s130(x1[59:58],x1[63:62],x2[63:62]);
recursive_stage1 s131(x1[61:60],x1[65:64],x2[65:64]);
recursive_stage1 s132(x1[63:62],x1[67:66],x2[67:66]);
recursive_stage1 s133(x1[65:64],x1[69:68],x2[69:68]);
recursive_stage1 s134(x1[67:66],x1[71:70],x2[71:70]);
recursive_stage1 s135(x1[69:68],x1[73:72],x2[73:72]);
recursive_stage1 s136(x1[71:70],x1[75:74],x2[75:74]);
recursive_stage1 s137(x1[73:72],x1[77:76],x2[77:76]);
recursive_stage1 s138(x1[75:74],x1[79:78],x2[79:78]);
recursive_stage1 s139(x1[77:76],x1[81:80],x2[81:80]);

wire [81:0] x3;  //recursive doubling stage3
assign x3[7:0]=x2[7:0];

recursive_stage1 s203(x2[1:0],x2[9:8],x3[9:8]);
recursive_stage1 s204(x2[3:2],x2[11:10],x3[11:10]);
recursive_stage1 s205(x2[5:4],x2[13:12],x3[13:12]);
recursive_stage1 s206(x2[7:6],x2[15:14],x3[15:14]);
recursive_stage1 s207(x2[9:8],x2[17:16],x3[17:16]);
recursive_stage1 s208(x2[11:10],x2[19:18],x3[19:18]);
recursive_stage1 s209(x2[13:12],x2[21:20],x3[21:20]);
recursive_stage1 s210(x2[15:14],x2[23:22],x3[23:22]);
recursive_stage1 s211(x2[17:16],x2[25:24],x3[25:24]);
recursive_stage1 s212(x2[19:18],x2[27:26],x3[27:26]);
recursive_stage1 s213(x2[21:20],x2[29:28],x3[29:28]);
recursive_stage1 s214(x2[23:22],x2[31:30],x3[31:30]);
recursive_stage1 s215(x2[25:24],x2[33:32],x3[33:32]);
recursive_stage1 s216(x2[27:26],x2[35:34],x3[35:34]);
recursive_stage1 s217(x2[29:28],x2[37:36],x3[37:36]);
recursive_stage1 s218(x2[31:30],x2[39:38],x3[39:38]);
recursive_stage1 s219(x2[33:32],x2[41:40],x3[41:40]);
recursive_stage1 s220(x2[35:34],x2[43:42],x3[43:42]);
recursive_stage1 s221(x2[37:36],x2[45:44],x3[45:44]);
recursive_stage1 s222(x2[39:38],x2[47:46],x3[47:46]);
recursive_stage1 s223(x2[41:40],x2[49:48],x3[49:48]);
recursive_stage1 s224(x2[43:42],x2[51:50],x3[51:50]);
recursive_stage1 s225(x2[45:44],x2[53:52],x3[53:52]);
recursive_stage1 s226(x2[47:46],x2[55:54],x3[55:54]);
recursive_stage1 s227(x2[49:48],x2[57:56],x3[57:56]);
recursive_stage1 s228(x2[51:50],x2[59:58],x3[59:58]);
recursive_stage1 s229(x2[53:52],x2[61:60],x3[61:60]);
recursive_stage1 s230(x2[55:54],x2[63:62],x3[63:62]);
recursive_stage1 s231(x2[57:56],x2[65:64],x3[65:64]);
recursive_stage1 s232(x2[59:58],x2[67:66],x3[67:66]);
recursive_stage1 s233(x2[61:60],x2[69:68],x3[69:68]);
recursive_stage1 s234(x2[63:62],x2[71:70],x3[71:70]);
recursive_stage1 s235(x2[65:64],x2[73:72],x3[73:72]);
recursive_stage1 s236(x2[67:66],x2[75:74],x3[75:74]);
recursive_stage1 s237(x2[69:68],x2[77:76],x3[77:76]);
recursive_stage1 s238(x2[71:70],x2[79:78],x3[79:78]);
recursive_stage1 s239(x2[73:72],x2[81:80],x3[81:80]);

wire [81:0] x4;  //recursive doubling stage 4
assign x4[15:0]=x3[15:0];

recursive_stage1 s307(x3[1:0],x3[17:16],x4[17:16]);
recursive_stage1 s308(x3[3:2],x3[19:18],x4[19:18]);
recursive_stage1 s309(x3[5:4],x3[21:20],x4[21:20]);
recursive_stage1 s310(x3[7:6],x3[23:22],x4[23:22]);
recursive_stage1 s311(x3[9:8],x3[25:24],x4[25:24]);
recursive_stage1 s312(x3[11:10],x3[27:26],x4[27:26]);
recursive_stage1 s313(x3[13:12],x3[29:28],x4[29:28]);
recursive_stage1 s314(x3[15:14],x3[31:30],x4[31:30]);
recursive_stage1 s315(x3[17:16],x3[33:32],x4[33:32]);
recursive_stage1 s316(x3[19:18],x3[35:34],x4[35:34]);
recursive_stage1 s317(x3[21:20],x3[37:36],x4[37:36]);
recursive_stage1 s318(x3[23:22],x3[39:38],x4[39:38]);
recursive_stage1 s319(x3[25:24],x3[41:40],x4[41:40]);
recursive_stage1 s320(x3[27:26],x3[43:42],x4[43:42]);
recursive_stage1 s321(x3[29:28],x3[45:44],x4[45:44]);
recursive_stage1 s322(x3[31:30],x3[47:46],x4[47:46]);
recursive_stage1 s323(x3[33:32],x3[49:48],x4[49:48]);
recursive_stage1 s324(x3[35:34],x3[51:50],x4[51:50]);
recursive_stage1 s325(x3[37:36],x3[53:52],x4[53:52]);
recursive_stage1 s326(x3[39:38],x3[55:54],x4[55:54]);
recursive_stage1 s327(x3[41:40],x3[57:56],x4[57:56]);
recursive_stage1 s328(x3[43:42],x3[59:58],x4[59:58]);
recursive_stage1 s329(x3[45:44],x3[61:60],x4[61:60]);
recursive_stage1 s330(x3[47:46],x3[63:62],x4[63:62]);
recursive_stage1 s331(x3[49:48],x3[65:64],x4[65:64]);
recursive_stage1 s332(x3[51:50],x3[67:66],x4[67:66]);
recursive_stage1 s333(x3[53:52],x3[69:68],x4[69:68]);
recursive_stage1 s334(x3[55:54],x3[71:70],x4[71:70]);
recursive_stage1 s335(x3[57:56],x3[73:72],x4[73:72]);
recursive_stage1 s336(x3[59:58],x3[75:74],x4[75:74]);
recursive_stage1 s337(x3[61:60],x3[77:76],x4[77:76]);
recursive_stage1 s338(x3[63:62],x3[79:78],x4[79:78]);
recursive_stage1 s339(x3[65:64],x3[81:80],x4[81:80]);

wire [81:0] x5;  //recursive doubling stage 5
assign x5[31:0]=x4[31:0];

recursive_stage1 s415(x4[1:0],x4[33:32],x5[33:32]);
recursive_stage1 s416(x4[3:2],x4[35:34],x5[35:34]);
recursive_stage1 s417(x4[5:4],x4[37:36],x5[37:36]);
recursive_stage1 s418(x4[7:6],x4[39:38],x5[39:38]);
recursive_stage1 s419(x4[9:8],x4[41:40],x5[41:40]);
recursive_stage1 s420(x4[11:10],x4[43:42],x5[43:42]);
recursive_stage1 s421(x4[13:12],x4[45:44],x5[45:44]);
recursive_stage1 s422(x4[15:14],x4[47:46],x5[47:46]);
recursive_stage1 s423(x4[17:16],x4[49:48],x5[49:48]);
recursive_stage1 s424(x4[19:18],x4[51:50],x5[51:50]);
recursive_stage1 s425(x4[21:20],x4[53:52],x5[53:52]);
recursive_stage1 s426(x4[23:22],x4[55:54],x5[55:54]);
recursive_stage1 s427(x4[25:24],x4[57:56],x5[57:56]);
recursive_stage1 s428(x4[27:26],x4[59:58],x5[59:58]);
recursive_stage1 s429(x4[29:28],x4[61:60],x5[61:60]);
recursive_stage1 s430(x4[31:30],x4[63:62],x5[63:62]);
recursive_stage1 s431(x4[33:32],x4[65:64],x5[65:64]);
recursive_stage1 s432(x4[35:34],x4[67:66],x5[67:66]);
recursive_stage1 s433(x4[37:36],x4[69:68],x5[69:68]);
recursive_stage1 s434(x4[39:38],x4[71:70],x5[71:70]);
recursive_stage1 s435(x4[41:40],x4[73:72],x5[73:72]);
recursive_stage1 s436(x4[43:42],x4[75:74],x5[75:74]);
recursive_stage1 s437(x4[45:44],x4[77:76],x5[77:76]);
recursive_stage1 s438(x4[47:46],x4[79:78],x5[79:78]);
recursive_stage1 s439(x4[49:48],x4[81:80],x5[81:80]);

wire [81:0] x6;  // recursive doubling stage 6
assign x6[63:0]=x5[63:0];

recursive_stage1 s531(x5[1:0],x5[65:64],x6[65:64]);
recursive_stage1 s532(x5[3:2],x5[67:66],x6[67:66]);
recursive_stage1 s533(x5[5:4],x5[69:68],x6[69:68]);
recursive_stage1 s534(x5[7:6],x5[71:70],x6[71:70]);
recursive_stage1 s535(x5[9:8],x5[73:72],x6[73:72]);
recursive_stage1 s536(x5[11:10],x5[75:74],x6[75:74]);
recursive_stage1 s537(x5[13:12],x5[77:76],x6[77:76]);
recursive_stage1 s538(x5[15:14],x5[79:78],x6[79:78]);
recursive_stage1 s539(x5[17:16],x5[81:80],x6[81:80]);

// final sum and carry

assign sum[0]=a[0]^b[0]^x6[0];
assign sum[1]=a[1]^b[1]^x6[2];
assign sum[2]=a[2]^b[2]^x6[4];
assign sum[3]=a[3]^b[3]^x6[6];
assign sum[4]=a[4]^b[4]^x6[8];
assign sum[5]=a[5]^b[5]^x6[10];
assign sum[6]=a[6]^b[6]^x6[12];
assign sum[7]=a[7]^b[7]^x6[14];
assign sum[8]=a[8]^b[8]^x6[16];
assign sum[9]=a[9]^b[9]^x6[18];
assign sum[10]=a[10]^b[10]^x6[20];
assign sum[11]=a[11]^b[11]^x6[22];
assign sum[12]=a[12]^b[12]^x6[24];
assign sum[13]=a[13]^b[13]^x6[26];
assign sum[14]=a[14]^b[14]^x6[28];
assign sum[15]=a[15]^b[15]^x6[30];
assign sum[16]=a[16]^b[16]^x6[32];
assign sum[17]=a[17]^b[17]^x6[34];
assign sum[18]=a[18]^b[18]^x6[36];
assign sum[19]=a[19]^b[19]^x6[38];
assign sum[20]=a[20]^b[20]^x6[40];
assign sum[21]=a[21]^b[21]^x6[42];
assign sum[22]=a[22]^b[22]^x6[44];
assign sum[23]=a[23]^b[23]^x6[46];
assign sum[24]=a[24]^b[24]^x6[48];
assign sum[25]=a[25]^b[25]^x6[50];
assign sum[26]=a[26]^b[26]^x6[52];
assign sum[27]=a[27]^b[27]^x6[54];
assign sum[28]=a[28]^b[28]^x6[56];
assign sum[29]=a[29]^b[29]^x6[58];
assign sum[30]=a[30]^b[30]^x6[60];
assign sum[31]=a[31]^b[31]^x6[62];
assign sum[32]=a[32]^b[32]^x6[64];
assign sum[33]=a[33]^b[33]^x6[66];
assign sum[34]=a[34]^b[34]^x6[68];
assign sum[35]=a[35]^b[35]^x6[70];
assign sum[36]=a[36]^b[36]^x6[72];
assign sum[37]=a[37]^b[37]^x6[74];
assign sum[38]=a[38]^b[38]^x6[76];
assign sum[39]=a[39]^b[39]^x6[78];

assign carry=x6[80];

endmodule




`default_nettype wire
