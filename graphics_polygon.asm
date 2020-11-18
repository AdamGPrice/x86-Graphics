; Draw_Poly parameters
%assign pointArrray		4
%assign pointCount		6
%assign colour			8

Draw_Poly:
	push	bp
	mov		bp, sp
	sub		sp, 0       	; Reserve space for local variables

	push	cx
	push	si

	; Loop through the points array and draw lines between each point
	mov		cx, 1
	mov		si, [bp + pointArrray]
Poly_Loop:
	push 	word [bp + colour]	; push colour for line draw
	push	word [si]			; y0
	push	word [si + 2]		; x0
	push	word [si + 4]		; y1
	push	word [si + 6]		; x1
	call 	Draw_Line

	add		si, 4
	inc		cx
	cmp		cx, [bp + pointCount]	; Exit loop if iterated through all the points
	jne		Poly_Loop

	mov		cx, si
	push 	word [bp + colour]		; push colour for line draw
	push	word [si]				; y0
	push	word [si + 2]			; x0
	mov		si, [bp + pointArrray]
	push	word [si]				; y1
	push	word [si + 2]			; x1
	call 	Draw_Line

Draw_Poly_End:
	push	si
	push	cx

	mov		sp, bp
	pop		bp
	ret		6