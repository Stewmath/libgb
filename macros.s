.MACRO popvars
    pop hl
    pop de
    pop bc
    pop af
.ENDM

.MACRO pushvars
    push af
    push bc
    push de
    push hl
.ENDM

.MACRO RGB15
	.dw \1 | (\2<<5) | (\3<<10)
.ENDM
