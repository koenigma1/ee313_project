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
    print "Stage\tGate\tWp\tWn\tCin\tBE\tLE\tgamma"
    for i,stage in enumerate(self.stages):
      print "%i\t" % i,
      stage.show()
      


