#!/usr/bin/env python3
from mupq import mupq
from interface import M3Settings, Qemu

import sys

if __name__ == "__main__":
    with Qemu() as m4:
        if "--nostack" not in sys.argv:
            test = mupq.StackBenchmark(M3Settings(), m4)
            test.test_all(sys.argv[1:])

        if "--nospeed" not in sys.argv:
            test = mupq.SpeedBenchmark(M3Settings(), m4)
            test.test_all(sys.argv[1:])

        if "--nohashing" not in sys.argv:
            test = mupq.HashingBenchmark(M3Settings(), m4)
            test.test_all(sys.argv[1:])

        if "--nosize" not in sys.argv:
            test = mupq.SizeBenchmark(M3Settings(), m4)
            test.test_all(sys.argv[1:])
