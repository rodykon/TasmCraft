IDEAL
MODEL small
STACK 100h
DATASEG

; BUFFER
	bufferSeg equ 0B000h

; BITMAP
	filename db 'MAIN_MAIN_MAIN.bmp', 0
	filehandle dw ?
	Header db 54 dup (0)
	Palette db 256*4 dup (0)
	ScrLine db 320 dup (0)
	ErrorMsg db 'Error', 13, 10,'$'
	
	main db 'MAIN.bmp', 0
	mainlngth dw 0008h
	mainNum equ 0
	
	main_play db 'PLAY.bmp', 0
	mainPlayNum equ 1
	
	main_help db 'HELP.bmp', 0
	mainHelpNum equ 2
	
	main_exit db 'EXIT.bmp', 0
	mainExitNum equ 3
	
	help_main db 'MHELP.bmp', 0
	helpMainNum equ 4
	
	help_return db 'RETURN.bmp', 0
	helpReturnNum equ 5
	
	exit_main db 'MEXIT.bmp', 0
	exitMainNum equ 6
	
	exit_yes db 'YES.bmp', 0
	exitYesNum equ 7
	
	exit_no db 'NO.bmp', 0
	exitNoNum equ 8
	
	lastBMP db 0
	currentBMP db 0
	
	
	gameStatus db 0   ; 0 = Main menu
					  ; 1 = Game
					  ; 2 = Help menu
					  ; 3 = Exit menu
					  ; 4 = Leave game

; CONSTANTS
	SCREEN_WIDTH dw 319
	SCREEN_HEIGHT dw 199
	
	FPS db 60
	
	DEFAULT_BLOCK_WIDTH dw 19
	
; KEYS
	W_PRESS db 11h    
	W_RELEASE db 91h
	A_PRESS db 1Eh
	A_RELEASE db 9Eh
	S_PRESS db 1Fh
	S_RELEASE db 9Fh
	D_PRESS db 20h
	D_RELEASE db 0A0h
	
	RIGHT_PRESS db 12h
	RIGHT_RELEASE db 92h
	LEFT_PRESS db 10h
	LEFT_RELEASE db 90h
	
	ESC_PRESS db 1
	ESC_RELEASE db 81
	
	Wkey db 'F'
	Akey db 'F'
	Skey db 'F'
	Dkey db 'F'
	
	RightKey db 'F'
	LastRight db 'F'
	RightOnPress db 'F'
	LeftKey db 'F'
	LastLeft db 'F'
	LeftOnPress db 'F'
	
	EscKey db 'F'
	
; MOUSE	
	fore1 dw 1111111111111111b
	fore2 dw 1111111111111111b
	fore3 dw 1111111111111111b
	fore4 dw 1111111000001111b
	fore5 dw 1111000000000111b
	fore6 dw 1111000000001111b
	fore7 dw 1111000011111111b
	fore8 dw 1110000001111111b
	fore9 dw 1110001000111111b
	fore10 dw 1110001100011111b
	fore11 dw 1110001110001111b
	fore12 dw 1110001111000111b
	fore13 dw 1111011111100011b
	fore14 dw 1111111111110001b
	fore15 dw 1111111111111000b
	fore16 dw 1111111111111100b
	back1 dw 0000000000000000b
	back2 dw 0000000000000000b
	back3 dw 0000000000000000b
	back4 dw 0000000000000000b
	back5 dw 0000000111110000b
	back6 dw 0000001100000000b
	back7 dw 0000011000000000b
	back8 dw 0000110100000000b
	back9 dw 0000100010000000b
	back10 dw 0000100001000000b
	back11 dw 0000100000100000b
	back12 dw 0000100000010000b
	back13 dw 0000000000001000b
	back14 dw 0000000000000100b
	back15 dw 0000000000000010b
	back16 dw 0000000000000000b
	
	HotSpotX dw 0005h
	HotSpotY dw 0005h
	
	
	MouseScreenX dw ?
	MouseScreenY dw ?
	
	MouseX dw ?
	MouseY dw ?
	
	MouseLeft db 'F'
	MouseRight db 'F'
	
; TEXT
	
	include 'numbers.asm'
	
	
; BLOCKS
	bedrock dw 0
	grass dw 1
	stone dw 2
	dirt dw 3
	tree dw 4
	treeBlock dw 5
	

