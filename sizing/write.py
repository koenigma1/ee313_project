'''
  simulate a static 8-stage decoder
'''

from path import Path
from stage import nand, inv, pmos

def reduceSize():
  r = 0.1
  while r <= 1:
    p.stages[-1].reduction = r
    p.size()
    delay = p.totalDelay()
    print r, delay
    r += 0.01

 

def main():
  # build the model
  short = Path(180, 7461)
  short.stages = [inv(),
              inv(),
              pmos(reduction=0.3)]
  short.sideload(1, 180)
  short.size()
  print "short inverter chain"
  print "path effort: %0.01f" % short.pathEffort()
  short.show()

  p = Path(180, 7461)
  p.stages = [inv(),
              inv(),
              inv(),
              pmos(reduction=0.25)]
  p.sideload(1, 180)
  p.sideload(1, short.stages[-1].getSizeP())
  # add a side load of 1024 lambda at the last nand
  print ""
  print "long inverter chain"
  print "path effort: %0.01f" % p.pathEffort()
  p.size()
  p.show()
  sizes = p.getSizes()
  out = '''
** Library name: schem
** Cell name: write
** View name: schematic
.subckt write bl0 bl_b0 blpc_b wrdata wren0 vcell inh_bulk_n inh_bulk_p
m5 bl0 blpc_b vdd! inh_bulk_p pmos L=2 W=80
m1 bl0 blpc_b bl_b0 inh_bulk_p pmos L=2 W=80
m0 bl_b0 blpc_b vdd! inh_bulk_p pmos L=2 W=80
m4 net23 wr2 bl_b0 inh_bulk_n nmos L=2 W=90
m3 net26 wr2 bl0 inh_bulk_n nmos L=2 W=90
xu0 wrdata net18 inv_pcell_13
xu2 wrdata net23 inv_pcell_14
xu1 net18 net26 inv_pcell_14
xu3 wren0 wr1 {inv_1}
xu4 wr1 wr2 {inv_2}
xu5 wr2 wr3 {inv_3}
m6 vcell wr2 Vcc_hi Vcc_hi pmos L=2 W={pmos_1}
m7 vcell wr3 Vcc_lo Vcc_hi pmos L=2 W={pmos_2}
.ends write
** End of subcircuit definition.

** Library name: ee313
** Cell name: inv
** View name: schematic
.subckt inv_pcell_13 a y
m1 y a vdd! vdd! pmos L=2 W=8
m2 y a 0 0 nmos L=2 W=4
.ends inv_pcell_13
** End of subcircuit definition.

** Library name: ee313
** Cell name: inv
** View name: schematic
.subckt inv_pcell_14 a y
m1 y a vdd! vdd! pmos L=2 W=12
m2 y a 0 0 nmos L=2 W=24
.ends inv_pcell_14
** End of subcircuit definition.
'''
  sizes = {'inv_1': p.stages[0].getName(),
           'inv_2': p.stages[1].getName(),
           'inv_3': p.stages[2].getName(),
           'pmos_1': short.stages[-1].getSizeP(),
           'pmos_2': p.stages[3].getSizeP()}
  out = out.format(**sizes)

  for stage in p.stages[0:3]:
    out += stage.instantiate()
  print out 
  open('../part1_sol_team_netlist/write.ckt', 'w').write(out) 

  #template = open('decode_6s.ckt.in').read()
  #out = open('decode.ckt', 'w')
  #out.write(template.format(**sizes))

if __name__ == '__main__':
  main()
