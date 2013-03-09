'''
  simulate a static 8-stage decoder
'''

from path import Path
from stage import nand, inv

def main():
  # build the model
  p = Path(12, 3218)
  p.stages = [nand(3, fast_fall=True),
              inv(be=4, fast_rise=True),
              nand(2, fast_fall=True),
              inv(fast_rise=True),
              inv(fast_fall=True),
              inv(be=16, fast_rise=True),
              nand(2, fast_fall=True),
              inv(fast_rise=True)]
  # add a side load of 1024 lambda at the last nand
  p.sideloads[5] = 731
  print "path effort: %0.01f" % p.pathEffort()
  print "stage effort: %0.02f" % p.optimalStageEffort()
  p.size()
  p.show()
  sizes = p.getSizes()
  template = open('decode_8s.ckt.in').read()
  out = open('decode_8s.ckt', 'w')
  out.write(template.format(**sizes))


if __name__ == '__main__':
  main()