; WORLD	
	
	wrld1  dw 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '$'
	wrld2  dw 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, '$'
	wrld3  dw 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, '$'
	wrld4  dw 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, '$'
	wrld5  dw 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 4, 1, 1, 1, 1, 1, 1, 1, 0, '$'
	wrld6  dw 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 0, '$'
	wrld7  dw 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 4, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 4, 2, 2, 2, 1, 1, 1, 1, 1, 1, 0, '$'
	wrld8  dw 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1, 0, '$'
	wrld9  dw 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 3, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 4, 1, 1, 1, 1, 2, 2, 2, 2, 1, 1, 4, 1, 1, 1, 0, '$'
	wrld10 dw 0, 1, 4, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 3, 3, 3, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 0, '$'
	wrld11 dw 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 3, 3, 3, 2, 3, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 4, 1, 1, 1, 4, 1, 1, 1, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 0, '$'
	wrld12 dw 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 3, 2, 2, 2, 3, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 3, 3, 3, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, '$'
	wrld13 dw 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 3, 2, 2, 2, 3, 3, 4, 1, 1, 1, 1, 1, 1, 4, 1, 1, 1, 1, 1, 1, 3, 2, 3, 3, 3, 1, 1, 4, 1, 1, 1, 1, 1, 1, 1, 0, '$'
	wrld14 dw 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 3, 2, 3, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 2, 3, 2, 3, 3, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, '$'
	wrld15 dw 0, 1, 4, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 3, 2, 2, 2, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 4, 1, 3, 3, 2, 2, 2, 3, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, '$'
	wrld16 dw 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 3, 2, 2, 3, 3, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 3, 2, 2, 2, 3, 1, 1, 1, 1, 1, 1, 4, 1, 1, 1, 0, '$'
	wrld17 dw 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 3, 2, 2, 3, 3, 1, 1, 1, 1, 1, 4, 1, 4, 1, 1, 1, 1, 1, 1, 3, 3, 2, 2, 2, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, '$'
	wrld18 dw 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 3, 2, 2, 3, 3, 1, 1, 4, 1, 1, 1, 1, 1, 1, 1, 4, 1, 1, 1, 3, 2, 3, 2, 2, 3, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, '$'
	wrld19 dw 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 3, 2, 2, 3, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 2, 3, 2, 2, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, '$'
	wrld20 dw 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 2, 3, 2, 3, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 4, 1, 1, 1, 3, 3, 2, 2, 3, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, '$'
	wrld21 dw 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 3, 2, 2, 3, 3, 1, 1, 1, 1, 1, 1, 1, 4, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 3, 2, 2, 3, 3, 1, 1, 4, 1, 1, 1, 1, 1, 1, 0, '$'
	wrld22 dw 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 3, 2, 2, 2, 3, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 2, 3, 2, 3, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, '$'
	wrld23 dw 0, 4, 1, 1, 1, 1, 1, 1, 1, 3, 3, 2, 2, 2, 3, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 3, 2, 2, 2, 2, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, '$'
	wrld24 dw 0, 1, 1, 1, 1, 1, 1, 1, 3, 3, 3, 2, 2, 3, 2, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 3, 3, 2, 2, 3, 3, 3, 1, 1, 1, 1, 1, 1, 4, 1, 1, 0, '$'
	wrld25 dw 0, 1, 1, 1, 1, 1, 1, 1, 1, 3, 3, 2, 2, 2, 3, 1, 1, 1, 4, 1, 4, 1, 1, 1, 1, 1, 1, 1, 4, 1, 1, 3, 3, 2, 2, 2, 3, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, '$'
	wrld26 dw 0, 1, 1, 1, 1, 1, 1, 1, 1, 3, 3, 2, 2, 2, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 3, 3, 2, 2, 2, 3, 3, 3, 1, 1, 1, 1, 4, 1, 1, 1, 1, 1, 0, '$'
	wrld27 dw 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 3, 2, 2, 3, 3, 1, 1, 1, 1, 4, 1, 1, 1, 1, 1, 1, 1, 3, 2, 3, 2, 2, 2, 2, 3, 3, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, '$'
	wrld28 dw 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 3, 2, 2, 2, 3, 3, 1, 1, 1, 1, 1, 1, 1, 4, 1, 4, 1, 1, 3, 2, 2, 2, 2, 2, 3, 3, 1, 1, 1, 1, 1, 1, 1, 1, 4, 1, 1, 0, '$'
	wrld29 dw 0, 1, 4, 1, 1, 1, 1, 1, 1, 1, 3, 3, 2, 2, 2, 3, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 3, 2, 2, 2, 2, 3, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, '$'
	wrld30 dw 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 2, 2, 2, 2, 3, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 3, 2, 2, 2, 3, 3, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, '$'
	wrld31 dw 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 3, 2, 2, 2, 2, 3, 3, 1, 1, 1, 1, 4, 1, 1, 1, 1, 3, 3, 3, 3, 2, 3, 3, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, '$'
	wrld32 dw 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 2, 3, 2, 2, 2, 3, 3, 4, 3, 1, 1, 1, 1, 1, 1, 3, 3, 3, 2, 2, 2, 3, 3, 1, 1, 1, 4, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, '$'
	wrld33 dw 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 3, 2, 2, 2, 2, 3, 3, 3, 3, 1, 1, 1, 1, 1, 3, 3, 2, 2, 2, 2, 3, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 4, 1, 0, '$'
	wrld34 dw 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 3, 3, 2, 2, 2, 2, 3, 3, 3, 1, 4, 1, 3, 4, 3, 3, 2, 2, 2, 3, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, '$'
	wrld35 dw 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 3, 3, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 3, 2, 2, 2, 2, 3, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, '$'
	wrld36 dw 0, 4, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 3, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 2, 2, 2, 2, 3, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, '$'
	wrld37 dw 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 3, 3, 2, 2, 2, 2, 3, 2, 2, 3, 3, 2, 2, 2, 2, 2, 3, 3, 3, 1, 1, 4, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, '$'
	wrld38 dw 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 3, 3, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3, 2, 3, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 4, 1, 1, 1, 1, 1, 0, '$'
	wrld39 dw 0, 1, 1, 1, 1, 1, 1, 1, 1, 3, 3, 3, 1, 1, 1, 4, 3, 2, 2, 3, 3, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, '$'
	wrld40 dw 0, 1, 1, 1, 1, 1, 1, 1, 3, 3, 3, 3, 1, 1, 1, 1, 1, 3, 3, 3, 3, 3, 3, 3, 2, 3, 3, 3, 3, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, '$'
	wrld41 dw 0, 1, 1, 1, 1, 1, 1, 1, 3, 3, 2, 2, 3, 1, 1, 1, 1, 1, 1, 1, 3, 3, 3, 3, 3, 3, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 4, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, '$'
	wrld42 dw 0, 1, 1, 1, 1, 1, 1, 3, 2, 2, 2, 2, 2, 3, 1, 1, 1, 1, 1, 1, 1, 3, 1, 1, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 4, 1, 1, 0, '$'
	wrld43 dw 0, 1, 1, 1, 1, 1, 1, 1, 3, 2, 2, 2, 2, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 4, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, '$'
	wrld44 dw 0, 1, 1, 1, 1, 1, 1, 3, 3, 2, 2, 2, 2, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, '$'
	wrld45 dw 0, 1, 1, 1, 1, 1, 1, 3, 3, 2, 2, 2, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 4, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, '$'
	wrld46 dw 0, 1, 1, 1, 1, 1, 1, 1, 1, 3, 3, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 4, 1, 1, 1, 1, 1, 0, '$'
	wrld47 dw 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, '$'
	wrld48 dw 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, '$'
	wrld49 dw 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, '$'
	wrld50 dw 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	worldSiz dw 2549
	
	worldX dw 0
	worldY dw 0
	
	; INNER VARS
	WORLD_Y_OFFSET dw ?
	BLOCK_REMAINDER_DELTA_Y dw ?
	WORLD_X_OFFSET dw ?
	X_BLOCKS_TO_SKIP dw ?
	; !!!!!!
	
	
; PLAYER
	playerFront db '*', '*', 0, 0, 0, '*', '*', '$','*', '*', 89, 89, 89, '*', '*', '$','*', '*', 89, 89, 89, '*', '*', '$','*', '*', 89, 89, 89, '*', '*', '$','*', '*', 4, 89, 4, '*', '*', '$','*', 40, 40, 4, 40, 40, '*', '$',40, 40, 40, 40, 40, 40, 40, '$',40, 40, 40, 40, 40, 40, 40, '$',40, 40, 40, 40, 40, 40, 40, '$',40, 40, 40, 40, 40, 40, 40, '$',89, 40, 40, 40, 40, 40, 89, '$','*', 0, 0, 0, 0, 0, '*', '$','*', 0, 0, 0, 0, 0, '*', '$','*', 0, 0, 0, 0, 0, '*', '$','*', 0, 0, '*', 0, 0, '*', '$','*', 0, 0, '*', 0, 0, '*', '$','*', 0, 0, '*', 0, 0, '*', '$','*', 0, 0, '*', 0, 0, '*', '$','*', 0, 0, '*', 0, 0, '*', '$','*', 0, 0, '*', 0, 0, '*', '$',0, 0, 0, '*', 0, 0, 0
	playerSiz dw 167
	
	playerScreenX dw 20
	playerScreenY dw 20
	
	playerX dw 20
	playerY dw 20
	playerVelocity dw 4
	
	COLLISION_WIDTH dw 10
	COLLISION_HEIGHT dw 20
	
; Inventory

