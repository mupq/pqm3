
#ifndef SCHOOLBOOKS_I
#define SCHOOLBOOKS_I

#include "macros.i"

// 13
.macro c0_4x4 acc, c00, c01, c02, c03, c10, c11, c12, c13, twiddle, Qprime, Q, tmp
    mul \acc, \c01, \c13
    mla \acc, \c02, \c12, \acc
    mla \acc, \c03, \c11, \acc
    montgomery_reduce_16 \acc, \Qprime, \Q, \tmp
    mul \acc, \acc, \twiddle
    mla \acc, \c00, \c10, \acc
    montgomery_reduce_16 \acc, \Qprime, \Q, \tmp
.endm

// 13
.macro c1_4x4 acc, c00, c01, c02, c03, c10, c11, c12, c13, twiddle, Qprime, Q, tmp
    mul \acc, \c02, \c13
    mla \acc, \c03, \c12, \acc
    montgomery_reduce_16 \acc, \Qprime, \Q, \tmp
    mul \acc, \acc, \twiddle
    mla \acc, \c00, \c11, \acc
    mla \acc, \c01, \c10, \acc
    montgomery_reduce_16 \acc, \Qprime, \Q, \tmp
.endm

// 13
.macro c2_4x4 acc, c00, c01, c02, c03, c10, c11, c12, c13, twiddle, Qprime, Q, tmp
    mul \acc, \c03, \c13
    montgomery_reduce_16 \acc, \Qprime, \Q, \tmp
    mul \acc, \acc, \twiddle
    mla \acc, \c00, \c12, \acc
    mla \acc, \c01, \c11, \acc
    mla \acc, \c02, \c10, \acc
    montgomery_reduce_16 \acc, \Qprime, \Q, \tmp
.endm

// 8
.macro c3_4x4 acc, c00, c01, c02, c03, c10, c11, c12, c13, Qprime, Q, tmp
    mul \acc, \c00, \c13
    mla \acc, \c01, \c12, \acc
    mla \acc, \c02, \c11, \acc
    mla \acc, \c03, \c10, \acc
    montgomery_reduce_16 \acc, \Qprime, \Q, \tmp
.endm

// 13
.macro c0_4x4_neg acc, c00, c01, c02, c03, c10, c11, c12, c13, twiddle, Qprime, Q, tmp
    mul \acc, \c01, \c13
    mla \acc, \c02, \c12, \acc
    mla \acc, \c03, \c11, \acc
    montgomery_reduce_16 \acc, \Qprime, \Q, \tmp
    mul \tmp, \c00, \c10
    mls \acc, \acc, \twiddle, \tmp
    montgomery_reduce_16 \acc, \Qprime, \Q, \tmp
.endm

// 13
.macro c1_4x4_neg acc, c00, c01, c02, c03, c10, c11, c12, c13, twiddle, Qprime, Q, tmp
    mul \acc, \c02, \c13
    mla \acc, \c03, \c12, \acc
    montgomery_reduce_16 \acc, \Qprime, \Q, \tmp
    mul \tmp, \c00, \c11
    mla \tmp, \c01, \c10, \tmp
    mls \acc, \acc, \twiddle, \tmp
    montgomery_reduce_16 \acc, \Qprime, \Q, \tmp
.endm

// 13
.macro c2_4x4_neg acc, c00, c01, c02, c03, c10, c11, c12, c13, twiddle, Qprime, Q, tmp
    mul \acc, \c03, \c13
    montgomery_reduce_16 \acc, \Qprime, \Q, \tmp
    mul \tmp, \c00, \c12
    mla \tmp, \c01, \c11, \tmp
    mla \tmp, \c02, \c10, \tmp
    mls \acc, \acc, \twiddle, \tmp
    montgomery_reduce_16 \acc, \Qprime, \Q, \tmp
.endm

#endif





