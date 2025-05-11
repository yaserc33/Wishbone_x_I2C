class i2c_scoreboard extends uvm_scoreboard;
    import i2c_pkg::*;
    import wb_pkg::*;
    `uvm_component_utils(i2c_scoreboard)


  ////////////////declaring the analysis port//////////////////
  `uvm_analysis_imp_decl(_wb_i2c_ref_model)
  `uvm_analysis_imp_decl(_i2c)


   uvm_analysis_imp_wb_i2c_ref_model#(wb_transaction, i2c_scoreboard)  ref_model_imp;
   uvm_analysis_imp_i2c#(i2c_transaction, i2c_scoreboard)  i2c_imp;

  
// ////////////////////////////////////////////////////////////////////

    // Counters for analysis
    int err;
    int total_matched_packets=0;
    int total_wrong_packets=0;
    int total_i2c_transactions=0;
    int total_spi_transactions=0;
    int total_uart_transactions=0;
    int total_wb_transactions=0; 
    int total_packets_received=0;



    // i2c_Scoreboard Data Structures
 
    i2c_transaction i2c_queue[$];   
    wb_transaction wb_queue[$];   



    function new(string name= "i2c_scoreboard" , uvm_component parent);
        super.new(name,  parent);

        ref_model_imp=new("ref_model_imp", this);
        i2c_imp=new("i2c_imp", this);

    endfunction :new





    // Transaction Capturing - i2c
    function void write_i2c(i2c_transaction tr);
    	i2c_transaction clone_tr;
		$cast(clone_tr,tr.clone());
        i2c_queue.push_back(clone_tr);
        `uvm_info("i2c_SCOREBOARD", $sformatf("Received i2c Transaction: %s", tr.sprint()), UVM_FULL)
                  
        total_i2c_transactions+=2;//because 2 byte in one transaction and we count byte wise 
        total_packets_received+=2;
        
        compare_transactions();
    endfunction

    //Transaction Capturing - WB
    function void write_wb_i2c_ref_model(wb_transaction tr);
		wb_transaction clone_tr;
		$cast(clone_tr,tr.clone());
        wb_queue.push_back(clone_tr);
        `uvm_info("i2c_SCOREBOARD", $sformatf("Received WB Transaction: %s", tr.sprint()), UVM_FULL)
                  
        total_wb_transactions++;
        total_packets_received++; 
    endfunction



    //Compare Transactions
    function void compare_transactions();
        if (i2c_queue.size() > 0 && wb_queue.size() > 0) begin
            i2c_transaction i2c_pkt = i2c_queue.pop_front();
            wb_transaction wb_pkt = wb_queue.pop_front();
           
            if (wb_pkt.op_type==wb_write)begin 
                if (i2c_pkt.din == wb_pkt.dout) 
                    total_matched_packets++;
                else begin
                    `uvm_error("Mismatch", $sformatf("Mismatch: i2c = %h, WB = %h", i2c_pkt.din, wb_pkt.dout))
                    `uvm_info("Mismatch", $sformatf("Received i2c Transaction: %s", i2c_pkt.sprint()), UVM_LOW)
                    `uvm_info("Mismatch", $sformatf("Received WB Transaction: %s", wb_pkt.sprint()), UVM_LOW)
                     err++;
                end



            end  
            else if  (wb_pkt.op_type==wb_read) begin 
                if (i2c_pkt.dout == wb_pkt.din) 
                    total_matched_packets++;
                else begin
                    `uvm_error("i2c_SCOREBOARD", $sformatf("Mismatch: i2c = %h, WB = %h", i2c_pkt.din, wb_pkt.dout))
                     err++;
                end
            end
        end
    endfunction:compare_transactions
    








     function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info(get_type_name(),"printing report",UVM_NONE)

    $display("\n****************** TEST REPORT ******************\n");



   $display("Packets Summary:\n");
   $display( "   - Total WB Packets Received:  %d", total_wb_transactions);
   $display( "   - Total SPI Packets Received: %d",total_spi_transactions);
   $display( "   - Total I2C Packets Received: %d", total_i2c_transactions);
   $display( "   - Total UART Packets Received:%d", total_uart_transactions);
   $display( "   - Total Packets Received: %d", total_packets_received);
   $display( "   - Total Matched Packets:  %d", total_matched_packets);
   $display( "   - Number of Mismatches:   %d\n",err);
      

  if (err || total_packets_received != total_i2c_transactions+total_wb_transactions  ) begin
      $display("\n==================================================\n",
      "                   TEST FAILED ❌\n",
      "==================================================\n");
  end else begin
      $display("\n==================================================\n",
      "                    TEST PASS ✅\n",
      "==================================================\n");

  end

    $display("\n****************** END OF REPORT ******************\n");

endfunction : report_phase

endclass :i2c_scoreboard

    