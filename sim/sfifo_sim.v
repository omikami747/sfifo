//------------------------------------------------------------------------------
// Simulation Environment Top Level for Synchronous FIFO
//
// Author: Vijay A. Nebhrajani
// Email:  vijay.nebhrajani@gmail.com
// Date:   July 12, 2022
//------------------------------------------------------------------------------

module sfifo_sim;

  reg           rst;
  reg           clk;  
  reg           w_en;
  reg [15:0]     din;
  reg           r_en;
  wire [15:0]    dout;
  wire          full;
  wire          empty;
  wire          ovfl;
  wire          udfl;
  
  event         setup_event;
  event         error_event;
  event         wr_event;
  event         rd_event;
  
  reg           ok_to_read;
  reg           rd_en_d;
  reg           empty_d;
  reg           rd_vld;
  reg           chk_en;
  reg           chk_en_d;
  reg           chk_en_d2;
  reg           checker_was_enabled;

  // Side Channel FIFO
  reg [15:0]     scf_mem [0:127];
  reg [6:0]     scf_wptr;
  reg [6:0]     scf_rptr;
  reg [7:0]     scf_wcnt;
  reg           scf_full;
  reg           scf_empty;
  
  integer       wr_count;
  integer       rd_count;
  
  //----------------------------------------------------------------------
  // Timing parameters
  //----------------------------------------------------------------------
  `include "../sim/sfifo_timing_params.v"

  //----------------------------------------------------------------------
  // Simulation related tasks and functions
  //----------------------------------------------------------------------
  `include "../sim/sfifo_simtasks.v"

  //----------------------------------------------------------------------
  // Clock generation
  //----------------------------------------------------------------------
  always
    begin
      clk <= 1'b0;
      # t_clk_low;
      clk <= 1'b1;
      # t_clk_high;
    end

  //----------------------------------------------------------------------
  // Reset generation
  //----------------------------------------------------------------------
  // initial
  //   begin
  //     rst <= 1'b0;
  //     repeat (4) @ (posedge clk);
  //     rst <= 1'b1;
  //     @ (posedge clk);
  //   end

  //----------------------------------------------------------------------
  // Event for setup alignment
  //----------------------------------------------------------------------
  always @(posedge clk)
    begin
      #(t_clk_low + t_clk_high - t_s);
      -> setup_event;
    end

  //----------------------------------------------------------------------
  // Read process
  //----------------------------------------------------------------------
  always @(posedge clk)
    begin
      if (empty == 1'b0)
        begin
          ok_to_read = 1;
        end
      else
        begin
          ok_to_read = 0;
        end
      
      # t_h;
      r_en = 1'b0;

      if (chk_en == 1'b1)
        begin
          if (ok_to_read == 1'b1)
            begin
              @ setup_event;
              r_en = 1'b1;
            end
        end
    end

  //----------------------------------------------------------------------
  // Read checker
  //----------------------------------------------------------------------
  always @(posedge clk or negedge rst)
    if (rst == 1'b0)
      begin
        rd_en_d   <= 1'b0;
        rd_vld    <= 1'b0;
        chk_en_d  <= 1'b0;
        chk_en_d2 <= 1'b0;
        empty_d   <= 1'b1;
        scf_rptr  <= 7'd0;
      end

    else
      begin
        rd_en_d   <= r_en;
        rd_vld    <= rd_en_d;
        chk_en_d  <= chk_en;
        chk_en_d2 <= chk_en_d;
        empty_d   <= empty;

        if (chk_en_d2 == 1'b1)
          begin
            if ((rd_vld == 1'b1) && (empty_d == 1'b0))
              begin
                -> rd_event;
                rd_count = rd_count + 1;
                if (dout !== scf_mem[scf_rptr])
                  begin
                    $display("At time %0t: ERROR: Data read error, expected 0x%h received 0x%h\n", 
                         $time, scf_mem[scf_rptr], dout);
                    -> error_event;
                  end

                if (scf_rptr == 7'h7F)
                  begin
                    scf_rptr = 7'h00;
                  end
                else
                  begin
                    scf_rptr = scf_rptr + 1'b1;
                  end

              end
          end
      end

  //----------------------------------------------------------------------
  // Side Channel FIFO
  //----------------------------------------------------------------------
  initial
    begin
      scf_wptr = 0;
      scf_wcnt = 0;
    end
  
  always @(posedge clk or negedge rst)
    if (rst == 1'b0)
      begin
        scf_wptr <= 'd0;
        scf_wcnt <= 'd0;
      end
    else
      begin
        if ((w_en == 1'b1) && (r_en == 1'b0))
          begin
            scf_wcnt <= scf_wcnt + 1;
          end
        else if ((w_en == 1'b0) && (r_en == 1'b1))
          begin
            scf_wcnt <= scf_wcnt - 1;
          end
        else
          begin
            scf_wcnt <= scf_wcnt;
          end


        // if (w_en == 1'b1)
        //   scf_wcnt = scf_wcnt + 1;


        // if (r_en == 1'b1)
        //   scf_wcnt = scf_wcnt - 1;

      end // else: !if(rst == 1'b0)

  //----------------------------------------------------------------------
  // Design under test
  //----------------------------------------------------------------------
  sfifo u1_sfifo 
    (.rst(rst),
     .clk(clk),
     .wr_in(w_en),
     .din_in(din),
     .rd_in(r_en),
     .dout(dout),
     .full(full),
     .empty(empty),
     .ovfl(ovfl),
     .udfl(udfl)
    );

endmodule // sfifo_tb
