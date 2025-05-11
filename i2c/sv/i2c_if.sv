interface i2c_if (input bit clk, input bit rst_n);
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import i2c_pkg::*;




//signals
wire scl;
wire sda;

logic sda_w;
assign sda = sda_w;





  bit [6:0] Slave_addr = 7'b1010_101 ; // this is the addr of this slave
  bit[7:0] header;

 task  send_to_dut (i2c_transaction tr);
 
 sda_w <= 1'bz;

@(negedge sda iff  scl); //start condtion 


        read_header ();
         
        if ( Slave_addr == header[7:1] )  begin
            ack();
         
            if (header[0] == 1'b0) //  0:R  1:W  from slave POV
            begin
            `uvm_info("i2c_slave_driver", "reading byte from i2c master...", UVM_HIGH)
             read_byte();
            end
    
            else begin
            `uvm_info("i2c_slave_driver", $sformatf("sending the byte:[%0h] to i2c master" , tr.dout), UVM_HIGH)
             write_byte(tr.dout);
            end
         end
         

endtask :send_to_dut





task read_header();

foreach (header[i]) begin
  @(posedge scl);
  header[i] =sda;
end 

//$display("🥳🥳🥳🥳heder = %b at $t", header , $time);
 endtask : read_header







 task read_byte ();  

        repeat(8)  // stalling for 8 cycle  
         @(posedge scl); 
          
        ack(); //send ack to sda
 endtask :read_byte



task write_byte (bit [7:0] dout);  
sda_w <=1'b0;
  foreach (dout[i]) begin
    #500;
    sda_w <= dout[i];  // send MSB first
    @(negedge scl);
  end 
  sda_w <= 'z;  //release the line
endtask :write_byte


//send ack into sda
task ack(); 
     @(negedge scl); // ------------------------
     sda_w <=0;    //ack
     @(negedge scl); //-----------------------
      sda_w <= 'z;
endtask :ack 





endinterface : i2c_if

