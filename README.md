# PQM3

PQM3 contains deploys _post quantum_ crypto schemes to the _Cortex M3_.

We target any scheme that is a finalist in the [NIST competition](https://csrc.nist.gov/news/2020/pqc-third-round-candidate-announcement).
Our goal is to show which schemes are feasible for deployment om Cortex M3
devices, and show how they compare in speed and size.

This project is based on its older sister project [`pqm4`](https://github.com/mupq/pqm4).

## Getting started

We currently support multiple boards, but also support the schemes to be
emulated using QEMU. Let me get you up to speed:

```shell
# Clone the repository and cd into it.
git clone --recursive https://github.com/mupq/pqm3.git
cd pqm3

# Install all the required dependencies.
# Arch linux
sudo pacman -S arm-none-eabi-gcc arm-none-eabi-binutils qemu qemu-arch-extra

# Ubuntu
sudo apt install gcc-arm-none-eabi binutils-arm-none-eabi qemu-system-arm

# QEMU emulates the lm3s platform. So build all the schemes with `PLATFORM=lm3s`.
make -j PLATFORM=lm3s

# At this point there is a bunch of binaries in the `elf/` directory.
# You can run any of these binaries using `qemu-system-arm`. For example, to
# test kyber768, run:
qemu-system-arm -cpu cortex-m3 \
                -machine lm3s6965evb \
                -nographic \
                -semihosting-config enable=on,target=native \
                -kernel ./elf/crypto_kem_kyber768_m3_test.elf

# To kill the qemu emulator, press Ctrl+A and then X.
```

## Running on hardware

We currently support the following platforms:

- `lm3s`: The board emulated by QEMU (default).
- `sam3x8e`: The [Arduino Due](https://store.arduino.cc/arduino-due) development board.
- `stm32f207zg`: The [Nucleo STM32F207ZG](https://www.st.com/en/evaluation-tools/nucleo-f207zg.html).
<!-- This next link was broken on the ST website? Had the board been discontinued? -->
- `stm32l100c-disco`: The [STM32L100 Discovery board](https://web.archive.org/web/20200902192134/https://www.st.com/en/evaluation-tools/32l100cdiscovery.html).
  (See [#2](https://github.com/mupq/pqm3/pull/2))

### Arduino Due

For flashing the firmwares to the Arduino Due, we use the [Bossa](https://www.shumatech.com/web/products/bossa) tool.
We will use the `miniterm` serial monitor to read the output from the Arduino.

First, to compile for the Arduino Due, set the `PLATFORM` variable to `sam3x8e`.

The Arduino Due binaries are written to `bin/`, but are not built by default.
So you will have to tell `make` what you want.
For example, to produce a speed benchmark of Kyber768, plug in your Due and run:

```shell
make PLATFORM=sam3x8e ./bin/crypto_kem_kyber768_m3_speed.bin
# (You might need to run `make clean` first, if you previously built for a different platform.)

# Flash the binary using bossac.
bossac -a --erase --write --verify --boot=1 --port=/dev/ttyACM0 ./bin/crypto_kem_kyber768_m3_speed.bin

# Open the serial monitor.
miniterm.py /dev/ttyACM0

```

If everything went well, you should have gotten something looking like this:

```
--- Miniterm on /dev/ttyACM0  9600,8,N,1 ---
--- Quit: Ctrl+] | Menu: Ctrl+T | Help: Ctrl+T followed by Ctrl+H ---
==========================
keypair cycles:
1087702
encaps cycles:
1281392
decaps cycles:
1228259
OK KEYS
```

### Nucleo STM32F207ZG

`TODO: Write this when you get the board.`

### STM32L100 Discovery

`TODO: Write this when you get the board.`