inv1 db 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, '$'
inv2 db 18, 25, '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', 25, 18, 25, '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', 25, 18, 25, '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', 25, 18, 25, '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', 25, 18, '$'
inv3 db 18, 25, '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', 25, 18, 25, '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', 25, 18, 25, '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', 25, 18, 25, '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', 25, 18, '$'
inv4 db 18, 25, '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', 25, 18, 25, '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', 25, 18, 25, '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', 25, 18, 25, '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', 25, 18, '$'
inv5 db 18, 25, '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', 25, 18, 25, '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', 25, 18, 25, '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', 25, 18, 25, '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', 25, 18, '$'
inv6 db 18, 25, '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', 25, 18, 25, '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', 25, 18, 25, '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', 25, 18, 25, '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', 25, 18, '$'
inv7 db 18, 25, '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', 25, 18, 25, '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', 25, 18, 25, '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', 25, 18, 25, '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', 25, 18, '$'
inv8 db 18, 25, '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', 25, 18, 25, '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', 25, 18, 25, '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', 25, 18, 25, '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', 25, 18, '$'
inv9 db 18, 25, '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', 25, 18, 25, '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', 25, 18, 25, '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', 25, 18, 25, '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', 25, 18, '$'
inv10 db 18, 25, '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', 25, 18, 25, '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', 25, 18, 25, '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', 25, 18, 25, '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', 25, 18, '$'
inv11 db 18, 25, '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', 25, 18, 25, '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', 25, 18, 25, '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', 25, 18, 25, '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', 25, 18, '$'
inv12 db 18, 25, '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', 25, 18, 25, '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', 25, 18, 25, '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', 25, 18, 25, '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', 25, 18, '$'
inv13 db 18, 25, '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', 25, 18, 25, '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', 25, 18, 25, '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', 25, 18, 25, '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', 25, 18, '$'
inv14 db 18, 25, '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', 25, 18, 25, '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', 25, 18, 25, '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', 25, 18, 25, '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', 25, 18, '$'
inv15 db 18, 25, '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', 25, 18, 25, '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', 25, 18, 25, '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', 25, 18, 25, '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', 25, 18, '$'
inv16 db 18, 25, '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', 25, 18, 25, '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', 25, 18, 25, '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', 25, 18, 25, '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', 25, 18, '$'
inv17 db 18, 25, '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', 25, 18, 25, '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', 25, 18, 25, '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', 25, 18, 25, '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', 25, 18, '$'
inv18 db 18, 25, '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', 25, 18, 25, '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', 25, 18, 25, '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', 25, 18, 25, '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', 25, 18, '$'
inv19 db 18, 25, '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', 25, 18, 25, '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', 25, 18, 25, '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', 25, 18, 25, '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', 25, 18, '$'
inv20 db 18, 25, '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', 25, 18, 25, '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', 25, 18, 25, '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', 25, 18, 25, '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', 25, 18, '$'
inv21 db 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18
	
	invSize dw 1889
	
	inventory dw '*', '*', '*', '*'
	invNum db 0, 0, 0, 0
	
	Current db 1
	
	; MENU BUTTONS
	
	playbutton dw 135, 125, 180, 140
	helpbutton dw 135, 150, 180, 165
	exitbutton dw 135, 180, 180, 190
	
	returnbutton dw 225, 178, 292, 190
	
	yesbutton dw 90, 88, 123, 103
	nobutton dw 193, 88, 217, 103
	
CODESEG

proc graphicsMode
	push ax
	
	mov al, 13h
	mov ah, 0
	int 10h
	
	pop ax
	ret
	endp graphicsMode

proc textMode
	push ax
	mov al, 3h
	mov ah, 0
	int 10h
	pop ax
	endp textMode
	
proc getColor
	push bp
	mov bp, sp
	
	push ax
	push cx
	push dx
	
	X equ [bp + 6]
	Y equ [bp + 4]
	
	mov ah, 0Dh
	mov cx, X
	mov dx, Y
	int 10h
	mov [bp + 6], al
	
	pop dx
	pop cx
	pop ax
	
	pop bp
	ret 2
	endp getColor
	
proc drawLine
	push bp
	mov bp, sp
	
	push ax
	push bx
	push cx
	push dx
	
	X1 equ [bp + 12]
	Y1 equ [bp + 10]
	X2 equ [bp + 8]
	Y2 equ [bp + 6]
	Color equ [bp + 4]
	
	mov ax, X2
	sub ax, X1
	
	mov bx, Y2
	sub bx, Y1
	
	cmp ax, bx
	jg DoX
	
	mov cx, Y1
	dec cx
	DrawY:
		inc cx
		push X1
		push cx
		push Color
		call drawPixel
		cmp cx, Y2
		jne DrawY
		jmp Done
DoX:
	mov cx, X1
	dec cx
	DrawX:
		inc cx
		push cx
		push Y1
		push Color
		call drawPixel
		cmp cx, X2
		jne DrawX
		
Done:
	pop dx
	pop cx
	pop bx
	pop ax
	
	pop bp
	ret 10
	endp drawLine
	
proc drawRect
	push bp
	mov bp, sp
	
	push ax
	push bx
	
	X equ [bp + 12]
	Y equ [bp + 10]
	Wid equ [bp + 8]
	Hei equ [bp + 6]
	Color equ [bp + 4]
	
	mov ax, X
	add ax, Wid
	
	push X
	push Y
	push ax
	push Y
	push Color
	call drawLine
	
	mov bx, Y
	add bx, Hei
	
	push ax
	push Y
	push ax
	push bx
	push Color
	call drawLine
	
	push X
	push bx
	push ax
	push bx
	push Color
	call drawLine
	
	push X
	push Y
	push X
	push bx
	push Color
	call drawLine
	
	pop bx
	pop ax
	
	pop bp
	ret 10
	endp drawRect
	
proc fillRect
	push bp
	mov bp, sp
	
	push ax
	push bx
	push cx
	
	X equ [bp + 12]
	Y equ [bp + 10]
	Wid equ [bp + 8]
	Hei equ [bp + 6]
	Color equ [bp + 4]
	
	mov bx, Y
	mov cx, Hei
	inc cx
	add cx, bx
	mov ax, X
	add ax, Wid
	drawLoop:
		push X
		push bx
		push ax
		push bx
		push Color
		call drawLine
		
		inc bx
		cmp bx, cx
		jne drawLoop
	
	pop cx
	pop bx
	pop ax
	
	pop bp
	ret 10
	endp fillRect
	
proc drawBlock   ; This proc allows addition of any type of block. It also recieves start and end coords on the block that state where the drawing should begin and end.
	push bp
	mov bp, sp
	
	push ax
	push bx
	push cx
	push dx
	push si
	push di
	
	X equ [bp + 16]  ; On Screen
	Y equ [bp + 14]  ; """""""""
	StartX equ [bp + 12] ; On Block
	StartY equ [bp + 10] ; """""""""
	EndX equ [bp + 8]    ; """""""""
	EndY equ [bp +6]     ; """""""""
	Block equ [bp + 4]
	
	xor di, di
	
	mov dx, EndX
	sub dx, StartX
	mov si, EndY
	sub si, StartY ; Get width and height of the blocks
	
	
	mov cx, Block
	
	cmp cx, [grass]
	je SetGrass
	
	cmp cx, [stone]
	je SetStone
	
	cmp cx, [dirt]
	je SetDirt
	
	cmp cx, [bedrock]
	je SetBedrock
	
	cmp cx, [treeBlock]
	je setTreeBlock
	
	cmp cx, [tree]
	je SetTree
	jne Mid
	
SetGrass:
	mov ax, 2
	mov bx, 10
	jmp Draw
	
SetStone:
	mov ax, 7
	mov bx, 8
	jmp Draw
	
SetDirt:
	mov ax, 114
	mov bx, 186
	jmp Draw
	
	
SetBedrock:
	mov ax, 17
	mov bx, 16
	jmp Draw
	
SetTree:
	push X
	push Y
	push StartX
	push StartY
	push EndX
	push EndY
	push offset tree1
	call drawSpecialBlock
	jmp Mid
	
SetTreeBlock:
	mov ax, 6
	mov bx, 42
	jmp Draw
	
Mid:
	jmp DontDraw
	
