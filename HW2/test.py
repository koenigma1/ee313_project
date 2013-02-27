from circuitbook import *
from numpy import linspace
import time

FO = [1,2,4,6,8]

class test(TestRun):
    def setup(self):
        # Setup process model
        models = EE313ProcessModel()

        # Instantiate the SimulationRun objects
        self.tran = self.construct('testTranSim', models)
    
    def test(self):
        results = []
        tRise = []
        for fo in FO: 
            self.tran.set_dut_param('fanout', fo)
            tranRes = self.simulate(self.tran, cleanup = True)
            riseTime = tranRes['riseTime']
            fallTime = tranRes['fallTime']
            delay = (riseTime+fallTime)/2
            results.append(delay)
            tRise.append(riseTime)
            with self.epl_section() as epl:
                epl.println("FO: %i\tDelay: %0.2fps\ttRise: %0.2fps" % (fo, delay, riseTime))

        with self.epl_section() as epl:
            PairedVector(x=Vector(FO),y=Vector(results)).plot(xlabel='fanout',
                            ylabel='delay',
                            title='delay vs. fanout',
                            filename = 'plot_' + time.ctime())
            PairedVector(x=Vector(FO),y=Vector(tRise)).plot(xlabel='fanout',
                            ylabel='delay',
                            title='tRise vs. fanout',
                            filename = 'plot_tRise_' + time.ctime())
