* FILE: task2.sp
* Sense Amp Worst-case Delay Measurements

******************* default header for EE313 ******************
.include '/usr/class/ee313/ee313_spice_header.h'
*********************** end header ******************************
.param tcyc = 1ns
.param trf = 50ps
.param vdiff = 50mV
.param offset_wordline=0
.param offset_bitline=0
.include 'full.ckt'
.include '/usr/class/ee313/project/stimulus.sp'

* generate sae
.SUBCKT sae_gen out
Vsrc src gnd PULSE(0 'supply' 'tcyc/2' trf trf 'tcyc/2-trf' tcyc)
Xgen src out signal_gen
.ENDS
Xsae_gen sae sae_gen

* generate sapc_b
.SUBCKT sapc_b_gen out
Vsrc src gnd PULSE(0 'supply' 'tcyc/2-tcyc/8' trf trf 'tcyc/2-trf+tcyc/4' tcyc)
Xgen src out signal_gen
.ENDS
Xsapc_b_gen sapc_b sapc_b_gen

Vbl  bl0 gnd 'supply-vdiff'
Vblb bl_b0 gnd 'supply'
Vslb sel_b0 gnd 0

.tran 'trf/100' 'tcyc/2+4*tcyc'

.meas TRAN tdly
+ TRIG v(sae)   VAL='supply/2' rise=2
+ TARG v(out_b) VAL='supply/2' rise=2

.meas TRAN switch_power
+	AVG i(V_supply1) FROM='2*tcyc' TO='3*tcyc'

.meas TRAN sae_power
+	AVG i(Xsae_gen.Xgen.V_monitor) FROM='2*tcyc' TO='3*tcyc'

.meas TRAN sapc_b_power
+	AVG i(Xsapc_b_gen.Xgen.V_monitor) FROM='2*tcyc' TO='3*tcyc'

.END
***********************************************************************
* End of Deck
***********************************************************************

  
