'''
  simulate a static 8-stage decoder
'''

from path import Path
from stage import nand, inv

def main():
  # build the model
  p = Path(12, 4505.6)
  p.stages = [nand(3, fast_fall=True),
              nand(3, fast_rise=True),
              nand(2, fast_fall=True),
              nand(2, fast_rise=True),
              inv(fast_fall=True),
              inv(fast_rise=True)]

  # add a side load of 1024 lambda at the last nand
  p.size()
  p.show()


if __name__ == '__main__':
  main()
