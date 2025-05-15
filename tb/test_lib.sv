class base_test extends uvm_test;

  `uvm_component_utils(base_test)

  testbench tb;

  function new(string name = "base_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    // Enable transaction recording for everything
    uvm_config_int::set(this, "*", "recording_detail", UVM_FULL);
    // Create the tb
    tb = testbench::type_id::create("tb", this);
  endfunction : build_phase

  function void end_of_elaboration_phase(uvm_phase phase);
    uvm_top.print_topology();
  endfunction

  function void check_phase(uvm_phase phase);
    check_config_usage();
  endfunction

endclass : base_test




//----------------------------------------------------------------
// TEST: : This test validate that the Wishbone correctly issues a write transaction to the I²C peripheral, writing two bytes (a header byte followed by a data byte) to the I²C master. 
//----------------------------------------------------------------
class wb_write_byte_on_i2c extends base_test;

  `uvm_component_utils(wb_write_byte_on_i2c)

  function new(string name = get_type_name(), uvm_component parent = null);
    super.new(name, parent);
  endfunction : new




  task run_phase(uvm_phase phase);
    uvm_objection obj = phase.get_objection();
    obj.set_drain_time(this, 100ns);
  endtask : run_phase


  virtual function void build_phase(uvm_phase phase);


    // Set the default sequence for the clock
    uvm_config_wrapper::set(this, "*mc_seqr.run_phase",  "default_sequence", i2c_write_mc_seq::get_type()); 
    uvm_config_wrapper::set(this, "*clk_rst*", "default_sequence", clk10_rst5_seq::get_type());
    
   




    super.build_phase(phase);
  endfunction : build_phase

endclass : wb_write_byte_on_i2c


//----------------------------------------------------------------
// TEST: : This test validate that the Wishbone correctly issues a read opration from the I²C peripheral, writing two bytes (a header byte followed by a data byte) to the I²C master. 
//----------------------------------------------------------------
class wb_read_byte_on_i2c extends base_test;

  `uvm_component_utils(wb_read_byte_on_i2c)

  function new(string name = get_type_name(), uvm_component parent = null);
    super.new(name, parent);
  endfunction : new




  task run_phase(uvm_phase phase);
    uvm_objection obj = phase.get_objection();
    obj.set_drain_time(this, 100ns);
  endtask : run_phase


  virtual function void build_phase(uvm_phase phase);


    // Set the default sequence for the clock
    uvm_config_wrapper::set(this, "*mc_seqr.run_phase",  "default_sequence", i2c_read_mc_seq::get_type()); 
    uvm_config_wrapper::set(this, "*clk_rst*", "default_sequence", clk10_rst5_seq::get_type());
    
   




    super.build_phase(phase);
  endfunction : build_phase

endclass : wb_read_byte_on_i2c






//----------------------------------------------------------------
// TEST: : This general purpose test
//----------------------------------------------------------------
class wb_i2c_test extends base_test;

  `uvm_component_utils(wb_i2c_test)

  function new(string name = get_type_name(), uvm_component parent = null);
    super.new(name, parent);
  endfunction : new




  task run_phase(uvm_phase phase);
    uvm_objection obj = phase.get_objection();
    obj.set_drain_time(this, 100ns);
  endtask : run_phase


  virtual function void build_phase(uvm_phase phase);


    // Set the default sequence for the clock
    uvm_config_wrapper::set(this, "*clk_rst*", "default_sequence", clk10_rst5_seq::get_type());
   
   
   //select one of the following test  
    //  uvm_config_wrapper::set(this, "*mc_seqr.run_phase",  "default_sequence", i2c_write_to_wrong_addr_mc_seq::get_type()); 
    uvm_config_wrapper::set(this, "*mc_seqr.run_phase",  "default_sequence", i2c_write_while_busy_mc_seq::get_type()); 
    // uvm_config_wrapper::set(this, "*mc_seqr.run_phase",  "default_sequence", i2c_multiple_write_mc_seq::get_type()); 
    // uvm_config_wrapper::set(this, "*mc_seqr.run_phase",  "default_sequence", i2c_multiple_read_mc_seq::get_type()); 
   




    super.build_phase(phase);
  endfunction : build_phase

endclass : wb_i2c_test
