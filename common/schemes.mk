_git_submodule_update_mupq := $(shell git submodule update --init --recursive mupq)

KEM_SEARCH_PATHS = \
	crypto_kem \
	mupq/crypto_kem \
	mupq/pqclean/crypto_kem

SIGN_SEARCH_PATHS = \
	crypto_sign \
	mupq/crypto_sign \
	mupq/pqclean/crypto_sign

# findschemes = $(foreach spath,$(1),$(wildcard $(spath)*/))
# KEM_SCHEMES := $(call findschemes,$(KEM_SEARCH_PATHS))
# KEM_SCHEMES := $(call findschemes,$(KEM_SCHEMES))

# $(info KEM_SCHEMES: $(KEM_SCHEMES))

# .PHONY: obj/.schemes.mk
obj/.schemes.mk:
	@echo "KEM_SCHEMES := \\" > $@
	@for SPATH in $(KEM_SEARCH_PATHS); do \
		SCHEMES=$$(find $${SPATH} -mindepth 1 -maxdepth 1 -type d); \
		for SCHEME in $${SCHEMES}; do \
			find $${SCHEME} -mindepth 1 -maxdepth 1 -type d \! \( -name avx -or -name avx2 -or -name sse -or -name vec \) -printf "\\t%p \\\\\\n"  >> $@; \
		done; \
	done;
	@echo "" >> $@
	@echo "SIGN_SCHEMES := \\" >> $@
	@for SPATH in $(SIGN_SEARCH_PATHS); do \
		SCHEMES=$$(find $${SPATH} -mindepth 1 -maxdepth 1 -type d); \
		for SCHEME in $${SCHEMES}; do \
			find $${SCHEME} -mindepth 1 -maxdepth 1 -type d \! \( -name avx -or -name avx2 -or -name sse -or -name vec -or -name aesni \) -printf "\\t%p \\\\\\n"  >> $@; \
		done; \
	done;

-include obj/.schemes.mk

# TODO: Handle these special exclusions better
SIGN_SCHEMES := $(filter-out mupq/crypto_sign/falcon%,$(SIGN_SCHEMES))
KEM_SCHEMES := $(filter-out mupq/pqclean/crypto_kem/frodokem1344%,$(KEM_SCHEMES))
KEM_SCHEMES := $(filter-out mupq/pqclean/crypto_kem/mceliece%,$(KEM_SCHEMES))
SIGN_SCHEMES := $(filter-out mupq/pqclean/crypto_sign/rainbow%,$(SIGN_SCHEMES))
# SIGN_SCHEMES := $(filter-out mupq/pqclean/crypto_sign/sphincs-haraka-192%,$(SIGN_SCHEMES))
# SIGN_SCHEMES := $(filter-out mupq/pqclean/crypto_sign/sphincs-sha256-192%,$(SIGN_SCHEMES))
# SIGN_SCHEMES := $(filter-out mupq/pqclean/crypto_sign/sphincs-shake256-192%,$(SIGN_SCHEMES))
SIGN_SCHEMES := $(filter-out mupq/pqclean/crypto_sign/sphincs-haraka-256%,$(SIGN_SCHEMES))
SIGN_SCHEMES := $(filter-out mupq/pqclean/crypto_sign/sphincs-sha256-256%,$(SIGN_SCHEMES))
SIGN_SCHEMES := $(filter-out mupq/pqclean/crypto_sign/sphincs-shake256-256%,$(SIGN_SCHEMES))

schemename = $(subst /,_,$(1))
schemesrc = $(wildcard $(1)/*.c) $(wildcard $(1)/*.s) $(wildcard $(1)/*.S)
namespace = $(shell echo $(if $(filter mupq_pqclean_%,$(1)),$(subst mupq_pqclean_crypto_$(2)_,pqclean_,$(1))_) | tr '[:lower:]' '[:upper:]' | tr -d '-')

define compiletest =
	@echo "  CC      $@"
	$(Q)[ -d $(@D) ] || mkdir -p $(@D)
	$(Q)$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $< -Wl,--start-group $(LDLIBS) -Wl,--end-group
endef

define schemelib =
obj/lib$(2).a: $(call objs,$(call schemesrc,$(1)))
libs: obj/lib$(2).a
elf/$(2)_%.elf: LDLIBS+=-l$(2)
elf/$(2)_%.elf: CPPFLAGS+=-I$(1)
elf/$(2)_%.elf: CPPFLAGS+=-DMUPQ_NAMESPACE=$(call namespace,$(2),$(3))
elf/$(2)_%.elf: mupq/crypto_$(3)/%.c obj/lib$(2).a $(LINKDEPS)
	$$(compiletest)
elf/$(2)_hashing.elf: PROFILE_HASHING=1

tests: elf/$(2)_test.elf elf/$(2)_speed.elf elf/$(2)_hashing.elf elf/$(2)_stack.elf elf/$(2)_testvectors.elf
tests-bin: bin/$(2)_test.bin bin/$(2)_speed.bin bin/$(2)_hashing.bin bin/$(2)_stack.bin bin/$(2)_testvectors.bin
endef

elf/mupq_pqclean_%.elf: MUPQ_NAMESPACE=$(shell tr)

$(foreach scheme,$(KEM_SCHEMES), \
	$(eval $(call schemelib,$(scheme),$(call schemename,$(scheme)),kem)))
$(foreach scheme,$(SIGN_SCHEMES), \
	$(eval $(call schemelib,$(scheme),$(call schemename,$(scheme)),sign)))
