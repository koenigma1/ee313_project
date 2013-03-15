'''
  optimize sizing over a path
'''
import stage

class Path():
  def __init__(self, inputCap, loadCap):
    self.stages = []
    self.sideloads = {}
    self.inputCap = inputCap
    self.loadCap = loadCap

  def sideload(self, index, c):
    self.sideloads[index] = c

  def pathEffort(self):
    return self._pe(self.stages, self.inputCap, self.loadCap)

  def _pe(self, stages, inputCap, load):
    pe = float(load) / inputCap
    for stage in stages:
      pe *= (stage.le*stage.be)
    return pe

  def optimalStageEffort(self):
    return self._se(self.stages, self.inputCap, self.loadCap)

  def _se(self, stages, inputCap, load):
    return self._pe(stages, inputCap, load) ** (1.0/len(stages))
   
  def size(self, start=None, end=None, inputCap=None, loadCap=None):
    if start == None:
      start = 0
      end = len(self.stages)-1
      inputCap = self.inputCap
      loadCap = self.loadCap

    se = self._se(self.stages[start:end+1], inputCap, loadCap)
    lastW = loadCap
    for i in range(end, start-1, -1):
      if i in self.sideloads and i != end and i != start:
        # use recursion to size towards the left
        self.size(0, i, inputCap, lastW + (self.sideloads[i] / self.stages[i].be))
        # then resize towards the right
        self.size(i, end, self.stages[i].Cin, loadCap)
        break
      elif i not in self.sideloads or i != start:
        lastW = self.stages[i].size(se, lastW)

  def getSizes(self):
    '''
      put the sizes in a format we can pass to string.format
    '''
    sizeDict = {}
    for i,stage in enumerate(self.stages):
      sizeDict["s%i_wn" % (i+1)] = '%i' % stage.getSizeN()
      sizeDict["s%i_wp" % (i+1)] = '%i' % stage.getSizeP()
    return sizeDict
  

  def show(self):
    out = ["Stage",
           "Gate",
           "Wn",
           "Wp",
           "Cin",
           "BE",
           "LE",
           "gamma",
           "Effort",
           "Para",
           "Stage",
           "F04"]
    print "\t".join(out)
    for i,stage in enumerate(self.stages):
      print "%i\t" % (i+1),
      stage.show()
  
    effort = 0
    para = 0
    be = 1
    le = 1
    for stage in self.stages:
      (e, p) = stage.delay()
      effort += e
      para += p
      be *= stage.be
      le *= stage.le
    print "total\t\t\t\t\t",
    print "%i\t" % be,
    print "%0.03f\t\t" % le,
    print "%0.02f\t" % effort,
    print "%0.02f\t" % para,
    print "%0.02f\t" % (effort + para),
    print "%0.02f\t" % ((effort + para) / 5)
      

  def totalDelay(self):
    delay = 0
    for stage in self.stages:
      (e, p) = stage.delay()
      delay += e + p
    return delay/5
