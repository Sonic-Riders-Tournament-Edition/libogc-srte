#include <asm.h>

#define A00_A01		fr0
#define A02_A03		fr1
#define A10_A11		fr2
#define A12_A13		fr3
#define A20_A21		fr4
#define A22_A23		fr5

#define B00_B01		fr6
#define B02_B03		fr7
#define B10_B11		fr8
#define B12_B13		fr9
#define B20_B21		fr10
#define B22_B23		fr11

#define D00_D01		fr12
#define D02_D03		fr13
#define D10_D11		fr14
#define D12_D13		fr15
#define D20_D21		fr2
#define D22_D23		fr0

#define UNIT01		fr31

#define RET_REG		fr1
#define V1_XY		fr2
#define V1_Z		fr3
#define V2_XY		fr4
#define V2_Z		fr5
#define D1_XY		fr6
#define D1_Z		fr7
#define D2_XY		fr8
#define D2_Z		fr9
#define W1_XY		fr10
#define W1_Z		fr11
#define W2_XY		fr12
#define W2_Z		fr13

	.globl	ps_guMtxConcat
	//r3 = mtxA, r4 = mtxB, r5 = mtxAB
ps_guMtxConcat:
	stwu 	r1, -0x40(r1)
	psq_l 		fr0, 0(r3), 0, 0
	stfd 	fr14, 8(r1)
	psq_l 		fr6, 0(r4), 0, 0
	lis 	r6, Unit01@ha
	psq_l 		fr7, 8(r4), 0, 0
	stfd 	fr15, 0x10(r1)
	addi 	r6, r6, Unit01@l
	stfd 	fr31, 0x28(r1)
	psq_l 		fr8, 16(r4), 0, 0
	ps_muls0 	fr12, fr6, fr0
	psq_l 		fr2, 16(r3), 0, 0
	ps_muls0 	fr13, fr7, fr0
	psq_l 		fr31, 0(r6), 0, 0
	ps_muls0 	fr14, fr6, fr2
	psq_l 		fr9, 24(r4), 0, 0
	ps_muls0 	fr15, fr7, fr2
	psq_l 		fr1, 8(r3), 0, 0
	ps_madds1 	fr12, fr8, fr0, fr12
	psq_l 		fr3, 24(r3), 0, 0
	ps_madds1 	fr14, fr8, fr2, fr14
	psq_l 		fr10, 32(r4), 0, 0
	ps_madds1 	fr13, fr9, fr0, fr13
	psq_l 		fr11, 40(r4), 0, 0
	ps_madds1 	fr15, fr9, fr2, fr15
	psq_l 		fr4, 32(r3), 0, 0
	psq_l 		fr5, 40(r3), 0, 0
	ps_madds0 	fr12, fr10, fr1, fr12
	ps_madds0 	fr13, fr11, fr1, fr13
	ps_madds0 	fr14, fr10, fr3, fr14
	ps_madds0 	fr15, fr11, fr3, fr15
	psq_st 		fr12, 0(r5), 0, 0
	ps_muls0 	fr2, fr6, fr4
	ps_madds1 	fr13, fr31, fr1, fr13
	ps_muls0 	fr0, fr7, fr4
	psq_st 		fr14, 16(r5), 0, 0
	ps_madds1 	fr15, fr31, fr3, fr15
	psq_st 		fr13, 8(r5), 0, 0
	ps_madds1 	fr2, fr8, fr4, fr2
	ps_madds1 	fr0, fr9, fr4, fr0
	ps_madds0 	fr2, fr10, fr5, fr2
	lfd 	fr14, 8(r1)
	psq_st 		fr15, 24(r5), 0, 0
	ps_madds0 	fr0, fr11, fr5, fr0
	psq_st 		fr2, 32(r5), 0, 0
	ps_madds1 	fr0, fr31, fr5, fr0
	lfd 	fr15, 0x10(r1)
	psq_st 		fr0, 40(r5), 0, 0
	lfd 	fr31, 0x28(r1)
	addi 	r1, r1, 0x40
	blr 

	.globl ps_guMtxIdentity
	//r3 == mtx
ps_guMtxIdentity:
	lfs		fr0,Unit01@sdarel(r13)
	lfs		fr1,Unit01+4@sdarel(r13)
	psq_st		fr0,8(r3),0,0
	ps_merge01	fr2,fr0,fr1
	psq_st		fr0,24(r3),0,0
	ps_merge10	fr3,fr1,fr0
	psq_st		fr0,32(r3),0,0
	psq_st		fr2,16(r3),0,0
	psq_st		fr3,0(r3),0,0
	psq_st		fr3,40(r3),0,0
	blr

	.globl ps_guMtxCopy
	//r3 = src, r4 = dst
ps_guMtxCopy:
	psq_l		fr0,0(r3),0,0
	psq_st		fr0,0(r4),0,0
	psq_l		fr1,8(r3),0,0
	psq_st		fr1,8(r4),0,0
	psq_l		fr2,16(r3),0,0
	psq_st		fr2,16(r4),0,0
	psq_l		fr3,24(r3),0,0
	psq_st		fr3,24(r4),0,0
	psq_l		fr4,32(r3),0,0
	psq_st		fr4,32(r4),0,0
	psq_l		fr5,40(r3),0,0
	psq_st		fr5,40(r4),0,0
	blr

	.globl ps_guMtxTranspose
	//r3 = src, r4 = xpose