Draw:

	push X
	push Y
	push dx
	push si
	push ax
	call fillRect ; Draw inner rectangle
	
	add dx, X
	add si, Y ; add width and height to screen draw coords to get end bottom right coords
	
	cmp StartX, di ; If start X is not 0, don't draw left line
	jne Check2
	
	push X
	push Y
	push X
	push si
	push bx
	call drawLine
	
Check2:
	cmp StartY, di ; If start Y is not 0, don't draw top line
	jne Check3
	
	push X
	push Y
	push dx
	push Y
	push bx
	call drawLine
	
Check3:
	mov di, [DEFAULT_BLOCK_WIDTH]
	cmp EndX, di ; If end X is not block width, dont draw right line
	jne Check4
	
	push dx
	push Y
	push dx
	push si
	push bx
	call drawLine
	
Check4:
	cmp EndY, di ; If end Y is not block width, don't draw bottom line
	jne DontDraw
	
	push X
	push si
	push dx
	push si
	push bx
	call drawLine
	
DontDraw:
	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	
	pop bp
	ret 14
	endp drawBlock
	
	proc drawSpecialBlock
	push bp
	mov bp, sp
	
	X equ [bp + 16]  ; On Screen
	Y equ [bp + 14]  ; """""""""
	StartX equ [bp + 12] ; On Block
	StartY equ [bp + 10] ; """""""""
	EndX equ [byte ptr bp + 8]    ; """""""""
	EndY equ [bp +6]     ; """""""""
	OffsetBlock equ [bp + 4]
	BlockLength equ 361 ; 19^2
	
	mov di, OffsetBlock
	
	mov dx, X
	mov si, Y
	
	mov cx, BlockLength
	
; LOOP LENGTH CALCULATIONS
	
	; StartX*BlockWidth
	mov ax, StartX
	mov bl, [byte ptr DEFAULT_BLOCK_WIDTH]
	mul bl
	sub cx, ax ; Don't run unneeded iterations (while skipping startX pixels at the begining of each row)
	
	; StartY*(BlockWidth-StartX)
	mov ax, StartY
	mov bx, [DEFAULT_BLOCK_WIDTH]
	sub bx, StartX
	mul bl
	sub cx, ax ; Don't run unneeded iterations (while skipping startY rows at beginning)
	
	; EndY(BlockWidth-StartX)
	mov ax, [DEFAULT_BLOCK_WIDTH]
	sub ax, EndY
	mov bx, [DEFAULT_BLOCK_WIDTH]
	sub bx, StartX
	mul bl
	sub cx, ax ; Don't run unneeded iterations (while skipping endY rows at end)
	
; START PIXEL CALCULATIONS
	xor bx, bx
	
	add bx, StartX ; Skip the StartX pixels on first row
	
	mov ax, StartY
	mov bl, [byte ptr DEFAULT_BLOCK_WIDTH]
	mul bl
	add bx, ax ; Skip StartY rows at the beginning
	
DrawSpecial:
	cmp bx, 0
	je Draw1 ; Don't go row down on first pixel
	
	mov ax, si
	sub ax, Y
	cmp ax, EndY
	je ending ; skip unwanted rows
	
	mov ax, bx
	div [byte ptr DEFAULT_BLOCK_WIDTH]
	cmp ah, 0 ; If remainder is BlockWidth-EndX, go row down        CHECK IF AT END OF ROW
	jne Draw1
		inc si ;Increase Y
		mov dx, X ;Zero X
		add bx, StartX ; Start row in startX
		
Draw1:
	push dx
	push si
	push [di + bx]
	call drawPixel
	
	inc bx ; Move to next pixel
	inc dx ; Increment X position
	loop DrawSpecial
	
ending:
	pop bp
	ret 14
	endp drawSpecialBlock
	
	proc drawWorld  ; Draw Array of blocks
	push bp
	mov bp, sp
	
	push ax
	push bx
	push cx
	push dx
	push si
	push di
	
	XOff equ [bp + 10]
	YOff equ [bp + 8]
	offWorld equ [bp + 6]
	Siz equ [bp + 4]
	
	mov bx, offWorld
	mov cx, Siz
	
	xor ax, ax
	
	mov ax, XOff
	div [byte ptr DEFAULT_BLOCK_WIDTH]
	mov [byte ptr X_BLOCKS_TO_SKIP], al ; Quotient represents number of blocks to skip on each row
	mov [byte ptr WORLD_X_OFFSET], ah ; Remainder represents number of pixels to skip from the last block
	
	xor ax, ax
	
	mov ax, YOff
	div [byte ptr DEFAULT_BLOCK_WIDTH] ; Calculate number of rows to skip
	cmp al, 0
	je dontSkip

skipRows:
	WaitForNext:
		cmp [byte ptr bx], '$'
		je Next
		
		add bx, 2
		dec cx
		jmp WaitForNext
	
Next:
	add bx, 2
	dec cx
	dec al
	cmp al, 0
	jne skipRows
	
	
dontSkip:	
	mov [byte ptr WORLD_Y_OFFSET], ah ; Draw part block (Y axis)
	
	xor ax, ax ;Holds X Value
	xor dx, dx ;Holds Y Value
	mov si, [DEFAULT_BLOCK_WIDTH] ; Block end print X
	mov di, [DEFAULT_BLOCK_WIDTH] ; Block end print Y
	
	jmp SetXStart
	RenderWorld:
		cmp [byte ptr bx], '$'
		je RowDown
		
		cmp ax, [SCREEN_WIDTH]
		jg WaitForSign ; Don't print rest of row
		
		cmp dx, [SCREEN_HEIGHT]
		jg Middle ; Don't print rows after bottom
		
		mov si, [SCREEN_WIDTH]
		sub si, ax ;Delta X
		
		cmp si, [DEFAULT_BLOCK_WIDTH]
		jl afterResetOne
		
		mov si, [DEFAULT_BLOCK_WIDTH]
		
	afterResetOne:
		
		mov di, [SCREEN_HEIGHT]
		sub di, dx ;Delta Y
		
		cmp di, [DEFAULT_BLOCK_WIDTH]
		jl afterReset
		
		mov di, [DEFAULT_BLOCK_WIDTH]
		
	afterReset:
		
		push ax
		push dx
		push 0000h
		push [WORLD_Y_OFFSET]
		push si
		push di
		push [bx]
		call drawBlock
		
		
		add ax, [DEFAULT_BLOCK_WIDTH]
		add bx, 2
		loop RenderWorld
		
		jmp FinishProc
	
	Middle:
		jmp FinishProc
		
	WaitForSign:
		cmp [byte ptr bx], '$'
		je RowDown
		
		add bx, 2
		loop WaitForSign
		
		jmp FinishProc
		
	RowDown:
		add bx, 2
		
		mov ax, [DEFAULT_BLOCK_WIDTH]
		sub ax, [WORLD_Y_OFFSET]
		mov [BLOCK_REMAINDER_DELTA_Y], ax ; Calculate how many pixels to drop
		
		xor ax, ax
		add dx, [BLOCK_REMAINDER_DELTA_Y]
		mov [WORLD_Y_OFFSET], 0000h
		
		jmp SetXStart

	SetXStart:
		push ax
		mov ax, [X_BLOCKS_TO_SKIP]
		
		SkipBlocks: ; Skip first blocks in array
			add bx, 2
			dec cx
			dec ax
			cmp ax, 0
			jne SkipBlocks
		
		pop ax
		; Print First block of row
		push ax
		push dx
		push [WORLD_X_OFFSET]
		push [WORLD_Y_OFFSET]
		push [DEFAULT_BLOCK_WIDTH]
		push di
		push [bx]
		call drawBlock
		
		push dx
		mov dx, [DEFAULT_BLOCK_WIDTH]
		sub dx, [WORLD_X_OFFSET]
		add ax, dx ; Calculate where to plot next block
		pop dx
		
		add bx, 2
		jmp RenderWorld
		
