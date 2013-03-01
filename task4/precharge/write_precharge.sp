EE-313 Sense Amplifier Analysis 

***************************************************************
*GLOBAL INCLUDES
***************************************************************
.include "$EE313_HOME/ee313_spice_header.h"

**************************************************************
*NETLISTS
**************************************************************
.include "./schem.SRAM.ckt"
***************************************************************
*PARAMETERS
***************************************************************
.param half_vdd='supply*0.5'
***************************************************************
*SOURCES AND STIMULI
***************************************************************
* Input list
* address0 address255 ck blcp_b 
* Outputs
* bl0 bl63 bl_b0 bl_b63
*vdc3 address0 gnd pwl (0 'supply' 1300ps 'supply' 1350ps 0) 
*vdc4 address255 gnd pwl ( 0 0 1300ps 0 1350ps 'supply')  
*Vck ck gnd     pulse( 0 'supply'  500ps 50ps 50ps 500ps 1000ps)
Vwl0 wl0 gnd pulse( 0 'supply'  500ps 50ps 50ps 500ps 1000ps)     
Vblpc_b blpc_b gnd pulse( 0 'supply'  500ps 50ps 50ps 500ps 1000ps)     
Vwl255 wl255 gnd dc 0 
Vsapc_b sapc_b gnd dc 'supply'
Vsae	sae    gnd dc 'supply'
***************************************************************
*INITIAL CONDITIONS
***************************************************************
.ic xiTOP_LEFT.bit = 0
.ic .iTOP_LEFT.bit_b = 'supply'
***************************************************************
*ANALYSIS
***************************************************************
.tran 1p 2.7n 
***************************************************************
*DATA FOR SWEEP - ALLOWS simultaneous sweep over many variables
***************************************************************
.print tran I1(xi14.m0)
.print tran I1(xi14.m2)
.print tran I1(xiTOP_LEFT.m5)
*************************************************************
*PROCESS RESULTS
*************************************************************

*PROBES for big netlists
*.probe  tran  v(stim) v(stag2) v(stag5)

*MEASUREMENTS
* Measure Top row delays 
.measure avg_I_blpc_b AVG i(Vblpc_b) FROM=500ps TO=1600ps
.measure avg_I_bl0 AVG i(xi14.vbl) FROM=500ps TO=1600ps
.measure avg_I_pdn AVG I1(xiTOP_LEFT.m5) FROM=500ps TO=1600ps
.end