ps_guMtxTranspose:
	lfs		fr0,Unit01@sdarel(r13)
	psq_l		fr1,0(r3),0,0
	stfs		fr0,44(r4)
	psq_l		fr2,16(r3),0,0
	ps_merge00	fr5,fr1,fr2
	psq_l		fr3,8(r3),1,0
	ps_merge11	fr6,fr1,fr2
	psq_l		fr4,24(r3),1,0
	psq_st		fr5,0(r4),0,0
	psq_l		fr1,32(r3),0,0
	ps_merge00	fr7,fr3,fr4
	psq_st		fr6,16(r4),0,0
	ps_merge00	fr5,fr1,fr0
	psq_st		fr7,32(r4),0,0
	ps_merge10	fr6,fr1,fr0
	psq_st		fr5,8(r4),0,0
	lfs		fr3,40(r3)
	psq_st		fr6,24(r4),0,0
	stfs		fr3,40(r4)
	blr

	.globl ps_guMtxInverse
	//r3 = src, r4 = inv
ps_guMtxInverse:
	psq_l		fr0,0(r3),1,0
	psq_l		fr1,4(r3),0,0
	psq_l		fr2,16(r3),1,0
	ps_merge10	fr6,fr1,fr0
	psq_l		fr3,20(r3),0,0
	psq_l		fr4,32(r3),1,0
	ps_merge10	fr7,fr3,fr2
	psq_l		fr5,36(r3),0,0
	ps_mul		fr11,fr3,fr6
	ps_mul		fr13,fr5,fr7
	ps_merge10	fr8,fr5,fr4
	ps_msub		fr11,fr1,fr7,fr11
	ps_mul		fr12,fr1,fr8
	ps_msub		fr13,fr3,fr8,fr13
	ps_mul		fr10,fr3,fr4
	ps_msub		fr12,fr5,fr6,fr12
	ps_mul		fr9,fr0,fr5
	ps_mul		fr8,fr1,fr2
	ps_sub		fr6,fr6,fr6
	ps_msub		fr10,fr2,fr5,fr10
	ps_mul		fr7,fr0,fr13
	ps_msub		fr9,fr1,fr4,fr9
	ps_madd		fr7,fr2,fr12,fr7
	ps_msub		fr8,fr0,fr3,fr8
	ps_madd		fr7,fr4,fr11,fr7
	ps_cmpo0	cr0,fr7,fr6
	bne			0f
	li			r3,0
	blr

0:	fres		fr0,fr7
	ps_add		fr6,fr0,fr0
	ps_mul		fr5,fr0,fr0
	ps_nmsub	fr0,fr7,fr5,fr6
	lfs		fr1,12(r3)
	ps_muls0	fr13,fr13,fr0
	lfs		fr2,28(r3)
	ps_muls0	fr12,fr12,fr0
	lfs		fr3,44(r3)
	ps_muls0	fr11,fr11,fr0
	ps_merge00	fr5,fr13,fr12
	ps_muls0	fr10,fr10,fr0
	ps_merge11	fr4,fr13,fr12
	ps_muls0	fr9,fr9,fr0
	psq_st		fr5,0(r4),0,0
	ps_mul		fr6,fr13,fr1
	psq_st		fr4,16(r4),0,0
	ps_muls0	fr8,fr8,fr0
	ps_madd		fr6,fr12,fr2,fr6
	psq_st		fr10,32(r4),1,0
	ps_nmadd	fr6,fr11,fr3,fr6
	psq_st		fr9,36(r4),1,0
	ps_mul		fr7,fr10,fr1
	ps_merge00	fr5,fr11,fr6
	psq_st		fr8,40(r4),1,0
	ps_merge11	fr4,fr11,fr6
	psq_st		fr5,8(r4),0,0
	ps_madd		fr7,fr9,fr2,fr7
	psq_st		fr4,24(r4),0,0
	ps_nmadd	fr7,fr8,fr3,fr7
	li		r3,1
	psq_st		fr7,44(r4),1,0
	blr

	.globl ps_guMtxInvXpose
	//r3 = src, r4 = invx
ps_guMtxInvXpose:
	psq_l       fr0, 0(r3), 1, 0
	psq_l       fr1, 4(r3), 0, 0
	psq_l       fr2, 16(r3), 1, 0
	ps_merge10  fr6, fr1, fr0
	psq_l       fr3, 20(r3), 0, 0
	psq_l       fr4, 32(r3), 1, 0
	ps_merge10  fr7, fr3, fr2
	psq_l       fr5, 36(r3), 0, 0
	ps_mul      fr11, fr3, fr6
	ps_merge10  fr8, fr5, fr4
	ps_mul      fr13, fr5, fr7
	ps_msub     fr11, fr1, fr7, fr11
	ps_mul      fr12, fr1, fr8
	ps_msub     fr13, fr3, fr8, fr13
	ps_msub     fr12, fr5, fr6, fr12
	ps_mul      fr10, fr3, fr4
	ps_mul      fr9,  fr0, fr5
	ps_mul      fr8,  fr1, fr2
	ps_msub     fr10, fr2, fr5, fr10
	ps_msub     fr9,  fr1, fr4, fr9
	ps_msub     fr8,  fr0, fr3, fr8
	ps_mul      fr7, fr0, fr13
	ps_sub      fr1, fr1, fr1
	ps_madd     fr7, fr2, fr12, fr7
	ps_madd     fr7, fr4, fr11, fr7
	ps_cmpo0    cr0, fr7, fr1
	bne         0f
	addi        r3, 0, 0
	blr

