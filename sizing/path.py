'''
  optimize sizing over a path
'''


class Path():
  def __init__(self, inputCap, loadCap):
    self.stages = []
    self.inputCap = inputCap
    self.loadCap = loadCap

  def pathEffort(self):
    pe = float(self.loadCap) / self.inputCap
    for stage in self.stages:
      pe *= (stage.le*stage.be)
    self.pe = pe
    return self.pe

  def optimalStageEffort(self):
    self.se = self.pe ** (1.0/len(self.stages))
    return self.se
   
  def size(self):
    self.optimalStageEffort()
    lastW = self.loadCap
    for stage in reversed(self.stages):
      lastW = stage.size(self.se, lastW)

  def show(self):
    out = ["Stage",
           "Gate",
           "Wp",
           "Wn",
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
      


