#ifndef NTT_H
#define NTT_H

#include "SABER_params.h"
#include "NTT_params.h"
#include <stdint.h>

static const int32_t final_constants[8] = {
    Q1, Q2, Q1invRmod, Q2prime, Q1Q2
};

// profile.compressed_layers = 2;
// for(int i = 0; i < profile.compressed_layers; i++){
//     profile.merged_layers[i]= 3;
// }

// gen_streamlined_CT_negacyclic_table(streamlined_CT_negacyclic_table_Q1, RmodQ1, omegaQ1, Q1, &profile, 0);
// print_table(streamlined_CT_negacyclic_table_Q1, NTT_N);
static const int32_t streamlined_CT_negacyclic_table_Q1[NTT_N] = {
3777, -3182, 3625, -3696, -1100, 2456, 2194, -121, -2088, -2816, 3266, -3600, -1738, 3689, 2250, 1986, 2237, -638, -7, 1887, -810, -834, 1993, 1599, 1305, 1760, 679, -438, 2495, -2006, -3706, 3555, 1881, 3174, 396, 2319, 2557, -1525, -2555, 2440, -3772, 2535, -2876, -1483, 1296, 2310, -3153, -1535, 549, 1701, -3364, -2830, 2956, 514, -1399, 1321, -1414, -1921, 617, 1431, -2043, -103, 2804, 0
};

// gen_streamlined_CT_negacyclic_table(streamlined_CT_negacyclic_table_Q2, RmodQ2, omegaQ2, Q2, &profile, 0);
// print_table(streamlined_CT_negacyclic_table_Q2, NTT_N);
static const int32_t streamlined_CT_negacyclic_table_Q2[NTT_N] = {
-758, 359, 1517, -1422, 1493, 202, -287, -182, 130, -1602, 1469, -126, -1618, -1162, 1577, 829, -1458, -8, -516, 666, -320, 171, 1325, 573, 1015, 552, 1223, 652, -622, 383, -264, -282, -1544, -1491, -1293, 1474, -411, -1542, -725, 1508, -398, 961, -1468, -1571, 205, 677, -1275, 1065, 448, -1202, -732, -608, -1421, -107, 951, -247, -962, 1017, 681, -271, 830, 90, -853, 0
};

// gen_mul_table(mul_Rmod_table_Q1, center_mul(omegaQ1, RmodQ1, Q1), expmod(omegaQ1, 2, Q1), Q1);
// print_table(mul_Rmod_table_Q1, NTT_N >> 1);
static const int32_t mul_Rmod_table_Q1[NTT_N >> 1] = {
3266, -3600, -1738, 3689, -638, -7, 1887, -810, 1305, 1760, 679, -438, 3555, 1881, 3174, 396, -2555, 2440, -3772, 2535, 2310, -3153, -1535, 549, 2956, 514, -1399, 1321, 1431, -2043, -103, 2804
};

// gen_mul_table(mul_Rmod_table_Q2, center_mul(omegaQ2, RmodQ2, Q2), expmod(omegaQ2, 2, Q2), Q2);
// print_table(mul_Rmod_table_Q2, NTT_N >> 1);
static const int32_t mul_Rmod_table_Q2[NTT_N >> 1] = {
1469, -126, -1618, -1162, -8, -516, 666, -320, 1015, 552, 1223, 652, -282, -1544, -1491, -1293, -725, 1508, -398, 961, 677, -1275, 1065, 448, -1421, -107, 951, -247, -271, 830, 90, -853
};

// gen_streamlined_inv_CT_negacyclic_table(streamlined_inv_CT_negacyclic_table_Q1, RmodQ1, expmod(invomegaQ1, 2, Q1), center_mul(expmod(RmodQ1, 2, Q1), invNQ1, Q1), invomegaQ1, Q1, &profile, 0);
// print_table(streamlined_inv_CT_negacyclic_table_Q1, NTT_N << 1);
static const int32_t streamlined_inv_CT_negacyclic_table_Q1[NTT_N << 1] = {
-3593, -3593, -3777, -3593, -3625, -3777, 3182, -3593, -3593, -3777, -3593, -3625, -3777, 3182, -33, -3804, -2077, -2707, 3576, -3257, 1624, -2029, -2194, 1414, -1701, -617, 2830, 1921, 3364, 1398, -848, 2800, 3653, -2062, -3771, 1727, -630, -3625, -2194, -2456, 1414, 2876, -1701, -2319, -1966, 1709, 2183, 2357, 768, -2246, 3648, 853, 1100, -2495, 834, 3706, -1599, 2006, -1993, 1589, 3014, 1787, 2795, -1113, 3675, 474, 174, -3777, -3625, 3182, -2194, 1100, -2456, 3696, -3773, 2893, 3201, 300, 1763, 1425, -1227, 1008, -2456, 2876, -2319, -1296, 1525, 1483, -2557, -1463, 338, 2652, -2235, -2765, -1015, 308, -2901, 3182, 1100, 3696, -2495, -2250, 834, 121, 530, -1750, -1323, 3209, 3317, 1801, 2314, 2794, 3696, -2250, 121, -2237, 2816, -1986, 2088, -108, 1516, -513, -480, 3324, -2280, 427, -3149, 0
};

