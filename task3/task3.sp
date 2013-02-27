EE-313 Sense Amplifier Analysis 

***************************************************************
*GLOBAL INCLUDES
***************************************************************
.include "$EE313_HOME/ee313_spice_header.h"

**************************************************************
*NETLISTS
**************************************************************
.include "./schem.task3.ckt"
*sae, sapc_b drivers
*.subckt inv_pcell a y W_P=3 W_N=1
*m1 y a vdd! vdd! pmos L=2 W=W_P
*m2 y a 0 0 nmos L=2 W=W_N
*.ends inv_pcell
*Xsae_driver sae_in sae inv_pcell W_P=6 W_N=2
*Xpc_b_driver sae_in sapc_b inv_pcell W_P=4.5 W_N=1.5

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
* bl0 bl63 bl_b0  
vdc3 address0 gnd dc 'supply' 
vdc4 address255 gnd dc 0  
Vck ck gnd     pwl(  0ns 0   2ns 0
+                       2.1ns 'supply'  7ns 'supply' )
Vblpc_b blpc_b gnd     pwl(  0ns 0   2ns 0
+                       2.1ns 'supply'  7ns 'supply' )

***************************************************************
*INITIAL CONDITIONS
***************************************************************
***************************************************************
*ANALYSIS
***************************************************************
.tran 1p 20n 
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
*DATA FOR SWEEP - ALLOWS simultaneous sweep over many variables
***************************************************************
*************************************************************
*PROCESS RESULTS
*************************************************************

*PROBES for big netlists
*.probe  tran  v(stim) v(stag2) v(stag5)

*MEASUREMENTS
.meas   tran  bl_delay trig v(ck) val='half_vdd' rise=1
+                     targ v(bl_b0) val='supply-0.15' fall=1
*.meas   tran  sense_delay_b trig v(sae) val='half_vdd' rise=1
*+                     targ v(out_b) val='half_vdd' rise=1
*.meas   dc    vsw1  when v(out1,involts)=0  cross=1
*.meas   dc    vfrac1  param='vsw1/supply'
*.meas   tran  rf_ratio  param='t8020/9'
*.MEAS TRAN avgcurr AVG I(v_vddr) FROM=10ns TO=150ns
*.MEAS TRAN avgVout AVG V(out) FROM=10ns TO=150ns
*.MEAS TRAN power PARAM='avgCurr*avgVout'

.end
