DEVICE=lm3s6965

EXCLUDED_SCHEMES = \
	mupq/pqclean/crypto_kem/frodokem1344% \
	mupq/pqclean/crypto_kem/mceliece% \
	mupq/crypto_sign/falcon-512-tree% \
	mupq/crypto_sign/falcon-1024% \
	mupq/crypto_sign/falcon-1024-tree% \
	mupq/pqclean/crypto_sign/rainbow% \
	mupq/pqclean/crypto_sign/sphincs-sha256-192% \
	mupq/pqclean/crypto_sign/sphincs-shake256-192% \
	mupq/pqclean/crypto_sign/sphincs-haraka-192% \
	mupq/pqclean/crypto_sign/sphincs-sha256-256% \
	mupq/pqclean/crypto_sign/sphincs-shake256-256% \
	mupq/pqclean/crypto_sign/sphincs-haraka-256%

include common/opencm3.mk
