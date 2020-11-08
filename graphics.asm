%include "graphics_line.asm"
%include "graphics_rect.asm"
%include "graphics_circle.asm"

; File contains all our graphics calls for different primitives

Graphics_Calls:
    ; Draw 10 Different lines using Draw_Line function 

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

	; Draw different rects using Draw_Rect function 
	
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

	push	word 10					; colour
	push	word 40					; height
	push	word 100				; width
	push	word 100				; y
	push	word 260				; x
	call	Draw_Rect

	push	word 13					; colour
	push	word 40					; height
	push	word 100				; width
	push	word 180				; y
	push	word 40					; x
	call	Draw_Rect

	push	word 13					; colour
	push	word 40					; height
	push	word 100				; width
	push	word 180				; y
	push	word 40					; x
	call	Draw_Rect

	; Drawing Circles

	push	word 12					; colour
	push	word 46					; radius
	push	word 100				; centery
	push	word 80					; centerx
	call	Draw_Circle

	push	word 3					; colour
	push	word 20					; radius
	push	word 140				; centery
	push	word 200				; centerx
	call	Draw_Circle

	push	word 9					; colour
	push	word 60					; radius
	push	word 80					; centery
	push	word 220				; centerx
	call	Draw_Circle

	ret