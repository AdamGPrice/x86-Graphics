; Parameters
%assign centerX		4
%assign centerY		6
%assign r			8
%assign colour		10

; local varibles
%assign	d			2
%assign	x			4
%assign	y			6

Draw_Circle:
	push	bp
	mov		bp, sp
	sub		sp, 6				; Reserve space on the stack for local variables

	push	ax					; Save the state of registers we makes use of
	push	bx
	push 	ds
	push 	si

	mov		ax, 0A000h			; Set the memory address to A0000h using the segment register
	mov		ds, ax

	mov		ax, [bp + r]		; x = r
	mov		[bp - y], ax
	mov		[bp - x], word 0	; y = 0
	add		ax, [bp + r]		; d = 3 - (2 * r)
	mov		[bp - d], word 3
	sub		[bp - d], ax


Draw_Pixels_Loop:
	mov		cx, word [bp + centerX]		; Quadrant 1
	add		cx, word [bp - x]			; xc + x, yc + y
	mov		dx, word [bp + centerY]
	add		dx, word [bp - y]
	call	Circle_Put_Pixel

	mov		cx, word [bp + centerX]		; Quadrant 2
	sub		cx, word [bp - x]			; xc - x, yc + y
	mov		dx, word [bp + centerY]
	add		dx, word [bp - y]
	call	Circle_Put_Pixel

	mov		cx, word [bp + centerX]		; Quadrant 3
	add		cx, word [bp - x]			; xc + x, yc - y
	mov		dx, word [bp + centerY]
	sub		dx, word [bp - y]
	call	Circle_Put_Pixel

	mov		cx, word [bp + centerX]		; Quadrant 4
	sub		cx, word [bp - x]			; xc - x, yc - y
	mov		dx, word [bp + centerY]
	sub		dx, word [bp - y]
	call	Circle_Put_Pixel

	mov		cx, word [bp + centerX]		; Quadrant 5
	add		cx, word [bp - y]			; xc + y, yc + x
	mov		dx, word [bp + centerY]
	add		dx, word [bp - x]
	call	Circle_Put_Pixel

	mov		cx, word [bp + centerX]		; Quadrant 6
	sub		cx, word [bp - y]			; xc - y, yc + x
	mov		dx, word [bp + centerY]
	add		dx, word [bp - x]
	call	Circle_Put_Pixel

	mov		cx, word [bp + centerX]		; Quadrant 7
	add		cx, word [bp - y]			; xc + y, yc - x
	mov		dx, word [bp + centerY]
	sub		dx, word [bp - x]
	call	Circle_Put_Pixel

	mov		cx, word [bp + centerX]		; Quadrant 7
	sub		cx, word [bp - y]			; xc - y, yc - x
	mov		dx, word [bp + centerY]
	sub		dx, word [bp - x]
	call	Circle_Put_Pixel

	inc		word [bp - x]		; x++

	cmp		[bp - d], word 0	; check if d <= 0
	jle		Something_Else		; if true skip changes directly below
	
	dec		word [bp - y]		; y--
	mov		ax, [bp - x]		; d = d * (x - y) + 10
	sub		ax, [bp - y]
	mov 	bx, word 4
	mul		bx
	add		ax, word 10
	add		ax, [bp - d]
	mov		[bp - d], ax
	jmp		Is_Still_Looping	; if these changes are made skip other changes

Something_Else:	
	mov		ax, [bp - x]		; d = d + 4 * x + 6; 
	mov		bx, 4
	mul 	bx
	add		ax, word 6
	add		ax, [bp - d]
	mov		[bp - d], ax


Is_Still_Looping:
	mov		ax, [bp - y]	; Stop looping if y >= x
	cmp		ax, [bp - x]
	jge		Draw_Pixels_Loop

Draw_Circle_End:
	pop		dx					; Restore the registers we used back to their orignal value
	pop		cx
	pop		bx
	pop		ax

	mov		sp, bp
	pop		bp
	ret		8


Circle_Put_Pixel:
	mov		ax,	dx					; y * 320	
	mov		bx, 320
	mul		bx
	add		ax, cx					; Add x to the result				
	mov		si, ax					; si is now the offset pixel location from A0000h (Video memory)

	; Error Checking, DS is set to A000h in the function and wont change
	cmp		si, 0f9ffh				; Check that si is 63999 or less
	ja		Draw_Pixel_End			; Don't access video memory if higher than 63999 

	mov		al, [bp + colour]		; Get the colour from the stack and make sure its 8 bits using al
	mov		[si], al				; Write the colour into video memeory
	ret