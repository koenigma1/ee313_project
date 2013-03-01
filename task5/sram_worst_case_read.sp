EE-313 SRAM Noise Analysis 

***************************************************************
*GLOBAL INCLUDES
***************************************************************
.param supply=1.0
.option scale=0.022u
.option accurate post
.option dcic=0
.global vdd! vdd gnd
.option parhier=local
.option list
.option ingold=2
.op
.protect
.lib '/usr/class/ee313/lib/opConditions.lib' TTTT
.unprotect
.param supply=0.69140625
.param supply=0.691
V_supply vdd gnd dc=Supply
V_supply1 vdd! gnd dc=Supply
vgnd gnd 0 0

.option ingold=2

.data opcond
+ supply
0.69140625
0.691
.enddata 

**************************************************************
*NETLISTS
**************************************************************
.include "./schem.SRAM_noise.ckt"
***************************************************************
*PARAMETERS
***************************************************************
.param tcyc = 100n
***************************************************************
*SOURCES AND STIMULI
***************************************************************
* Input list
* address0 address255 ck blcp_b wrdata wren 
* Outputs
* bl0 bl63 bl_b0 bl_b63  
*va0 address0 gnd dc 'supply' 
*va255 address255 gnd dc 0 
vwl0 wl0 gnd dc 'supply' 
vwl255 wl255 gnd dc 0 
vwrdata wrdata gnd dc 'supply' 
vwen wren gnd dc 0 
Vck ck gnd     pulse( 0 'supply'  500ps 50ps 50ps '0.5*tcyc' 'tcyc')
Vblpc_b blpc_b gnd pulse( 0 'supply'  500ps 50ps 50ps '0.5*tcyc' 'tcyc')     
***************************************************************
*INITIAL CONDITIONS
***************************************************************
.ic v(xctl.bit)  = 'supply'
.ic v(xctl.bit_b)= 0
***************************************************************
*ANALYSIS
***************************************************************
.tran '0.01*tcyc' 'tcyc' SWEEP data=opcond 

*************************************************************
*PROCESS RESULTS
*************************************************************

*MEASUREMENTS
.meas TRAN max_bit_b MAX v(xctl.bit_b)
.end 
