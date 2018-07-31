   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.11.5 - 29 Dec 2015
   3                     ; Generator (Limited) V4.4.4 - 27 Jan 2016
  89                     ; 26 void FIFO_Clear(FIFO *Queue)
  89                     ; 27 {
  91                     	switch	.text
  92  0000               _FIFO_Clear:
  96                     ; 28 	Queue->Head = Queue->Tail = 0;
  98  0000 6f02          	clr	(2,x)
  99  0002 6f01          	clr	(1,x)
 100                     ; 29 }
 103  0004 81            	ret
 140                     ; 31 uint8_t FIFO_WriteAvail(FIFO *Queue)
 140                     ; 32 {
 141                     	switch	.text
 142  0005               _FIFO_WriteAvail:
 144  0005 89            	pushw	x
 145  0006 89            	pushw	x
 146       00000002      OFST:	set	2
 149                     ; 33   return(FIFO_INC(Queue->Head,Queue->SizeMask)!=Queue->Tail);
 151  0007 f6            	ld	a,(x)
 152  0008 5f            	clrw	x
 153  0009 97            	ld	xl,a
 154  000a 1f01          	ldw	(OFST-1,sp),x
 156  000c 1e03          	ldw	x,(OFST+1,sp)
 157  000e e601          	ld	a,(1,x)
 158  0010 5f            	clrw	x
 159  0011 97            	ld	xl,a
 160  0012 5c            	incw	x
 161  0013 01            	rrwa	x,a
 162  0014 1402          	and	a,(OFST+0,sp)
 163  0016 01            	rrwa	x,a
 164  0017 1401          	and	a,(OFST-1,sp)
 165  0019 01            	rrwa	x,a
 166  001a 1603          	ldw	y,(OFST+1,sp)
 167  001c 90e602        	ld	a,(2,y)
 168  001f 905f          	clrw	y
 169  0021 9097          	ld	yl,a
 170  0023 90bf00        	ldw	c_y,y
 171  0026 b300          	cpw	x,c_y
 172  0028 2704          	jreq	L01
 173  002a a601          	ld	a,#1
 174  002c 2001          	jra	L21
 175  002e               L01:
 176  002e 4f            	clr	a
 177  002f               L21:
 180  002f 5b04          	addw	sp,#4
 181  0031 81            	ret
 228                     ; 36 uint8_t FIFO_Write(FIFO *Queue, FIFO_Data_t data)
 228                     ; 37 {
 229                     	switch	.text
 230  0032               _FIFO_Write:
 232  0032 89            	pushw	x
 233       00000000      OFST:	set	0
 236                     ; 38 	if(FIFO_WriteAvail(Queue))
 238  0033 add0          	call	_FIFO_WriteAvail
 240  0035 4d            	tnz	a
 241  0036 271d          	jreq	L311
 242                     ; 40 		Queue->Head = FIFO_INC(Queue->Head,Queue->SizeMask);
 244  0038 1e01          	ldw	x,(OFST+1,sp)
 245  003a e601          	ld	a,(1,x)
 246  003c 4c            	inc	a
 247  003d 1e01          	ldw	x,(OFST+1,sp)
 248  003f f4            	and	a,(x)
 249  0040 1e01          	ldw	x,(OFST+1,sp)
 250  0042 e701          	ld	(1,x),a
 251                     ; 41 		FIFO_BUF(Queue)[Queue->Head] = data;
 253  0044 1e01          	ldw	x,(OFST+1,sp)
 254  0046 e601          	ld	a,(1,x)
 255  0048 5f            	clrw	x
 256  0049 97            	ld	xl,a
 257  004a 72fb01        	addw	x,(OFST+1,sp)
 258  004d 7b05          	ld	a,(OFST+5,sp)
 259  004f e703          	ld	(3,x),a
 260                     ; 42 		return 1;	
 262  0051 a601          	ld	a,#1
 264  0053 2001          	jra	L61
 265  0055               L311:
 266                     ; 44 	return 0;
 268  0055 4f            	clr	a
 270  0056               L61:
 272  0056 85            	popw	x
 273  0057 81            	ret
 310                     ; 47 uint8_t FIFO_ReadAvail(FIFO *Queue)
 310                     ; 48 {
 311                     	switch	.text
 312  0058               _FIFO_ReadAvail:
 314  0058 89            	pushw	x
 315       00000000      OFST:	set	0
 318                     ; 49 	return(Queue->Head != Queue->Tail);
 320  0059 e601          	ld	a,(1,x)
 321  005b 1e01          	ldw	x,(OFST+1,sp)
 322  005d e102          	cp	a,(2,x)
 323  005f 2704          	jreq	L22
 324  0061 a601          	ld	a,#1
 325  0063 2001          	jra	L42
 326  0065               L22:
 327  0065 4f            	clr	a
 328  0066               L42:
 331  0066 85            	popw	x
 332  0067 81            	ret
 380                     ; 52 uint8_t FIFO_Read(FIFO *Queue, FIFO_Data_t *data)
 380                     ; 53 {
 381                     	switch	.text
 382  0068               _FIFO_Read:
 384  0068 89            	pushw	x
 385       00000000      OFST:	set	0
 388                     ; 54 	if (FIFO_ReadAvail(Queue))
 390  0069 aded          	call	_FIFO_ReadAvail
 392  006b 4d            	tnz	a
 393  006c 271e          	jreq	L161
 394                     ; 56 		Queue->Tail = FIFO_INC(Queue->Tail,Queue->SizeMask);	
 396  006e 1e01          	ldw	x,(OFST+1,sp)
 397  0070 e602          	ld	a,(2,x)
 398  0072 4c            	inc	a
 399  0073 1e01          	ldw	x,(OFST+1,sp)
 400  0075 f4            	and	a,(x)
 401  0076 1e01          	ldw	x,(OFST+1,sp)
 402  0078 e702          	ld	(2,x),a
 403                     ; 57 		*data = FIFO_BUF(Queue)[Queue->Tail];
 405  007a 1e01          	ldw	x,(OFST+1,sp)
 406  007c e602          	ld	a,(2,x)
 407  007e 5f            	clrw	x
 408  007f 97            	ld	xl,a
 409  0080 72fb01        	addw	x,(OFST+1,sp)
 410  0083 e603          	ld	a,(3,x)
 411  0085 1e05          	ldw	x,(OFST+5,sp)
 412  0087 f7            	ld	(x),a
 413                     ; 58 		return 1;
 415  0088 a601          	ld	a,#1
 417  008a 2001          	jra	L03
 418  008c               L161:
 419                     ; 60 	return 0;	
 421  008c 4f            	clr	a
 423  008d               L03:
 425  008d 85            	popw	x
 426  008e 81            	ret
 473                     ; 63 uint8_t Getc(FIFO *Queue)
 473                     ; 64 {
 474                     	switch	.text
 475  008f               _Getc:
 477  008f 89            	pushw	x
 478  0090 88            	push	a
 479       00000001      OFST:	set	1
 482  0091               L112:
 483                     ; 67 	while(!FIFO_Read(Queue,&ch))
 485  0091 96            	ldw	x,sp
 486  0092 1c0001        	addw	x,#OFST+0
 487  0095 89            	pushw	x
 488  0096 1e04          	ldw	x,(OFST+3,sp)
 489  0098 adce          	call	_FIFO_Read
 491  009a 85            	popw	x
 492  009b 4d            	tnz	a
 493  009c 27f3          	jreq	L112
 494                     ; 70 	return ch;
 496  009e 7b01          	ld	a,(OFST+0,sp)
 499  00a0 5b03          	addw	sp,#3
 500  00a2 81            	ret
 513                     	xdef	_Getc
 514                     	xdef	_FIFO_ReadAvail
 515                     	xdef	_FIFO_Read
 516                     	xdef	_FIFO_WriteAvail
 517                     	xdef	_FIFO_Write
 518                     	xdef	_FIFO_Clear
 519                     	xref.b	c_y
 538                     	end
