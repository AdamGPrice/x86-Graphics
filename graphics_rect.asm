; Draws a rect on the screen with x, y 
; being the top left corner of the rect.
;
; push onto the stack in this order:
; 	word 	colour
; 	word	height
; 	word	width	
; 	word	y
; 	word	x
;
; 'Draw_Rect' cleans up the stack on return

; Parameters
%assign	x			4
%assign y			6
%assign	width		8
%assign height		10
%assign colour		12

; local variables
%assign offset 		2

Draw_Rect:
	push	bp
	mov		bp, sp
	sub		sp, 2					; Reserve space for local variable

	push	ax						; Push registers that we will use onto the stack
	push	bx
	push	cx
	push	es
	push	di

	mov		ax, 0A000h				; Set the memory address to A0000h using the segment register
	mov		es, ax

	call	Rect_Boundry_Checks

	cld								; Clear direction flag to make sure we are incrementing when copying into memory

	; calculate where the top left corner of the rectangle is in memory
	; di = (y * 320) + 320	
	mov		di,	[bp + y]			; y * 256	
	sal		di, 8			
	mov		ax, [bp + y]			; y * 64
	sal		ax, 6
	add		di, ax					; di = y * 256 + y * 64 = y * 320
	add		di, [bp + x]			; Add x to the result
									; di is now the offset pixel location from A0000h (Video memory)

	mov		ax, 320					; calculate the offset to add to di after each stosb call
	sub		ax, [bp + width]		; offset = width of screen - width of rect
	mov		[bp - offset], ax

	mov		al, [bp + colour]		; The byte to be repeated. The colour 
Rect_loop:
	; Error Checking, ES is set to A000h at the start of the function and wont change until ret
	mov		bx, di
	add		bx, [bp + width]
	cmp		ax, 0f9ffh				; Check if (DI + width) is less than 63999 and below 0  
	ja		Draw_Pixel_End			; Don't access video memory if higher than 63999 

	mov		cx, [bp + width]		; how many times to repeat
	rep		stosb

	add		di, [bp - offset]		; move di to the start of the next line
	sub		[bp + height], word 1
	jnz		Rect_loop

Draw_Rect_End:
	pop		di
	pop		es
	pop		cx
	pop		bx
	pop		ax

	mov		sp, bp
	pop		bp
	ret		10						; Return, removing 5 parameters from the stack

Rect_Boundry_Checks:
	cmp		[bp + x], word 319		; if x or y is outside the window range exit
	ja		Draw_Rect_End
	cmp		[bp + y], word 199
	ja		Draw_Rect_End

	mov		ax, word 320			; Check if x + width goes beyond 320
	sub		ax,	[bp + x]
	cmp		[bp + width], ax
	jl		Skip_Width_Changes		; Ajust width to be max width if so
	mov		[bp + width], ax

Skip_Width_Changes:	
	mov		ax, word 200			; Check if y + height goes beyond 200
	sub		ax,	[bp + y]
	cmp		[bp + height], ax
	jl		Skip_Height_Changes		; Ajust width to be max height if so
	mov		[bp + height], ax

Skip_Height_Changes:
	ret								; Return to the main function