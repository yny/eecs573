	lda	$r5,0x1
	lda	$r1,0x1000
	lda	$r7,0x46c4
	stq	$r7,0($r1)
	lda	$r7,0x3c21
	stq	$r7,0($r1)
	lda	$r7,0x1111
	stq	$r7,0($r1)
	lda	$r7,0x6fff
	stq	$r7,0($r1)
	lda	$r7,0x7afa
	stq	$r7,0($r1)
	lda	$r7,0x4810
	stq	$r7,0($r1)
	lda	$r7,0x5487
	stq	$r7,0($r1)
loop:	mulq	$r5,0x0a,$r2
	stq	$r2,0($r1)
	ldq	$r3,0($r1)
	stq     $r3,0x100($r1)
	addq    $r1,0x8,$r1
	addq	$r5,0x1,$r5
	cmple   $r5,0xf,$r4
	bne     $r4,loop
	lda	$r7,0x0011
	stq	$r7,0($r1)
	lda	$r7,0x1100
	stq	$r7,0($r1)
	lda	$r7,0x1fdd
	stq	$r7,0($r1)
	call_pal        0x555


