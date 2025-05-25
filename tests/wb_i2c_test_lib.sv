`ifndef SOC
class base_test extends uvm_test;

     string m_tb_name;

    testbench tb;

    `uvm_component_utils(base_test)

    function new(string name = "base_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        m_tb_name = "m_wb_i2c_tb";

        tb = testbench::type_id::create("tb", this);
        `uvm_info(get_type_name(), "Inside build phase of base_test (test library class)", UVM_HIGH)
        uvm_config_db#(string)::set(null, "*", "m_tb_name",m_tb_name);       
    endfunction : build_phase

    function void end_of_elaboration_phase(uvm_phase phase);
      	 uvm_root uvm_top = uvm_root::get();
         uvm_top.print_topology();
    endfunction : end_of_elaboration_phase

endclass : base_test

//Virtual sequencer test
class mcsequencer_basic_test extends base_test;

    //Component macro
    `uvm_component_utils(mcsequencer_basic_test)

    //Class constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    //Build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        // Set the config object into the config DB
 	if (!uvm_config_db#(string)::get(this, "", "m_tb_name", m_tb_name))
			  `uvm_error("CONFIGDB", "Could not find Testbench Name in config DB");
      //Default sequence of clock and reset sequencer
     	
        uvm_config_wrapper::set(this,$sformatf("%s.m_clock_and_reset_env.agent.sequencer.run_phase",m_tb_name),
                                "default_sequence", clk10_rst5_seq::get_type());
        uvm_config_wrapper::set(this,$sformatf("%s.mcsequencer.run_phase",m_tb_name),
                                "default_sequence", i2c_write_mc_seq::get_type()); 
    endfunction : build_phase

endclass : mcsequencer_basic_test
`endif






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
    // uvm_config_wrapper::set(this, "*mc_seqr.run_phase",  "default_sequence", i2c_write_while_busy_mc_seq::get_type()); 
    // uvm_config_wrapper::set(this, "*mc_seqr.run_phase",  "default_sequence", i2c_multiple_write_mc_seq::get_type()); 
    // uvm_config_wrapper::set(this, "*mc_seqr.run_phase",  "default_sequence", i2c_multiple_read_mc_seq::get_type()); 
   




    super.build_phase(phase);   

    
  endfunction : build_phase

endclass : wb_i2c_test
