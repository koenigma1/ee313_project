from circuitbook import *

CIRCUITS = ['inv', 'nand', 'nor', 'inv_skewed']

class TestSeq(TestSequence):
    """a
        This script is to test different versions of circuits with the same
        interface
    """
    def sequence(self):
        for i in CIRCUITS:
            self.execute('test', i)
