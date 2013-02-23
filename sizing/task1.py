'''
  simulate a static 8-stage decoder
'''

from path import Path
from stage import nand, inv

def main():
  # build the model
  p = Path(24, 4505.6)
  p.stages = [nand(3, be=2),
              inv(),
              nand(2, be=4),
              inv(),
              inv(),
              inv(),
              nand(2, be=16),
              inv()]
  print "path effort:", p.pathEffort()
  print "stage effort:", p.optimalStageEffort()
  p.size()
  p.show()


if __name__ == '__main__':
  main()
