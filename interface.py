import argparse

import serial
import select
import subprocess

from mupq import mupq
import logging


def parse_arguments():
    parser = argparse.ArgumentParser(description="PQM4 Specific Settings")
    parser.add_argument(
        "-p",
        "--platform",
        help="The PQM4 platform",
        choices=["lm3s", "sam3x8e", "nucleo-stm32f207zg", "stm32l100c-disco"],
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
    parser.add_argument("-u", "--uart", help="Path to UART output")
    return parser.parse_known_args()


def get_platform(args):
    settings = M3Settings(args.platform, args.opt, args.lto)
    if args.platform == "sam3x8e":
        return Arduino(args.uart if args.uart is not None else "/dev/ttyACM0"), settings
    elif args.platform == "lm3s":
        return Qemu(), settings
    elif args.platform == "stm32l100c-disco":
        return STM32(), settings
    else:
        raise NotImplementedError("Unsupported Platform")


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
        {'scheme': 'sphincs-haraka-192f-robust'},
        {'scheme': 'sphincs-haraka-192f-simple'},
        {'scheme': 'sphincs-haraka-192s-robust'},
        {'scheme': 'sphincs-haraka-192s-simple'},
        {'scheme': 'sphincs-haraka-256f-robust'},
        {'scheme': 'sphincs-haraka-256f-simple'},
        {'scheme': 'sphincs-haraka-256s-robust'},
        {'scheme': 'sphincs-haraka-256s-simple'},
        {'scheme': 'sphincs-sha256-192f-robust'},
        {'scheme': 'sphincs-sha256-192f-simple'},
        {'scheme': 'sphincs-sha256-192s-robust'},
        {'scheme': 'sphincs-sha256-192s-simple'},
        {'scheme': 'sphincs-sha256-256f-robust'},
        {'scheme': 'sphincs-sha256-256f-simple'},
        {'scheme': 'sphincs-sha256-256s-robust'},
        {'scheme': 'sphincs-sha256-256s-simple'},
        {'scheme': 'sphincs-shake256-192f-robust'},
        {'scheme': 'sphincs-shake256-192f-simple'},
        {'scheme': 'sphincs-shake256-192s-robust'},
        {'scheme': 'sphincs-shake256-192s-simple'},
        {'scheme': 'sphincs-shake256-256f-robust'},
        {'scheme': 'sphincs-shake256-256f-simple'},
        {'scheme': 'sphincs-shake256-256s-robust'},
        {'scheme': 'sphincs-shake256-256s-simple'},
    )

    def __init__(self, platform, opt="speed", lto=False):
        """Initialize with a specific pqvexriscv platform"""
        optflags = {"speed": [], "size": ["OPT_SIZE=1"], "debug": ["DEBUG=1"]}
        if opt not in optflags:
            raise ValueError(f"Optimization flag should be in {list(optflags.keys())}")
        super(M3Settings, self).__init__()
        self.makeflags = [f"PLATFORM={platform}"]
        self.makeflags += optflags[opt]
        if lto:
            self.makeflags += ["LTO=1"]


class Qemu(mupq.Platform):
    class Wrapper(object):
        def __init__(self, proc, timeout=60):
            self.log = logging.getLogger("platform interface")
            self.proc = proc
            self.timeout = timeout

        def terminate(self):
            self.log.debug("Terminating QEMU process")
            self.proc.stdout.close()
            self.proc.terminate()
            self.proc.kill()

        def read(self, n=1):
            r, w, x = select.select([self.proc.stdout], [], [], self.timeout)
            for stdio in r:
                return stdio.read(n)
            raise Exception("timeout")

        def reset_input_buffer(self):
            pass

    def __init__(self):
        super().__init__()
        self.platformname = "lm3s"
        self.wrapper = None

    def __enter__(self):
        return super().__enter__()

    def __exit__(self, *args, **kwargs):
        if self.wrapper is not None:
            self.wrapper.terminate()
            self.wrapper = None
        return super().__exit__(*args, **kwargs)

    def device(self):
        if self.wrapper is None:
            raise Exception("No process started yet")
        return self.wrapper

    def flash(self, binary_path):
        super().flash(binary_path)
        if self.wrapper is not None:
            self.wrapper.terminate()
            self.wrapper = None
        args = [
            "qemu-system-arm",
            "-cpu",
            "cortex-m3",
            "-M",
            "lm3s6965evb",
            "-nographic",
            "-kernel",
            binary_path,
        ]
        proc = subprocess.Popen(
            args,
            stdin=subprocess.PIPE,
            stdout=subprocess.PIPE,
            stderr=subprocess.DEVNULL,
        )
        self.wrapper = self.Wrapper(proc)


class Arduino(mupq.Platform):
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

    def device(self):
        return self._dev

    def flash(self, binary_path):
        super().flash(binary_path)
        if self._dev is not None:
            self._dev.close()
        subprocess.check_call(
            ["bossac", "--port", self.tty, "--arduino-erase"],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        )
        subprocess.check_call(
            ["bossac", "--port", self.tty, "--write", "--boot=1", binary_path],
            # stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        )
        self._dev = serial.Serial(self.tty, 9600, timeout=10)


class STM32(mupq.Platform):
    def __init__(self, tty="/dev/ttyUSB0"):
        super().__init__()
        self.platformname = "stm32"
        self.tty = tty
        self._dev = None

    def __enter__(self):
        return super().__enter__()

    def __exit__(self, *args, **kwargs):
        self._dev.close()
        return super().__exit__(*args, **kwargs)

    def device(self):
        return self._dev

    def flash(self, binary_path):
        super().flash(binary_path)
        if self._dev is not None:
            self._dev.close()
        subprocess.check_call(
            ["st-flash", "--reset", "write", binary_path, "0x8000000"],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        )
        self._dev = serial.Serial(self.tty, 9600, timeout=10)
