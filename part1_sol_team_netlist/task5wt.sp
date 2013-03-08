* FILE: task5wt.sp
* Worst-case write minimum operating voltage

******************* default header for EE313 ******************
.include '/usr/class/ee313/ee313_spice_header.h'
*********************** end header ******************************
.param tcyc = 1n
.param trf = 50ps
.param vsense = 150m
.param td = 180ps


.include 'schem.task1.ckt'
.include 'sizes.inc'
.include './project.task5.ckt'
.include '/usr/class/ee313/project/stimulus.sp'

* initialize control cells
.ic v(xctl.bit) = 'supply'
.ic v(xctl.bit_b) = 0
.ic v(xctr.bit)  = 0
.ic v(xctr.bit_b)= 'supply'
.ic v(xcbl.bit)  = 0
.ic v(xcbl.bit_b)= 'supply'
.ic v(xcbr.bit)  = 'supply'
.ic v(xcbr.bit_b)= 0

* initialize other cells
* initial value for xi2 and xi3 affects
* read speed and vmin by leakage current
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

* Disable blpc_b signal
Vblpc_b blpc_b gnd 'supply'

* Enable write
Vwren wren gnd 'supply'
Vdata wrdata gnd 0

.tran 'trf/100' '4*tcyc+tcyc/2'

.meas TRAN td_ck2wlr
+ TRIG v(ck)	    VAL='supply/2' rise=1
+ TARG v(wl0)       VAL='supply/2' rise=1

.meas TRAN td_ck2wlf   
+ TRIG v(ck)        VAL='supply/2' fall=1
+ TARG v(wl0)	    VAL='supply/2' fall=1

.meas TRAN wl_pw
+ TRIG v(wl255) VAL='supply/2' rise=1
+ TARG v(wl255) VAL='supply/2' fall=1

* Measure max/min voltage inside bottom left cell 
* If max_bit_b < 1/6Vdd, unsuccessful write detected
.meas TRAN max_bit_b MAX v(xcbr.bit_b)
.meas TRAN min_bit   MIN v(xcbr.bit)

* Report Supply Voltage
.meas TRAN supply_voltage AVG v(vdd!)

.END
***********************************************************************
* End of Deck
***********************************************************************

  
