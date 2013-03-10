'''
  simulate a static 8-stage decoder
'''

from path import Path
from stage import nand, inv, pmos

def main():
  # build the model
  p = Path(12, 7461)
  p.stages = [inv(),
              inv(),
              inv(),
              #inv(),
              pmos()]
  #p.sideload(2, 1425)
  # add a side load of 1024 lambda at the last nand
  print "path effort: %0.01f" % p.pathEffort()
  print "stage effort: %0.02f" % p.optimalStageEffort()
  p.size()
  p.show()
  sizes = p.getSizes()
  #template = open('decode_6s.ckt.in').read()
  #out = open('decode.ckt', 'w')
  #out.write(template.format(**sizes))

if __name__ == '__main__':
  main()