FinishProc:
	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	
	pop bp
	ret 8
	endp drawWorld
	
	proc drawPicture ; Draw array of pixels
	push bp
	mov bp, sp
	
	push ax
	push bx
	push cx
	push si
	
	PaintX equ [bp + 10]
	PaintY equ [bp + 8]
	offPainting equ [bp + 6]
	PaintingSiz equ [bp + 4]
	
	mov ax, PaintX
	mov si, PaintY
	
	mov cx, PaintingSiz
	mov bx, offPainting
	
PaintLoop:
	cmp [byte ptr bx], '$'
	je NextRow
	
	cmp [byte ptr bx], '*'
	je afterDraw
	
	push ax
	push si
	push [bx]
	call drawPixel

afterDraw:
	inc ax
	inc bx
	loop PaintLoop
	
	jmp endDraw
NextRow:
	mov ax, PaintX
	inc si
	inc	bx
	dec cx
	jmp PaintLoop
	
endDraw:
	pop si
	pop cx
	pop bx
	pop ax
	
	pop bp
	ret 8
	endp drawPicture
	
proc drawPlayer
	push [playerScreenX]
	push [playerScreenY]
	push offset playerFront
	push [playerSiz]
	call drawPicture
	ret
	endp drawPlayer
	
proc drawWorlds
	
	push [worldX]
	push [worldY]
	push offset wrld1
	push [worldSiz]
	call drawWorld
	
	ret
	endp drawWorlds
	
	
proc getKeys  ; Handle Keys
	push ax
	
	in al, 60h
	
	cmp al, [W_PRESS]
	jne APress
	mov [Wkey], 'T'
	
APress:
	cmp al, [A_PRESS]
	jne SPress
	mov [Akey], 'T'
	
SPress:
	cmp al, [S_PRESS]
	jne DPress
	mov [Skey], 'T'
	
DPress:
	cmp al, [D_PRESS]
	jne RightPress
	mov [Dkey], 'T'
	
RightPress:
	cmp al, [RIGHT_PRESS]
	jne LeftPress
	mov [RightKey], 'T'
	
LeftPress:
	cmp al, [LEFT_PRESS]
	jne EscPress
	mov [LeftKey], 'T'

EscPress:
	cmp al, [ESC_PRESS]
	jne WRelease
	mov [EscKey], 'T'
	
WRelease:
	cmp al, [W_RELEASE]
	jne ARelease
	mov [Wkey], 'F'
	
ARelease:
	cmp al, [A_RELEASE]
	jne SRelease
	mov [Akey], 'F'
	
SRelease:
	cmp al, [S_RELEASE]
	jne DRelease
	mov [Skey], 'F'
	
DRelease:
	cmp al, [D_RELEASE]
	jne RightRelease
	mov [Dkey], 'F'
	
RightRelease:
	cmp al, [RIGHT_RELEASE]
	jne LeftRelease
	mov [RightKey], 'F'
	
LeftRelease:
	cmp al, [LEFT_RELEASE]
	jne EscRelease
	mov [LeftKey], 'F'
	
EscRelease:
	cmp al, [ESC_RELEASE]
	jne Finish
	mov [EscKey], 'F'
	
Finish:	
	pop ax
	ret
	endp getKeys
	
	proc movePlayer
	push bx
	mov bx, [playerVelocity]
	
	
WK:
	cmp [Wkey], 'T'
	jne AK 
	; W
	
	cmp [playerY], 85
	jge moveWorldW
	
movePlayerW:
	sub [playerScreenY], bx
	jmp AK
	
moveWorldW:
	cmp [playerY], 833
	jg movePlayerW
	
	sub [worldY], bx 
	
	cmp [worldY], 0
	je movePlayerW
	
	; W
AK:
	cmp [Akey], 'T'
	jne SK
	; A
	
	cmp [playerX], 150
	jge moveWorldA
	
movePlayerA:
	sub [playerScreenX], bx 
	jmp Sk
	
moveWorldA:
	cmp [playerX], 760
	jg movePlayerA
	
	sub [worldX], bx
	
	cmp [worldX], 0
	je movePlayerA
	
	; A
SK:	
	cmp [Skey], 'T'
	jne DK
	; S
	
	cmp [playerY], 85
	jge moveWorldS
	
movePlayerS:
	add [playerScreenY], bx
	jmp DK
	
moveWorldS:
	cmp [worldY], 748
	jge movePlayerS
	add [worldY], bx
	
	
	; S
DK:	
	cmp [Dkey], 'T'
	jne Fin
	; D
	
	cmp [playerX], 150
	jge moveWorldD
	
movePlayerD:
	add [playerScreenX], bx
	jmp Fin
	
moveWorldD:
	cmp [worldX], 610
	jge movePlayerD
	add [worldX], bx
	
	
	; D
Fin:
	pop bx
	ret 
	endp movePlayer
	
proc calcCoords ; The procedure adds world coords to screen coords in order to get player world coords
	push ax
	
	; Calculate player world position
	xor ax, ax
	mov ax, [playerScreenX]
	add ax, [worldX]
	mov [playerX], ax
	
	xor ax, ax
	mov ax, [playerScreenY]
	add ax, [worldY]
	mov [playerY], ax
	
	; Calculate mouse world position
	xor ax, ax
	mov ax, [worldX]
	add ax, [MouseScreenX]
	mov [MouseX], ax
	
	xor ax, ax
	mov ax, [worldY]
	add ax, [MouseScreenY]
	mov [MouseY], ax
	
	pop ax
	ret
	endp calcCoords
	
proc getWorldPosition ; Get world array position from x and y coorinates
	push bp
	mov bp, sp
	
	push ax
	push bx
	
	XPos equ [bp + 6]
	YPos equ [bp + 4]
	
	xor ax, ax
	xor bx, bx
	
	mov ax, YPos
	div [byte ptr DEFAULT_BLOCK_WIDTH]
	mov bl, 50d
	xor ah, ah
	mul bl
	mov bx, ax ; BX = (Y/BlockWidth)*50
	
	xor ax, ax
	mov ax, XPos
	div [byte ptr DEFAULT_BLOCK_WIDTH] ; AX = X/BlockWidth
	xor ah, ah
	
	add ax, bx ; Y/BlockWidth*51 + X/BlockWidth
	
	mov cx, 0002h
	mul cx  ; Normalize to word array
	
	mov [bp + 6], ax
	
	pop bx
	pop ax
	
	pop bp
	ret 2
	endp getWorldPosition
	
proc getBlock ; Returns the type of block at given coords
	push bp
	mov bp, sp
	
	push ax
	push bx
	
	X equ [bp + 6]
	Y equ [bp + 4]
	
	push X
	push Y
	call getWorldPosition
	pop bx
	
	mov ax, [offset wrld1 + bx]
	mov [bp + 6], ax
	
	pop bx
	pop ax
	
	pop bp
	ret 2
	endp getBlock
	
	
