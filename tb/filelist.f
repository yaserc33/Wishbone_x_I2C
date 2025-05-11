

///////////////////////////////////////
#      inclouding the UVCs
///////////////////////////////////////

+incdir+../wb/sv            
../wb/sv/wb_pkg.sv          
../wb/sv/wb_if.sv           

+incdir+../clock_and_reset/sv 
../clock_and_reset/sv/clock_and_reset_if.sv
../clock_and_reset/sv/clock_and_reset_pkg.sv


+incdir+../i2c/sv 
../i2c/sv/i2c_pkg.sv
../i2c/sv/i2c_if.sv


+incdir+../wb_x_i2c_module/sv
../wb_x_i2c_module/sv/i2c_module_pkg.sv 




///////////////////////////////////////
#      inclouding the RTL files
///////////////////////////////////////

+incdir+../rtl  

// i2c files
../rtl/i2c/i2c_master_bit_ctrl.v
../rtl/i2c/i2c_master_byte_ctrl.v
//../rtl/i2c/i2c_master_defines.v --> inclouded from i2c_master_bit_ctrl.v
../rtl/i2c/i2c_master_top.v


// clokgen & hw_top files
clkgen.sv
hw_top.sv

# compile top level module 
top.sv    




//     run command
// vcs -sverilog -timescale=1ns/1ns -full64 -f filelist.f -ntb_opts -uvm   -o   simv ;     ./simv -f run.f;


