
#ifndef MACROS_I
#define MACROS_I

.macro central_reduce target, Mhalf, M
    cmp \target, \Mhalf
    it ge
    subge \target, \M
    cmn \target, \Mhalf
    it lt
    addlt \target, \M
.endm

// 2
.macro ldrstr2 ldrstr, target, c0, c1, mem0, mem1
    \ldrstr \c0, [\target, \mem0]
    \ldrstr \c1, [\target, \mem1]
.endm

// 2
.macro ldrstr2jump ldrstr, target, c0, c1, mem1, jump
    \ldrstr \c1, [\target, \mem1]
    \ldrstr \c0, [\target], \jump
.endm

.macro ldrstr4 ldrstr, target, c0, c1, c2, c3, mem0, mem1, mem2, mem3
    \ldrstr \c0, [\target, \mem0]
    \ldrstr \c1, [\target, \mem1]
    \ldrstr \c2, [\target, \mem2]
    \ldrstr \c3, [\target, \mem3]
.endm

.macro ldrstr4jump ldrstr, target, c0, c1, c2, c3, mem1, mem2, mem3, jump
    \ldrstr \c1, [\target, \mem1]
    \ldrstr \c2, [\target, \mem2]
    \ldrstr \c3, [\target, \mem3]
    \ldrstr \c0, [\target], \jump
.endm

.macro ldrstrvec ldrstr, target, c0, c1, c2, c3, c4, c5, c6, c7, mem0, mem1, mem2, mem3, mem4, mem5, mem6, mem7
    ldrstr4 \ldrstr, \target, \c0, \c1, \c2, \c3, \mem0, \mem1, \mem2, \mem3
    ldrstr4 \ldrstr, \target, \c4, \c5, \c6, \c7, \mem4, \mem5, \mem6, \mem7
.endm

.macro ldrstrvecjump ldrstr, target, c0, c1, c2, c3, c4, c5, c6, c7, mem1, mem2, mem3, mem4, mem5, mem6, mem7, jump
    ldrstr4 \ldrstr, \target, \c4, \c5, \c6, \c7, \mem4, \mem5, \mem6, \mem7
    ldrstr4jump \ldrstr, \target, \c0, \c1, \c2, \c3, \mem1, \mem2, \mem3, \jump
.endm

.macro barrett a, Qbar, Q, tmp
    mul.w \tmp, \a, \Qbar
    add.w \tmp, \tmp, #0x1000000
    asr.w \tmp, \tmp, #25
    mls.w \a, \tmp, \Q, \a
.endm

.macro montgomery_reduce_16 a, Qprime, Q, tmp
    mul \tmp, \a, \Qprime
    sxth.w \tmp, \tmp
    mla \a, \tmp, \Q, \a
    asr \a, \a, #16
.endm

.macro montgomery_mul_16 a, b, Qprime, Q, tmp
    mul \a, \a, \b
    mul \tmp, \a, \Qprime
    sxth.w \tmp, \tmp
    mla \a, \tmp, \Q, \a
    asr \a, \a, #16
.endm

.macro montgomery_mul_16_addSub c0, c1, twiddle, Qprime, Q, tmp
    mul \c1, \c1, \twiddle
    mul \tmp, \c1, \Qprime
    sxth.w \tmp, \tmp
    mla \c1, \tmp, \Q, \c1
    add \c0, \c0, \c1, asr #16
    sub \c1, \c0, \c1, asr #15
.endm

.macro montgomery_mul_16_vec4 c0, c1, c2, c3, multiplier, Qprime, Q, tmp
    montgomery_mul_16 \c0, \multiplier, \Qprime, \Q, \tmp
    montgomery_mul_16 \c1, \multiplier, \Qprime, \Q, \tmp
    montgomery_mul_16 \c2, \multiplier, \Qprime, \Q, \tmp
    montgomery_mul_16 \c3, \multiplier, \Qprime, \Q, \tmp
.endm

.macro montgomery_mul_16_vec8 c0, c1, c2, c3, c4, c5, c6, c7, multiplier, Qprime, Q, tmp
    montgomery_mul_16 \c0, \multiplier, \Qprime, \Q, \tmp
    montgomery_mul_16 \c1, \multiplier, \Qprime, \Q, \tmp
    montgomery_mul_16 \c2, \multiplier, \Qprime, \Q, \tmp
    montgomery_mul_16 \c3, \multiplier, \Qprime, \Q, \tmp
    montgomery_mul_16 \c4, \multiplier, \Qprime, \Q, \tmp
    montgomery_mul_16 \c5, \multiplier, \Qprime, \Q, \tmp
    montgomery_mul_16 \c6, \multiplier, \Qprime, \Q, \tmp
    montgomery_mul_16 \c7, \multiplier, \Qprime, \Q, \tmp
.endm

.macro addSub1 c0, c1
    add.w \c0, \c1
    sub.w \c1, \c0, \c1, lsl #1
.endm

.macro addSub2 c0, c1, c2, c3
    add \c0, \c1
    add \c2, \c3
    sub.w \c1, \c0, \c1, lsl #1
    sub.w \c3, \c2, \c3, lsl #1
.endm

.macro addSub4 c0, c1, c2, c3, c4, c5, c6, c7
    add \c0, \c1
    add \c2, \c3
    add \c4, \c5
    add \c6, \c7
    sub.w \c1, \c0, \c1, lsl #1
    sub.w \c3, \c2, \c3, lsl #1
    sub.w \c5, \c4, \c5, lsl #1
    sub.w \c7, \c6, \c7, lsl #1
.endm


#endif
