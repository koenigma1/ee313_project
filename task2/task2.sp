EE-313 Sense Amplifier Analysis 

***************************************************************
*GLOBAL INCLUDES
***************************************************************
.include "./ee313_spice_header.h"

**************************************************************
*NETLISTS
**************************************************************
.include "./schem.sense.ckt"
*sae, sapc_b drivers
.subckt inv_pcell a y W_P=3 W_N=1
m1 y a vdd! vdd! pmos L=2 W=W_P
m2 y a 0 0 nmos L=2 W=W_N
.ends inv_pcell
Xsae_driver sae_in sae inv_pcell W_P=6 W_N=2
Xsapc_b_driver sae_in sapc_b inv_pcell W_P=4.5 W_N=1.5

***************************************************************
*PARAMETERS
***************************************************************
.param OFFSET_bl=0.1
.param OFFSET_bl_b=0
.param diff='0'
.param diff_b='0'
.param half_vdd='supply*0.5'

***************************************************************
*SOURCES AND STIMULI
***************************************************************
* Input list
* bl0, bl_b0, sel_b0, sapc_b, sae  
vdc1 bl0 bl0_in dc 'OFFSET_bl-diff' 
vdc2 bl_b0 bl_b0_in  dc 0 'OFFSET_bl_b-diff_b'
vdc3 bl0_in gnd dc 'supply' 
vdc4 bl_b0_in gnd dc 'supply' 
vdc5 sel_b0 gnd dc 0 
Vsapc_b sae_in gnd     pwl(  0ns 'supply'   20ps 'supply'
+                       25ps 0  70ps 0 )

***************************************************************
*INITIAL CONDITIONS
***************************************************************
***************************************************************
*ANALYSIS
***************************************************************
.tran 1p 0.3n SWEEP data=cases

***************************************************************
*DATA FOR SWEEP - ALLOWS simultaneous sweep over many variables
***************************************************************
.data cases
+ diff diff_b OFFSET_bl OFFSET_bl_b
 0.05	0	0.1	0
 0	0.05	0	0.1
 0.05	0	0	0
 0	0.05	0	0
.enddata 
.print param(diff+OFFSET_bl)
.print param(diff_b+OFFSET_bl_b)
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
.meas   tran  sense_delay trig v(sae) val='half_vdd' rise=1
+                     targ v(out) val='half_vdd' rise=1
*.meas   dc    vsw1  when v(out1,involts)=0  cross=1
*.meas   dc    vfrac1  param='vsw1/supply'
*.meas   tran  rf_ratio  param='t8020/9'
*.MEAS TRAN avgcurr AVG I(v_vddr) FROM=10ns TO=150ns
*.MEAS TRAN avgVout AVG V(out) FROM=10ns TO=150ns
*.MEAS TRAN power PARAM='avgCurr*avgVout'

.end
