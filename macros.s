.MACRO ldbc
	ld bc, ((\1)<<8) | (\2)
.ENDM
.MACRO ldde
	ld de, ((\1)<<8) | (\2)
.ENDM
.MACRO ldhl
	ld hl, ((\1)<<8) | (\2)
.ENDM

.MACRO RGB16
	.dw \1 | (\2<<5) | (\3<<10)
.ENDM
