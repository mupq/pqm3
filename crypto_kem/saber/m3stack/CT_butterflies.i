
#ifndef CT_BUTTERFLIES_I
#define CT_BUTTERFLIES_I

#include "macros.i"

.macro _3_layer_CT_16 c0, c1, c2, c3, c4, c5, c6, c7, twiddle_ptr, twiddle, Qprime, Q, tmp
    ldr.w \twiddle, [\twiddle_ptr, #0]
    montgomery_mul_16_addSub \c0, \c4, \twiddle, \Qprime, \Q, \tmp
    montgomery_mul_16_addSub \c1, \c5, \twiddle, \Qprime, \Q, \tmp
    montgomery_mul_16_addSub \c2, \c6, \twiddle, \Qprime, \Q, \tmp
    montgomery_mul_16_addSub \c3, \c7, \twiddle, \Qprime, \Q, \tmp

    ldr.w \twiddle, [\twiddle_ptr, #4]
    montgomery_mul_16_addSub \c0, \c2, \twiddle, \Qprime, \Q, \tmp
    montgomery_mul_16_addSub \c1, \c3, \twiddle, \Qprime, \Q, \tmp
    ldr.w \twiddle, [\twiddle_ptr, #8]
    montgomery_mul_16_addSub \c4, \c6, \twiddle, \Qprime, \Q, \tmp
    montgomery_mul_16_addSub \c5, \c7, \twiddle, \Qprime, \Q, \tmp

    ldr.w \twiddle, [\twiddle_ptr, #12]
    montgomery_mul_16_addSub \c0, \c1, \twiddle, \Qprime, \Q, \tmp
    ldr.w \twiddle, [\twiddle_ptr, #16]
    montgomery_mul_16_addSub \c2, \c3, \twiddle, \Qprime, \Q, \tmp
    ldr.w \twiddle, [\twiddle_ptr, #20]
    montgomery_mul_16_addSub \c4, \c5, \twiddle, \Qprime, \Q, \tmp
    ldr.w \twiddle, [\twiddle_ptr, #24]
    montgomery_mul_16_addSub \c6, \c7, \twiddle, \Qprime, \Q, \tmp
.endm

.macro _3_layer_inv_CT_16 c0, c1, c2, c3, c4, c5, c6, c7, twiddle_ptr, twiddle, Qprime, Q, tmp
    ldr.w \twiddle, [\twiddle_ptr, #0]
    montgomery_mul_16_addSub \c0, \c1, \twiddle, \Qprime, \Q, \tmp
    montgomery_mul_16_addSub \c2, \c3, \twiddle, \Qprime, \Q, \tmp
    montgomery_mul_16_addSub \c4, \c5, \twiddle, \Qprime, \Q, \tmp
    montgomery_mul_16_addSub \c6, \c7, \twiddle, \Qprime, \Q, \tmp

    ldr.w \twiddle, [\twiddle_ptr, #4]
    montgomery_mul_16_addSub \c0, \c2, \twiddle, \Qprime, \Q, \tmp
    montgomery_mul_16_addSub \c4, \c6, \twiddle, \Qprime, \Q, \tmp
    ldr.w \twiddle, [\twiddle_ptr, #8]
    montgomery_mul_16_addSub \c1, \c3, \twiddle, \Qprime, \Q, \tmp
    montgomery_mul_16_addSub \c5, \c7, \twiddle, \Qprime, \Q, \tmp

    ldr.w \twiddle, [\twiddle_ptr, #12]
    montgomery_mul_16_addSub \c0, \c4, \twiddle, \Qprime, \Q, \tmp
    ldr.w \twiddle, [\twiddle_ptr, #16]
    montgomery_mul_16_addSub \c1, \c5, \twiddle, \Qprime, \Q, \tmp
    ldr.w \twiddle, [\twiddle_ptr, #20]
    montgomery_mul_16_addSub \c2, \c6, \twiddle, \Qprime, \Q, \tmp
    ldr.w \twiddle, [\twiddle_ptr, #24]
    montgomery_mul_16_addSub \c3, \c7, \twiddle, \Qprime, \Q, \tmp
.endm

.macro _3_layer_inv_CT_16_light c0, c1, c2, c3, c4, c5, c6, c7, twiddle_ptr, twiddle, Qprime, Q, tmp
    ldr.w \twiddle, [\twiddle_ptr, #0]
    montgomery_mul_16_addSub \c0, \c1, \twiddle, \Qprime, \Q, \tmp
    montgomery_mul_16_addSub \c2, \c3, \twiddle, \Qprime, \Q, \tmp
    montgomery_mul_16_addSub \c4, \c5, \twiddle, \Qprime, \Q, \tmp
    montgomery_mul_16_addSub \c6, \c7, \twiddle, \Qprime, \Q, \tmp

    addSub2 \c0, \c2, \c4, \c6
    addSub1 \c0, \c4

    ldr.w \twiddle, [\twiddle_ptr, #8]
    montgomery_mul_16_addSub \c1, \c3, \twiddle, \Qprime, \Q, \tmp
    montgomery_mul_16_addSub \c5, \c7, \twiddle, \Qprime, \Q, \tmp

    montgomery_mul_16_addSub \c2, \c6, \twiddle, \Qprime, \Q, \tmp
    ldr.w \twiddle, [\twiddle_ptr, #16]
    montgomery_mul_16_addSub \c1, \c5, \twiddle, \Qprime, \Q, \tmp
    ldr.w \twiddle, [\twiddle_ptr, #24]
    montgomery_mul_16_addSub \c3, \c7, \twiddle, \Qprime, \Q, \tmp
.endm

#endif


