class i2c_module extends uvm_env;
	`uvm_component_utils(i2c_module);
	
    
    i2c_scoreboard i2c_sbd;
	wb_x_i2c_ref_model i2c_ref_model;


	function new(string name ="i2c_module", uvm_component parent);
		super.new(name,parent);

	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		i2c_sbd = i2c_scoreboard::type_id::create("i2c_sbd",this);
		i2c_ref_model = wb_x_i2c_ref_model::type_id::create("i2c_ref_model",this);
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		i2c_ref_model.sbd_port.connect(i2c_sbd.ref_model_imp);		

	endfunction
endclass


