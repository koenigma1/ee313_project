* FILE: task5rd.sp
* Worst-case read minimum operating voltage

******************* default header for EE313 ******************
.include '/usr/class/ee313/ee313_spice_header.h'
*********************** end header ******************************
.param tcyc = 1ns
.param trf = 50ps
.param vsense = 150m
.param td = 180ps


.include 'schem.task1.ckt'
.include 'sizes.inc'
.include './project.task5.ckt'
.include '/usr/class/ee313/project/stimulus.sp'
.param supply = 0.65

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

* Generate blpc_b signal
.SUBCKT blpc_b_gen out
Vsrc src gnd PULSE (0 'supply' 'tcyc/2+td-trf' trf trf 'tcyc/2-trf+2*trf' tcyc)
Xgen src out signal_gen
.ENDS
Xblpc_b_gen blpc_b blpc_b_gen

* Disable write
Vwren wren gnd 0

.tran 'trf/100' '4*tcyc+tcyc/2'

.meas TRAN td_ck2wlr
+ TRIG v(ck)	    VAL='supply/2' rise=1
+ TARG v(wl0)       VAL='supply/2' rise=1

.meas TRAN td_ck2wlf   
+ TRIG v(ck)        VAL='supply/2' fall=1
+ TARG v(wl0)	    VAL='supply/2' fall=1

* Measure delay from wordline to bitline split vsense on the second
* cycle. If failed means destructive read during the first cycle
.meas TRAN td_wl2bl
+ TRIG v(wl0)        VAL='supply/2' rise=2
+ TARG v(bl0,bl_b0)  VAL='vsense'   rise=2

* Measure max/min voltage inside top left cell
* If max_bit_b > 5/6Vdd destructive read detected
* If td_wl2bl failed, but max_bit_b is not close to supply, something
* unexcepted is going on. Check waveform in CSCOPE.
.meas TRAN max_bit_b MAX v(xctl.bit_b)
.meas TRAN min_bit   MIN v(xctl.bit)

* Report Supply Voltage
.meas TRAN supply_voltage AVG v(vdd!)

.END
***********************************************************************
* End of Deck
***********************************************************************

  
