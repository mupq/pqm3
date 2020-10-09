#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include "poly_mul.h"

extern void polymul_asm(uint16_t *r, const uint16_t *a, const uint16_t *b);

extern void poly_mul_acc(const uint16_t a[SABER_N], const uint16_t b[SABER_N], uint16_t res[SABER_N]);


void pol_mul(uint16_t* a, uint16_t* b, uint16_t* res, uint16_t p, uint32_t n)
{
#if 0
    poly_mul_acc(a,b,res);

#else
    uint32_t i;
    uint16_t c[2*n - 1];

#if 0
    polymul_asm(c, a, b);

#else
        uint32_t j;
	for (i = 0; i< 2*n-1; i++) c[i] = 0;
        for (i = 0; i < n; i++) {
                for (j = 0; j < n; j++) {
                        c[i+j]=( c[i+j] + (a[i] * b[j]) ); //&(p-1);
                }
        }


#endif

    for (i = n; i < 2*n-1; i++){
        res[i - n] = (c[i - n] - c[i]) & (p - 1);
    }
    res[n - 1] = c[n - 1];
#endif
}
