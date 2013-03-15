'''
  simulate a static 8-stage decoder
'''

from path import Path
from stage import nand, inv, nor

def main():
  # build the model
  p = Path(12, 3218)
  p.stages = [nand(3, fast_fall=True),
              inv(be=4, fast_rise=True),
              nand(2, fast_fall=True),
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
  out = open('decode_with_nor.ckt', 'w')
  out.write(template.format(**sizes))

if __name__ == '__main__':
  main()