0:	fres        fr0, fr7
	psq_st      fr1,  12(r4), 1, 0
	ps_add      fr6, fr0, fr0
	ps_mul      fr5, fr0, fr0
	psq_st      fr1,  28(r4), 1, 0
	ps_nmsub    fr0, fr7, fr5, fr6
	psq_st      fr1,  44(r4), 1, 0
	ps_muls0    fr13, fr13, fr0
	ps_muls0    fr12, fr12, fr0
	ps_muls0    fr11, fr11, fr0
	psq_st      fr13,  0(r4), 0, 0
	psq_st      fr12,  16(r4), 0, 0
	ps_muls0    fr10, fr10, fr0
	ps_muls0    fr9,  fr9,  fr0
	psq_st      fr11,  32(r4), 0, 0
	psq_st      fr10,  8(r4), 1, 0
	ps_muls0    fr8,  fr8,  fr0
	addi        r3, 0, 1
	psq_st      fr9,   24(r4), 1, 0
	psq_st      fr8,   40(r4), 1, 0
	blr

	.globl ps_guMtxScale
	//r3 = mtx,fr1 = xS,fr2 = yS,fr3 = zS
ps_guMtxScale:
	lfs		fr0,Unit01@sdarel(r13)
	stfs		fr1,0(r3)
	psq_st		fr0,4(r3),0,0
	psq_st		fr0,12(r3),0,0
	stfs		fr2,20(r3)
	psq_st		fr0,24(r3),0,0
	psq_st		fr0,32(r3),0,0
	stfs		fr3,40(r3)
	stfs		fr0,44(r3)
	blr

	.globl ps_guMtxScaleApply
	//r3 = src,r4 = dst,fr1 = xS,fr2 = yS,fr3 = zS
ps_guMtxScaleApply:
	frsp		fr1,fr1
	psq_l		fr4,0(r3),0,0
	frsp		fr2,fr2
	psq_l		fr5,8(r3),0,0
	frsp		fr3,fr3
	ps_muls0	fr4,fr4,fr1
	psq_l		fr6,16(r3),0,0
	ps_muls0	fr5,fr5,fr1
	psq_l		fr7,24(r3),0,0
	ps_muls0	fr6,fr6,fr2
	psq_l		fr8,32(r3),0,0
	psq_st		fr4,0(r4),0,0
	ps_muls0	fr7,fr7,fr2
	psq_l		fr2,40(r3),0,0
	psq_st		fr5,8(r4),0,0
	ps_muls0	fr8,fr8,fr3
	psq_st		fr6,16(r4),0,0
	ps_muls0	fr2,fr2,fr3
	psq_st		fr7,24(r4),0,0
	psq_st		fr8,32(r4),0,0
	psq_st		fr2,40(r4),0,0
	blr

	.globl ps_guMtxApplyScale
	//r3 = src,r4 = dst,fr1 = xS,fr2 = yS,fr3 = zS
ps_guMtxApplyScale:
	lfs		fr6,Unit01+4@sdarel(r13)
	frsp		fr1,fr1
	psq_l		fr4,0(r3),0,0
	frsp		fr2,fr2
	psq_l		fr5,8(r3),0,0
	frsp		fr3,fr3
	ps_merge00	fr10,fr1,fr2
	ps_merge00	fr11,fr3,fr6
	ps_mul		fr4,fr4,fr10
	psq_l		fr6,16(r3),0,0
	ps_mul		fr5,fr5,fr11
	psq_l		fr7,24(r3),0,0
	ps_mul		fr6,fr6,fr10
	psq_l		fr8,32(r3),0,0
	psq_st		fr4,0(r4),0,0
	ps_mul		fr7,fr7,fr11
	psq_l		fr2,40(r3),0,0
	psq_st		fr5,8(r4),0,0
	ps_mul		fr8,fr8,fr10
	psq_st		fr6,16(r4),0,0
	ps_mul		fr2,fr2,fr11
	psq_st		fr7,24(r4),0,0
	psq_st		fr8,32(r4),0,0
	psq_st		fr2,40(r4),0,0
	blr

	.globl ps_guMtxTrans
	//r3 = mtx,fr1 = xT,fr2 = yT,fr3 = zT
ps_guMtxTrans:
	lfs 		fr0, Unit01@sdarel(r13)
	lfs 		fr4, Unit01+0x4@sdarel(r13)
	stfs 		fr1, 0xc(r3)
	stfs 		fr2, 0x1c(r3)
	psq_st 		fr0, 4(r3), 0, 0
	psq_st 		fr0, 32(r3), 0, 0
	stfs 		fr0, 0x10(r3)
	stfs 		fr4, 0x14(r3)
	stfs 		fr0, 0x18(r3)
	stfs 		fr4, 0x28(r3)
	stfs 		fr3, 0x2c(r3)
	stfs 		fr4, 0(r3)
	blr 

	.globl ps_guMtxTransApply
	//r3 = src,r4 = dst,fr1 = xT,fr2 = yT,fr3 = zT
ps_guMtxTransApply:
	psq_l		fr4,0(r3),0,0
	frsp		fr1,fr1
	psq_l		fr5,8(r3),0,0
	frsp		fr2,fr2
	psq_l		fr7,24(r3),0,0
	frsp		fr3,fr3
	psq_l		fr8,40(r3),0,0
	ps_sum1		fr5,fr1,fr5,fr5
	psq_l		fr6,16(r3),0,0
	ps_sum1		fr7,fr2,fr7,fr7
	psq_l		fr9,32(r3),0,0
	ps_sum1		fr8,fr3,fr8,fr8
	psq_st		fr4,0(r4),0,0
	psq_st		fr5,8(r4),0,0
	psq_st		fr6,16(r4),0,0
	psq_st		fr7,24(r4),0,0
	psq_st		fr9,32(r4),0,0
	psq_st		fr8,40(r4),0,0
	blr

	.globl ps_guMtxApplyTrans
	//r3 = src,r4 = dst,fr1 = xT,fr2 = yT,fr3 = zT
