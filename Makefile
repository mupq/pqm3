.PHONY: all
all:
	@echo "Please use the scripts in this directory instead of using the Makefile"
	@echo
	@echo "If you really want to use it, please specify IMPLEMENTATION_PATH=path/to/impl"
	@echo "and a target binary, e.g.,"
	@echo "make IMPLEMENTATION_PATH=crypto_kem/kyber768/m4 bin/crypto_kem_kyber768_m4_test.bin"
	@echo "make clean also works"

include common/config.mk
include common/crypto.mk
include common/rules.mk

elf/boardtest.elf: $(call objs,common/test.c)

.PHONY: clean libclean

clean: libclean
	rm -rf elf/
	rm -rf bin/
	rm -rf bin-host/
	rm -rf obj/
	rm -rf testvectors/
	rm -rf benchmarks/

.SECONDARY:
