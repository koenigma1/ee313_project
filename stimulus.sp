* FILE: stimulus.sp

**********************************************************************
* External pin:
* ck: clock signal at 1GHz
* a0: address pin 0
* a255: address pin 255
* a0 and a255 alternate every other clock cycle
* Need to define cycle time tcyc, and rise
* fall time trf externally
**********************************************************************

.SUBCKT inv_stimulus in out WP=24 LP=2 WN=8 LN=2
* seperate stimulus power from main supply
Vstimulus_supply vdd_stimulus gnd 'supply'
M_0 out in gnd gnd NMOS W=WN L=LN GEOMOD=0 
M_1 out in vdd_stimulus vdd_stimulus PMOS W=WP L=LP GEOMOD=0 
.ENDS

.SUBCKT inv_chain_stimulus in out
X_0 in net_1 inv_stimulus M=1
X_1 net_1 out inv_stimulus M=4
X_2 out net_3 inv_stimulus M=16
X_3 net_3 net_4 inv_stimulus M=64
.ENDS

.SUBCKT signal_gen in out
X_0 in net_2 inv_chain_stimulus
E_0 net_3 gnd net_2 gnd 1 
V_sense net_3 out 0  
V_monitor net_4 gnd 'supply'
F_0 net_4 gnd V_sense -0.5 abs=1
F_1 net_4 gnd V_sense -0.5
.ENDS

* start main CELL clock
.SUBCKT clk_gen out
Vsrc src  gnd pulse 0 'supply' 'tcyc/2' trf trf 'tcyc/2-trf' tcyc
Xgen src out signal_gen
.ENDS

* start main CELL a0
.SUBCKT a0_gen out
Vsrc src gnd pulse 0 'supply' 'tcyc/2-tcyc/8' trf trf 'tcyc-trf' '2*tcyc'
Xgen src out signal_gen
.ENDS

* start main CELL a255
.SUBCKT a255_gen out
Vsrc src gnd pulse 0 'supply' 'tcyc/2+tcyc-tcyc/8' trf trf 'tcyc-trf' '2*tcyc'
Xgen src out signal_gen
.ENDS

* generate clock and address signal
Xclk_gen ck clk_gen
Xa0_gen a0 a0_gen
Xa255_gen a255 a255_gen
