`timescale 1ns/1ns

module top;

  // UVM class library compiled in a package
  import uvm_pkg::*;
  // Bring in the rest of the library (macros and template classes)
  `include "uvm_macros.svh"
  import wb_pkg::*;
  import clock_and_reset_pkg::*;
  import i2c_pkg::*;
  import i2c_module_pkg::*;

  
  
  `include "wb_i2c_mcsequencer.sv"
  `include "wb_i2c_sequences.sv"
  `include "wb_i2c_mcseqs_lib.sv"
  `include "wb_i2c_tb.sv"
  `include "wb_i2c_test_lib.sv"


  
  initial begin
    wb_vif_config::set(null,"*.tb.wb.*","vif", hw_top.wif);
    clock_and_reset_vif_config::set(null , "*clk_rst*" , "vif" , hw_top.cr_if);
    i2c_vif_config::set(null,"*.tb.i2c.*","vif", hw_top.iif);

    run_test();
  end




  initial begin
  $dumpfile("wave.vcd");
  $dumpvars;
  end

endmodule:top
