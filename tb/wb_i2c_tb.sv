class testbench extends uvm_env;
  `uvm_component_utils(testbench)

  //declare handels for the UVCs
  wb_env wb;
  clock_and_reset_env clk_rst;
  i2c_env i2c;
  mc_sequencer mc_seqr;

//Declare a handle for module uvc  "scoreboard"
  i2c_module  sb_module;



  function new(string name, uvm_component parent = null);
    super.new(name, parent);
  endfunction : new


  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    uvm_config_int::set(this, "*wb*", "num_masters", 1);
    uvm_config_int::set(this, "*wb*", "num_slaves", 0);

    uvm_config_int::set(this, "*i2c*", "num_masters", 0);
    uvm_config_int::set(this, "*i2c*", "num_slaves", 1);

    wb = wb_env::type_id::create("wb", this);
    clk_rst = clock_and_reset_env::type_id::create("clk_rst", this);
    i2c = i2c_env::type_id::create("i2c", this);
    mc_seqr = mc_sequencer::type_id::create("mc_seqr", this);

    // Create Scoreboard Module UVC
    sb_module = i2c_module::type_id::create("sb_module", this);
    
  endfunction : build_phase



  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    //sequencers connection to mc_seqr
    mc_seqr.wb_seqr = wb.masters[0].sequencer;
    mc_seqr.i2c_seqr = i2c.slaves[0].sequencer;




    //Scoreboard connection 
    // // TLM connections between spi and Scoreboard
     i2c.slaves[0].monitor.i2c_analysis_port.connect(sb_module.i2c_sbd.i2c_imp); 
    // // TLM connections between wb and Scoreboard
     wb.masters[0].monitor.wb_port.connect(sb_module.i2c_ref_model.wb_imp);



    `uvm_info(get_type_name(), "connect_phase", UVM_FULL)
  endfunction : connect_phase





endclass : testbench