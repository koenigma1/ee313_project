'''
  simulate a static 8-stage decoder
'''

from path import Path
from stage import nand, inv

def main():
  # build the model
  p = Path(4, 153.02/0.022/1.4)
  p.stages = [inv(fast_rise=True),
	      inv(fast_fall=True),
	      inv(fast_rise=True),
	      inv(fast_fall=True),
	      inv(fast_rise=True),
	      ]
  # add a side load of 1024 lambda at the last nand
#  p.sideloads[5] = 1024
  print "path effort: %0.01f" % p.pathEffort()
  print "stage effort: %0.02f" % p.optimalStageEffort()
  p.size()
  p.show()


if __name__ == '__main__':
  main()
