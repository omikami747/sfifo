module sfifo_tb();
   reg tstclk              ;
   reg tstrst              ;
   reg tstwr               ;
   reg [15:0]    tstdin    ;
   wire          tstfull   ;
   wire          tstovfl   ;
   reg           tstrd     ;
   wire [15:0]   tstdout   ; 
   wire          tstempty  ;
   wire          tstudfl   ;

   sfifo dut (
	      .clk(tstclk),
	      .rst(tstrst),
	      .wr(tstwr),
	      .din(tstdin),
	      .full(tstfull),
	      .ovfl(tstovfl),
	      .rd(tstrd),
	      .dout(tstdout),
	      .empty(tstempty),
	      .udfl(tstudfl)
	      );
   always
     begin
	tstclk <= 1'b0 ;
	#5;
	tstclk <= 1'b1 ;
	#5;
     end

   initial
     begin
	$dumpvars;
	
	tstrst <= 1'b0;
	repeat(2)
	  begin
	     @(posedge tstclk)
	       begin
	       end
	  end
	
	tstrst <= 1'b1;
	
	
	tstwr <= 1'b1;
	tstdin <= 'b0;
	repeat(1)
	  begin
	     @(posedge tstclk)
	       begin
	       end
	  end
	tstwr <= 1'b0;
	tstrd <= 1'b1;
	repeat(1)
	  begin
	     @(posedge tstclk)
	       begin
	       end
	  end
	tstrd <= 1'b0;
	#400;
	$finish;
	
     end
endmodule
