; Draws a line of the screen using 2 points
; x0, y0 is the first and x1, y1 is he second point
;
; push onto the stack in this order:
; 	word 	colour
; 	word	y1
; 	word	x1	
; 	word	y0
; 	word	x0
;
; 'Draw_Line' cleans up the stack on return

; Draw_Line parameters
%assign x0		4
%assign y0		6
%assign x1		8
%assign y1		10
%assign colour	12

; Draw_Line local variables
%assign deltaX	2
%assign deltaY	4
%assign error	6
%assign error2	8
%assign signX	10
%assign signY	12

Draw_Line:
	push	bp
	mov		bp, sp
	sub		sp, 12					; Reserve space for local variables

	push	ax						; Push registers that we will use onto the stack
	push	bx
	push	ds
	push	si

	mov		ax, 0A000h				; Set the memory address to A0000h using the segment register
	mov		ds, ax

	jmp		Boundry_Checks			; Exit The function if the coords are outside screen pixels
 
Start_Line_Drawing:
	mov		[bp - signX], word -1	; Set signX and signY to be -1 by default
	mov		[bp - signY], word -1

	; Get deltaX and signX
	mov		ax, [bp + x1]			; x1 - x0
	sub		ax,	[bp + x0]
	jl		Keep_SignX_Negative		; If x0 < x1 then signX = 1 else keep -1
	mov		[bp - signX], word 1
Keep_SignX_Negative:	
	mov		bx,	ax					; abs(x1 - x0)
	neg		ax						; code for abs taken form here: https://stackoverflow.com/a/11927940
	cmovl	ax, bx
	mov		[bp - deltaX], ax		; store absolute value as deltaX

	; Get deltaY and signY
	mov		ax, [bp + y1]			; x1 - x0
	sub		ax,	[bp + y0]
	jl		Keep_SignY_Negative		; If x0 < x1 then signX = 1 else keep -1
	mov		[bp - signY], word 1
Keep_SignY_Negative:	
	mov		bx,	ax					; absolute value of the result
	neg		ax
	cmovl	ax, bx
	mov		[bp - deltaY], ax		; store absolute value

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
	jle		Skip_X_Change			; If less than or equal to don't increment x0 by signX
	mov		ax,	[bp - deltaY]		; error = error - dy
	sub		[bp - error], ax
	mov		ax, [bp - signX]			; x0 = x0 + signX
	add		[bp + x0], ax

Skip_X_Change:
	mov		ax, [bp - deltaX]		; Check if error2 < dx
	cmp		[bp - error2], ax
	jge		Draw_Loop			    ; if greater or equal to don't increment y0 by signY
	mov		ax, [bp - deltaX]		; error = error + dx
	add		[bp - error], ax		
	mov		ax, [bp - signY]			; y0 = y0 + signY
	add		[bp + y0], ax

	jmp		Draw_Loop				; go to the start of draw loop

Draw_Line_End:
	; Restore registers back to their original value 
	pop		si
	pop		ds
	pop		bx
	pop		ax

	mov		sp, bp
	pop		bp
	ret		10						; Return, removing 5 parameters from the stack


Draw_Pixel:
	; si = (y * 320) + x	
	mov		si,	[bp + y0]			; y * 256	
	sal		si, 8			
	mov		ax, [bp + y0]			; y * 64
	sal		ax, 6
	add		si, ax					; si = y * 256 + y * 64 = y * 320
	add		si, [bp + x0]			; Add x to the result
									; si is now the offset pixel location from A0000h (Video memory)

	; Error Checking, DS is set to A000h at the start of the function and wont change until ret
	cmp		si, 0f9ffh				; Check that si is 63999 or less
	ja		Draw_Pixel_End			; Don't access video memory if higher than 63999 
	
	mov		al, [bp + colour]		; Get the colour from the stack and make sure its 8 bits
	mov		[si], al				; Set the colour in video memeory

Draw_Pixel_End:
	ret

Boundry_Checks:
	; Check each coord is below its max value and above 0 using unsigned comparison
	; Exit the function and don't draw a line if true
	cmp		[bp + x0], word 319
	ja		Draw_Line_End
	cmp		[bp + x1], word 319
	ja		Draw_Line_End
	cmp		[bp + y0], word 199
	ja		Draw_Line_End
	cmp		[bp + y1], word 199
	ja		Draw_Line_End

	jmp		Start_Line_Drawing