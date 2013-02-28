EE-313 Sense Amplifier Analysis 

***************************************************************
*GLOBAL INCLUDES
***************************************************************
.include "$EE313_HOME/ee313_spice_header.h"

**************************************************************
*NETLISTS
**************************************************************
.include "./schem.task3.ckt"
.include "./sizes.inc"
***************************************************************
*PARAMETERS
***************************************************************
.param diff='0'
.param diff_b='0'
.param half_vdd='supply*0.5'

***************************************************************
*SOURCES AND STIMULI
***************************************************************
* Input list
* address0 address255 ck blcp_b 
* Outputs
* bl0 bl63 bl_b0 bl_b63  
vdc3 address0 gnd pwl (0 'supply' 1300ps 'supply' 1350ps 0) 
vdc4 address255 gnd pwl ( 0 0 1300ps 0 1350ps 'supply')  
Vck ck gnd     pulse( 0 'supply'  500ps 50ps 50ps 500ps 1000ps)
Vblpc_b blpc_b gnd pulse( 0 'supply'  500ps 50ps 50ps 500ps 1000ps)     

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
.tran 1p 2.5n 
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
.meas   tran  read_1_diff_delay trig v(ck) val='half_vdd' rise=1
+                     targ v(bl0,bl_b0) val='0.15' rise=1
.meas   tran  wl0_delay trig v(ck) val='half_vdd' rise=1
+                     targ v(wl0) val='half_vdd' rise=1
.meas   tran  read_0_diff_delay trig v(ck) val='half_vdd' rise=2
+                     targ v(bl0,bl_b0) val='-0.15' fall=1
.meas   tran  wl255_delay trig v(ck) val='half_vdd' rise=2
+                     targ v(wl255) val='half_vdd' rise=1

.end
