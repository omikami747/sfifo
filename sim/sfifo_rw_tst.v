// this module is for testing basic reads and writes

`include "../sim/sfifo_sim.vh"

module sfifo_rw_tst;
   
   integer i;
   
   initial
     begin
	$dumpvars;
	
	// Initialize (reset etc)
	`SFIFO_INIT;
	
	// Enable read and check
	`SFIFO_CHK_EN(`ON);
	
	// Perform five random writes
	for (i = 0; i < 5; i = i + 1)
          begin
             `SFIFO_WR($random);
          end
	
	// Enable read and check
	`SFIFO_CHK_EN(`OFF);
	
	`DELAY(5);
	
	`SFIFO_CHK_EN(`ON);
	
	// One more write
	`SFIFO_WR($random);
	
	// Delay a bit
	`DELAY(20);
	
	`FINISH;
     end      
   
endmodule // sfifo_rw_tst
