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

id = 1234

class Stage():
  def __init__(self, be=1, reduction=False):
    self.gamma = self.c_para / self.c_gate
    self.be = be
    self.le = float(self.w_n + self.w_p) / (1 + P_TO_N)
    self.slow_le = self.le
    if hasattr(self, 'w_p_fast'):
      self.slow_le *= float(self.w_p_fast) / self.w_p
    if hasattr(self, 'w_n_fast'):
      self.slow_le *= float(self.w_n_fast) / self.w_n
    self.reduction = reduction
    global id
    self.id = id
    id += 1

  def size_stack(self, n, vdd, vth, ecl):
    diff = vdd-vth
    return (diff + n*ecl)/(diff + ecl)

  def getName(self):
    return "%s_%i" % (self.name, self.id)

  def instantiate(self):
    sizes = {}
    sizes['w_p'] = self.getSizeP()
    sizes['w_n'] = self.getSizeN()
    sizes['name'] = self.getName()
    sizes['m'] = 1
    return self.template.format(**sizes)

  def size(self, se, load):
    # SE = LE * BE * load/in
    # in = (LE * BE * load) / SE
    self.Cin = (self.le * self.be * load) / se
    # split the input load between w_p and w_n
    self.se = se
    if self.reduction:
      self.Cin *= self.reduction
      self.se = (self.le * self.be * load) / self.Cin
    self.M = self.Cin / (self.w_p + self.w_n)
    return self.Cin

  def getSizeN(self):
    return int(round(self.w_n*self.M))

  def getSizeP(self):
    return int(round(self.w_p*self.M))

  def show(self):
    se = self.se * self.slow_le / float(self.le)
    out = [self.name,
           "%i" % self.getSizeN(),
           "%i" % self.getSizeP(),
           "%i" % round(self.Cin),
           "%i" % self.be,
           "%0.03f" % self.le,
           "%0.02f" % self.gamma,
           "%0.02f" % self.se,
           "%0.02f" % (self.le*self.gamma),
           "%0.02f" % (self.se+self.le*self.gamma),
           "%0.02f" % (0.2*(self.se+self.le*self.gamma))]
           #"%0.02f" % se,
           #"%0.02f" % (self.slow_le*self.gamma),
           #"%0.02f" % (se+self.slow_le*self.gamma),
           #"%0.02f" % (0.2*(se+self.slow_le*self.gamma))]
    print "\t".join(out)

  def slow_delay(self):
    se = self.se * self.slow_le / float(self.le)
    return (se, self.slow_le*self.gamma)

  def delay(self):
    return (self.se, self.le*self.gamma)

class nand(Stage):
  def __init__(self, n, be=1, fast_rise=False, fast_fall=False, reduction=False):
    self.name = "nand%i" % n 
    self.w_n = self.size_stack(n, VDD, VTH, ECL_NMOS)
    self.w_p = P_TO_N
    if fast_fall:
      self.w_p_fast = self.w_p
      self.w_p = MIN_W
    if fast_rise:
      self.w_n_fast = self.w_n
      self.w_n = MIN_W
    self.c_para = (n*self.w_p + self.w_n) * C_JUNCTION
    self.c_gate = (self.w_p + self.w_n) * C_GATE
    # LE = RCgate / RCgate,inv
    # we sized for equal drive strength to inv, so take Cgate / Cgate,inv
    Stage.__init__(self, be, reduction)
    self.template='''
.subckt {name} a b y
m2 y b vdd! vdd! pmos L=2 W={w_p} M={m}
m0 y a vdd! vdd! pmos L=2 W={w_p} M={m}
m3 mid_a b 0 0 nmos L=2 W={w_n} M={m}
m1 y a mid_a 0 nmos L=2 W={w_n} M={m}
.ends {name}
'''

class nor(Stage):
  def __init__(self, n, be=1, fast_rise=False, fast_fall=False, reduction=False):
    self.name = "nor%i" % n 
    self.w_n = 1
    self.w_p = P_TO_N*self.size_stack(n, VDD, VTH, ECL_PMOS)
    if fast_fall:
      self.w_p_fast = self.w_p
      self.w_p = MIN_W
    if fast_rise:
      self.w_n_fast = self.w_n
      self.w_n = MIN_W/4
    self.c_para = (self.w_p + n*self.w_n) * C_JUNCTION
    self.c_gate = (self.w_p + self.w_n) * C_GATE
    # LE = RCgate / RCgate,inv
    # we sized for equal drive strength to inv, so take Cgate / Cgate,inv
    Stage.__init__(self, be, reduction)

class inv(Stage):
  def __init__(self, be=1, fast_rise=False, fast_fall=False, reduction=False):
    self.name = "inv"
    self.w_n = 1
    self.w_p = P_TO_N
    if fast_fall:
      self.w_p_fast = self.w_p
      self.w_p = MIN_W
    if fast_rise:
      self.w_n_fast = self.w_n
      self.w_n = MIN_W
    self.c_para = (self.w_p + self.w_n) * C_JUNCTION
    self.c_gate = (self.w_p + self.w_n) * C_GATE
    Stage.__init__(self, be, reduction)
    self.template = '''
.subckt {name} a y
m1 y a vdd! vdd! pmos L=2 W={w_p} M={m}
m2 y a 0 0 nmos L=2 W={w_n} M={m}
.ends {name}
'''



class pmos(Stage):
  def __init__(self, be=1, reduction=False):
    self.name = "pmos"
    self.w_n = 0
    self.w_p = P_TO_N
    self.c_para = self.w_p * C_JUNCTION
    self.c_gate = self.w_p * C_GATE
    Stage.__init__(self, be, reduction)
