* FILE: task1.sp
* Decoder Design

******************* default header for EE313 ******************
.include '/usr/class/ee313/ee313_spice_header.h'
*********************** end header ******************************
.param tcyc = 1ns
.param trf = 50ps

.include 'schem.task1.ckt'
.include 'sizes.inc'
xi17 wl0 wl255 a0 a255 ck decoder_schematic

.include '/usr/class/ee313/project/stimulus.sp'

* wordline loading
Cwl0 wl0 gnd 99.1fF
Cwl255 wl255 gnd 99.1fF

.tran 'trf/10' '4.5*tcyc'

.meas TRAN tdr
+ TRIG v(ck)  VAL='supply/2' rise=1
+ TARG v(wl0) VAL='supply/2' rise=1

.meas TRAN tdf
+ TRIG v(ck)  VAL='supply/2' fall=1
+ TARG v(wl0) VAL='supply/2' fall=1

.meas TRAN supply_power
+	AVG i(V_supply1) FROM='2*tcyc' TO='3*tcyc'

.meas TRAN ck_power
+	AVG i(Xclk_gen.Xgen.V_monitor) FROM='2*tcyc' TO='3*tcyc'

.END
***********************************************************************
* End of Deck
***********************************************************************

  