proc setBlock ; Change a block in X and Y coords
	push bp
	mov bp, sp
	
	push ax
	push bx
	
	X equ [bp + 8]
	Y equ [bp + 6]
	Block equ [bp + 4]
	
	mov ax, Block
	
	push X
	push Y
	call getWorldPosition
	
	pop bx
	
	mov [offset wrld1 + bx], ax
	
	pop ax
	pop bx
	
	pop bp
	ret 6
	endp setBlock
	
	proc startMouse
		mov ax, 0
		int 33h
		
		mov ax, 1
		int 33h
		
		mov ax, 9
		mov bx, [HotSpotX]
		mov cx, [HotSpotY]
		mov dx, offset fore1
		push ds
		pop es
		int 33h
	ret
	endp startMouse
	
	proc getLeftMouseButton
	
	mov ax, 3h
	int 33h
	
	shr bx, 1
	jnc NoLeft
	
	mov [MouseLeft], 'T'
	jmp CheckRight
	
NoLeft:
	mov [MouseLeft], 'F'
	
CheckRight:
	shr bx, 1
	jnc NoRight
	
	mov [MouseRight], 'T'
	jmp EndProcedure
	
NoRight:
	mov [MouseRight], 'F'
	
EndProcedure:
	ret 
	endp getLeftMouseButton
	
	proc getMousePosition
	push ax
	push cx
	push dx
	
	mov ax, 3h
	int 33h
	
	mov [MouseScreenY], dx
	
	shr cx, 1
	
	mov [MouseScreenX], cx
	
	pop dx
	pop cx
	pop dx
	
	ret
	endp getMousePosition

proc simpleCollision
	
	push [playerX]
	push [playerY]
	call getBlock
	pop cx
	
	cmp cx, [grass]
	je TR ; Player is on grass
		mov [Wkey], 'F'
		mov [Akey], 'F'
		jmp noColl
TR:
	mov ax, [playerX]
	add ax, [COLLISION_WIDTH]
	push ax
	push [playerY]
	call getBlock
	pop cx
	cmp cx, [grass]
	je BR
		mov [Wkey], 'F'
		mov [Dkey], 'F'
		jmp noColl
BR:
	mov bx, [playerY]
	add bx, [COLLISION_HEIGHT]
	push ax
	push bx
	call getBlock
	pop cx
	cmp cx, [grass]
	je BLe
		mov [Skey], 'F'
		mov [Dkey], 'F'
		jmp noColl
BLe:
	push [playerX]
	push bx
	call getBlock
	pop cx
	cmp cx, [grass]
	je noColl
		mov [Skey], 'F'
		mov [Akey], 'F'
noColl:
	ret
	endp simpleCollision

	proc drawInventory ; Draws the inventory (Duh)
	push ax
	push dx
	push si
	push bx
	push cx
	
	EmptyColor equ 103 ; Color of empty spot
	SpotWidth equ 22
	NumOffset equ 9 ; Where the number (representing the amount) is in relation to the blocks
	
	mov ax, 122
	mov dx, 171
	mov si, offset inventory
	mov bx, offset invNum
	mov cx, 4
	
	FirstX equ ax
	FirstY equ dx
	InvArr equ si
	InvAmounts equ bx
	NumSpots equ cx
	
invBlocks:
	cmp [byte ptr InvArr], '*' ; If there is no block in spot, draw solid rectangle
	jne drawPlace
	
	push FirstX
	push FirstY
	push [DEFAULT_BLOCK_WIDTH]
	push [DEFAULT_BLOCK_WIDTH]
	push EmptyColor
	call fillRect
	jmp finLoop
	
drawPlace:
	push FirstX
	push FirstY
	push 0000h
	push 0000h
	push [DEFAULT_BLOCK_WIDTH]
	push [DEFAULT_BLOCK_WIDTH]
	push [InvArr]
	call drawBlock
	
	; Draw number representing how much of the block there is
	add FirstX, NumOffset
	add FirstY, NumOffset
	
	push FirstX
	push FirstY
	push [InvAmounts]
	call drawNumber
	
	sub FirstX, NumOffset
	sub FirstY, NumOffset
	; ---------
	
finLoop:
	add InvArr, 2
	inc InvAmounts
	add FirstX, SpotWidth
	loop invBlocks ; Move in arrays, add spot width to X, and loop
	
	push 120
	push 170
	push offset inv1
	push [invSize]
	call drawPicture ; Draw the actual inventory picture above blocks
	
	mov FirstX, 122
	mov FirstY, 171
	
	mov cx, 4
drawCurrent: ; Draw rectangle around current inventory place
	mov bx, 0005h
	sub bx, cx ; Get current block 1-4
	
	cmp bl, [Current]
	jne notCurrent
		push FirstX
		push FirstY
		push [DEFAULT_BLOCK_WIDTH]
		push [DEFAULT_BLOCK_WIDTH]
		push 40d
		call drawRect
notCurrent:
	add FirstX, SpotWidth
	loop drawCurrent
	
	pop ax
	pop dx
	pop si
	pop bx
	pop cx
	
	ret
	endp drawInventory
	
proc addToInventory ; Recieves an item and intuitively adds it to inventory
	push bp
	mov bp, sp
	
	push ax
	push bx
	
	Item equ [bp + 4]
	
	mov ax, Item
	mov bx, offset inventory
	
	cmp ax, [bx]
	jne secondSpot
	
	cmp [byte ptr offset InvNum], 99d
	jge firstClear
	
	mov [bx], ax
	inc [byte ptr offset invNum]
	jmp DontAdd
	
secondSpot:
	cmp ax, [bx + 2]
	jne thirdSpot
	
	cmp [byte ptr offset InvNum + 1], 99d
	jge firstClear
	
	mov [bx + 2], ax
	inc [byte ptr offset invNum + 1]
	jmp DontAdd
	
thirdSpot:
	cmp ax, [bx + 4]
	jne fourthSpot
	
	cmp [byte ptr offset InvNum + 2], 99d
	jge firstClear
	
	mov [bx + 4], ax
	inc [byte ptr offset invNum + 2]
	jmp DontAdd
	
fourthSpot:
	cmp ax, [bx + 6]
	jne firstClear
	
	cmp [byte ptr offset InvNum + 3], 99d
	jge firstClear
	
	mov [bx + 6], ax
	inc [byte ptr offset invNum + 3]
	jmp DontAdd
	
DontAddMid:
	jmp DontAdd
	
firstClear:
	cmp [byte ptr bx], '*'
	jne secondClear
	
	mov [bx], ax
	inc [byte ptr offset invNum]
	jmp DontAdd
	
secondClear:
	cmp [byte ptr bx + 2], '*'
	jne thirdClear
	
	mov [bx + 2], ax
	inc [byte ptr offset invNum + 1]
	jmp DontAdd
	
thirdClear:
	cmp [byte ptr bx + 4], '*'
	jne fourthClear
	
	mov [bx + 4], ax
	inc [byte ptr offset invNum + 2]
	jmp DontAdd
	
fourthClear:
	cmp [byte ptr bx + 6], '*'
	jne DontAdd
	
	mov [bx + 6], ax
	inc [byte ptr offset invNum + 3]
	
