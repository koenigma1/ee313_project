from circuitbook import *

class testTranSim(SimulationRun):
    ''' variable
        - ck_frequency: clock frequency
        - vdd: supply voltage
    '''
    def setup(self):
        # Set the interface we expect
        self.attach_to_interface('test')
        
        # Load the HSpice simulator
        self.simulator = HspiceSimulator()

        # Run a Tran analysis
        self.analyze_tran(start=0, stop=1000e-12, step=2e-12)
		
        # Specify which nodes and devices to save
        self.save_output(nodes=['in', 'out'])

    def start_run(self):
        # use the corner vdd voltage
        self.vdd = self.corner.supply()
        self.clear_stimulus()

        # Power Supply Stimulus
        self.add_stimulus(DCVoltageSourceStimulus(pnode='vdd!',nnode='gnd',value=self.vdd, name='vdd'))
        
        # Input Pulse
        self.add_stimulus(PulseVoltageSourceStimulus(pnode='pulse', nnode='gnd',
                                                        val0=0, val1=self.vdd,
                                                        period='1000p', rise='50p', fall='50p',
                                                        width='500p', delay='100p', name='input'))
        
        # Initial Condition
        self.add_stimulus_block("""
        .ic v(out)=0
        """.format(self.vdd))

    def postprocess(self):
        # Get the object that holds the simulation results
        tranRes = self.sim_results.tran()
        
        inRes = tranRes.signal_for('in')
        outRes = tranRes.signal_for('out')
        

        
        inRise = inRes.find_cross(threshold=self.vdd/2, 
                                        direction='rise', edge=1
                                        )
        inFall = inRes.find_cross(threshold=self.vdd/2, 
                                        direction='fall', edge=1
                                        )
        
        outRise = outRes.find_cross(threshold=self.vdd/2, 
                                        direction='rise', edge=1,
                                        after = inFall
                                        )
        outFall = outRes.find_cross(threshold=self.vdd/2, 
                                        direction='fall', edge=1,
                                        after = inRise
                                        )
        riseTime = outRise - inFall
        fallTime = outFall - inRise
        return {'riseTime': riseTime*1e12, 'fallTime': fallTime*1e12}
