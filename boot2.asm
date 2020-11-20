; Second stage of the boot loader

BITS 16

ORG 9000h
	jmp 	Second_Stage

%include "functions_16.asm"
%include "graphics.asm"				; File includes all the different graphics calls 

;	Start of the second stage of the boot loader
	
Second_Stage:
	mov 	si, second_stage_msg	; Output our greeting message
	call 	Console_WriteLine_16

	mov		ah, 0					; Set the display mode to mode 13h 
	mov		al, 13h
	int		10h

	call	Graphics_Calls			; Start drawing shapes		

	; This never-ending loop ends the code.  It replaces the hlt instruction
	; used in earlier examples since that causes some odd behaviour in 
	; graphical programs.
endloop:
	jmp		endloop

second_stage_msg	db 'Second stage loaded', 0

	times 3584-($-$$) db 0	