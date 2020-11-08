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
	push 	cx
	push 	dx

	mov		ax, [bp + r]		; x = r
	mov		[bp - y], ax
	mov		[bp - x], word 0	; y = 0
	add		ax, [bp + r]		; d = 3 - (2 * r)
	mov		[bp - d], word 3
	sub		[bp - d], ax


Draw_Pixels_Loop:
	mov		ah, 0ch
	mov		bh, 0
	mov		al, [bp + colour]	; Set pixel colour.

	mov		cx, word [bp + centerX]		; Quadrant 1
	add		cx, word [bp - x]			; xc + x, yc + y
	mov		dx, word [bp + centerY]
	add		dx, word [bp - y]
	int		10h

	mov		cx, word [bp + centerX]		; Quadrant 2
	sub		cx, word [bp - x]			; xc - x, yc + y
	mov		dx, word [bp + centerY]
	add		dx, word [bp - y]
	int		10h

	mov		cx, word [bp + centerX]		; Quadrant 3
	add		cx, word [bp - x]			; xc + x, yc - y
	mov		dx, word [bp + centerY]
	sub		dx, word [bp - y]
	int		10h

	mov		cx, word [bp + centerX]		; Quadrant 4
	sub		cx, word [bp - x]			; xc - x, yc - y
	mov		dx, word [bp + centerY]
	sub		dx, word [bp - y]
	int		10h

	mov		cx, word [bp + centerX]		; Quadrant 5
	add		cx, word [bp - y]			; xc + y, yc + x
	mov		dx, word [bp + centerY]
	add		dx, word [bp - x]
	int		10h

	mov		cx, word [bp + centerX]		; Quadrant 6
	sub		cx, word [bp - y]			; xc - y, yc + x
	mov		dx, word [bp + centerY]
	add		dx, word [bp - x]
	int		10h

	mov		cx, word [bp + centerX]		; Quadrant 7
	add		cx, word [bp - y]			; xc + y, yc - x
	mov		dx, word [bp + centerY]
	sub		dx, word [bp - x]
	int		10h

	mov		cx, word [bp + centerX]		; Quadrant 7
	sub		cx, word [bp - y]			; xc - y, yc - x
	mov		dx, word [bp + centerY]
	sub		dx, word [bp - x]
	int		10h

	inc		word [bp - x]		; x++

	cmp		[bp - d], word 0
	jle		something_else
	dec		word [bp - y]		; y--

	mov		ax, [bp - x]		; d = d * (x - y) + 10
	sub		ax, [bp - y]
	mov 	bx, word 4
	mul		bx
	add		ax, word 10
	add		ax, [bp - d]
	mov		[bp - d], ax
	jmp		Is_Still_Looping

something_else:
	mov		ax, [bp - x]
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