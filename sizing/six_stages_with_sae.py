'''
  simulate a static 8-stage decoder
'''

from path import Path
from stage import nand, inv, nor

def sae_chain():
  '''
    size and return a schematic with the sae chain
  '''
  # build the model
  p = Path(4, 1576)
  p.stages = [nand(2, fast_fall=True),
              inv(fast_rise=True),
              inv(fast_fall=True),
              inv(fast_rise=True)]
  # add a side load of 1024 lambda at the last nand
  print "path effort: %0.01f" % p.pathEffort()
  print "stage effort: %0.02f" % p.optimalStageEffort()
  p.size()
  p.show()
  #sizes = p.getSizes()
  #template = open('sae_chain.ckt.in').read()
  #out = open('sae_chain.ckt', 'w')
  #out.write(template.format(**sizes))
  out = '''
.subckt sae_inv_chain sae wl wl_pulldown sae_b
x123 sae wl net_sae_1 {nand_pcell}
x124 net_sae_1 net_sae_2 {inv_pcell1}
x125 net_sae_2 sae_b {inv_pcell2}
x126 sae_b wl_pulldown {inv_pcell3}
.ends sae_inv_chain
'''
  names = {'nand_pcell': p.stages[0].getName(),
           'inv_pcell1': p.stages[1].getName(),
           'inv_pcell2': p.stages[2].getName(),
           'inv_pcell3': p.stages[3].getName()}
  out = out.format(**names)

  for i in p.stages:
    out += i.instantiate()
  return out


def main():
  # build the model
  p = Path(12, 3218)
  p.stages = [nand(3, fast_fall=True),
              inv(be=4, fast_rise=True),
              nand(3, fast_fall=True),
              inv(be=16, fast_rise=True),
              nand(2, fast_fall=True),
              nor(2, fast_rise=True)]
  # add a side load of 1024 lambda at the last nand
  p.sideloads[3] = 731
  print "path effort: %0.01f" % p.pathEffort()
  print "stage effort: %0.02f" % p.optimalStageEffort()
  p.size()
  p.show()
  sizes = p.getSizes()
  sizes['sae_wn'] = 400
  template = open('decode_6s_with_nor.ckt.in').read()
  template += sae_chain()
  out = open('decode_with_nor.ckt', 'w')
  out.write(template.format(**sizes))

if __name__ == '__main__':
  main()
