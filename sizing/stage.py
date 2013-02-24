'''
  name: stage.py
  author: Mark Koenig
  model a stage using velocity saturation model 
'''

ECL_NMOS = 0.5
ECL_PMOS = 1.3
VDD = 1.0
VTH = 0.3
P_TO_N = 3
C_GATE = 1.4
C_JUNCTION = 1.2
# constants for skew
MIN_W = 0.5

class Stage():
  def __init__(self, be=1):
    self.gamma = self.c_para / self.c_gate
    self.be = be
    self.le = (self.w_n + self.w_p) / (1 + P_TO_N)

  def size_stack(self, n, vdd, vth, ecl):
    diff = vdd-vth
    return (diff + n*ecl)/(diff + ecl)

  def size(self, se, load):
    # SE = LE * BE * load/in
    # in = (LE * BE * load) / SE
    self.Cin = (self.le * self.be * load) / se
    # split the input load between w_p and w_n
    self.M = self.Cin / (self.w_p + self.w_n)
    self.se = se
    return self.Cin

  def show(self):
    out = [self.name,
           "%i" % round(self.w_n*self.M),
           "%i" % round(self.w_p*self.M),
           "%i" % round(self.Cin),
           "%i" % self.be,
           "%0.02f" % self.le,
           "%0.02f" % self.gamma,
           "%0.02f" % self.se,
           "%0.02f" % (self.le*self.gamma),
           "%0.02f" % (self.se+self.le*self.gamma),
           "%0.02f" % (0.2*(self.se+self.le*self.gamma))]
    print "\t".join(out)

  def delay(self):
    return (self.se, self.le*self.gamma)

class nand(Stage):
  def __init__(self, n, be=1, fast_rise=False, fast_fall=False):
    self.name = "nand%i" % n 
    self.w_n = self.size_stack(n, VDD, VTH, ECL_NMOS)
    self.w_p = P_TO_N
    if fast_fall:
      self.w_p = MIN_W
    if fast_rise:
      self.w_n = MIN_W
    self.c_para = (n*self.w_p + self.w_n) * C_JUNCTION
    self.c_gate = (self.w_p + self.w_n) * C_GATE
    # LE = RCgate / RCgate,inv
    # we sized for equal drive strength to inv, so take Cgate / Cgate,inv
    Stage.__init__(self, be)

class inv(Stage):
  def __init__(self, be=1, fast_rise=False, fast_fall=False):
    self.name = "inv"
    self.w_n = 1
    self.w_p = P_TO_N
    if fast_fall:
      self.w_p = MIN_W
    if fast_rise:
      self.w_n = MIN_W
    self.c_para = (self.w_p + self.w_n) * C_JUNCTION
    self.c_gate = (self.w_p + self.w_n) * C_GATE
    Stage.__init__(self, be)

