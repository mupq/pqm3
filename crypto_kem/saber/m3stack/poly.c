#include "poly.h"
#include "cbd.h"
#include "NTT.h"
#include "fips202.h"
#include "pack_unpack.h"

#include <stdio.h>

#define h1 (1 << (SABER_EQ - SABER_EP - 1))
#define h2 ((1 << (SABER_EP - 2)) - (1 << (SABER_EP - SABER_ET - 1)) + (1 << (SABER_EQ - SABER_EP - 1)))
#define MAX(a,b) (((a)>(b))?(a):(b))

extern void __asm_poly_add(uint16_t*, uint16_t*, uint16_t*);

static inline shake128incctx shake128_absorb_seed(const uint8_t seed[SABER_SEEDBYTES]){

    shake128incctx ctx;
    shake128_inc_init(&ctx);
    shake128_inc_absorb(&ctx, seed, SABER_SEEDBYTES);
    shake128_inc_finalize(&ctx);

    return ctx;

}

void InnerProdDecNTT_16(uint8_t m[SABER_KEYBYTES], const uint8_t ciphertext[SABER_BYTES_CCA_DEC], const uint8_t sk[SABER_INDCPA_SECRETKEYBYTES]){

    uint32_t poly_NTT[SABER_N / 2];
    uint32_t buff_NTT[SABER_N / 2];
    uint32_t acc_NTT[SABER_N];
    uint16_t poly[SABER_N];
    uint16_t buff[SABER_N];

    size_t i;

    for (i = 0; i < SABER_L; i++) {

#ifdef SABER_COMPRESS_SECRETKEY
        BS2POLmu(sk + i * SABER_POLYSECRETBYTES, buff);
#else
        BS2POLq(sk + i * SABER_POLYSECRETBYTES, buff);
#endif
        BS2POLp(ciphertext + i * SABER_POLYCOMPRESSEDBYTES, poly);

        NTT_forward1(buff_NTT, buff);
        NTT_forward1(poly_NTT, poly);

        if(i == 0){
            NTT_mul1(acc_NTT, buff_NTT, poly_NTT);
        }else{
            NTT_mul_acc1(acc_NTT, buff_NTT, poly_NTT);
        }

        NTT_forward2(buff_NTT, buff);
        NTT_forward2(poly_NTT, poly);

        if(i == 0){
            NTT_mul2(acc_NTT + SABER_N / 2, buff_NTT, poly_NTT);
        }else{
            NTT_mul_acc2(acc_NTT + SABER_N / 2, buff_NTT, poly_NTT);
        }

    }

    NTT_inv(poly, acc_NTT);

    BS2POLT(ciphertext + SABER_POLYVECCOMPRESSEDBYTES, buff);

    for (i = 0; i < SABER_N; i++) {
        poly[i] = (poly[i] + h2 - (buff[i] << (SABER_EP - SABER_ET))) >> (SABER_EP - 1);
    }

    POLmsg2BS(m, poly);

}

void MatrixVectorMulKeyPairNTT_16_stack2(uint8_t pk[SABER_INDCPA_PUBLICKEYBYTES], uint8_t sk[SABER_INDCPA_SECRETKEYBYTES]){

    uint16_t poly[MAX(SABER_N, MAX(SABER_POLYCOINBYTES, SABER_POLYBYTES) / 2)];
    uint16_t s[SABER_N];
    uint16_t buff[SABER_N];
    uint16_t acc[SABER_L * SABER_N];
    uint8_t s_buff[SABER_N / 2];

    uint8_t *shake_out = (uint8_t*)poly;
    uint32_t *poly_NTT = (uint32_t*)poly;
    uint32_t *s_NTT = (uint32_t*)s;
    uint32_t *buff_NTT = (uint32_t*)buff;

    uint8_t *seed_A = pk + SABER_POLYVECCOMPRESSEDBYTES;
    uint8_t *seed_s = sk;

    size_t i, j;

    shake128incctx shake_s_ctx = shake128_absorb_seed(seed_s);
    shake128incctx shake_A_ctx = shake128_absorb_seed(seed_A);

    for (i = 0; i < SABER_L; i++) {

        shake128_inc_squeeze(shake_out, SABER_POLYCOINBYTES, &shake_s_ctx);
        cbd(s, shake_out);
#ifdef SABER_COMPRESS_SECRETKEY
        POLmu2BS(sk + i * SABER_POLYSECRETBYTES, s); // sk <- s
#else
        POLq2BS(sk + i * SABER_POLYSECRETBYTES, s);
#endif
        POLmu2BS(s_buff, s);

        for (j = 0; j < SABER_L; j++) {

            shake128_inc_squeeze(shake_out, SABER_POLYBYTES, &shake_A_ctx);

            BS2POLq(shake_out, buff);
            NTT_forward1(buff_NTT, buff);

            BS2POLmu(s_buff, s);
            NTT_forward1(s_NTT, s);

            NTT_mul1(buff_NTT, buff_NTT, s_NTT);
            NTT_inv1(buff_NTT);

            BS2POLq(shake_out, poly);
            NTT_forward2(poly_NTT, poly);

            BS2POLmu(s_buff, s);
            NTT_forward2(s_NTT, s);

            NTT_mul2(poly_NTT, poly_NTT, s_NTT);
            NTT_inv2(poly_NTT);

            if(i == 0){
                solv_CRT(acc + j * SABER_N, buff_NTT, poly_NTT);
            }else{
                solv_CRT(poly, buff_NTT, poly_NTT);
                __asm_poly_add(acc + j * SABER_N, acc + j * SABER_N, poly);
            }

        }
    }

    shake128_inc_ctx_release(&shake_A_ctx);
    shake128_inc_ctx_release(&shake_s_ctx);

    for (i = 0; i < SABER_L; i++) {

        for (j = 0; j < SABER_N; j++) {
            acc[i * SABER_N + j] = ((acc[i * SABER_N + j] + h1) >> (SABER_EQ - SABER_EP));
        }

        POLp2BS(pk + i * SABER_POLYCOMPRESSEDBYTES, acc + i * SABER_N);
    }

}


