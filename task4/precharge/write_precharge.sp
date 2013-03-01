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
Vck ck gnd     pulse( 0 'supply'  500ps 50ps 50ps 500ps 1000ps)
Vblpc_b blpc_b gnd pulse( 0 'supply'  500ps 50ps 50ps 500ps 1000ps)     
Vsapc_b sapc_b gnd pulse( 0 'supply'  500ps 50ps 50ps 500ps 1000ps)     
Vsae	sae    gnd pulse( 0 'supply'  500ps 50ps 50ps 500ps 1000ps)     

***************************************************************
*INITIAL CONDITIONS
***************************************************************
.ic xiSRAM.xiTOP_LEFT.bit = 'supply'
.ic xiSRAM.xiTOP_LEFT.bit_b = 0 
.ic xiSRAM.xiTOP_RIGHT.bit = 0 
.ic xiSRAM.xiTOP_RIGHT.bit_b = 'supply' 

.ic xiSRAM.xiBOTTOM_LEFT.bit = 0 
.ic xiSRAM.xiBOTTOM_LEFT.bit_b = 'supply' 
.ic xiSRAM.xiBOTTOM_RIGHT.bit = 'supply' 
.ic xiSRAM.xiBOTTOM_RIGHT.bit_b = 0 
***************************************************************
*ANALYSIS
***************************************************************
.tran 1p 2.7n 
***************************************************************
*DATA FOR SWEEP - ALLOWS simultaneous sweep over many variables
***************************************************************
.print tran I1(xiSRAM.xiTOP_LEFT.m5)
.print tran I1(xiSRAM.xiTOP_LEFT.m4)
*************************************************************
*PROCESS RESULTS
*************************************************************

*PROBES for big netlists
*.probe  tran  v(stim) v(stag2) v(stag5)

*MEASUREMENTS
* Measure Top row delays 
.measure avg_I_blpc_b INTEG i(Vblpc_b) FROM=500ps TO=1600ps
.measure max_I_blpc_b MAX i(Vblpc_b) FROM=500ps TO=1600ps
.measure min_I_blpc_b MIN i(Vblpc_b) FROM=500ps TO=1600ps
.end
