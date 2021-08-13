

.syntax unified
.cpu cortex-m3

.align 2
.global __asm_poly_add
.type __asm_poly_add, %function
__asm_poly_add:
    push.w {r4-r12, lr}

    add.w r12, r1, #512

    _poly_add:

    ldrsh.w r5, [r1, #2]
    ldrsh.w r6, [r1, #4]
    ldrsh.w r7, [r1, #6]
    ldrsh.w r4, [r1], #8
    ldrsh.w r9, [r2, #2]
    ldrsh.w r10, [r2, #4]
    ldrsh.w r11, [r2, #6]
    ldrsh.w r8, [r2], #8

    add r4, r8
    add r5, r9
    add r6, r10
    add r7, r11

    strh.w r5, [r0, #2]
    strh.w r6, [r0, #4]
    strh.w r7, [r0, #6]
    strh.w r4, [r0], #8

    cmp.w r1, r12
    bne.w _poly_add

    pop.w {r4-r12, pc}

.align 2
.global __asm_1_to_16
.type __asm_1_to_16, %function
__asm_1_to_16:
    push.w {r4-r12, lr}

    add.w r14, r0, #512

    _1_to_16:

    ldr.w r2, [r1], #4

    add.w r12, r0, #64

    _1_to_16_inner:

    sbfx.w r3, r2, #0, #1
    sbfx.w r4, r2, #1, #1
    sbfx.w r5, r2, #2, #1
    sbfx.w r6, r2, #3, #1
    sbfx.w r7, r2, #4, #1
    sbfx.w r8, r2, #5, #1
    sbfx.w r9, r2, #6, #1
    sbfx.w r10, r2, #7, #1

    strh.w r4, [r0, #2]
    strh.w r5, [r0, #4]
    strh.w r6, [r0, #6]
    strh.w r7, [r0, #8]
    strh.w r8, [r0, #10]
    strh.w r9, [r0, #12]
    strh.w r10, [r0, #14]
    strh.w r3, [r0], #16

    lsr.w r2, r2, #8

    cmp.w r0, r12
    bne.w _1_to_16_inner

    cmp.w r0, r14
    bne.w _1_to_16

    pop.w {r4-r12, pc}

.align 2
.global __asm_3_to_16
.type __asm_3_to_16, %function
__asm_3_to_16:
    push.w {r4-r12, lr}

    add.w r14, r0, #512

    _3_to_16:

    ldr.w r4, [r1, #4]
    ldr.w r5, [r1, #8]
    ldr.w r3, [r1], #12

    sbfx.w r2, r3, #0, #3
    strh.w r2, [r0], #2
    sbfx.w r2, r3, #3, #3
    strh.w r2, [r0], #2
    sbfx.w r2, r3, #6, #3
    strh.w r2, [r0], #2
    sbfx.w r2, r3, #9, #3
    strh.w r2, [r0], #2
    sbfx.w r2, r3, #12, #3
    strh.w r2, [r0], #2
    sbfx.w r2, r3, #15, #3
    strh.w r2, [r0], #2
    sbfx.w r2, r3, #18, #3
    strh.w r2, [r0], #2
    sbfx.w r2, r3, #21, #3
    strh.w r2, [r0], #2
    sbfx.w r2, r3, #24, #3
    strh.w r2, [r0], #2
    sbfx.w r2, r3, #27, #3
    strh.w r2, [r0], #2
    lsr.w r3, r3, #30
    sbfx.w r2, r4, #0, #1
    orr.w r2, r3, r2, lsl #2
    strh.w r2, [r0], #2

    sbfx.w r2, r4, #1, #3
    strh.w r2, [r0], #2
    sbfx.w r2, r4, #4, #3
    strh.w r2, [r0], #2
    sbfx.w r2, r4, #7, #3
    strh.w r2, [r0], #2
    sbfx.w r2, r4, #10, #3
    strh.w r2, [r0], #2
    sbfx.w r2, r4, #13, #3
    strh.w r2, [r0], #2
    sbfx.w r2, r4, #16, #3
    strh.w r2, [r0], #2
    sbfx.w r2, r4, #19, #3
    strh.w r2, [r0], #2
    sbfx.w r2, r4, #22, #3
    strh.w r2, [r0], #2
    sbfx.w r2, r4, #25, #3
    strh.w r2, [r0], #2
    sbfx.w r2, r4, #28, #3
    strh.w r2, [r0], #2
    lsr.w r4, r4, #31
    sbfx.w r2, r5, #0, #2
    orr.w r2, r4, r2, lsl #1
    strh.w r2, [r0], #2

    sbfx.w r2, r5, #2, #3
    strh.w r2, [r0], #2
    sbfx.w r2, r5, #5, #3
    strh.w r2, [r0], #2
    sbfx.w r2, r5, #8, #3
    strh.w r2, [r0], #2
    sbfx.w r2, r5, #11, #3
    strh.w r2, [r0], #2
    sbfx.w r2, r5, #14, #3
    strh.w r2, [r0], #2
    sbfx.w r2, r5, #17, #3
    strh.w r2, [r0], #2
    sbfx.w r2, r5, #20, #3
    strh.w r2, [r0], #2
    sbfx.w r2, r5, #23, #3
    strh.w r2, [r0], #2
    sbfx.w r2, r5, #26, #3
    strh.w r2, [r0], #2
    sbfx.w r2, r5, #29, #3
    strh.w r2, [r0], #2

    cmp.w r0, r14
    bne.w _3_to_16

    pop.w {r4-r12, pc}

.align 2
.global __asm_4_to_16
.type __asm_4_to_16, %function
__asm_4_to_16:
    push.w {r4-r12, lr}

    sub.w r1, r1, #4
    sub.w r14, r0, #16

    add.w r1, r1, #128
    add.w r0, r14, #512

    _4_to_16:

    ldr.w r2, [r1], #-4

    sbfx.w r3, r2, #0, #4
    sbfx.w r4, r2, #4, #4
    sbfx.w r5, r2, #8, #4
    sbfx.w r6, r2, #12, #4
    sbfx.w r7, r2, #16, #4
    sbfx.w r8, r2, #20, #4
    sbfx.w r9, r2, #24, #4
    sbfx.w r10, r2, #28, #4

    strh.w r4, [r0, #2]
    strh.w r5, [r0, #4]
    strh.w r6, [r0, #6]
    strh.w r7, [r0, #8]
    strh.w r8, [r0, #10]
    strh.w r9, [r0, #12]
    strh.w r10, [r0, #14]
    strh.w r3, [r0], #-16

    cmp.w r0, r14
    bne.w _4_to_16

    pop.w {r4-r12, pc}

.align 2
.global __asm_6_to_16
.type __asm_6_to_16, %function
__asm_6_to_16:
    push.w {r4-r12, lr}

    add.w r14, r0, #512

    _6_to_16:

    ldr.w r4, [r1, #4]
    ldr.w r5, [r1, #8]
    ldr.w r3, [r1], #12

    sbfx.w r2, r3, #0, #6
    strh.w r2, [r0], #2
    sbfx.w r2, r3, #6, #6
    strh.w r2, [r0], #2
    sbfx.w r2, r3, #12, #6
    strh.w r2, [r0], #2
    sbfx.w r2, r3, #18, #6
    strh.w r2, [r0], #2
    sbfx.w r2, r3, #24, #6
    strh.w r2, [r0], #2
    lsr.w r3, r3, #30
    sbfx.w r2, r4, #0, #4
    orr.w r2, r3, r2, lsl #2
    strh.w r2, [r0], #2

    sbfx.w r2, r4, #4, #6
    strh.w r2, [r0], #2
    sbfx.w r2, r4, #10, #6
    strh.w r2, [r0], #2
    sbfx.w r2, r4, #16, #6
    strh.w r2, [r0], #2
    sbfx.w r2, r4, #22, #6
    strh.w r2, [r0], #2
    lsr.w r4, r4, #28
    sbfx.w r2, r5, #0, #2
    orr.w r2, r4, r2, lsl #4
    strh.w r2, [r0], #2

    sbfx.w r2, r5, #2, #6
    strh.w r2, [r0], #2
    sbfx.w r2, r5, #8, #6
    strh.w r2, [r0], #2
    sbfx.w r2, r5, #14, #6
    strh.w r2, [r0], #2
    sbfx.w r2, r5, #20, #6
    strh.w r2, [r0], #2
    sbfx.w r2, r5, #26, #6
    strh.w r2, [r0], #2

    cmp.w r0, r14
    bne.w _6_to_16

    pop.w {r4-r12, pc}

.align 2
.global __asm_10_to_16
.type __asm_10_to_16, %function
__asm_10_to_16:
    push.w {r4-r12, lr}

    sub.w r1, r1, #10
    sub.w r14, r0, #16

    add.w r1, r1, #320
    add.w r0, r14, #512

    _10_to_16:

    ldr.w r4, [r1, #4]
    ldrsh.w r5, [r1, #8]
    ldr.w r3, [r1], #-10

    sbfx.w r2, r3, #0, #10
    strh.w r2, [r0], #2
    sbfx.w r2, r3, #10, #10
    strh.w r2, [r0], #2
    sbfx.w r2, r3, #20, #10
    strh.w r2, [r0], #2
    lsr.w r3, r3, #30
    sbfx.w r2, r4, #0, #8
    orr.w r2, r3, r2, lsl #2
    strh.w r2, [r0], #2

    sbfx.w r2, r4, #8, #10
    strh.w r2, [r0], #2
    sbfx.w r2, r4, #18, #10
    strh.w r2, [r0], #2
    lsr.w r4, r4, #28
    sbfx.w r2, r5, #0, #6
    orr.w r2, r4, r2, lsl #4
    strh.w r2, [r0], #2

    sbfx.w r2, r5, #6, #10
    strh.w r2, [r0], #-30

    cmp.w r0, r14
    bne.w _10_to_16

    pop.w {r4-r12, pc}

.align 2
.global __asm_13_to_16
.type __asm_13_to_16, %function
__asm_13_to_16:
    push.w {r4-r12, lr}

    sub.w r1, r1, #26
    sub.w r14, r0, #32

    add.w r1, r1, #416
    add.w r0, r14, #512

    _13_to_16:

    ldr.w r4, [r1, #4]
    ldr.w r5, [r1, #8]
    ldr.w r6, [r1, #12]
    ldr.w r7, [r1, #16]
    ldr.w r8, [r1, #20]
    ldrsh.w r9, [r1, #24]
    ldr.w r3, [r1], #-26

    sbfx.w r2, r3, #0, #13
    strh.w r2, [r0], #2
    sbfx.w r2, r3, #13, #13
    strh.w r2, [r0], #2
    lsr.w r3, r3, #26
    sbfx.w r2, r4, #0, #7
    orr.w r2, r3, r2, lsl #6
    strh.w r2, [r0], #2

    sbfx.w r2, r4, #7, #13
    strh.w r2, [r0], #2
    lsr.w r4, r4, #20
    sbfx.w r2, r5, #0, #1
    orr.w r2, r4, r2, lsl #12
    strh.w r2, [r0], #2

    sbfx.w r2, r5, #1, #13
    strh.w r2, [r0], #2
    sbfx.w r2, r5, #14, #13
    strh.w r2, [r0], #2
    lsr.w r5, r5, #27
    sbfx.w r2, r6, #0, #8
    orr.w r2, r5, r2, lsl #5
    strh.w r2, [r0], #2

    sbfx.w r2, r6, #8, #13
    strh.w r2, [r0], #2
    lsr.w r6, r6, #21
    sbfx.w r2, r7, #0, #2
    orr.w r2, r6, r2, lsl #11
    strh.w r2, [r0], #2

    sbfx.w r2, r7, #2, #13
    strh.w r2, [r0], #2
    sbfx.w r2, r7, #15, #13
    strh.w r2, [r0], #2
    lsr.w r7, r7, #28
    sbfx.w r2, r8, #0, #9
    orr.w r2, r7, r2, lsl #4
    strh.w r2, [r0], #2

    sbfx.w r2, r8, #9, #13
    strh.w r2, [r0], #2
    lsr.w r8, r8, #22
    sbfx.w r2, r9, #0, #3
    orr.w r2, r8, r2, lsl #10
    strh.w r2, [r0], #2

    sbfx.w r2, r9, #3, #13
    strh.w r2, [r0], #-62

    cmp.w r0, r14
    bne.w _13_to_16

    pop.w {r4-r12, pc}

