
.param tcyc = 1ns
.param trf = 50ps
.param vsense=150m
.param td=180ps
.param dc1='supply'
.param dc2='supply'
.param dc3='supply'
.param dc4='supply'
.param supply_hi='1.0V'
.param supply_lo='1.0V'
.param offset_wordline=0
.param offset_bitline=0
.param vdiff=0.150
Vdc1 D1en_b gnd dc='dc1'
Vdc2 D2en_b gnd dc='dc2'
Vdc3 D3en_b gnd dc='dc3'
Vdc4 D4en_b gnd dc='dc4'
Vdc_hi vcc_hi gnd dc='supply_hi'
Vdc_lo vcc_lo gnd dc='supply_lo'

