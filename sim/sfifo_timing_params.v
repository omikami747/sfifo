//------------------------------------------------------------------------------
// Timing parameters for the simulation environment
//
// Author: Vijay A. Nebhrajani
// Email:  vijay.nebhrajani@gmail.com
// Date:   July 12, 2022
//------------------------------------------------------------------------------

parameter t_clk_low  = 5;
parameter t_clk_high = 5;
parameter t_s        = 0.2  * (t_clk_low + t_clk_high);
parameter t_h        = 0.1  * (t_clk_low + t_clk_high);
parameter t_cq       = 0.15 * (t_clk_low + t_clk_high);
  