// gen_streamlined_inv_CT_negacyclic_table(streamlined_inv_CT_negacyclic_table_Q2, RmodQ2, expmod(invomegaQ2, 2, Q2), center_mul(expmod(RmodQ2, 2, Q2), invNQ2, Q2), invomegaQ2, Q2, &profile, 0);
// print_table(streamlined_inv_CT_negacyclic_table_Q2, NTT_N << 1);
static const int32_t streamlined_inv_CT_negacyclic_table_Q2[NTT_N << 1] = {
-1044, -1044, 758, -1044, -1517, 758, -359, -1044, -1044, 758, -1044, -1517, 758, -359, -447, 936, 1235, -821, 535, -450, -1426, 1355, 287, 962, 1202, -681, 608, -1017, 732, 1274, -76, -1025, -289, 1052, 1573, 1197, 331, -1517, 287, -202, 962, 1468, 1202, -1474, -1583, -193, 69, 1062, 569, 797, 543, 1410, -1493, 622, -171, 264, -573, -383, -1325, -910, 1481, -219, 682, -1227, -648, -855, -712, 758, -1517, -359, 287, -1493, -202, 1422, -296, 1089, -1476, -283, -882, 1333, -1339, -56, -202, 1468, -1474, -205, 1542, 1571, 411, 650, 1320, 632, 464, 1352, 1414, -816, 33, -359, -1493, 1422, 622, -1577, -171, 182, 687, 1600, -848, -749, 630, -1, 1432, 40, 1422, -1577, 182, 1458, 1602, -829, -130, 1438, 1435, -927, -807, 461, -1010, 1534, 452, 0
};

extern void __asm_mul(uint32_t *des, uint32_t R2modQ, uint32_t Qprime2, uint32_t Q, uint32_t *src);
extern void __asm_negacyclic_ntt(uint32_t *des, const int32_t *root_table, uint32_t Qprime, uint32_t Q, uint16_t *src, uint32_t RmodQ);
extern void __asm_negacyclic_ntt_light(uint32_t *des, const int32_t *root_table, uint32_t Qprime, uint32_t Q, uint16_t *src, uint32_t RmodQ);
extern void __asm_base_mul(uint32_t *des, const int32_t *mul_Rmod_table, uint32_t Qprime, uint32_t Q, uint32_t *src1, uint32_t *src2);
extern void __asm_base_mul_acc(uint32_t *des, const int32_t *mul_Rmod_table, uint32_t Qprime, uint32_t Q, uint32_t *src1, uint32_t *src2);
extern void __asm_intt(uint32_t *des, const int32_t *inv_root_table, uint32_t Qprime, uint32_t Q, uint32_t RmodQ);
extern void __asm_intt_light(uint32_t *des, const int32_t *inv_root_table, uint32_t Qprime, uint32_t Q, uint32_t RmodQ);
extern void __asm_solv_CRT(uint16_t *des, uint32_t *src2, uint32_t *src1, const int32_t *_final_constants);

#define NTT_forward1(out, in) __asm_negacyclic_ntt(out, streamlined_CT_negacyclic_table_Q1, Q1prime, Q1, in, Q1bar)
#define NTT_forward2(out, in) __asm_negacyclic_ntt_light(out, streamlined_CT_negacyclic_table_Q2, Q2prime, Q2, in, Q2bar)

#define NTT_forward(out, in) { \
        NTT_forward1(out + 0 * SABER_N / 2, in); \
        NTT_forward2(out + 1 * SABER_N / 2, in); \
    }

#define NTT_mul1(out, in1, in2) __asm_base_mul(out, mul_Rmod_table_Q1, Q1prime, Q1, in1, in2)
#define NTT_mul2(out, in1, in2) __asm_base_mul(out, mul_Rmod_table_Q2, Q2prime, Q2, in1, in2)

#define NTT_mul(out, in1, in2) { \
        NTT_mul1(out + 0 * SABER_N / 2, in1 + 0 * SABER_N / 2, in2 + 0 * SABER_N / 2); \
        NTT_mul2(out + 1 * SABER_N / 2, in1 + 1 * SABER_N / 2, in2 + 1 * SABER_N / 2); \
    }

#define NTT_mul_acc1(out, in1, in2) __asm_base_mul_acc(out, mul_Rmod_table_Q1, Q1prime, Q1, in1, in2)
#define NTT_mul_acc2(out, in1, in2) __asm_base_mul_acc(out, mul_Rmod_table_Q2, Q2prime, Q2, in1, in2)

#define NTT_mul_acc(out, in1, in2) { \
        NTT_mul_acc1(out + 0 * SABER_N / 2, in1 + 0 * SABER_N / 2, in2 + 0 * SABER_N / 2); \
        NTT_mul_acc2(out + 1 * SABER_N / 2, in1 + 1 * SABER_N / 2, in2 + 1 * SABER_N / 2); \
    }

#define NTT_inv1(in) __asm_intt(in, streamlined_inv_CT_negacyclic_table_Q1, Q1prime, Q1, Q1bar)
#define NTT_inv2(in) __asm_intt_light(in, streamlined_inv_CT_negacyclic_table_Q2, Q2prime, Q2, Q2bar)
#define solv_CRT(out, in1, in2) __asm_solv_CRT(out, in2, in1, final_constants)

#define NTT_inv(out, in) { \
        NTT_inv1(in + 0 * SABER_N / 2); \
        NTT_inv2(in + 1 * SABER_N / 2); \
        solv_CRT(out, in + 0 * SABER_N / 2, in + 1 * SABER_N / 2 ); \
    }



#endif
