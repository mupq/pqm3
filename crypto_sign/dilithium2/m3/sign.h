#ifndef SIGN_H
#define SIGN_H

#include <stddef.h>
#include "params.h"
#include "poly.h"
#include "polyvec.h"


int crypto_sign_signature(
    uint8_t *sig, size_t *siglen,
    const uint8_t *m, size_t mlen, const uint8_t *sk);


int crypto_sign(
        uint8_t *sm, size_t *smlen,
        const uint8_t *msg, size_t len,
        const uint8_t *sk
);


void challenge(poly *c, const unsigned char mu[CRHBYTES],
                                        const polyveck *w1);

int crypto_sign_keypair(uint8_t *pk, uint8_t *sk);


int crypto_sign_verify(
    const uint8_t *sig, size_t siglen,
    const uint8_t *m, size_t mlen, const uint8_t *pk);



int crypto_sign_open(uint8_t *m, size_t *mlen,
        const uint8_t *sm, size_t smlen,
        const uint8_t *pk);

#endif