uint32_t MatrixVectorMulEncNTT_16_stack2(uint8_t ct0[SABER_POLYVECCOMPRESSEDBYTES], uint8_t ct1[SABER_SCALEBYTES_KEM], const uint8_t seed_s[SABER_NOISE_SEEDBYTES], const uint8_t seed_A[SABER_SEEDBYTES], const uint8_t pk[SABER_INDCPA_PUBLICKEYBYTES], const uint8_t m[SABER_KEYBYTES], int compare){

    uint16_t s[SABER_N];
    uint16_t poly[MAX(SABER_N, MAX(SABER_POLYBYTES, SABER_POLYCOINBYTES) / 2)];
    uint16_t acc[SABER_N];
    uint16_t buff[SABER_N];

    uint8_t s_buff[SABER_L * SABER_N / 2];

    uint8_t *shake_out = (uint8_t*)poly;

    uint32_t *s_NTT = (uint32_t*)s;
    uint32_t *poly_NTT = (uint32_t*)poly;
    uint32_t *buff_NTT = (uint32_t*)buff;

    uint16_t *mp = poly;

    size_t i, j;
    uint32_t fail = 0;

    shake128incctx shake_s_ctx = shake128_absorb_seed(seed_s);

    for(i = 0; i < SABER_L; i++){
        shake128_inc_squeeze(shake_out, SABER_POLYCOINBYTES, &shake_s_ctx);
        cbd(s, shake_out);
        POLmu2BS(s_buff + i * SABER_N / 2, s);
    }

    shake128_inc_ctx_release(&shake_s_ctx);

    shake128incctx shake_A_ctx = shake128_absorb_seed(seed_A);

    for (i = 0; i < SABER_L; i++) {

        for (j = 0; j < SABER_L; j++) {

            shake128_inc_squeeze(shake_out, SABER_POLYBYTES, &shake_A_ctx);

            BS2POLq(shake_out, buff);
            NTT_forward1(buff_NTT, buff);

            BS2POLmu(s_buff + j * SABER_N / 2, s);
            NTT_forward1(s_NTT, s);

            NTT_mul1(buff_NTT, s_NTT, buff_NTT);
            NTT_inv1(buff_NTT);

            BS2POLq(shake_out, poly);
            NTT_forward2(poly_NTT, poly);

            BS2POLmu(s_buff + j * SABER_N / 2, s);
            NTT_forward2(s_NTT, s);

            NTT_mul2(poly_NTT, s_NTT, poly_NTT);
            NTT_inv2(poly_NTT);

            if(j == 0){
                solv_CRT(acc, buff_NTT, poly_NTT);
            }else{
                solv_CRT(poly, buff_NTT, poly_NTT);
                __asm_poly_add(acc, acc, poly);
            }

        }

        for (j = 0; j < SABER_N; j++) {
            acc[j] = ((acc[j] + h1) >> (SABER_EQ - SABER_EP));
        }

        if (compare) {
            fail |= POLp2BS_cmp(ct0 + i * SABER_POLYCOMPRESSEDBYTES, acc);
        } else {
            POLp2BS(ct0 + i * SABER_POLYCOMPRESSEDBYTES, acc);
        }
    }

    shake128_inc_ctx_release(&shake_A_ctx);

    for(j = 0; j < SABER_L; j++){

        BS2POLp(pk + j * SABER_POLYCOMPRESSEDBYTES, poly);
        NTT_forward1(poly_NTT, poly);

        BS2POLmu(s_buff + j * SABER_N / 2, s);
        NTT_forward1(s_NTT, s);

        NTT_mul1(buff_NTT, poly_NTT, s_NTT);
        NTT_inv1(buff_NTT);

        BS2POLp(pk + j * SABER_POLYCOMPRESSEDBYTES, poly);
        NTT_forward2(poly_NTT, poly);

        BS2POLmu(s_buff + j * SABER_N / 2, s);
        NTT_forward2(s_NTT, s);

        NTT_mul2(poly_NTT, poly_NTT, s_NTT);
        NTT_inv2(poly_NTT);

        if(j == 0){
            solv_CRT(acc, buff_NTT, poly_NTT);
        }else{
            solv_CRT(buff, buff_NTT, poly_NTT);
            __asm_poly_add(acc, acc, buff);
        }

    }

    BS2POLmsg(m, mp);

    for(j = 0; j < SABER_N; j++){
        acc[j] = (acc[j] - (mp[j] << (SABER_EP - 1)) + h1) >> (SABER_EP - SABER_ET);
    }

    if(compare){
        fail |= POLT2BS_cmp(ct1, acc);
    }else{
        POLT2BS(ct1, acc);
    }

    return fail;

}




