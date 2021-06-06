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
        default="size",
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

    #: List of dicts, in each dict specify (Scheme class) attributes of the
    #: scheme with values, if all attributes match the scheme is skipped.
    skip_list = (
        {"scheme": "ntrulpr653"},
        {"scheme": "ntrulpr761"},
        {"scheme": "ntrulpr857"},
        {"scheme": "dilithium3", "implementation": "clean"},
        {"scheme": "dilithium4", "implementation": "clean"},
        {"scheme": "falcon-1024-tree", "implementation": "opt-leaktime"},
        {"scheme": "falcon-1024-tree", "implementation": "opt-ct"},
        {"scheme": "frodokem640aes", "implementation": "clean"},
        {"scheme": "frodokem640aes", "implementation": "opt"},
        {"scheme": "frodokem976aes", "implementation": "clean"},
        {"scheme": "frodokem976aes", "implementation": "opt"},
        {"scheme": "frodokem1344aes", "implementation": "clean"},
        {"scheme": "frodokem1344aes", "implementation": "opt"},
        {"scheme": "frodokem640shake", "implementation": "clean"},
        {"scheme": "frodokem976shake", "implementation": "clean"},
        {"scheme": "frodokem976shake", "implementation": "opt"},
        {"scheme": "frodokem1344shake", "implementation": "clean"},
        {"scheme": "frodokem1344shake", "implementation": "opt"},
        {"scheme": "rainbowIa-classic", "implementation": "clean"},
        {"scheme": "rainbowIa-cyclic", "implementation": "clean"},
        {"scheme": "rainbowIa-cyclic-compressed", "implementation": "clean"},
        {"scheme": "rainbowIIIc-classic", "implementation": "clean"},
        {"scheme": "rainbowIIIc-cyclic", "implementation": "clean"},
        {"scheme": "rainbowIIIc-cyclic-compressed", "implementation": "clean"},
        {"scheme": "rainbowVc-classic", "implementation": "clean"},
        {"scheme": "rainbowVc-cyclic", "implementation": "clean"},
        {"scheme": "rainbowVc-cyclic-compressed", "implementation": "clean"},
        {"scheme": "mceliece348864", "implementation": "clean"},
        {"scheme": "mceliece348864f", "implementation": "clean"},
        {"scheme": "mceliece460896", "implementation": "clean"},
        {"scheme": "mceliece460896f", "implementation": "clean"},
        {"scheme": "mceliece6688128", "implementation": "clean"},
        {"scheme": "mceliece6688128f", "implementation": "clean"},
        {"scheme": "mceliece6960119", "implementation": "clean"},
        {"scheme": "mceliece6960119f", "implementation": "clean"},
        {"scheme": "mceliece8192128", "implementation": "clean"},
        {"scheme": "mceliece8192128f", "implementation": "clean"},
        {"scheme": "mceliece348864", "implementation": "vec"},
        {"scheme": "mceliece348864f", "implementation": "vec"},
        {"scheme": "mceliece460896", "implementation": "vec"},
        {"scheme": "mceliece460896f", "implementation": "vec"},
        {"scheme": "mceliece6688128", "implementation": "vec"},
        {"scheme": "mceliece6688128f", "implementation": "vec"},
        {"scheme": "mceliece6960119", "implementation": "vec"},
        {"scheme": "mceliece6960119f", "implementation": "vec"},
        {"scheme": "mceliece8192128", "implementation": "vec"},
        {"scheme": "mceliece8192128f", "implementation": "vec"},
        {"scheme": "hqc-128-1-cca2", "implementation": "leaktime"},
        {"scheme": "hqc-192-1-cca2", "implementation": "leaktime"},
        {"scheme": "hqc-192-2-cca2", "implementation": "leaktime"},
        {"scheme": "hqc-256-1-cca2", "implementation": "leaktime"},
        {"scheme": "hqc-256-2-cca2", "implementation": "leaktime"},
        {"scheme": "hqc-256-3-cca2", "implementation": "leaktime"},
        {'scheme': 'sphincs-haraka-256f-robust'},
        {'scheme': 'sphincs-haraka-256f-simple'},
        {'scheme': 'sphincs-haraka-256s-robust'},
        {'scheme': 'sphincs-haraka-256s-simple'},
        {'scheme': 'sphincs-sha256-256f-robust'},
        {'scheme': 'sphincs-sha256-256f-simple'},
        {'scheme': 'sphincs-sha256-256s-robust'},
        {'scheme': 'sphincs-sha256-256s-simple'},
        {'scheme': 'sphincs-shake256-256f-robust'},
        {'scheme': 'sphincs-shake256-256f-simple'},
        {'scheme': 'sphincs-shake256-256s-robust'},
        {'scheme': 'sphincs-shake256-256s-simple'},
    )

    def __init__(self, platform, opt="speed", lto=False, aio=False, iterations=1, binary_type='bin'):
        """Initialize with a specific pqvexriscv platform"""
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
