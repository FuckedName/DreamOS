	org  07c00h			; Boot 状态, Bios 将把 Boot Sector 加载到 0:7C00 处并开始执行

BaseOfStack		equ	0100h	; 调试状态下堆栈基地址(栈底, 从这个位置向低地址生长)

	jmp short LABEL_START		; Start to boot.
	nop				; 这个 nop 不可少

LABEL_START:	
	mov	ax, cs
	mov	ds, ax
	mov	es, ax
	mov	ss, ax
	mov	sp, BaseOfStack

	mov	bx, 4105h		
	mov	ax, 4f02h		;
	int	10h			; 
	mov	ah, 02h		;
	int	10h			; 

	LEDS    EQU        0x0ff1
	mov [LEDS], al
	mov	al,	0ffh
	out	21h,	AL
	nop
	out	0a1h,	AL

	cli

	CALL	waitkbdout
	MOV	AL,	0d1h
	OUT	064h,	AL
	CALL	waitkbdout
	MOV	AL,	0dfh
	OUT	060h,	AL
	CALL	waitkbdout

	;protect mode
	LGDT	[GDTR0]
	MOV	EAX,CR0
	AND	EAX,0x7fffffff
	OR	EAX,0x00000001
	MOV	CR0,EAX
	MOV	AX,	1*8
	MOV	DS,	AX
	MOV	DS,AX
	MOV	ES,AX
	MOV	FS,AX
	MOV	GS,AX
	MOV	SS,AX
	XOR	ECX,ECX
	XOR	EDX,EDX
L35:
	XOR	EAX,EAX
L34:
	MOV	BYTE [0xe0000000 + EAX + EDX], 11
	INC	EAX
	CMP	EAX, 1024
	JLE	L34
	INC	ECX
	ADD	EDX, 1024
	CMP	ECX, 168
	JLE	L35
L36:
	JMP	L36
	hlt

;read disk
	mov ax, 0820h
	mov es, ax
	mov ch, 0
	mov dh, 0
	mov cl, 2

readloop:
	mov si, 0

retry:
	mov ah, 02h
	mov al, 01h
	mov bx, 0
	mov dl, 0h
	int 013h
	jnc next
	add si, 1
	cmp si, 5
	jae error
	mov ah, 0h
	mov dl, 0h
	int 013h
	jmp retry

next:
	mov ax, es
	add ax, 020h
	mov es, ax
	add cl, 1
	cmp cl, 18
	jbe readloop
	mov cl, 1
	add dh, 1
	cmp dh, 2
	jb  readloop
	mov dh, 0
	add ch, 1
	cmp ch, 80 ; zhumian count
	jb  readloop

	mov [0ff0h], ch
	jmp 0c200h ; 0x8000+0x4200=0xc200

error:
	mov si, msg

waitkbdout:
	IN	AL,	064h
	AND	AL,	002h
	JNZ	waitkbdout
	RET

GDT0:
	RESB	8
	DW	0xffff,0x0000,0x9200,0x00cf
	DW	0xffff,0x0000,0x9a28,0x0047
	DW	0

GDTR0:
        DW        8*3-1
        DD        GDT0

msg:
	db 00ah, 00ah
	db "load error"
	db 00ah
	db 0

times 	510-($-$$)	db	0	; 填充剩下的空间，使生成的二进制代码恰好为512字节
dw 	0xaa55				; 结束标志
