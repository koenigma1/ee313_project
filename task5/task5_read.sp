EE-313 SRAM Noise Analysis 

***************************************************************
*GLOBAL INCLUDES
***************************************************************
.include '/usr/class/ee313/ee313_spice_header.h'

**************************************************************
*NETLISTS
**************************************************************
.include "./schem.SRAM_noise.ckt"
***************************************************************
*PARAMETERS
***************************************************************
.param tcyc = 1n
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
.tran '0.05*tcyc' 'tcyc' 

*************************************************************
*PROCESS RESULTS
*************************************************************

*MEASUREMENTS
.meas TRAN max_bit_b MAX v(xctl.bit_b)
.end 
