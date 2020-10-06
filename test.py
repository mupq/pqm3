#!/usr/bin/env python3
from mupq import mupq
from interface import M3Settings, Qemu

import sys

if __name__ == "__main__":
    with Qemu() as platform:
        test = mupq.SimpleTest(M3Settings(), platform)
        test.test_all(sys.argv[1:])
