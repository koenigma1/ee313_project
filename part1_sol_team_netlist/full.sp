* FILE: sense_timing.sp
* SAE Generation 

******************* default header for EE313 ******************
.include '/usr/class/ee313/ee313_spice_header.h'
*********************** end header ******************************
.param tcyc = 1ns
.param trf = 50ps
.param vsense=150m
.param td=180ps
.param dc1='supply'
.param dc2='supply'
.param dc3='supply'
.param dc4='supply'
.param vsw=0.5102
.param offset_wordline=0
.param offset_bitline=0
Vdc1 D1en_b gnd dc='dc1' 
Vdc2 D2en_b gnd dc='dc2'
Vdc3 D3en_b gnd dc='dc3'
Vdc4 D4en_b gnd dc='dc4'

.include 'full.ckt'
.include '/usr/class/ee313/project/stimulus.sp'

* initialize control cells
.ic v(xctl.bit)  = 'supply'
.ic v(xctl.bit_b)= 0
.ic v(xctr.bit)  = 0
.ic v(xctr.bit_b)= 'supply'
.ic v(xcbl.bit)  = 0
.ic v(xcbl.bit_b)= 'supply'
.ic v(xcbr.bit)  = 'supply'
.ic v(xcbr.bit_b)= 0

* initialize other cells
.ic v(xi1.bit) = 'supply'
.ic v(xi1.bit_b) = 0
.ic v(xi2.bit) = 0
.ic v(xi2.bit_b) = 'supply'
.ic v(xi3.bit) = 'supply'
.ic v(xi3.bit_b) = 0
.ic v(xi4.bit) = 'supply'
.ic v(xi4.bit_b) = 0
.ic v(xi5.bit) = 'supply'
.ic v(xi5.bit_b) = 0
.ic v(xReplica.xFirst_rbit.bit) = 0
.ic v(xReplica.xFirst_rbit.bit_b) = 'supply'
* Generate blpc_b signal
.SUBCKT blpc_b_gen out
Vsrc src gnd PULSE (0 'supply' 'tcyc/2+td-trf' trf trf 'tcyc/2-trf+2*trf' tcyc)
Xgen src out signal_gen
.ENDS
Xblpc_b_gen blpc_b blpc_b_gen

.data tune_delay
+	dc1     dc2     dc3      dc4
	1.0   	 1.0  	  1.0       1.0
	0	 1.0   	  1.0       1.0
	0	 0	  1.0       1.0
	0	 0	  0	    1.0
	0	 0	  0	    0 
.enddata

*.tran 'trf/100' '10*tcyc+tcyc/2' 
.tran 'trf/100' '10*tcyc+tcyc/2' SWEEP data=tune_delay

** SAE Generation
.meas TRAN td_ck2sae
+ TRIG v(ck)	    VAL='supply/2' rise=1
+ TARG v(sae)       VAL='supply/2' rise=1
.meas TRAN td_rbl2sae
+ TRIG v(rbl)	    VAL='supply/2' fall=1
+ TARG v(sae)       VAL='supply/2' rise=1
.meas TRAN td_ck2rbl
+ TRIG v(ck)	    VAL='supply/2' rise=1
+ TARG v(rbl)       VAL='supply-vsw' fall=1
**
.meas TRAN td_ck2wlr
+ TRIG v(ck)	    VAL='supply/2' rise=1
+ TARG v(wl0)       VAL='supply/2' rise=1

.meas TRAN td_ck2wlf   
+ TRIG v(ck)        VAL='supply/2' fall=1
+ TARG v(wl0)	    VAL='supply/2' fall=1

.meas TRAN td_wl2bl0
+ TRIG v(wl0)       VAL='supply/2' rise=1
+ TARG v(bl0,bl_b0) VAL='vsense'   rise=1

.meas TRAN td_ck2bl0
+ TRIG v(ck)        VAL='supply/2' rise=1
+ TARG v(bl0,bl_b0) VAL='vsense'   rise=1

.meas TRAN td_wl2bl63
+ TRIG v(wl0)       VAL='supply/2' rise=1
+ TARG v(bl_b63,bl63) VAL='vsense'   rise=1

.meas TRAN td_ck2bl63
+ TRIG v(ck)        VAL='supply/2' rise=1
+ TARG v(bl_b63,bl63) VAL='vsense'   rise=1

.meas TRAN wl_pw
+ TRIG v(wl0) VAL='supply/2' rise=1
+ TARG v(wl0) VAL='supply/2' fall=1

* power measurement
.probe idrive = par('i(xctl.m4)')
.meas TRAN idsat
+	MAX i(xctl.m4)

.meas TRAN mem_core_power
+	AVG i(V_supply) FROM='2*tcyc' TO='3*tcyc'

.meas TRAN blpc_b_power
+	AVG i(Xblpc_b_gen.Xgen.V_monitor) FROM='2*tcyc' TO='3*tcyc'


.END
***********************************************************************
* End of Deck
***********************************************************************

  
