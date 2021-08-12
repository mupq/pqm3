

#include "macros.i"
#include "schoolbooks.i"

#ifndef LOOP
#define LOOP
#endif

.syntax unified
.cpu cortex-m3

.align 2
.global __asm_base_mul_acc
.type __asm_base_mul_acc, %function
__asm_base_mul_acc:
    push.w {r4-r12, lr}

    sub.w sp, sp, #16

    ldr.w r12, [sp, #56]
    ldr.w r14, [sp, #60]

    str.w r12, [sp, #0]
    str.w r14, [sp, #4]
    str.w r1, [sp, #8]

    .equ width, 2

#ifdef LOOP
    add.w r12, r0, #256*width
    str.w r12, [sp, #12]
    mul_acc_loop:
#else
.rept 32
#endif

    ldr.w r1, [sp, #8]
    ldr.w r12, [r1], #4
    str.w r1, [sp, #8]

    ldr.w r1, [sp, #0]
    ldr.w r14, [sp, #4]
    ldrstr4 ldrsh.w, r1, r4, r5, r6, r7, #4*width, #5*width, #6*width, #7*width
    ldrstr4 ldrsh.w, r14, r8, r9, r10, r11, #4*width, #5*width, #6*width, #7*width

    c3_4x4 r14, r4, r5, r6, r7, r8, r9, r10, r11, r2, r3, r1
    ldsh.w r1, [r0, #7*width]
    add.w r14, r14, r1
    strh.w r14, [r0, #7*width]
    c2_4x4_neg r14, r4, r5, r6, r7, r8, r9, r10, r11, r12, r2, r3, r1
    ldsh.w r1, [r0, #6*width]
    add.w r14, r14, r1
    strh.w r14, [r0, #6*width]
    c1_4x4_neg r14, r4, r5, r6, r7, r8, r9, r10, r11, r12, r2, r3, r1
    ldsh.w r1, [r0, #5*width]
    add.w r14, r14, r1
    strh.w r14, [r0, #5*width]
    c0_4x4_neg r14, r4, r5, r6, r7, r8, r9, r10, r11, r12, r2, r3, r1
    ldsh.w r1, [r0, #4*width]
    add.w r14, r14, r1
    strh.w r14, [r0, #4*width]

    ldr.w r1, [sp, #0]
    ldr.w r14, [sp, #4]
    ldrstr4jump ldrsh.w, r1, r4, r5, r6, r7, #1*width, #2*width, #3*width, #8*width
    ldrstr4jump ldrsh.w, r14, r8, r9, r10, r11, #1*width, #2*width, #3*width, #8*width
    str.w r1, [sp, #0]
    str.w r14, [sp, #4]

    c3_4x4 r14, r4, r5, r6, r7, r8, r9, r10, r11, r2, r3, r1
    ldsh.w r1, [r0, #3*width]
    add.w r14, r14, r1
    strh.w r14, [r0, #3*width]
    c2_4x4 r14, r4, r5, r6, r7, r8, r9, r10, r11, r12, r2, r3, r1
    ldsh.w r1, [r0, #2*width]
    add.w r14, r14, r1
    strh.w r14, [r0, #2*width]
    c1_4x4 r14, r4, r5, r6, r7, r8, r9, r10, r11, r12, r2, r3, r1
    ldsh.w r1, [r0, #1*width]
    add.w r14, r14, r1
    strh.w r14, [r0, #1*width]
    c0_4x4 r14, r4, r5, r6, r7, r8, r9, r10, r11, r12, r2, r3, r1
    ldsh.w r1, [r0, #0*width]
    add.w r14, r14, r1
    strh.w r14, [r0], #8*width

#ifdef LOOP
    ldr.w r12, [sp, #12]
    cmp.w r0, r12
    bne.w mul_acc_loop
#else
.endr
#endif

    add.w sp, sp, #16
    pop.w {r4-r12, pc}

.align 2
.global __asm_base_mul
.type __asm_base_mul, %function
__asm_base_mul:
    push.w {r4-r12, lr}

    sub.w sp, sp, #16

    ldr.w r12, [sp, #56]
    ldr.w r14, [sp, #60]

    str.w r12, [sp, #0]
    str.w r14, [sp, #4]
    str.w r1, [sp, #8]

    .equ width, 2

#ifdef LOOP
    add.w r12, r0, #256*width
    str.w r12, [sp, #12]
    mul_loop:
#else
.rept 32
#endif

    ldr.w r1, [sp, #8]
    ldr.w r12, [r1], #4
    str.w r1, [sp, #8]

    ldr.w r1, [sp, #0]
    ldr.w r14, [sp, #4]
    ldrstr4 ldrsh.w, r1, r4, r5, r6, r7, #4*width, #5*width, #6*width, #7*width
    ldrstr4 ldrsh.w, r14, r8, r9, r10, r11, #4*width, #5*width, #6*width, #7*width

    c3_4x4 r14, r4, r5, r6, r7, r8, r9, r10, r11, r2, r3, r1
    strh.w r14, [r0, #7*width]
    c2_4x4_neg r14, r4, r5, r6, r7, r8, r9, r10, r11, r12, r2, r3, r1
    strh.w r14, [r0, #6*width]
    c1_4x4_neg r14, r4, r5, r6, r7, r8, r9, r10, r11, r12, r2, r3, r1
    strh.w r14, [r0, #5*width]
    c0_4x4_neg r14, r4, r5, r6, r7, r8, r9, r10, r11, r12, r2, r3, r1
    strh.w r14, [r0, #4*width]

    ldr.w r1, [sp, #0]
    ldr.w r14, [sp, #4]
    ldrstr4jump ldrsh.w, r1, r4, r5, r6, r7, #1*width, #2*width, #3*width, #8*width
    ldrstr4jump ldrsh.w, r14, r8, r9, r10, r11, #1*width, #2*width, #3*width, #8*width
    str.w r1, [sp, #0]
    str.w r14, [sp, #4]

    c3_4x4 r14, r4, r5, r6, r7, r8, r9, r10, r11, r2, r3, r1
    strh.w r14, [r0, #3*width]
    c2_4x4 r14, r4, r5, r6, r7, r8, r9, r10, r11, r12, r2, r3, r1
    strh.w r14, [r0, #2*width]
    c1_4x4 r14, r4, r5, r6, r7, r8, r9, r10, r11, r12, r2, r3, r1
    strh.w r14, [r0, #1*width]
    c0_4x4 r14, r4, r5, r6, r7, r8, r9, r10, r11, r12, r2, r3, r1
    strh.w r14, [r0], #8*width

#ifdef LOOP
    ldr.w r12, [sp, #12]
    cmp.w r0, r12
    bne.w mul_loop
#else
.endr
#endif

    add.w sp, sp, #16
    pop.w {r4-r12, pc}