ps_guMtxApplyTrans:
	lfs		fr6,Unit01+4@sdarel(r13)
	psq_l		fr4,0(r3),0,0
	frsp		fr1,fr1
	psq_l		fr5,8(r3),0,0
	frsp		fr2,fr2
	ps_merge00	fr10,fr1,fr2
	psq_l		fr7,24(r3),0,0
	frsp		fr3,fr3
	ps_mul		fr1,fr4,fr10
	ps_merge00	fr11,fr3,fr6
	psq_l		fr8,40(r3),0,0
	ps_madd		fr2,fr5,fr11,fr1
	psq_l		fr6,16(r3),0,0
	ps_sum0		fr3,fr2,fr3,fr2
	psq_l		fr9,32(r3),0,0
	ps_mul		fr12,fr6,fr10
	psq_st		fr4,0(r4),0,0
	ps_madd		fr4,fr7,fr11,fr12
	psq_st		fr5,8(r4),1,0
	ps_sum0		fr12,fr4,fr12,fr4
	psq_st		fr3,12(r4),1,0
	ps_mul		fr3,fr9,fr10
	psq_st		fr6,16(r4),0,0
	ps_madd		fr2,fr8,fr11,fr3
	psq_st		fr7,24(r4),1,0
	ps_sum0		fr3,fr2,fr3,fr2
	psq_st		fr12,28(r4),1,0
	psq_st		fr9,32(r4),0,0
	psq_st		fr8,40(r4),1,0
	psq_st		fr3,44(r4),1,0
	blr

	.globl ps_guMtxRotTrig
	//r3 = mt,r4 = axis,fr1 = sinA,fr2 = cosA
ps_guMtxRotTrig:
	frsp		fr1,fr1
	lfs		fr3,Unit01@sdarel(r13)
	frsp		fr2,fr2
	lfs		fr4,Unit01+4@sdarel(r13)
	ori		r4,r4,0x20
	ps_neg		fr5,fr1
	cmplwi		r4,'x'
	beq		0f
	cmplwi		r4,'y'
	beq		1f
	cmplwi		r4,'z'
	beq		2f
	b		3f
0:
	psq_st		fr4,0(r3),1,0
	psq_st		fr3,4(r3),0,0
	ps_merge00	fr6,fr1,fr2
	psq_st		fr3,12(r3),0,0
	ps_merge00	fr7,fr2,fr5
	psq_st		fr3,28(r3),0,0
	psq_st		fr3,44(r3),1,0
	psq_st		fr6,36(r3),0,0
	psq_st		fr7,20(r3),0,0
	b		3f
1:
	ps_merge00	fr6,fr2,fr3
	ps_merge00	fr7,fr3,fr4
	psq_st		fr3,24(r3),0,0
	psq_st		fr6,0(r3),0,0
	ps_merge00	fr8,fr5,fr3
	ps_merge00	fr9,fr1,fr3
	psq_st		fr6,40(r3),0,0
	psq_st		fr7,16(r3),0,0
	psq_st		fr9,8(r3),0,0
	psq_st		fr8,32(r3),0,0
	b		3f
2:
	psq_st		fr3,8(r3),0,0
	ps_merge00	fr6,fr1,fr2
	ps_merge00	fr8,fr2,fr5
	psq_st		fr3,24(r3),0,0
	psq_st		fr3,32(r3),0,0
	ps_merge00	fr7,fr4,fr3
	psq_st		fr6,16(r3),0,0
	psq_st		fr8,0(r3),0,0
	psq_st		fr7,40(r3),0,0
3:
	blr

	.globl __ps_guMtxRotAxisRadInternal
	//r3 = mtx, r4 = vec, fr1 = sT, fr2 = cT
__ps_guMtxRotAxisRadInternal:
	stwu		r1,-64(r1)
	frsp		fr2,fr2
	psq_l		fr3,0(r4),0,0
	frsp		fr1,fr1
	stfd		fr14,8(r1)
	lfs		fr11,NrmData+4@sdarel(r13)
	lfs		fr12,NrmData@sdarel(r13)
	ps_mul		fr5,fr3,fr3
	lfs		fr4,8(r4)
	fadds		fr10,fr12,fr12
	ps_madd		fr6,fr4,fr4,fr5
	fsubs		fr14,fr12,fr12
	ps_sum0		fr7,fr6,fr4,fr5
	fsubs		fr13,fr10,fr2
	frsqrte		fr8,fr7
	fmuls		fr5,fr8,fr8
	fmuls		fr6,fr8,fr12
	fnmsubs		fr5,fr5,fr7,fr11
	fmuls		fr8,fr5,fr6
	ps_merge00	fr2,fr2,fr2
	ps_muls0	fr3,fr3,fr8
	ps_muls0	fr4,fr4,fr8
	ps_muls0	fr7,fr3,fr13
	ps_muls0	fr12,fr3,fr1
	ps_muls0	fr8,fr4,fr13
	ps_muls1	fr6,fr7,fr3
	ps_muls0	fr5,fr7,fr3
	ps_muls0	fr7,fr7,fr4
	fnmsubs		fr9,fr4,fr1,fr6
	fmadds		fr10,fr4,fr1,fr6
	ps_neg		fr3,fr12
	ps_sum0		fr11,fr7,fr14,fr12
	ps_sum0		fr5,fr5,fr9,fr2
	ps_sum1		fr6,fr2,fr10,fr6
	ps_sum0		fr9,fr3,fr14,fr7
	psq_st		fr11,8(r3),0,0
	ps_sum0		fr3,fr7,fr7,fr3
	psq_st		fr5,0(r3),0,0
	ps_muls0	fr8,fr8,fr4
	psq_st		fr6,16(r3),0,0
	ps_sum1		fr7,fr12,fr3,fr7
	psq_st		fr9,24(r3),0,0
	ps_sum0		fr8,fr8,fr14,fr2
	psq_st		fr7,32(r3),0,0
	psq_st		fr8,40(r3),0,0
	lfd			fr14,8(r1)
	addi		r1,r1,64
	blr

	.globl ps_guMtxReflect
	//r3 = mtx,r4 = vec1,r5 = vec2
