//------------------------------------------------------------------------------
//  File         : sfifo
//  Author       : Omkar Kamath
//  Date         : 10th February 2023
//  Description  : synchronous first in first out memory module
//  (C) Omkar Kamath, 2022. No part may be reproduced without permission from
//     author.
//------------------------------------------------------------------------------


module sfifo 
  (input         clk,
   input 	 rst,

   // Write side interface
   input 	 wr_in,
   input [15:0]  din_in,
   output reg 	 full,
   output reg	 ovfl,

   // Read side interface
   input 	 rd_in,
   output reg [15:0] dout,
   output reg 	 empty,
   output reg 	 udfl        
  );

   reg [5:0] 	 rd_ptr       ;
   reg [5:0] 	 wr_ptr       ;
   reg 		 rd_cycle     ;
   reg           wr_cycle     ;
   reg [15:0] 	 mem [63:0]   ;

   
   reg 		 wr           ;
   reg [15:0] 	 din          ;
   reg           rd           ;
   

   
   // reg [15:0] 	 dout     ;
   // reg 		 empty    ;
   // reg 		 udfl     ;
   // reg 		 ovfl     ;
   // reg           full     ;
   
   //--------------------------------------------------------------------
   // flop in 
   //--------------------------------------------------------------------

   always @(posedge clk or negedge rst)
     begin
	if ( rst == 1'b0 )
	  begin
	     
	  end
	else
	  begin
	     wr  <= wr_in           ;
	     din <= din_in          ;
	     rd  <= rd_in           ;
	  end
     end
     
   //--------------------------------------------------------------------
   // read address pointer
   //--------------------------------------------------------------------
   
   
   always @( posedge clk or negedge rst )
     begin
	if ( rst == 1'b0 )
	  begin
	     rd_ptr <= 'b0;
	  end
	else
	  begin
	     if ( rd == 1'b1 && empty == 1'b0 )
	       begin
		  rd_ptr <= rd_ptr + 'b1 ;
	       end
	  end // else: !if( rst == 1'b0 )
     end // always @ ( posedge clk or negedge rst )


   //--------------------------------------------------------------------
   // write address pointer
   //--------------------------------------------------------------------


   always @( posedge clk or negedge rst )
     begin
	if ( rst == 1'b0 )
	  begin
	     wr_ptr <= 'b0;
	  end
	else
	  begin
	     if ( wr == 1'b1 && full == 1'b0 )
	       begin
		  wr_ptr <= wr_ptr + 'b1 ;
	       end
	  end // else: !if( rst == 1'b0 )
     end // always @ ( posedge clk or negedge rst )

   
   //--------------------------------------------------------------------
   // even odd read cycle counter
   //--------------------------------------------------------------------

   
   always @( posedge clk or negedge rst )
     begin
	if ( rst == 1'b0 )
	  begin
	     rd_cycle <= 1'b0 ;
	  end
	else
	  begin
	     if ( rd_ptr == 6'b111111 && rd == 1'b1 && empty == 1'b0 )
	       begin
		  rd_cycle <= rd_cycle + 'b1 ;
	       end
	  end // else: !if( rst == 1'b0 )
     end // always @ ( posedge clk or negedge rst )

   
   //--------------------------------------------------------------------
   // even odd write cycle counter
   //--------------------------------------------------------------------

   
   always @( posedge clk or negedge rst )
     begin
	if ( rst == 1'b0 )
	  begin
	     wr_cycle <= 1'b0 ;
	  end
	else
	  begin
	     if ( wr_ptr == 6'b111111 && wr == 1'b1 && full == 1'b0 )
	       begin
		  wr_cycle <= wr_cycle + 'b1 ;
	       end
	  end // else: !if( rst == 1'b0 )
     end // always @ ( posedge clk or negedge rst )
   
   
   //--------------------------------------------------------------------
   // overflow signal
   //--------------------------------------------------------------------  

   
   always @ (*)
     begin
	if ( wr && full == 1'b1 )
	  begin
	     ovfl <= 1'b1;
	  end
	else
	  begin
	     ovfl <= 1'b0;
	  end
     end

   
   //--------------------------------------------------------------------
   // underflow signal
   //--------------------------------------------------------------------  

   
   always @ (*)
     begin
	if ( rd && empty == 1'b1 )
	  begin
	     udfl <= 1'b1;
	  end
	else
	  begin
	     udfl <= 1'b0;
	  end
     end

   
   //--------------------------------------------------------------------
   // full signal
   //--------------------------------------------------------------------


   always @(*)
     begin
	if ( rd_ptr == wr_ptr && rd_cycle ^ wr_cycle == 1'b1 )
	  begin
	     full <= 1'b1  ;
	  end
	else
	  begin
	     full <= 1'b0  ;
	  end
     end // always @ (*)
   
   //--------------------------------------------------------------------
   // empty signal
   //--------------------------------------------------------------------


   always @(*)
     begin
	if ( rd_ptr == wr_ptr && rd_cycle ^ wr_cycle == 1'b0 )
	  begin
	     empty <= 1'b1  ;
	  end
	else
	  begin
	     empty <= 1'b0  ;
	  end
     end // always @ (*)
   
   //--------------------------------------------------------------------
   // data out from the fifo
   //--------------------------------------------------------------------


   always @( posedge clk or negedge rst )
     begin
	if ( rst == 1'b0 )
	  begin
	     
	  end  
	else
	  begin
	     if ( rd == 1'b1 && empty == 1'b0 )
	       begin
		  dout <= mem[rd_ptr] ;
	       end
	     if ( wr == 1'b1 && full == 1'b0 )
	       begin
		  mem[wr_ptr] <= din  ;
	       end
	  end
     end // always @ ( posedge clk or negedge rst )

   //--------------------------------------------------------------------
   // flop out
   //--------------------------------------------------------------------

   
   // //always @(posedge clk or negedge rst)
   // //  begin
   // 	if ( rst == 1'b0 )
   // 	  begin
   // 	  end
   // 	else
   // 	  begin
   // 	     dout_out  <= dout     ;
   // 	     empty_out <= empty    ;
   // 	     udfl_out  <= udfl     ;
   // 	     full_out  <= full     ;
   // 	     ovfl_out  <= ovfl     ;
   // 	  end
   //   end
   
endmodule
