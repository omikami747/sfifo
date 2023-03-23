`include "/home/kali/GOALS/fifo/sim/sfifo_sim.vh"
module sfifo_alt_rw_tst;
   
`include "/home/kali/GOALS/fifo/test/sfifo_simtasks.sv"
   integer i;
   
   initial
     begin
	$dumpvars;
	
	// Initialize (reset etc)
	`SFIFO_INIT;
	
	// Perform 64 writes
	for (i = 0; i < 64; i++)
          begin
             `SFIFO_WR($random);
             `SFIFO_CHK_EN(`OFF);
             `DELAY(4);
             `SFIFO_CHK_EN(`ON);
             `DELAY(4);
          end
	
	// Delay a bit
	`DELAY(100);
	
	`FINISH;
     end
   
endmodule // sfifo_rw_tst
