
#include "macros.i"
#include "CT_butterflies.i"

#ifndef LOOP
#define LOOP
#endif

.syntax unified
.cpu cortex-m3

.align 2
.global __asm_intt
.type __asm_intt, %function
__asm_intt:
    push {r4-r12, lr}

    sub.w sp, sp, #16
    ldr.w r4, [sp, #56]
    str.w r4, [sp, #8]

    .equ width, 2

#ifdef LOOP
    add.w r12, r0, #256*width
    str.w r12, [sp, #0]
    _i_0_1_2:
#else
.rept 8
#endif

#ifdef LOOP
    add.w r14, r0, #4*width
    str.w r14, [sp, #4]
    _i_0_1_2_inner:
#else
.rept 2
#endif

.rept 2

    ldrstrvec ldrsh.w, r0, r4, r5, r6, r7, r8, r9, r10, r11, #0*width, #4*width, #8*width, #12*width, #16*width, #20*width, #24*width, #28*width

    addSub4 r4, r5, r6, r7, r8, r9, r10, r11
    addSub2 r4, r6, r8, r10

    ldr.w r12, [r1, #8]
    montgomery_mul_16_addSub r5, r7, r12, r2, r3, r14
    montgomery_mul_16_addSub r9, r11, r12, r2, r3, r14

    ldr.w r12, [sp, #8]
    barrett r4, r12, r3, r14
    barrett r5, r12, r3, r14
    barrett r6, r12, r3, r14
    barrett r7, r12, r3, r14

    ldr.w r12, [r1, #12]
    montgomery_mul_16_addSub r4, r8, r12, r2, r3, r14
    ldr.w r12, [r1, #16]
    montgomery_mul_16_addSub r5, r9, r12, r2, r3, r14
    ldr.w r12, [r1, #20]
    montgomery_mul_16_addSub r6, r10, r12, r2, r3, r14
    ldr.w r12, [r1, #24]
    montgomery_mul_16_addSub r7, r11, r12, r2, r3, r14

    ldrstrvecjump strh.w, r0, r4, r5, r6, r7, r8, r9, r10, r11, #4*width, #8*width, #12*width, #16*width, #20*width, #24*width, #28*width, #width

.endr

#ifdef LOOP
    ldr.w r14, [sp, #4]
    cmp.w r0, r14
    bne.w _i_0_1_2_inner
#else
.endr
#endif

    add.w r0, r0, #28*width

#ifdef LOOP
    ldr.w r12, [sp, #0]
    cmp.w r0, r12
    bne.w _i_0_1_2
#else
.endr
#endif

    add.w r1, r1, #28
    sub.w r0, r0, #256*width

#ifdef LOOP
    add.w r12, r0, #32*width
    str.w r12, [sp, #0]
    _i_3_4_5:
#else
.rept 8
#endif

.rept 4

    ldrstrvec ldrsh.w, r0, r4, r5, r6, r7, r8, r9, r10, r11, #0*width, #32*width, #64*width, #96*width, #128*width, #160*width, #192*width, #224*width
    _3_layer_inv_CT_16 r4, r5, r6, r7, r8, r9, r10, r11, r1, r12, r2, r3, r14
    ldr.w r12, [r1, #28]
    montgomery_mul_16 r4, r12, r2, r3, r14
    ldr.w r12, [r1, #32]
    montgomery_mul_16 r5, r12, r2, r3, r14
    ldr.w r12, [r1, #36]
    montgomery_mul_16 r6, r12, r2, r3, r14
    ldr.w r12, [r1, #40]
    montgomery_mul_16 r7, r12, r2, r3, r14
    ldr.w r12, [r1, #44]
    montgomery_mul_16 r8, r12, r2, r3, r14
    ldr.w r12, [r1, #48]
    montgomery_mul_16 r9, r12, r2, r3, r14
    ldr.w r12, [r1, #52]
    montgomery_mul_16 r10, r12, r2, r3, r14
    ldr.w r12, [r1, #56]
    montgomery_mul_16 r11, r12, r2, r3, r14
    ldrstrvecjump strh.w, r0, r4, r5, r6, r7, r8, r9, r10, r11, #32*width, #64*width, #96*width, #128*width, #160*width, #192*width, #224*width, #width

.endr

    add.w r1, r1, #60

#ifdef LOOP
    ldr.w r12, [sp, #0]
    cmp.w r0, r12
    bne.w _i_3_4_5
#else
.endr
#endif

    add.w sp, sp, #16
    pop {r4-r12, pc}

.align 2
.global __asm_intt_light
.type __asm_intt_light, %function
__asm_intt_light:
    push {r4-r12, lr}

    sub.w sp, sp, #16
    ldr.w r4, [sp, #56]
    str.w r4, [sp, #8]

    .equ width, 2

#ifdef LOOP
    add.w r12, r0, #256*width
    str.w r12, [sp, #0]
    _i_0_1_2_light:
#else
.rept 8
#endif

#ifdef LOOP
    add.w r14, r0, #4*width
    str.w r14, [sp, #4]
    _i_0_1_2_inner_light:
#else
.rept 2
#endif

.rept 2

    ldrstrvec ldrsh.w, r0, r4, r5, r6, r7, r8, r9, r10, r11, #0*width, #4*width, #8*width, #12*width, #16*width, #20*width, #24*width, #28*width

    addSub4 r4, r5, r6, r7, r8, r9, r10, r11
    addSub2 r4, r6, r8, r10

    ldr.w r12, [r1, #8]
    montgomery_mul_16_addSub r5, r7, r12, r2, r3, r14
    montgomery_mul_16_addSub r9, r11, r12, r2, r3, r14

    ldr.w r12, [sp, #8]
    barrett r4, r12, r3, r14
    barrett r5, r12, r3, r14
    barrett r6, r12, r3, r14
    barrett r7, r12, r3, r14

    ldr.w r12, [r1, #12]
    montgomery_mul_16_addSub r4, r8, r12, r2, r3, r14
    ldr.w r12, [r1, #16]
    montgomery_mul_16_addSub r5, r9, r12, r2, r3, r14
    ldr.w r12, [r1, #20]
    montgomery_mul_16_addSub r6, r10, r12, r2, r3, r14
    ldr.w r12, [r1, #24]
    montgomery_mul_16_addSub r7, r11, r12, r2, r3, r14

    ldrstrvecjump strh.w, r0, r4, r5, r6, r7, r8, r9, r10, r11, #4*width, #8*width, #12*width, #16*width, #20*width, #24*width, #28*width, #width

.endr

#ifdef LOOP
    ldr.w r14, [sp, #4]
    cmp.w r0, r14
    bne.w _i_0_1_2_inner_light
#else
.endr
#endif

    add.w r0, r0, #28*width

#ifdef LOOP
    ldr.w r12, [sp, #0]
    cmp.w r0, r12
    bne.w _i_0_1_2_light
#else
.endr
#endif

    add.w r1, r1, #28
    sub.w r0, r0, #256*width

#ifdef LOOP
    add.w r12, r0, #32*width
    str.w r12, [sp, #0]
    _i_3_4_5_light:
#else
.rept 8
#endif

.rept 4

    ldrstrvec ldrsh.w, r0, r4, r5, r6, r7, r8, r9, r10, r11, #0*width, #32*width, #64*width, #96*width, #128*width, #160*width, #192*width, #224*width
    _3_layer_inv_CT_16 r4, r5, r6, r7, r8, r9, r10, r11, r1, r12, r2, r3, r14
    ldr.w r12, [r1, #28]
    montgomery_mul_16 r4, r12, r2, r3, r14
    ldr.w r12, [r1, #32]
    montgomery_mul_16 r5, r12, r2, r3, r14
    ldr.w r12, [r1, #36]
    montgomery_mul_16 r6, r12, r2, r3, r14
    ldr.w r12, [r1, #40]
    montgomery_mul_16 r7, r12, r2, r3, r14
    ldr.w r12, [r1, #44]
    montgomery_mul_16 r8, r12, r2, r3, r14
    ldr.w r12, [r1, #48]
    montgomery_mul_16 r9, r12, r2, r3, r14
    ldr.w r12, [r1, #52]
    montgomery_mul_16 r10, r12, r2, r3, r14
    ldr.w r12, [r1, #56]
    montgomery_mul_16 r11, r12, r2, r3, r14
    ldrstrvecjump strh.w, r0, r4, r5, r6, r7, r8, r9, r10, r11, #32*width, #64*width, #96*width, #128*width, #160*width, #192*width, #224*width, #width

.endr

    add.w r1, r1, #60

#ifdef LOOP
    ldr.w r12, [sp, #0]
    cmp.w r0, r12
    bne.w _i_3_4_5_light
#else
.endr
#endif

    add.w sp, sp, #16
    pop {r4-r12, pc}












