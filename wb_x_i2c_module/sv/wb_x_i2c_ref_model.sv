class wb_x_i2c_ref_model extends uvm_scoreboard;
    `uvm_component_utils(wb_x_i2c_ref_model)

	import wb_pkg::*;
	import i2c_pkg::*;

 `uvm_analysis_imp_decl(_wb)

	uvm_analysis_imp_wb #(wb_transaction, wb_x_i2c_ref_model) wb_imp;
	uvm_analysis_port #(wb_transaction) sbd_port;


	function new(string name =get_type_name(), uvm_component parent);
		super.new(name,parent);
		wb_imp = new("wb_imp", this);
        sbd_port = new("sbd_port", this);

	endfunction

    // i2c registers 
	
	bit [7:0] PRER_LO[$]; //Clock Prescale register lo-byte 
	bit [7:0] PRER_HI[$]; //Clock Prescale register Hi-byte 
	bit [7:0] CTR [$]; //Control register 
	bit [7:0] TXR [$]; //Transmit register  
	bit [7:0] RXR [$]; //Receive register 
	bit [7:0] CR [$];  //Command register 
	bit [7:0] SR  [$];     //Status register





	function void write_wb (wb_transaction t);
        
        //deep copy 
        wb_transaction tr;
        $cast(tr, t.clone());


		case(tr.addr[2:0])

			2'b000: 
				begin
					if (tr.op_type == wb_write) 
						PRER_LO.push_back(tr.din); 
				end
			2'b001: 
				begin
					if (tr.op_type == wb_write) 
						PRER_HI.push_back(tr.din); 
				end
			2'b010: 
				begin
					if (tr.op_type == wb_write) 
						CTR.push_back(tr.din); 
				end
			2'b011:
				begin
					if (tr.op_type == wb_write) 
						begin
							TXR.push_back(tr.din);
							sbd_port.write(tr); 
						end
					else
						begin
							RXR.push_back(tr.dout); 
							sbd_port.write(tr); 
						end
				end	
			2'b100: 
				begin
					if (tr.op_type == wb_write) 
						CR.push_back(tr.din); 
					else
						SR.push_back(tr.dout); 
				end
				
		endcase


			

		endfunction:write_wb








endclass : wb_x_i2c_ref_model