ps_guMtxReflect:
	lfs		fr0,Unit01+4@sdarel(r13)
	psq_l		fr1,8(r5),1,0
	psq_l		fr2,0(r5),0,0
	psq_l		fr3,0(r4),0,0
	ps_nmadd	fr5,fr1,fr0,fr1
	psq_l		fr4,8(r4),1,0
	ps_nmadd	fr6,fr2,fr0,fr2
	ps_muls0	fr7,fr2,fr5
	ps_mul		fr8,fr6,fr3
	ps_muls0	fr9,fr2,fr6
	ps_sum0		fr8,fr8,fr8,fr8
	ps_muls1	fr10,fr2,fr6
	psq_st		fr7,32(r3),0,0
	ps_sum0		fr2,fr2,fr2,fr0
	ps_nmadd	fr8,fr5,fr4,fr8
	ps_sum1		fr10,fr0,fr10,fr10
	psq_st		fr9,0(r3),0,0
	ps_muls0	fr11,fr2,fr8
	ps_merge00	fr12,fr5,fr8
	psq_st		fr10,16(r3),0,0
	ps_merge00	fr13,fr7,fr11
	ps_muls0	fr12,fr12,fr1
	ps_merge11	fr11,fr7,fr11
	psq_st		fr13,8(r3),0,0
	ps_sum0		fr12,fr12,fr12,fr0
	psq_st		fr11,24(r3),0,0
	psq_st		fr12,40(r3),0,0
	blr

	.globl ps_guMtxQuat
ps_guMtxQuat:
	lfs 	fr1, Unit01+0x4@sdarel(r13)
	psq_l 		fr4, 0(r4), 0, 0
	psq_l 		fr5, 8(r4), 0, 0
	fsubs 	fr0, fr1, fr1
	fadds 	fr2, fr1, fr1
	ps_mul 		fr6, fr4, fr4
	ps_merge10 	fr9, fr4, fr4
	ps_madd 	fr8, fr5, fr5, fr6
	ps_mul 		fr7, fr5, fr5
	ps_sum0 	fr3, fr8, fr8, fr8
	ps_muls1 	fr10, fr9, fr5
	fres 	fr11, fr3
	ps_sum1 	fr8, fr7, fr8, fr6
	ps_nmsub 	fr3, fr3, fr11, fr2
	ps_muls1 	fr7, fr5, fr5
	ps_mul 		fr3, fr11, fr3
	ps_sum0 	fr6, fr6, fr6, fr6
	fmuls 	fr3, fr3, fr2
	ps_madd 	fr11, fr4, fr9, fr7
	ps_msub 	fr7, fr4, fr9, fr7
	psq_st 		fr0, 12(r3), 1, 0
	ps_nmsub 	fr6, fr6, fr3, fr1
	ps_nmsub 	fr8, fr8, fr3, fr1
	psq_st 		fr0, 44(r3), 1, 0
	ps_mul 		fr11, fr11, fr3
	ps_mul 		fr7, fr7, fr3
	psq_st 		fr6, 40(r3), 1, 0
	ps_madds0 	fr9, fr4, fr5, fr10
	ps_merge00 	fr5, fr11, fr8
	ps_nmsub 	fr10, fr10, fr2, fr9
	ps_merge10 	fr4, fr8, fr7
	psq_st 		fr5, 16(r3), 0, 0
	ps_mul 		fr9, fr9, fr3
	ps_mul 		fr10, fr10, fr3
	psq_st 		fr4, 0(r3), 0, 0
	psq_st 		fr9, 8(r3), 1, 0
	ps_merge10 	fr7, fr10, fr0
	ps_merge01 	fr11, fr10, fr9
	psq_st 		fr7, 24(r3), 0, 0
	psq_st 		fr11, 32(r3), 0, 0
	blr

	.global ps_guMtxMultVec
ps_guMtxMultVec:
	psq_l 		fr0, 0(r4), 0, 0
	psq_l 		fr2, 0(r3), 0, 0
	psq_l 		fr1, 8(r4), 1, 0
	ps_mul 		fr4, fr2, fr0
	psq_l 		fr3, 8(r3), 0, 0
	ps_madd 	fr5, fr3, fr1, fr4
	psq_l 		fr8, 16(r3), 0, 0
	ps_sum0 	fr6, fr5, fr6, fr5
	psq_l 		fr9, 24(r3), 0, 0
	ps_mul 		fr10, fr8, fr0
	psq_st 		fr6, 0(r5), 1, 0
	ps_madd 	fr11, fr9, fr1, fr10
	psq_l 		fr2, 32(r3), 0, 0
	ps_sum0 	fr12, fr11, fr12, fr11
	psq_l 		fr3, 40(r3), 0, 0
	ps_mul 		fr4, fr2, fr0
	psq_st 		fr12, 4(r5), 1, 0
	ps_madd 	fr5, fr3, fr1, fr4
	ps_sum0 	fr6, fr5, fr6, fr5
	psq_st 		fr6, 8(r5), 1, 0
	blr

	.globl ps_guMtxMultVecSR
