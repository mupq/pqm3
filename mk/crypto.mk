SYMCRYPTO_SRC = \
	mupq/common/fips202.c \
	mupq/common/sp800-185.c \
	mupq/common/nistseedexpander.c \
	common/keccakf1600.S \
	common/aes.c \
	common/aes-encrypt.S \
	common/aes-keyschedule.S \
	common/aes-publicinputs.c \
	common/aes-publicinputs.S \
	common/crypto_hashblocks_sha512_m3_inner32.S \
	common/crypto_hashblocks_sha512.c \
	mupq/common/sha2.c

obj/libsymcrypto.a: $(call objs,$(SYMCRYPTO_SRC))

obj/libsymcrypto-hashprof.a: CPPFLAGS+=-DPROFILE_HASHING
obj/libsymcrypto-hashprof.a: $(call hashprofobjs,$(SYMCRYPTO_SRC))

LDLIBS += -lsymcrypto$(if $(PROFILE_HASHING),-hashprof)
LIBDEPS += obj/libsymcrypto.a obj/libsymcrypto-hashprof.a
