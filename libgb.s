;.SECTION "libgb"

; Use this if the cartridge stays in
waitForVBlank:
	ldh a,(R_LCDC)
	and $80
	ret z
-
	halt
	nop
	ldh a,(z_interruptType)
	cp INT_VBLANK
	jr nz,-
	ret

; Use this if the cartridge may be hotswapped
/*
waitForVBlank:
	ldh a,(R_LCDC)
	and $80
	ret z
-
	ldh a, [R_LY]
	cp 144
	jr nz, -
	ret
*/

getInput:
	push bc
	push hl
	ld hl,buttonsPressed
	ld a,%00100000 ; get dpad
	ldh (R_P1),a
	ldh a,(R_P1)
	ldh a,(R_P1)
	ldh a,(R_P1)
	ldh a,(R_P1)
	ldh a,(R_P1)
	ldh a,(R_P1)
	ldh a,(R_P1)
	ldh a,(R_P1)
	ldh a,(R_P1)
	ldh a,(R_P1)
	xor $ff
	and $0f
	swap a
	ld b,a

	ld a,%00010000 ; get buttons
	ldh (R_P1),a
	ldh a,(R_P1)
	ldh a,(R_P1)
	ldh a,(R_P1)
	ldh a,(R_P1)
	ldh a,(R_P1)
	ldh a,(R_P1)
	ldh a,(R_P1)
	ldh a,(R_P1)
	ldh a,(R_P1)
	ldh a,(R_P1)
	xor $ff
	and $0f
	or b

	ld b,(hl)
	ld (hl),a
	ld c,a
	xor b
	and c
	ldh (z_buttonsJustPressed),a
	ld a,c
	xor b
	and b
	ldh (z_buttonsJustReleased),a

	pop hl
	pop bc
	ret

multiply:
; ========================================================
; Parameters:	B, C = numbers to multiply
; Returns:		hl = product
; ========================================================
	push de
	ld hl, 0
	ld a, b
	or a
	jr z, +
	ld a, c
	or a
	jr z, +
	ld d, 0
	ld e, c
-
	add hl, de
	dec b
	jr nz, -
+
	pop de
	ret

jphl:
	jp hl

; Clears wram and zero page.
; Omits only $cf00-cfff, where the stack is assumed to be.
clearWram:
	push bc
	push hl
	ld hl,$c000
	ld bc,$0f00
-
	xor a
	ldi (hl),a
	dec bc
	ld a,b
	or c
	jr nz,-

	ld hl,$d000
	ld bc,$1000
-
	xor a
	ldi (hl),a
	dec bc
	ld a,b
	or c
	jr nz,-

; zero page
	ld hl,$ff80
	ld b,$7f
	xor a
-
	ldi (hl),a
	dec b
	jr nz,-
	pop hl
	pop bc
	ret

; Assumes lcd is off.
clearVram:
	push bc
	push hl
	ld hl,$8000
	ld bc,$2000
-
	xor	a
	ldi	(hl),a
	dec	bc
	ld	a,b
	or	c
	jr	nz,-
	pop hl
	pop bc
	ret

; Copies bc bytes from hl to de.
copyData:
	ldi a,(hl)
	ld (de),a
	inc de
	dec	bc
	ld a,b
	or c
	jr	nz,copyData
	ret

; Fills bc bytes with value of a starting from hl.
fillData:
	push de
	ld d,a
-
	ld (hl),d
	inc hl
	dec bc
	ld a,b
	or c
	jr nz,-
	pop de
	ret

setCpuSpeed_1x:
	ldh	a, (R_KEY1)
	rlca
	ret	nc			;mode was already 1x.
	jr +

setCpuSpeed_2x:
	ldh	a,(R_KEY1)
	rlca
	ret	c			;mode was already 2x.

+	di

	ldh	a,(R_IE)
	push af

	xor	a
	ldh	(R_IE),a
	ldh	(R_IF),a
	ld	a,$30
	ldh	(R_P1),a
	ld	a,%00000001
	ldh	(R_KEY1),a

	stop
	nop

	pop	af
	ldh	(R_IE),a

	ei
	ret

; hl = input data (8x4x2 bytes)
loadBgPalettes:
	ld	b, %10000000
	ld	c, 8

-	ld	a, b
	ldh	($68), a		;$68 = bcps.

	ldi	a, (hl)
	ldh	($69), a		;$69 = bcpd.
	ldi	a, (hl)
	ldh	($69), a
	ldi	a, (hl)
	ldh	($69), a
	ldi	a, (hl)
	ldh	($69), a
	ldi	a, (hl)
	ldh	($69), a
	ldi	a, (hl)
	ldh	($69), a
	ldi	a, (hl)
	ldh	($69), a
	ldi	a, (hl)
	ldh	($69), a

	ld	a, b
	add	%00001000		;next palette.
	ld	b, a
	dec	c
	jr	nz, -
	ret


; hl = input data (8x4x2 bytes)
loadSprPalettes:
	ld	b, %10000000
	ld	c, 8

-	ld	a, b
	ldh	($6A), a		;$6A = ocps.

	ldi	a, (hl)
	ldh	($6B), a		;$6B = ocpd.
	ldi	a, (hl)
	ldh	($6B), a
	ldi	a, (hl)
	ldh	($6B), a
	ldi	a, (hl)
	ldh	($6B), a
	ldi	a, (hl)
	ldh	($6B), a
	ldi	a, (hl)
	ldh	($6B), a
	ldi	a, (hl)
	ldh	($6B), a
	ldi	a, (hl)
	ldh	($6B), a

	ld	a, b
	add	%00001000		;next palette.
	ld	b, a
	dec	c
	jr	nz, -
	ret

;.ENDS