ps_guMtxMultVecSR:
	psq_l 		fr0, 0(r3), 0, 0
	psq_l 		fr6, 0(r4), 0, 0
	psq_l 		fr2, 16(r3), 0, 0
	ps_mul 		fr8, fr0, fr6
	psq_l 		fr4, 32(r3), 0, 0
	ps_mul 		fr10, fr2, fr6
	psq_l 		fr7, 8(r4), 1, 0
	ps_mul 		fr12, fr4, fr6
	psq_l 		fr3, 24(r3), 0, 0
	ps_sum0 	fr8, fr8, fr8, fr8
	psq_l 		fr5, 40(r3), 0, 0
	ps_sum0 	fr10, fr10, fr10, fr10
	psq_l 		fr1, 8(r3), 0, 0
	ps_sum0 	fr12, fr12, fr12, fr12
	ps_madd 	fr9, fr1, fr7, fr8
	psq_st 		fr9, 0(r5), 1, 0
	ps_madd 	fr11, fr3, fr7, fr10
	psq_st 		fr11, 4(r5), 1, 0
	ps_madd 	fr13, fr5, fr7, fr12
	psq_st 		fr13, 8(r5), 1, 0
	blr 

	.globl ps_guVecAdd
	//r3 = v1,r4 = v2,r5 = dst
ps_guVecAdd:
	psq_l		V1_XY,0(r3),0,0
	psq_l		V2_XY,0(r4),0,0
	ps_add		D1_XY,V1_XY,V2_XY
	psq_st		D1_XY,0(r5),0,0
	psq_l		V1_Z,8(r3),1,0
	psq_l		V2_Z,8(r4),1,0
	ps_add		D1_Z,V1_Z,V2_Z
	psq_st		D1_Z,8(r5),1,0
	blr

	.globl ps_guVecSub
	//r3 = v1,r4 = v2,r5 = dst
ps_guVecSub:
	psq_l		V1_XY,0(r3),0,0
	psq_l		V2_XY,0(r4),0,0
	ps_sub		D1_XY,V1_XY,V2_XY
	psq_st		D1_XY,0(r5),0,0
	psq_l		V1_Z,8(r3),1,0
	psq_l		V2_Z,8(r4),1,0
	ps_sub		D1_Z,V1_Z,V2_Z
	psq_st		D1_Z,8(r5),1,0
	blr

	.globl ps_guVecScale
	//r3 = src,r4 = dst,fr1 = S
ps_guVecScale:
	psq_l		fr2,0(r3),0,0
	psq_l		fr3,8(r3),1,0
	ps_muls0	fr4,fr2,fr1
	psq_st		fr4,0(r4),0,0
	ps_muls0	fr4,fr3,fr1
	psq_st		fr4,8(r4),1,0	
	blr

	.globl	ps_guVecNormalize
	//r3 = v
ps_guVecNormalize:
	lfs		fr0,NrmData@sdarel(r13)
	lfs		fr1,NrmData+4@sdarel(r13)
	psq_l		fr2,0(r3),0,0
	ps_mul		fr4,fr2,fr2
	psq_l		fr3,8(r3),1,0
	ps_madd		fr5,fr3,fr3,fr4
	ps_sum0		fr6,fr5,fr3,fr4
	frsqrte		fr7,fr6
	fmuls		fr8,fr7,fr7
	fmuls		fr9,fr7,fr0
	fnmsubs		fr8,fr8,fr6,fr1
	fmuls		fr7,fr8,fr9
	ps_muls0	fr2,fr2,fr7
	psq_st		fr2,0(r3),0,0
	ps_muls0	fr3,fr3,fr7
	psq_st		fr3,8(r3),1,0
	blr

	.globl ps_guVecCross
	//r3 = v1,r4 = v2,r5 = v12
ps_guVecCross:
	psq_l		fr1,0(r4),0,0
	lfs		fr2,8(r3)
	psq_l		fr0,0(r3),0,0
	ps_merge10	fr6,fr1,fr1
	lfs		fr3,8(r4)
	ps_mul		fr4,fr1,fr2
	ps_muls0	fr7,fr1,fr0
	ps_msub		fr5,fr0,fr3,fr4
	ps_msub		fr8,fr0,fr6,fr7
	ps_merge11	fr9,fr5,fr5
	ps_merge01	fr10,fr5,fr8
	psq_st		fr9,0(r5),1,0
	ps_neg		fr10,fr10
	psq_st		fr10,4(r5),0,0	
	blr

	.globl ps_guVecDotProduct
	//r3 = vec1,r4 = vec2
ps_guVecDotProduct:
	psq_l		fr2,4(r3),0,0
	psq_l		fr3,4(r4),0,0
	ps_mul		fr2,fr2,fr3
	psq_l		fr5,0(r3),0,0
	psq_l		fr4,0(r4),0,0
	ps_madd		fr3,fr5,fr4,fr2
	ps_sum0		fr1,fr3,fr2,fr2
	blr

	.globl ps_guVecMultiply
