class mc_seq extends uvm_sequence;
    
    `uvm_object_utils(mc_seq)
  
   //declare the multichannel_sequencer
    `uvm_declare_p_sequencer(mc_sequencer)


  //declareing the sequences I want to use
  i2c_400k_seq i2c_400k;
  i2c_write_byte_seq i2c_write_byte;
  i2c_read_byte_seq i2c_read_byte;
  i2c_slave_seq i2c_slave;
  i2c_write_to_wrong_addr_seq i2c_write_to_wrong_addr;
  i2c_write_while_busy_seq i2c_write_while_busy;

    function new(string name ="mc_seq");
        super.new(name);
    endfunction:new

task pre_body();
    uvm_phase phase;
    `ifdef UVM_VERSION_1_2
      // in UVM1.2, get starting phase from method
      phase = get_starting_phase();
    `else
      phase = starting_phase;
    `endif
    if (phase != null) begin
      phase.raise_objection(this, get_type_name());
      `uvm_info(get_type_name(), "raise objection", UVM_MEDIUM)
    end
  endtask : pre_body

  task post_body();
    uvm_phase phase;
    `ifdef UVM_VERSION_1_2
      // in UVM1.2, get starting phase from method
      phase = get_starting_phase();
    `else
      phase = starting_phase;
    `endif
    if (phase != null) begin
      phase.drop_objection(this, get_type_name());
      `uvm_info(get_type_name(), "drop objection", UVM_MEDIUM)
    end
  endtask : post_body



endclass: mc_seq


class i2c_write_mc_seq extends mc_seq;
    
    `uvm_object_utils(i2c_write_mc_seq)
 

    function new(string name ="i2c_write_mc_seq");
        super.new(name);
    endfunction:new


// do the SEQs in the targeted seqr
 task body();

//enable i2c core and set the core on fast mode (400Kbps)
`uvm_do_on(i2c_400k, p_sequencer.wb_seqr)

//write to slave 
fork
`uvm_do_on(i2c_slave, p_sequencer.i2c_seqr)
`uvm_do_on(i2c_write_byte, p_sequencer.wb_seqr)
join


endtask:body


endclass: i2c_write_mc_seq



class i2c_read_mc_seq extends mc_seq;
    
    `uvm_object_utils(i2c_read_mc_seq)
 

    function new(string name ="i2c_read_mc_seq");
        super.new(name);
    endfunction:new



// do the SEQs in the targeted seqr
 task body();


`uvm_do_on(i2c_400k, p_sequencer.wb_seqr)


//read 
fork
`uvm_do_on(i2c_slave, p_sequencer.i2c_seqr)
`uvm_do_on(i2c_read_byte, p_sequencer.wb_seqr)
join


endtask:body


endclass: i2c_read_mc_seq




class i2c_write_to_wrong_addr_mc_seq extends mc_seq;
    
    `uvm_object_utils(i2c_write_to_wrong_addr_mc_seq)
 

    function new(string name ="i2c_write_to_wrong_addr_mc_seq");
        super.new(name);
    endfunction:new


// do the SEQs in the targeted seqr
 task body();

//enable i2c core and set the core on fast mode (400Kbps)
`uvm_do_on(i2c_400k, p_sequencer.wb_seqr)

//write to slave 
fork
`uvm_do_on(i2c_slave, p_sequencer.i2c_seqr)
`uvm_do_on(i2c_write_to_wrong_addr, p_sequencer.wb_seqr)
join


endtask:body


endclass: i2c_write_to_wrong_addr_mc_seq




class i2c_write_while_busy_mc_seq extends mc_seq;
    
    `uvm_object_utils(i2c_write_while_busy_mc_seq)
 

    function new(string name ="i2c_write_while_busy_mc_seq");
        super.new(name);
    endfunction:new


// do the SEQs in the targeted seqr
 task body();

//enable i2c core and set the core on fast mode (400Kbps)
`uvm_do_on(i2c_400k, p_sequencer.wb_seqr)

//write to slave 
fork
`uvm_do_on(i2c_slave, p_sequencer.i2c_seqr)
`uvm_do_on(i2c_write_while_busy, p_sequencer.wb_seqr)
join


endtask:body


endclass: i2c_write_while_busy_mc_seq


class i2c_multiple_write_mc_seq extends mc_seq;
    
    `uvm_object_utils(i2c_multiple_write_mc_seq)
 

    function new(string name ="i2c_multiple_write_mc_seq");
        super.new(name);
    endfunction:new


// do the SEQs in the targeted seqr
 task body();

//enable i2c core and set the core on fast mode (400Kbps)
`uvm_do_on(i2c_400k, p_sequencer.wb_seqr)

//write to slave 
fork
`uvm_do_on(i2c_slave, p_sequencer.i2c_seqr)
`uvm_do_on(i2c_write_byte, p_sequencer.wb_seqr)
join_any
`uvm_do_on(i2c_write_byte, p_sequencer.wb_seqr)
`uvm_do_on(i2c_write_byte, p_sequencer.wb_seqr)




endtask:body


endclass: i2c_multiple_write_mc_seq




class i2c_multiple_read_mc_seq extends mc_seq;
    
    `uvm_object_utils(i2c_multiple_read_mc_seq)
 

    function new(string name ="i2c_multiple_read_mc_seq");
        super.new(name);
    endfunction:new


// do the SEQs in the targeted seqr
 task body();

//enable i2c core and set the core on fast mode (400Kbps)
`uvm_do_on(i2c_400k, p_sequencer.wb_seqr)

//write to slave 
fork
`uvm_do_on(i2c_slave, p_sequencer.i2c_seqr)
`uvm_do_on(i2c_read_byte, p_sequencer.wb_seqr)
join_any
`uvm_do_on(i2c_read_byte, p_sequencer.wb_seqr)
`uvm_do_on(i2c_read_byte, p_sequencer.wb_seqr)




endtask:body


endclass: i2c_multiple_read_mc_seq