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
.op
.protect
.lib '/usr/class/ee313/lib/opConditions.lib' SFTT
.unprotect
.param supply=0.623828125
.param supply=0.623
V_supply vdd gnd dc=Supply
V_supply1 vdd! gnd dc=Supply
vgnd gnd 0 0
.option ingold=2

.data opcond
+ supply
0.623828125
0.623	
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
vwl0 wl0 gnd dc 0 
vwl255 wl255 gnd dc 'supply' 
vwrdata wrdata gnd dc 0 
vwen wren gnd dc 'supply' 
Vck ck gnd     pulse( 0 'supply'  500ps 50ps 50ps '0.5*tcyc' 'tcyc')
Vblpc_b blpc_b gnd pulse( 0 'supply'  500ps 50ps 50ps '0.5*tcyc' 'tcyc')     
***************************************************************
*INITIAL CONDITIONS
***************************************************************
.ic v(xcbr.bit)  = 'supply'
.ic v(xcbr.bit_b)= 0
***************************************************************
*ANALYSIS
***************************************************************
.tran '0.05*tcyc' 'tcyc' SWEEP data=opcond 

*************************************************************
*PROCESS RESULTS
*************************************************************

*MEASUREMENTS
.meas TRAN max_bit_b MAX v(xcbr.bit_b)
.end 
