
#include "macros.i"

.syntax unified
.cpu cortex-m3

#ifndef LOOP
#define LOOP
#endif

.align 2
.global __asm_solv_CRT
.type __asm_solv_CRT, %function
__asm_solv_CRT:
    push.w {r4-r12, lr}

    .equ width, 2

    mov.w r14, r0
    mov.w r0, r2

    ldm.w r3, {r8-r12}
    // r8 = Q1; r9 = Q2; r10 = Q1invRmod; r11 = Q2prime

    mov.w r3, r12
    lsr.w r2, r3, #1
    // r2 = Q1Q2half; r3 = Q1Q2

.rept 16

.set count, 8
.set indx, count

.rept count

.set indx, indx-1

.if indx == 0
    ldrstr2jump ldrsh.w, r0, r4, r5, #(indx*2+1)*width, #(count*2)*width
    ldrstr2jump ldrsh.w, r1, r6, r7, #(indx*2+1)*width, #(count*2)*width
.else
    ldrstr2 ldrsh.w, r0, r4, r5, #(indx*2+0)*width, #(indx*2+1)*width
    ldrstr2 ldrsh.w, r1, r6, r7, #(indx*2+0)*width, #(indx*2+1)*width
.endif

    sub.w r6, r6, r4
    montgomery_mul_16 r6, r10, r11, r9, r12
    mla.w r4, r6, r8, r4

    sub.w r7, r7, r5
    montgomery_mul_16 r7, r10, r11, r9, r12
    mla.w r5, r7, r8, r5

    central_reduce r4, r2, r3
    central_reduce r5, r2, r3

.if indx == 0
    ldrstr2jump strh.w, r14, r4, r5, #(indx*2+1)*width, #(count*2)*width
.else
    ldrstr2 strh.w, r14, r4, r5, #(indx*2+0)*width, #(indx*2+1)*width
.endif

.endr

.endr



    pop.w {r4-r12, pc}


