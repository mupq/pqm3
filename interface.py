import argparse

import serial
import select
import subprocess

from mupq import mupq
from mupq import platforms
import logging


def parse_arguments():
    parser = argparse.ArgumentParser(description="PQM4 Specific Settings")
    parser.add_argument(
        "-p",
        "--platform",
        help="The PQM4 platform",
        choices=["lm3s", "sam3x8e", "nucleo-f207zg", "stm32l100c-disco", "mps2-an385"],
        default="sam3x8e",
    )
    parser.add_argument(
        "-o",
        "--opt",
        help="Optimization flags",
        choices=["speed", "size", "debug"],
        default="speed",
    )
    parser.add_argument(
        "-l", "--lto", help="Enable LTO flags", default=False, action="store_true"
    )
    parser.add_argument(
        "-a", "--no-aio", help="Enable all-in-one compilation", default=False, action="store_true"
    )
    parser.add_argument("-u", "--uart", help="Path to UART output")
    parser.add_argument("-i", "--iterations", default=1, help="Number of iterations for benchmarks")
    return parser.parse_known_args()


def get_platform(args):
    platform = None
    bin_type = 'bin'
    if args.platform == "sam3x8e":
        platform = Arduino(args.uart if args.uart is not None else "/dev/ttyACM0")
    elif args.platform == "lm3s":
        platform = platforms.Qemu('qemu-system-arm', 'lm3s6965evb')
    elif args.platform == "mps2-an385":
        platform = platforms.Qemu('qemu-system-arm', 'mps2-an385')
    elif args.platform == "stm32l100c-disco":
        platform = platforms.StLink(args.uart, 9600)
    elif args.platform == "nucleo-f207zg":
        platform = platforms.StLink(args.uart, 9600)
    else:
        raise NotImplementedError("Unsupported Platform")
    settings = M3Settings(args.platform, args.opt, args.lto, not args.no_aio, args.iterations, bin_type)
    return platform, settings


class M3Settings(mupq.PlatformSettings):
    #: Specify folders to include
    scheme_folders = [  # mupq.PlatformSettings.scheme_folders + [
        ("pqm3", "crypto_kem", ""),
        ("pqm3", "crypto_sign", ""),
        ("mupq", "mupq/crypto_kem", ""),
        ("mupq", "mupq/crypto_sign", ""),
        ("pqclean", "mupq/pqclean/crypto_kem", "PQCLEAN"),
        ("pqclean", "mupq/pqclean/crypto_sign", "PQCLEAN"),
    ]

    platform_memory = {
        "lm3s": 64*1024,
        "sam3x8e": 96*1024,
        "nucleo-f207zg": 128*1024,
        "stm32l100c-disco": 16*1024,
        'mps2-an385': 4096*1024
    }

    def __init__(self, platform, opt="speed", lto=False, aio=False, iterations=1, binary_type='bin'):
        """Initialize with a specific pqvexriscv platform"""
        import skiplist
        self.skip_list = []
        for impl in skiplist.skip_list:
            if impl['estmemory'] > self.platform_memory[platform]:
                impl = impl.copy()
                del impl['estmemory']
                self.skip_list.append(impl)
        self.binary_type = binary_type
        optflags = {"speed": [], "size": ["OPT_SIZE=1"], "debug": ["DEBUG=1"]}
        if opt not in optflags:
            raise ValueError(f"Optimization flag should be in {list(optflags.keys())}")
        super(M3Settings, self).__init__()
        self.makeflags = [f"PLATFORM={platform}"]
        self.makeflags += [f"MUPQ_ITERATIONS={iterations}"]
        self.makeflags += optflags[opt]
        if lto:
            self.makeflags += ["LTO=1"]
        else:
            self.makeflags += ["LTO="]
        if aio:
            self.makeflags += ["AIO=1"]
        else:
            self.makeflags += ["AIO="]


class Arduino(platforms.SerialCommsPlatform):
    def __init__(self, tty="/dev/ttyACM0"):
        super().__init__()
        self.platformname = "sam3x8e"
        self.tty = tty
        self._dev = None

    def __enter__(self):
        return super().__enter__()

    def __exit__(self, *args, **kwargs):
        if self._dev is not None:
            self._dev.close()
        return super().__exit__(*args, **kwargs)

    def flash(self, binary_path):
        super().flash(binary_path)
        if self._dev is not None:
            self._dev.close()
        subprocess.check_call(
            ["bossac", "--port", self.tty, "--arduino-erase"],
            # stdout=subprocess.DEVNULL,
            # stderr=subprocess.DEVNULL,
        )
        subprocess.check_call(
            ["bossac", "--port", self.tty, "--write", "--boot=1", binary_path],
            # stdout=subprocess.DEVNULL,
            # stderr=subprocess.DEVNULL,
        )
        self._dev = serial.Serial(self.tty, 9600, timeout=10)
