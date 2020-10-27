; Second stage of the boot loader

BITS 16

ORG 9000h
	jmp 	Second_Stage

%include "functions_16.asm"

;	Start of the second stage of the boot loader
	
Second_Stage:
    mov 	si, second_stage_msg	; Output our greeting message
    call 	Console_WriteLine_16

	mov		ah, 0				; Set the graphics mode to 13h
	mov		al, 13h
	int		10h

	;mov		ax, 3
	;mov		bx, 10
	;mov		cx, 16
	;mov		dx, 8

	; Draw_Line(x0, y0, x1, y1, colour)

	push	word 14					; colour
	push	word 0					; y1
	push	word 0					; x1
	push	word 199				; y0
	push	word 319				; x0
	call	Draw_Line

	push	word 9					; colour
	push	word 0					; y1
	push	word 319				; x1
	push	word 199				; y0
	push	word 0					; x0
	call	Draw_Line

	push	word 7					; colour
	push	word 173				; y1
	push	word 100				; x1
	push	word 30					; y0
	push	word 20					; x0
	call	Draw_Line

	push	word 13					; colour
	push	word 100				; y1
	push	word 50					; x1
	push	word 40					; y0
	push	word 230				; x0
	call	Draw_Line

	push	word 12					; colour
	push	word 30					; y1
	push	word 200				; x1
	push	word 170				; y0
	push	word 160				; x0
	call	Draw_Line

	push	word 2					; colour
	push	word 60					; y1
	push	word 100				; x1
	push	word 120				; y0
	push	word 30					; x0
	call	Draw_Line

	push	word 4					; colour
	push	word 40					; y1
	push	word 20					; x1
	push	word 100				; y0
	push	word 300				; x0
	call	Draw_Line

	push	word 5					; colour
	push	word 140				; y1
	push	word 190				; x1
	push	word 180				; y0
	push	word 5					; x0
	call	Draw_Line

	push	word 6					; colour
	push	word 10					; y1
	push	word 140				; x1
	push	word 180				; y0
	push	word 160				; x0
	call	Draw_Line

	push	word 10					; colour
	push	word 20					; y1
	push	word 230				; x1
	push	word 100				; y0
	push	word 10					; x0
	call	Draw_Line

	; Rect
	push	word 9					; colour
	push	word 22					; height
	push	word 100				; width
	push	word 40					; y
	push	word 80					; x
	call	Draw_Rect

	push	word 4					; colour
	push	word 80					; height
	push	word 20					; width
	push	word 100				; y
	push	word 200				; x
	call	Draw_Rect

	push	word 14					; colour
	push	word 40					; height
	push	word 40					; width
	push	word 120				; y
	push	word 30					; x
	call	Draw_Rect

	; This never-ending loop ends the code.  It replaces the hlt instruction
	; used in earlier examples since that causes some odd behaviour in 
	; graphical programs.
endloop:
	jmp		endloop

%include "graphics.asm"

second_stage_msg	db 'Second stage loaded', 0

	times 3584-($-$$) db 0	