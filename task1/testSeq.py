from circuitbook import *

CIRCUITS = ['decoder']

class TestSeq(TestSequence):
    """
        This script is to test different versions of circuits with the same
        interface
    """
    def sequence(self):
        for i in CIRCUITS:
            self.execute('test', i)
