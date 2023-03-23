//------------------------------------------------------------------------------
// Header with some basic tick defines for constants and tasks/functions
//
// Author: Vijay A. Nebhrajani
// Email:  vijay.nebhrajani@gmail.com
// Date:   July 12, 2022
//------------------------------------------------------------------------------

//----------------------------------------------------------------------
// Constants
//----------------------------------------------------------------------
`define OFF   0
`define ON    1
`define FALSE 0
`define TRUE  1

//----------------------------------------------------------------------
// Functions/Tasks
//----------------------------------------------------------------------
`define SFIFO_INIT    sfifo_sim.init
`define SFIFO_WR      sfifo_sim.wrfifo
`define SFIFO_CHK_EN  sfifo_sim.fifo_chk_en
`define DELAY         sfifo_sim.delay
`define FINISH        sfifo_sim.endsim
