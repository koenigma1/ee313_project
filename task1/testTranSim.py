from circuitbook import *

OUTPUT = ['clk', 'address0', 'address255', 'inv1', 'pdec', 'wl0']

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
        self.analyze_tran(start=0, stop=0.6e-9, step=2e-12)
		
        # Specify which nodes and devices to save
        self.save_output(nodes=OUTPUT)

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
                                                        val0=0, val1=self.vdd,
                                                        period='1000p', rise='50p', fall='50p',
                                                        width='500p', delay='200p', name='clk'))
        
        # Initial Condition
        self.add_stimulus_block("""
        .ic v(wl)=1
        """.format(self.vdd))

    def postprocess(self):
        # Get the object that holds the simulation results
        tranRes = self.sim_results.tran()
        
        res = {}
        for node in OUTPUT:
          res[node] = tranRes.signal_for(node)
        
        return res
