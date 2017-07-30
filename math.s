multiplyBC:
; ========================================================
; Parameters:	B, C = numbers to multiply
; Returns:	bc = product
; ========================================================
	push de
	push hl
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
	ld b,h
	ld c,l
	pop hl
	pop de
	ret


divideBCByA:
; =======================================================================================
; Division by 0 will cause an infinite loop.
; BC (dividend) is signed, A (divisor) is unsigned.
; Parameters: bc = dividend, a = divisor
; Returns:    bc = quotient, a = remainder
; =======================================================================================
	push de
	push hl
	ld hl,0
	ld d,b
	ld e,a

	ld a,b
	or c
	jr z,@zero ; bc == 0?

	ld a,b ; Check for negative
	bit 7,a
	jr nz,@divNegative

@divPositive:
--
	ld a,e
	call subAFromBC
	inc hl
	ld a,b ; Check if bc == 0
	or c
	jr z,+
	ld a,b ; Check if bc < 0
	cp d
	jr z,--
	jr c,--

	dec hl ; Divided unevenly
+
	ld a,c ; Calculate remainder
	or a
	jr z,+
	add e
+
	ld b,h
	ld c,l
	pop hl
	pop de
	ret

; Note: don't count backwards with "dec hl", to avoid the sprite RAM bug
@divNegative:
--
	ld a,e
	call addAToBC
	inc hl
	ld a,b ; Check if bc == 0
	or c
	jr z,+
	ld a,b ; Check if bc > 0
	cp d
	jr nc,--

	dec hl ; Divided unevenly
+
	ld a,c ; Calculate remainder
	or a
	jr z,+
	add e
+
	dec hl ; bc = -hl
	ld a,h
	cpl
	ld b,a
	ld a,l
	cpl
	ld c,a

	pop hl
	pop de
	ret

@zero:
	pop hl
	pop de
	ret


hexToBcd:
; =======================================================================================
; Converts a normal number into a bcd (binary-coded decimal) number.
; Parameters: a = hexnumber to convert
; Returns:    bc = corresponding BCD number
; =======================================================================================
	ld bc,0
-
	cp 100
	jr c,@tens
	inc b
	sub 100
	jr -
@tens
	cp 10
	jr c,@ones
	inc c
	sub 10
	jr @tens
@ones
	swap c
	add c
	ld c,a
	ret

subAFromHL:
	cpl
	inc a
	ret z
	add l
	ld l,a
	jr c,+
	dec h
+
	ret

addAToHL:
	add l
	ld l,a
	jr nc,+
	inc h
+
	ret

subAFromDE:
	cpl
	inc a
	ret z
	add e
	ld e,a
	jr c,+
	dec d
+
	ret

addAToDE:
	add e
	ld e,a
	jr nc,+
	inc d
+
	ret

subAFromBC:
	cpl
	inc a
	ret z
	add c
	ld c,a
	jr c,+
	dec b
+
	ret

addAToBC:
	add c
	ld c,a
	jr nc,+
	inc b
+
	ret