ps_guVecMultiply:
	psq_l		fr0,0(r4),0,0
	psq_l		fr2,0(r3),0,0
	psq_l		fr1,8(r4),1,0
	ps_mul		fr4,fr2,fr0
	psq_l		fr3,8(r3),0,0
	ps_madd		fr5,fr3,fr1,fr4
	psq_l		fr8,16(r3),0,0
	ps_sum0		fr6,fr5,fr6,fr5
	psq_l		fr9,24(r3),0,0
	ps_mul		fr10,fr8,fr0
	psq_st		fr6,0(r5),1,0
	ps_madd		fr11,fr9,fr1,fr10
	psq_l		fr2,32(r3),0,0
	ps_sum0		fr12,fr11,fr12,fr11
	psq_l		fr3,40(r3),0,0
	ps_mul		fr4,fr2,fr0
	psq_st		fr12,4(r5),1,0
	ps_madd		fr5,fr3,fr1,fr4
	ps_sum0		fr6,fr5,fr6,fr5
	psq_st		fr6,8(r5),1,0
	blr

	.globl ps_guVecMultiplySR
	// r3 = mt, r4 = src, r5 = dst
ps_guVecMultiplySR:
    psq_l		fr0,0(r3),0,0    // m[0][0], m[0][1] GQR0 = 0
    // fp6 - x y 
    psq_l		fr6,0(r4),0,0 
    psq_l		fr2,16(r3),0,0   // m[1][0], m[1][1]
    // fp8 = m00x m01y // next X
    ps_mul		fr8,fr0,fr6
    psq_l		fr4,32(r3),0,0   // m[2][0], m[2][1]
    // fp10 = m10x m11y // next Y
    ps_mul		fr10,fr2,fr6
    psq_l		fr7,8(r4),1,0   // fp7 - z,1.0
    // fp12 = m20x m21y // next Z
    ps_mul		fr12,fr4,fr6  // YYY last FP6 usage
    psq_l		fr3,24(r3),0,0   // m[1][2], m[1][3]
    ps_sum0		fr8,fr8,fr8,fr8
    psq_l		fr5,40(r3),0,0   // m[2][2], m[2][3]
    ps_sum0		fr10,fr10,fr10,fr10
    psq_l		fr1,8(r3),0,0    // m[0][2], m[0][3] 
    ps_sum0		fr12,fr12,fr12,fr12
    ps_madd		fr9,fr1,fr7,fr8
    psq_st		fr9,0(r5),1,0      // store X
    ps_madd		fr11,fr3,fr7,fr10
    psq_st		fr11,4(r5),1,0      // store Y  
    ps_madd		fr13,fr5,fr7,fr12
    psq_st		fr13,8(r5),1,0      //  sore Z
	blr

	.globl ps_guVecMag
	// r3 = vec
ps_guVecMag:
	lfs 	fr4, NrmData@sdarel(r13)
	psq_l 		fr0, 0(r3), 0, 0
	ps_mul		fr0, fr0, fr0
	lfs		fr1, 8(r3)
	fsubs	fr2, fr4, fr4
	ps_madd		fr1, fr1, fr1, fr0
	ps_sum0		fr1, fr1, fr0, fr0
	fcmpu	cr0, fr1, fr2
	beq 	1f
	frsqrte	fr0, fr1
	lfs		fr3, NrmData+0x4@sdarel(r13)
	fmuls	fr2, fr0, fr0
	fmuls 	fr0, fr0, fr4
	fnmsubs	fr2, fr2, fr1, fr3
	fmuls	fr0, fr2, fr0
	fmuls 	fr1, fr1, fr0
1:
	blr

	.globl ps_guVecSquareMag
ps_guVecSquareMag:
	psq_l 		fr0, 0(r3), 0, 0
	ps_mul 		fr0, fr0, fr0
	lfs 	fr1, 8(r3)
	ps_madd 	fr1, fr1, fr1, fr0
	ps_sum0 	fr1, fr1, fr0, fr0
	blr 

	.globl ps_guVecDistance
ps_guVecDistance:
	psq_l 		fr0, 4(r3), 0, 0
	psq_l 		fr1, 4(r4), 0, 0
	ps_sub 		fr2, fr0, fr1
	psq_l 		fr0, 0(r3), 0, 0
	psq_l 		fr1, 0(r4), 0, 0
	ps_mul 		fr2, fr2, fr2
	ps_sub 		fr0, fr0, fr1
	lfs 	fr3, NrmData@sdarel(r13)
	ps_madd 	fr1, fr0, fr0, fr2
	fsubs 	fr0, fr3, fr3
	ps_sum0 	fr1, fr1, fr2, fr2
	fcmpu 	cr0, fr0, fr1
	beq 	1f
	lfs 	fr4, NrmData+0x4@sdarel(r13)
	frsqrte fr0, fr1
	fmuls 	fr2, fr0, fr0
	fmuls 	fr0, fr0, fr3
	fnmsubs fr2, fr2, fr1, fr4
	fmuls 	fr0, fr2, fr0
	fmuls 	fr1, fr1, fr0
1:
	blr

	.globl ps_guQuatScale
	//r3 = q,r4 = r, fr1 = scale
ps_guQuatScale:
	psq_l		fr4,0(r3),0,0
	psq_l		fr5,8(r3),0,0
	ps_muls0	fr4,fr4,fr1
	psq_st		fr4,0(r4),0,0
	ps_muls0	fr5,fr5,fr1
	psq_st		fr5,8(r4),0,0
	blr

	.globl ps_guQuatDotProduct
	//r3 = p, r4 = q ; fr1 = res
ps_guQuatDotProduct:
	psq_l		fr2,0(r3),0,0
	psq_l		fr4,0(r4),0,0
	ps_mul		fr1,fr2,fr4
	psq_l		fr3,8(r3),0,0
	psq_l		fr5,8(r4),0,0
	ps_madd		fr1,fr3,fr5,fr1
	ps_sum0		fr1,fr1,fr1,fr1
	blr

	.globl ps_guMtx44Concat
