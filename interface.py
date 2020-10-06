import subprocess

import serial
import select

from mupq import mupq
from threading import Timer
import logging


class M3Settings(mupq.PlatformSettings):
    #: Specify folders to include
    scheme_folders = [  # mupq.PlatformSettings.scheme_folders + [
        ("pqm4", "crypto_kem", ""),
        ("pqm4", "crypto_sign", ""),
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
    )


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
            r, w, x = select.select(
                [self.proc.stdout], [], [], self.timeout
            )
            for stdio in r:
                return stdio.read(n)
            raise Exception("timeout")

        def reset_input_buffer(self):
            pass

    def __init__(self):
        super().__init__()
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
