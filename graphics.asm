;=================================================================================================================================
; Draw line code starts here

; offsets for the Draw_line function parameters
%assign x0		4
%assign y0		6
%assign x1		8
%assign y1		10
%assign colour	12

; offsets for local variables
%assign deltaX	2
%assign deltaY	4
%assign error	6
%assign error2	8
%assign sx		10
%assign sy		12

Draw_Line:
	push	bp
	mov		bp, sp
	sub		sp, 12				; Reserve space for local variables

	push	ax					; Push registers that we will use onto the stack
	push 	bx
	push	cx
	push 	dx
	push	ds
	push	si

	mov		ax, 0A000h			; Set the memory address to A0000h using the segment register
	mov		ds, ax

	; Get the differece between x1 and x0 then store it on the stack as deltaX
	mov		ax, [bp + x1]		; x1 - x0
	sub		ax,	[bp + x0]	
	mov		bx,	ax				; absolute value of the result
	neg		ax			
	cmovl	ax, bx
	mov		[bp - deltaX], ax	; store absolute value

	; Differece between y1 and y0 stored in deltaY
	mov		ax, [bp + y1]		; x1 - x0
	sub		ax,	[bp + y0]	
	mov		bx,	ax				; absolute value of the result
	neg		ax
	cmovl	ax, bx
	mov		[bp - deltaY], ax	; store absolute value

	; if x0 < x1 then sx = 1 else sx = -1
	mov		ax, [bp + x0]
	cmp		ax, [bp + x1]
	jl		Set_Sx_Positive
	jmp		Set_Sx_Negative
Set_Sx_Positive:
	mov		[bp - sx], word 1
	jmp Set_Sx_End
Set_Sx_Negative:
	mov		[bp - sx], word -1
Set_Sx_End:

	; if y0 < y1 then sy = 1 else sx = -1
	mov		ax, [bp + y0]
	cmp		ax, [bp + y1]
	jl		Set_Sy_Positive
	jmp		Set_Sy_Negative
Set_Sy_Positive:
	mov		[bp - sy], word 1
	jmp Set_Sy_End
Set_Sy_Negative:
	mov		[bp - sy], word -1
Set_Sy_End:

	mov		ax, [bp - deltaX]		; error = deltaX - deltaY
	sub		ax, [bp - deltaY]
	mov		[bp - error], ax

Draw_Loop:
	call	Draw_Pixel

	mov		ax, [bp + x0]			; Check if x0 and x1 are the same
	xor		ax, [bp + x1]
	jnz		Draw_Loop_Contintue		; Contintue if not
	mov		bx, [bp + y0]			; Check if y0 and y1 are the same
	xor		bx,	[bp + y1]			
	jnz		Draw_Loop_Contintue		; Contintue if not
	jmp		Draw_Line_End			; If both are equal then exit the draw loop

Draw_Loop_Contintue:
	mov		ax, [bp - error]		; error 2 = error * 2
	add		ax, ax
	mov		[bp - error2], ax

	mov		ax, [bp - deltaY]		; Check if error2 > -deltaY
	neg		ax
	cmp		[bp - error2], ax
	jle		Skip_X_Change			; If less than or equal to skip making changes
	mov		ax,	[bp - deltaY]		; error = error - dy
	sub		[bp - error], ax
	mov		ax, [bp - sx]			; x0 = x0 + sx
	add		[bp + x0], ax

Skip_X_Change:
	mov		ax, [bp - deltaX]		; Check if error2 < dx
	cmp		[bp - error2], ax
	jge		Skip_Y_Change			; if greater or equal to skip making changes
	mov		ax, [bp - deltaX]		; error = error + dx
	add		[bp - error], ax		
	mov		ax, [bp - sy]			; y0 = y0 + sy
	add		[bp + y0], ax

Skip_Y_Change:
	jmp		Draw_Loop				; go back to top of the draw loop

Draw_Line_End:
	; Restore registers back to their original value 
	pop 	si
	pop 	ds
	pop		dx
	pop	 	cx
	pop		bx
	pop	 	ax

	mov		sp, bp
	pop		bp
	ret		10						; Return, removing 5 parameters from the stack


Draw_Pixel:
	; Calculate the pixel location in memory. A0000h + (y * 320) + x	
	mov		ax, [bp + y0]			; y * 320	
	mov		bx, 320
	mul		bx
	add		ax, [bp + x0]			; Add x to the result				
	mov		si, ax					; si is now the offset pixel location from A0000h (Video memory)

	; Error Checking, DS is set to A000h in the function and wont change
	cmp		si, 0f9ffh				; Check that si is 63999 or less
	ja		Draw_Pixel_End			; Don't access video memory if higher than 63999 
	
	mov		al, [bp + colour]		; Get the colour from the stack and make sure its 8 bits
	mov		[si], al				; Set the colour in video memeory

Draw_Pixel_End:
	ret


;=================================================================================================================================
; Draw rectangle code starts here

; Parameters
%assign	x			4
%assign y			6
%assign	width		8
%assign height		10
%assign rectColour	14

; local variables
%assign offset 		2

Draw_Rect:
	push	bp
	mov		bp, sp
	sub		sp, 2					; Reserve space for local variables

	push	ax						; Push registers that we will use onto the stack
	push 	bx
	push	cx
	push	es
	push	di

	mov		ax, 0A000h				; Set the memory address to A0000h using the segment register
	mov		es, ax

	cld								; Clear direction flag to make sure we are incrementing when copying into memory

	; calculate where the top left corner of the rectangle is in memory
	mov		ax, [bp + y]			; y * 320	
	mov		bx, 320
	mul		bx
	add		ax, [bp + x]			; Add x to the result	
	mov		di, ax					; Where in memory to start copying bytes to

	mov		ax, 320					; calculate the offset to add to di after each block of memory fill 
	sub		ax, [bp + width]		; offset = width of screen - width of rect
	mov		[bp - offset], ax

Rect_loop:
	mov		al, [bp + colour]		; The byte to be repeated. The colour 
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



;=================================================================================================================================
; Draw cirlce code starts here