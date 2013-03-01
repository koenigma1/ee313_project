from circuitbook import *
from numpy import linspace
import time
import sys
import os

sys.path.append(os.path.split(__file__)[0])
from testTranSim import SOURCES

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
            fig2 = None
            fig3 = None
            for key in SOURCES:
                fig2 = tranRes.pop(key).plot(xlabel='time', ylabel='i(%s)'%key, title='Current vs. time', fig=fig2, legend=key, filename='B')
                fig3 = tranRes.pop('q'+key).plot(xlabel='time', ylabel='q(%s)'%key, title='Charge vs. time', fig=fig3, legend=key, filename='C')
            for key in tranRes:
                fig = tranRes[key].plot(xlabel='time', ylabel='V', title='', fig=fig, legend=key, filename='A')
            
