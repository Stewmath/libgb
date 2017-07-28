.MEMORYMAP
	DEFAULTSLOT 0
	SLOTSIZE $4000
	SLOT 0 $0000 ; rom slot 0
	SLOT 1 $4000 ; rom slot 1

	SLOTSIZE $1000
	SLOT 2 $c000 ; wram slot 0
	SLOT 3 $d000 ; wram slot 1

	SLOTSIZE $7f
	SLOT 4 $ff80 ; hram
.ENDME
