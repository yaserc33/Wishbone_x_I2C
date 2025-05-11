module hw_top;

// Clock and reset signals
logic [31:0]  clock_period;
logic         run_clock;
logic         clock;
logic         reset;




//interface initialization

clock_and_reset_if cr_if (
              .clock(clock),
              .reset(reset),
              .run_clock(run_clock), 
              .clock_period(clock_period));



wb_if wif (
            .clk(clock),
            .rst_n(reset));




i2c_if iif (
            .clk(clock),
            .rst_n(reset));




// CLKGEN module generates clock
  clkgen clkgen (
    .clock(clock),
    .run_clock(run_clock),
    .clock_period(clock_period)
  );



    // ============================================
    //                      i2c
    // ============================================ 

logic scl_padoen_oe;
logic sda_padoen_oe;
logic scl_pad_o;
logic sda_pad_o;

assign iif.scl = scl_padoen_oe ? 1'bz : scl_pad_o; 
assign iif.sda = sda_padoen_oe ? 1'bz: sda_pad_o; 


pullup p1(iif.scl); // pullup scl line
pullup p2(iif.sda); // pullup sda line

 i2c_master_top i2c (
  // Wishbone interface
	.wb_clk_i(clock),
  .wb_rst_i(1'b0),
  .arst_i(~reset),
  .wb_adr_i(wif.addr[2:0]),
  .wb_dat_i(wif.din),
  .wb_dat_o(wif.dout),
	.wb_we_i(wif.we),
  .wb_stb_i(wif.stb),
  .wb_cyc_i(wif.cyc),
  .wb_ack_o(wif.ack),
  .wb_inta_o(),

  // I2c interface
	.scl_pad_i(iif.scl),
  .scl_pad_o(scl_pad_o),
  .scl_padoen_o(scl_padoen_oe),
  .sda_pad_i(iif.sda), 
  .sda_pad_o(sda_pad_o), 
  .sda_padoen_o(sda_padoen_oe)
  
   );



 















endmodule:hw_top