DontAdd:
	pop bx
	pop ax
	
	pop bp
	ret 2
	endp addToInventory
	
	proc removeFromInventory ; Proc removes a block from specified location in inventory
	push bp
	mov bp, sp
	
	push bx
	push si
	
	Location equ [bp + 4]
	
	mov bx, Location
	dec bx ; Index starts from 0
	
	mov si, bx
	shl si, 1
	
	cmp [byte ptr offset inventory + si], '*' ; If block is present
	je DontRemove
	
	dec [byte ptr offset invNum + bx] 
	jnz DontRemove ; If block count zeroed
	
	mov [byte ptr offset inventory + si], '*' ;Remove block
	
DontRemove:
	pop si
	pop bx
	
	pop bp
	ret 2
	endp removeFromInventory
	
	proc drawSingleNumber ; Get x, y and number, print the number in those coords
	push bp
	mov bp, sp
	
	push ax
	
	X equ [bp + 8]
	Y equ [bp + 6]
	Num equ [byte ptr bp + 4]
	
	FirstOff equ offset zero1
	NumberSize equ [numSiz]
	
	mov ax, NumberSize
	mul Num
	add ax, FirstOff ; AX = FirstOffset +  Num * NumberSize
	
	push X
	push Y
	push ax
	push NumberSize
	call drawPicture
	
	pop ax
	
	pop bp
	ret 6
	endp drawSingleNumber
	
	proc drawNumber ; Recieves x, y and number (up to two digits) and prints it
	push bp
	mov bp, sp
	
	push ax
	push bx
	
	X equ [bp + 8]
	Y equ [bp + 6]
	Num equ [byte ptr bp + 4]
	
	NumWidth equ 0004h ; Width of number texture
	Space equ 0001h ; Space between numbers
	
	mov bl, 10d
	mov al, Num
	xor ah, ah
	div bl
	
	mov bl, al
	xor bh, bh ; Needs to be word to push
	
	mov al, ah
	xor ah, ah ; Needs to be word to push
	
	
	Tens equ bx ; Quotient represents tens
	Ones equ ax ; Remainder represents ones
	
	cmp Tens, 0
	je DrawOnes ; If the number has one digit, don't draw tens
	
	push X
	push Y
	push Tens
	call drawSingleNumber

DrawOnes:	
	mov bx, X ; Not using tens anymore
	
	add bx, NumWidth
	add bx, Space ; Get new X to draw ones
	
	push bx
	push Y
	push Ones
	call drawSingleNumber
	
	pop bx
	pop ax
	
	pop bp
	ret 6
	endp drawNumber
	
	proc inventoryLogic ; Red rectangle logic
	
	; onPress logic
	cmp [RightKey], 'T'
	jne RightNotPressed
		cmp [LastRight], 'T'
		je RightNotPressed
			mov [RightOnPress], 'T'
			jmp leftCheck
RightNotPressed:
	mov [RightOnPress], 'F'
leftCheck:
	cmp [LeftKey], 'T'
	jne LeftNotPressed
		cmp [LastLeft], 'T'
		je LeftNotPressed
			mov [LeftOnPress], 'T'
			jmp left
LeftNotPressed:
	mov [LeftOnPress], 'F'
	
	;inventoryLogic
right:
	cmp [RightOnPress], 'T'
	jne left
		inc [Current]
left:
	cmp [LeftOnPress], 'T'
	jne checkValues
		dec [Current]
checkValues:
	
	cmp [Current], 1
	jge checkFour
		mov [Current], 4
checkFour:
	cmp [Current], 4
	jle finishLogic
		mov [Current], 1
finishLogic:
	push ax
	mov al, [RightKey]
	mov [LastRight], al
	mov al, [LeftKey]
	mov [LastLeft], al
	pop ax
	ret
	endp inventoryLogic
	
	proc playerActions ; Handles player actions such as placing/removing blocks.
	
	cmp [MouseLeft], 'T' ; Block mining logic
	jne LeftNotClicked
		push [MouseX]
		push [MouseY]
		call getBlock
		pop ax
		cmp ax, [grass]
		je LeftNotClicked
		cmp ax, [bedrock]
		je LeftNotClicked
		cmp ax, [tree]
		jne normal
			
			push [treeBlock]
			call addToInventory
			
			push [treeBlock]
			call addToInventory
			
			jmp remove
	normal:
		push ax
		call addToInventory ; Add to inventory
		
	remove:
		push [MouseX]
		push [MouseY]
		push [grass]
		call setBlock ; Remove from world
		
		
LeftNotClicked:
	
	cmp [MouseRight], 'T' ; Block placing logic
	jne RightNotClicked
		push [MouseX]
		push [MouseY]
		call getBlock
		pop bx
		cmp bx, [grass]
		jne RightNotClicked ; Don't allow placing blocks on top of other blocks
		
		
		xor bx, bx
		mov bl, [Current]
		dec bl
		shl bx, 1 ; Normalize
		
		cmp [byte ptr offset inventory + bx], '*' ; If space is empty
		je RightNotClicked
		push [MouseX]
		push [MouseY]
		push [offset inventory + bx]
		call setBlock ; Place block in world
		
		xor bx, bx
		mov bl, [Current]
		dec bl                    ; Remove from inventory
		dec [byte ptr offset InvNum + bx]
		jnz RightNotClicked
			shl bx, 1
			mov [byte ptr offset inventory + bx], '*'
		
RightNotClicked:
	ret
	endp playerActions
	
;------------------------------------------------- BUFFER PROCEDURES ----------------------------------- ;

proc clearBuffer
	push ds
	push si
	push cx
	push ax
	push bx
	
	mov bx, bufferSeg
	mov ds, bx
	xor si,si
	
	mov cx, 64000
ClearLoop:
	mov ax, [ds:si]
	xor [ds:si], ax
	inc si
	loop ClearLoop
	
	pop bx
	pop ax
	pop cx
	pop si
	pop ds
	
	ret
	endp clearBuffer

proc drawPixel
	push bp
	mov bp, sp
	
	push ax
	push bx
	push dx
	push di
	
	X equ [bp + 8]
	Y equ [bp + 6]
	Color equ [bp + 4]
	
	mov ax, Y
	mov dx,320
	mul dx               ;ax = y * 320
	mov di, X            ;di = x
	add di,ax            ;di = y * 320 + x
	mov bx, bufferSeg    ;bx = segment of video buffer
	mov es,bx            ;es:di = address of pixel
	mov al, Color        ;al = colour
	mov [es:di],al       ;Store colour in buffer at (x,y)
	
	pop di
	pop dx
	pop bx
	pop ax
	
	pop bp
	ret 6
	endp drawPixel
	
	proc printBuffer
	
	push bx
	push cx
	push ds
	push si
	push di
	
	mov bx, bufferSeg
	mov ds, bx             ;ds = segment for buffer
	xor si,si              ;ds:si = address for buffer
	mov ax, 0A000h         ;ax = segment for display memory
	mov es,ax  			   ;es = segment for display memeory
	xor di, di             ;es:di = address for display memory
	mov cx,32000           ;cx = number of words to copy
	cld                    ;Make sure direction flag is clear
	rep movsw              ;Copy 320*200/2 words from buffer to display memory
	
	pop di
	pop si
	pop ds
	pop cx
	pop bx
	
	ret
	endp printBuffer
	
; --------------------------------------------- END OF GAME PROCEDURES --------------------------------- ;


;-------------------------------------------------- MENU PROCEDURES ------------------------------------ ;

