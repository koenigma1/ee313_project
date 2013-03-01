EE-313 Sense Amplifier Analysis 

***************************************************************
*GLOBAL INCLUDES
***************************************************************
.include "$EE313_HOME/ee313_spice_header.h"

**************************************************************
*NETLISTS
**************************************************************
.include "./schem.sense.ckt"
*sae, sapc_b drivers
*.subckt inv_pcell a y W_P=3 W_N=1
*m1 y a vdd! vdd! pmos L=2 W=W_P
*m2 y a 0 0 nmos L=2 W=W_N
*.ends inv_pcell
*Xsae_driver sae_in sae inv_pcell W_P=6 W_N=2
*Xsapc_b_driver sae_in sapc_b inv_pcell W_P=4.5 W_N=1.5

***************************************************************
*PARAMETERS
***************************************************************
.param half_vdd='supply*0.5'

***************************************************************
*SOURCES AND STIMULI
***************************************************************
* Input list
* bl0, bl_b0, sel_b0, sapc_b, sae  
vdc3 bl0 gnd dc 'supply-0.150' 
vdc4 bl_b0 gnd dc 'supply' 
* set sel_b0 low during the time sapc_b is low
vdc5 sel_b0 gnd pwl( 0ns 'supply' 5ps 'supply' 10ps 0 490ps 0 495ps 'supply'  
Vsapc_b sapc_b gnd     pwl(  0ns 'supply'   20ps 'supply'
+                       25ps 0  475ps 0 480ps 'supply')
Vsae sae gnd     pwl(  0ns 'supply'   20ps 'supply'
+                       25ps 0  475ps 0 480ps 'supply')
Vdd vdd_m gnd dc 'supply'

***************************************************************
*INITIAL CONDITIONS
***************************************************************
***************************************************************
*ANALYSIS
***************************************************************
.tran 1p 1n

***************************************************************
*DATA FOR SWEEP - ALLOWS simultaneous sweep over many variables
***************************************************************
.print v(sbl)
.print v(sbl_b)
.print v(out)
.print v(out_b)
*************************************************************
*PROCESS RESULTS
*************************************************************

*PROBES for big netlists
*.probe  tran  v(stim) v(stag2) v(stag5)

*MEASUREMENTS
*.meas   tran  sense_delay trig v(sae) val='half_vdd' rise=1
*+                     targ v(out) val='half_vdd' rise=1
*.meas   tran  sense_delay_b trig v(sae) val='half_vdd' rise=1
*+                     targ v(out_b) val='half_vdd' rise=1
.meas   sel_b0_power INTEG i(vdc5) FROM=0 TO=1ns
.meas   Vsapc_b_power INTEG i(Vsapc_b) FROM=0 TO=1ns
.meas   Vsae_power INTEG i(Vsae) FROM=0 TO=1ns
.meas   vdd_power INTEG i(Vdd) FROM=0 TO=1ns

*.meas   dc    vsw1  when v(out1,involts)=0  cross=1
*.meas   dc    vfrac1  param='vsw1/supply'
*.meas   tran  rf_ratio  param='t8020/9'
*.MEAS TRAN avgcurr AVG I(v_vddr) FROM=10ns TO=150ns
*.MEAS TRAN avgVout AVG V(out) FROM=10ns TO=150ns
*.MEAS TRAN power PARAM='avgCurr*avgVout'

.end
