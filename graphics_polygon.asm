; Draws a polygon from an array of points using 'Draw_Line' for each line.
; 
; push onto the stack in this order before calling 'Draw_Polygon':
; 	word 	colour				; Colour of polygon
; 	word	pointCount			; Total points
; 	word	pointsArray			; Array address
;
; 'pointsArray' = address of where the points are located in memory.
; Each point is 2 words(4 bytes), y and x.
; Exaple points array:
;	Triangle:	dw 90, 233
;				dw 175, 233
;				dw 175, 300
;
; 'Draw_Polygon' cleans up the stack on return

; Draw_Polygon parameters
%assign pointsArray		4
%assign pointsCount		6
%assign colour			8

Draw_Polygon:
	push	bp
	mov		bp, sp

	push	cx
	push	si

	; Loop through the points array and draw lines between each point
	mov		cx, 1
	mov		si, [bp + pointsArray]
Poly_Loop:
	; Push points onto the stack by accessin the array with offsets and call Draw_Line
	push	word [bp + colour]	; colour
	push	word [si]			; y0
	push	word [si + 2]		; x0
	push	word [si + 4]		; y1
	push	word [si + 6]		; x1
	call	Draw_Line

	add		si, 4				; Move SI back 1 point (2 bytes) and loop
	inc		cx
	cmp		cx, [bp + pointsCount]	; Exit loop if iterated through all the points
	jne		Poly_Loop

	; Draw a line between the first and last point of the array
	mov		cx, si
	push	word [bp + colour]		; colour
	push	word [si]				; y0
	push	word [si + 2]			; x0
	mov		si, [bp + pointsArray]
	push	word [si]				; y1
	push	word [si + 2]			; x1
	call	Draw_Line

Draw_Polygon_End:
	push	si
	push	cx

	mov		sp, bp
	pop		bp
	ret		6