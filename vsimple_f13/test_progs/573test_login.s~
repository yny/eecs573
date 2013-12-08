	setpwd	0x01234
	login	0x01234

	lda	$r5,0x1
	lda	$r1,0x1000
loop:	mulq	$r5,0x0a,$r2
	stq	$r2,0($r1)
	ldq	$r3,0($r1)
	stq     $r3,0x100($r1)
	addq    $r1,0x8,$r1
	addq	$r5,0x1,$r5
	cmple   $r5,0xf,$r4
	bne     $r4,loop
	logout
	call_pal        0x555