include 'bitmap.asm'
	
	proc printBMP
	push bp
	mov bp, sp
	
	OffsetImage equ [bp+4]
	
	push OffsetImage
	call OpenFile
	call ReadHeader
	call ReadPalette
	;call CopyPal
	call CopyBitmap
	
	pop bp
	ret 2
	endp printBMP
	
	proc mainButtons
	push ax
	push bx
	
	mov ax, [MouseScreenX]
	mov bx, [MouseScreenY]
	
	cmp ax, [offset playbutton]
	jl notOnPlay
	
	cmp ax, [offset playbutton + 4]
	jg notOnPlay
	
	cmp bx, [offset playbutton + 2]
	jl notOnPlay
	
	cmp bx, [offset playbutton + 6]
	jg notOnPlay
	; IF ON PLAY
		push mainPlayNum
		call newBMP
		
		cmp [MouseLeft], 'T'
		jne Fin2
		
			mov [gameStatus], 1
			jmp Fin2
		
notOnPlay:
	cmp ax, [offset helpbutton]
	jl notOnHelp
	
	cmp ax, [offset helpbutton + 4]
	jg notOnHelp
	
	cmp bx, [offset helpbutton + 2]
	jl notOnHelp
	
	cmp bx, [offset helpbutton + 6]
	jg notOnHelp
	; IF ON HELP
		push mainHelpNum
		call newBMP
		
		cmp [MouseLeft], 'T'
		jne Fin2
		
			mov [gameStatus], 2
			jmp Fin2
		
notOnHelp:
	cmp ax, [offset exitbutton]
	jl notOnExit
	
	cmp ax, [offset exitbutton + 4]
	jg notOnExit
	
	cmp bx, [offset exitbutton + 2]
	jl notOnExit
	
	cmp bx, [offset exitbutton + 6]
	jg notOnExit
	; IF ON EXIT
		push mainExitNum
		call newBMP
		
		cmp [MouseLeft], 'T'
		jne Fin2
		
			mov [gameStatus], 3
			jmp Fin2
		
notOnExit:
	push mainNum
	call newBMP
	
Fin2:
	pop bx
	pop ax
	
	ret
	endp mainButtons
	
	proc helpButtons
	
	mov ax, [MouseScreenX]
	mov bx, [MouseScreenY]
	
	cmp ax, [offset returnbutton]
	jl notOnReturn
	
	cmp ax, [offset returnbutton + 4]
	jg notOnReturn
	
	cmp bx, [offset returnbutton + 2]
	jl notOnReturn
	
	cmp bx, [offset returnbutton + 6]
	jg notOnReturn
	; IF ON RETURN
		push HelpReturnNum
		call newBMP
		
		cmp [MouseLeft], 'T'
		jne Fin3
		
			mov [gameStatus], 0
			jmp Fin3
notOnReturn:
	push helpMainNum
	call newBMP
Fin3:
	ret
	endp helpButtons
	
	proc exitButtons
	push ax
	push bx
	
	mov ax, [MouseScreenX]
	mov bx, [MouseScreenY]
	
	cmp ax, [offset yesbutton]
	jl notOnYes
	
	cmp ax, [offset yesbutton + 4]
	jg notOnYes
	
	cmp bx, [offset yesbutton + 2]
	jl notOnYes
	
	cmp bx, [offset yesbutton + 6]
	jg notOnYes
	; IF ON YES
		push exitYesNum
		call newBMP
		
		cmp [MouseLeft], 'T'
		jne Fin4
		
			mov [gameStatus], 4
			jmp Fin4
		
notOnYes:
	cmp ax, [offset nobutton]
	jl notOnNo
	
	cmp ax, [offset nobutton + 4]
	jg notOnNo
	
	cmp bx, [offset nobutton + 2]
	jl notOnNo
	
	cmp bx, [offset nobutton + 6]
	jg notOnNo
	; IF ON NO
		push exitNoNum
		call newBMP
		
		cmp [MouseLeft], 'T'
		jne Fin4
		
			mov [gameStatus], 0
			jmp Fin4
		
notOnNo:
	push exitMainNum
	call newBMP
Fin4:
	pop bx
	pop ax
	
	ret
	endp exitButtons
	
	proc newBMP
	push bp
	mov bp, sp
	
	push ax
	push bx
	
	mov bl, [byte ptr bp + 4]
	BMP equ bl
	
	xor ax, ax
	mov al, [currentBMP]
	
	mov [currentBMP], BMP ; Move desired bmp to current
	
	cmp al, BMP ; Compare current to last
	je Mid2
	
	cmp BMP, mainNum ; Compare recieved number to image numbers and print images
	jne c2
		push offset main
		jmp callBMP
c2:
	cmp BMP, mainPlayNum
	jne c3
		push offset main_play
		jmp callBMP
c3:
	cmp BMP,mainHelpNum
	jne c4
		push offset main_help
		jmp callBMP
c4:
	cmp BMP, mainExitNum
	jne c5
		push offset main_exit
		jmp callBMP
Mid2:
	jmp dontChange
c5:
	cmp BMP, helpMainNum
	jne c6
		push offset help_main
		jmp callBMP
c6:
	cmp BMP, helpReturnNum
	jne c7
		push offset help_return
		jmp callBMP
c7:
	cmp BMP, exitMainNum
	jne c8
		push offset exit_main
		jmp callBMP
c8:
	cmp BMP, exitYesNum
	jne c9
		push offset exit_yes
		jmp callBMP
c9:
	cmp BMP, exitNoNum
	jne dontChange
		push offset exit_no
		jmp callBMP
		
callBMP:
	call closeFile
	call printBMP
dontChange:
	pop bx
	pop ax
	
	pop bp
	ret 2
	endp newBMP

	
start:
	mov ax, @data
	mov ds, ax
	
menuInit:
; MENU CODE
	call graphicsMode
	
	push offset main ; Print first image
	call OpenFile
	call ReadHeader
	call ReadPalette
	call CopyPal
	call CopyBitmap
	
	call startMouse

	MenuLoop:
	call getMousePosition
	call getLeftMouseButton
	
	cmp [gameStatus], 0 ; Check all game modes and perform appropriate actions
	jne notMain
		call mainButtons
notMain:
	cmp [gameStatus], 1
	jne notGame
		jmp gameInit
notGame:
	cmp [gameStatus], 2
	jne notHelp
		call helpButtons
notHelp:
	cmp [gameStatus], 3
	jne notExit
		call exitButtons
notExit:
	cmp [gameStatus], 4
	jne NotOnLeave
		jmp exit
NotOnLeave:
	jmp MenuLoop
	
	
	
; GAME CODE	

gameInit:
	; GAME INIT
	call graphicsMode
	
	call clearBuffer
	
	call startMouse
	
gameLoop:
;|||||||  

	; TICK
	call getKeys
	
	call inventoryLogic
	
	call getLeftMouseButton
	call getMousePosition
	
	call simpleCollision
	
	call movePlayer
	call calcCoords
	
	call playerActions
	
	cmp [EscKey], 'T' ; Check escape key
	jne ContinuePlaying
		mov [gameStatus], 0
		mov [EscKey], 'F'
		jmp menuInit
ContinuePlaying:
	
	; RENDER
	
	call drawWorlds
	
	call drawPlayer
	
	call drawInventory
	
	
	call printBuffer
;|||||||
	jmp gameLoop
	
exit:
	call textMode
	mov ax, 4c00h
	int 21h
END start

