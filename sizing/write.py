'''
  simulate a static 8-stage decoder
'''

from path import Path
from stage import nand, inv, pmos

def main():
  # build the model
  p = Path(180, 7461)
  p.stages = [inv(),
              inv(),
              inv(),
              pmos(reduction=0.8)]
  p.sideload(1, 180)
  p.sideload(1, 1823)
  # add a side load of 1024 lambda at the last nand
  print "path effort: %0.01f" % p.pathEffort()
  print "stage effort: %0.02f" % p.optimalStageEffort()
  p.size()
  p.show()
  sizes = p.getSizes()
  
  r = 0.3
  while r <= 1:
    p.stages[-1].reduction = r
    p.size()
    delay = p.totalDelay()
    print r, delay
    r += 0.01

  #template = open('decode_6s.ckt.in').read()
  #out = open('decode.ckt', 'w')
  #out.write(template.format(**sizes))

if __name__ == '__main__':
  main()