ps_guMtx44Concat:
	psq_l 		fr0, 0(r3), 0, 0
	psq_l 		fr2, 0(r4), 0, 0
	ps_muls0 	fr6, fr2, fr0
	psq_l 		fr3, 16(r4), 0, 0
	psq_l 		fr4, 32(r4), 0, 0
	ps_madds1 	fr6, fr3, fr0, fr6
	psq_l 		fr1, 8(r3), 0, 0
	psq_l 		fr5, 48(r4), 0, 0
	ps_madds0 	fr6, fr4, fr1, fr6
	psq_l 		fr0, 16(r3), 0, 0
	ps_madds1 	fr6, fr5, fr1, fr6
	psq_l 		fr1, 24(r3), 0, 0
	ps_muls0 	fr8, fr2, fr0
	ps_madds1 	fr8, fr3, fr0, fr8
	psq_l 		fr0, 32(r3), 0, 0
	ps_madds0 	fr8, fr4, fr1, fr8
	ps_madds1 	fr8, fr5, fr1, fr8
	psq_l 		fr1, 40(r3), 0, 0
	ps_muls0 	fr10, fr2, fr0
	ps_madds1 	fr10, fr3, fr0, fr10
	psq_l 		fr0, 48(r3), 0, 0
	ps_madds0 	fr10, fr4, fr1, fr10
	ps_madds1 	fr10, fr5, fr1, fr10
	psq_l 		fr1, 56(r3), 0, 0
	ps_muls0 	fr12, fr2, fr0
	psq_l 		fr2, 8(r4), 0, 0
	ps_madds1 	fr12, fr3, fr0, fr12
	psq_l 		fr0, 0(r3), 0, 0
	ps_madds0 	fr12, fr4, fr1, fr12
	psq_l 		fr3, 24(r4), 0, 0
	ps_madds1 	fr12, fr5, fr1, fr12
	psq_l 		fr1, 8(r3), 0, 0
	ps_muls0 	fr7, fr2, fr0
	psq_l 		fr4, 40(r4), 0, 0
	ps_madds1 	fr7, fr3, fr0, fr7
	psq_l 		fr5, 56(r4), 0, 0
	ps_madds0 	fr7, fr4, fr1, fr7
	psq_l 		fr0, 16(r3), 0, 0
	ps_madds1 	fr7, fr5, fr1, fr7
	psq_l 		fr1, 24(r3), 0, 0
	ps_muls0 	fr9, fr2, fr0
	psq_st 		fr6, 0(r5), 0, 0
	ps_madds1 	fr9, fr3, fr0, fr9
	psq_l 		fr0, 32(r3), 0, 0
	ps_madds0 	fr9, fr4, fr1, fr9
	psq_st 		fr8, 16(r5), 0, 0
	ps_madds1 	fr9, fr5, fr1, fr9
	psq_l 		fr1, 40(r3), 0, 0
	ps_muls0 	fr11, fr2, fr0
	psq_st 		fr10, 32(r5), 0, 0
	ps_madds1 	fr11, fr3, fr0, fr11
	psq_l 		fr0, 48(r3), 0, 0
	ps_madds0 	fr11, fr4, fr1, fr11
	psq_st 		fr12, 48(r5), 0, 0
	ps_madds1 	fr11, fr5, fr1, fr11
	psq_l 		fr1, 56(r3), 0, 0
	ps_muls0 	fr13, fr2, fr0
	psq_st 		fr7, 8(r5), 0, 0
	ps_madds1 	fr13, fr3, fr0, fr13
	psq_st 		fr9, 24(r5), 0, 0
	ps_madds0 	fr13, fr4, fr1, fr13
	psq_st 		fr11, 40(r5), 0, 0
	ps_madds1 	fr13, fr5, fr1, fr13
	psq_st 		fr13, 56(r5), 0, 0
	blr

	.globl ps_guMtx44MultVec
ps_guMtx44MultVec:
	psq_l 		fr0, 0(r4), 0, 0
	psq_l 		fr2, 48(r3), 0, 0
	psq_l 		fr1, 8(r4), 1, 0
	ps_mul 		fr4, fr0, fr2
	psq_l 		fr3, 56(r3), 0, 0
	ps_madd 	fr5, fr1, fr3, fr4
	ps_merge11 	fr12, fr1, fr1
	ps_sum0 	fr13, fr5, fr5, fr5
	psq_l 		fr4, 0(r3), 0, 0
	ps_merge00 	fr13, fr13, fr13
	psq_l 		fr5, 8(r3), 0, 0
	ps_div 		fr13, fr12, fr13
	psq_l 		fr6, 16(r3), 0, 0
	psq_l 		fr7, 24(r3), 0, 0
	psq_l 		fr8, 32(r3), 0, 0
	psq_l 		fr9, 40(r3), 0, 0
	ps_mul 		fr4, fr0, fr4
	ps_madd 	fr2, fr1, fr5, fr4
	ps_mul 		fr6, fr0, fr6
	ps_madd 	fr3, fr1, fr7, fr6
	ps_mul 		fr8, fr0, fr8
	ps_sum0 	fr2, fr2, fr2, fr2
	ps_madd 	fr9, fr1, fr9, fr8
	ps_sum1 	fr2, fr3, fr2, fr3
	ps_sum0 	fr3, fr9, fr9, fr9
	ps_mul 		fr2, fr2, fr13
	psq_st 		fr2, 0(r5), 0, 0
	ps_mul 		fr3, fr3, fr13
	psq_st 		fr3, 8(r5), 1, 0
	blr

	.section .sdata
	.balign 16
Unit01:
	.float	0.0, 1.0
QuatEpsilon:
	.float	0.00001
NrmData:
	.float	0.5, 3.0
