from circuitbook import *

OUTPUT = ['clk', 'wl0', 'wl255']
SOURCES = ['vvdd', 'vaddress0', 'vaddress255', 'vclk']

class testTranSim(SimulationRun):
    ''' variable
        - ck_frequency: clock frequency
        - vdd: supply voltage
    '''
    def setup(self):
        # Set the interface we expect
        self.attach_to_interface('decoder')
        
        # Load the HSpice simulator
        self.simulator = HspiceSimulator()

        # Run a Tran analysis
        self.analyze_tran(start=0, stop=10e-9, step=0.25e-12)
		
        # Specify which nodes and devices to save
        self.save_output(nodes=OUTPUT)
        self.save_output(vsources=SOURCES)

    def start_run(self):
        # use the corner vdd voltage
        self.vdd = self.corner.supply()
        self.clear_stimulus()

        # Power Supply Stimulus
        self.add_stimulus(DCVoltageSourceStimulus(pnode='vdd!',nnode='gnd',value=self.vdd, name='vdd'))
        self.add_stimulus(DCVoltageSourceStimulus(pnode='address0',nnode='gnd',value=self.vdd, name='address0'))
        self.add_stimulus(DCVoltageSourceStimulus(pnode='address255',nnode='gnd',value=0, name='address255'))
       
        
        # Input Pulse
        self.add_stimulus(PulseVoltageSourceStimulus(pnode='clk', nnode='gnd',
                                                        val0=self.vdd, val1=self.vdd,
                                                        period='1000p', rise='50p', fall='50p',
                                                        width='500p', delay='0p', name='clk'))
        
    def postprocess(self):
        # Get the object that holds the simulation results
        tranRes = self.sim_results.tran()
        t = tranRes['time']

        res = {}
        for node in OUTPUT:
          res[node] = tranRes.signal_for(node)

        for node in SOURCES:
          i = self.sim_results.results['tran'][node].i()
          charge = [0]
          for a in range(1, len(i)):
            if i[a] < 0:
              charge.append(i[a]*(t[a]-t[a-1]) + charge[a-1])
            else:
              charge.append(charge[a-1])
          print 'average power for %s:' % node, charge[-1] / (t[-1] - t[0])
          res[node] = PairedVector(t, i) 
          res['q' + node] = PairedVector(t, Vector(charge))

        inRise = res['clk'].find_cross(threshold=self.vdd/2, 
                                        direction='rise', edge=1
                                        )
        inFall = res['clk'].find_cross(threshold=self.vdd/2, 
                                        direction='fall', edge=1
                                        )
        
        outRise = res['wl0'].find_cross(threshold=self.vdd/2, 
                                        direction='rise', edge=1,
                                        after = inRise
                                        )
        outFall = res['wl0'].find_cross(threshold=self.vdd/2, 
                                        direction='fall', edge=1,
                                        after = inFall
                                        )
        riseTime = outRise - inRise
        fallTime = outFall - inFall
        print "riseTime:", riseTime, outRise, inRise
        print "fallTime:", fallTime, outFall, inFall

        return res
