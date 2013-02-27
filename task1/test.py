from circuitbook import *
from numpy import linspace
import time

class test(TestRun):
    def setup(self):
        # Setup process model
        models = EE313ProcessModel()

        # Instantiate the SimulationRun objects
        self.tran = self.construct('testTranSim', models)
    
    def test(self):
        tranRes = self.simulate(self.tran, cleanup = True)
        with self.epl_section() as epl:
            fig = None
            for key in tranRes:
                fig = tranRes[key].plot(xlabel='time', ylabel='V', title='', fig=fig, legend=key, filename='A')
              
