SYMCRYPTO_SRC_COMMON = \
	mupq/common/fips202.c \
	mupq/common/sp800-185.c \
	mupq/common/nistseedexpander.c

SYMCRYPTO_SRC = \
	$(SYMCRYPTO_SRC_COMMON) \
	common/keccakf1600.S \
	mupq/pqclean/common/aes.c \
	mupq/pqclean/common/sha2.c

HOST_SYMCRYPTO_SRC = \
	$(SYMCRYPTO_SRC_COMMON) \
	mupq/common/keccakf1600.S \
	mupq/pqclean/common/aes.c \
	mupq/pqclean/common/sha2.c

obj/libsymcrypto.a: $(call objs,$(SYMCRYPTO_SRC))

obj-host/libsymcrypto.a: $(call hostobjs,$(HOST_SYMCRYPTO_SRC))

LDLIBS += -lsymcrypto
LIBDEPS += obj/libsymcrypto.a

