.MACRO m_popvars
    pop hl
    pop de
    pop bc
    pop af
.ENDM

.MACRO m_pushvars
    push af
    push bc
    push de
    push hl
.ENDM

.MACRO m_RGB16
	.dw \1 | (\2<<5) | (\3<<10)
.ENDM
