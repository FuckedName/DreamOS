%include "pm.inc"

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

	; 清屏
	mov	ax, 0600h		; AH = 6,  AL = 0h
	mov	bx, 0700h		; 黑底白字(BL = 07h)
	mov	cx, 0			; 左上角: (0, 0)
	mov	dx, 0184fh		; 右下角: (80, 50)
	int	10h			; int 10h

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
	MOV	BYTE [0xe0000000+EAX+EDX*1],12
	INC	EAX
	CMP	EAX,1024
	JLE	L34
	INC	ECX
	ADD	EDX,1024
	CMP	ECX,768
	JLE	L35
L36:
	JMP	L36

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

times 	510-($-$$)	db	0	; 填充剩下的空间，使生成的二进制代码恰好为512字节
dw 	0xaa55				; 结束标志
