   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.11.5 - 29 Dec 2015
   3                     ; Generator (Limited) V4.4.4 - 27 Jan 2016
  47                     ; 8 void Init_Hardware(void)
  47                     ; 9 {
  49                     	switch	.text
  50  0000               _Init_Hardware:
  54                     ; 10 	CLK->CKDIVR = 0;									// Clk divider, CPU divider = 1
  56  0000 725f50c6      	clr	20678
  57                     ; 11 	EXTI->CR1 = 0x02 << 2;						// PB2 Interrupt: Falling edge
  59  0004 350850a0      	mov	20640,#8
  60                     ; 12 	PS2_PORT->CR2 = PS2_CLK;					// Enable PS2_CLK interrupt
  62  0008 35105009      	mov	20489,#16
  63                     ; 15 	GPIOA->CR1 = GPIOA->DDR = PA1|PA2|PA3;
  65  000c 350e5002      	mov	20482,#14
  66  0010 5550025003    	mov	20483,20482
  67                     ; 16 	GPIOC->CR1 = GPIOC->DDR = PC3|PC4|PC5|PC6|PC7;
  69  0015 35f8500c      	mov	20492,#248
  70  0019 55500c500d    	mov	20493,20492
  71                     ; 17 	GPIOD->CR1 = GPIOD->DDR = PD1|PD2|PD3|PD4;
  73  001e 351e5011      	mov	20497,#30
  74  0022 5550115012    	mov	20498,20497
  75                     ; 20 	TIM4->CR1 = TIM4_CR1_ARPE|TIM4_CR1_URS|TIM4_CR1_CEN;
  77  0027 35855340      	mov	21312,#133
  78                     ; 22 	TIM4->IER = TIM4_IER_UIE;					// Update IRQ enable
  80  002b 35015343      	mov	21315,#1
  81                     ; 23 	TIM4->PSCR = TIM4_PSCR;						// TIM4: 16MHz/2^TIM4_PSCR
  83  002f 35035347      	mov	21319,#3
  84                     ; 24 	TIM4->ARR = TIM4_ARR;							// Auto-reload
  86  0033 35c85348      	mov	21320,#200
  87                     ; 27 	ITC->ISPR2 = 0x03;
  89  0037 35037f71      	mov	32625,#3
  90                     ; 29 	ITC->ISPR1 = ITC->ISPR3 = ITC->ISPR4 = ITC->ISPR5 = ITC->ISPR6 = 0x00;
  92  003b 725f7f75      	clr	32629
  93  003f 725f7f74      	clr	32628
  94  0043 725f7f73      	clr	32627
  95  0047 725f7f72      	clr	32626
  96  004b 725f7f70      	clr	32624
  97                     ; 31 	Init_Serial();
  99  004f cd0185        	call	_Init_Serial
 101                     ; 33 	PS2.State = PS2_Idle;
 103  0052 3f07          	clr	_PS2+2
 104                     ; 35 	Hotkeys.State = HK_Idle;
 106  0054 3f03          	clr	_Hotkeys
 107                     ; 36 	Hotkeys.KeyAttr = 0;
 109  0056 3f04          	clr	_Hotkeys+1
 110                     ; 38 	rim();
 113  0058 9a            rim
 115                     ; 39 }
 119  0059 81            	ret
 145                     ; 42 @far @interrupt void TIM4_IRQ(void)
 145                     ; 43 {
 147                     	switch	.text
 148  005a               f_TIM4_IRQ:
 152                     ; 44 	TIM4->SR1 &= ~TIM4_SR1_UIF;				// Clear update IRQ
 154  005a 72115344      	bres	21316,#0
 155                     ; 46 	if(Micro_Timer1)
 157  005e 3d02          	tnz	_Micro_Timer1
 158  0060 2702          	jreq	L13
 159                     ; 47 		Micro_Timer1--;
 161  0062 3a02          	dec	_Micro_Timer1
 162  0064               L13:
 163                     ; 49 	if(Milli_Divider)
 165  0064 3d00          	tnz	_Milli_Divider
 166  0066 2704          	jreq	L33
 167                     ; 50 		Milli_Divider--;
 169  0068 3a00          	dec	_Milli_Divider
 171  006a 200a          	jra	L53
 172  006c               L33:
 173                     ; 53 		if(Milli_Timer1)
 175  006c 3d01          	tnz	_Milli_Timer1
 176  006e 2702          	jreq	L73
 177                     ; 54 			Milli_Timer1--;			
 179  0070 3a01          	dec	_Milli_Timer1
 180  0072               L73:
 181                     ; 56 		Milli_Divider = MILLI_DIVIDER_RELOAD;
 183  0072 35640000      	mov	_Milli_Divider,#100
 184  0076               L53:
 185                     ; 58 }
 188  0076 80            	iret
 212                     ; 60 @far @interrupt void PORTB_IRQ(void)
 212                     ; 61 {		
 213                     	switch	.text
 214  0077               f_PORTB_IRQ:
 218                     ; 62 	if((PS2.State == PS2_Idle)||(!Micro_Timer1))	// Start bit or resynchronized
 220  0077 3d07          	tnz	_PS2+2
 221  0079 2704          	jreq	L35
 223  007b 3d02          	tnz	_Micro_Timer1
 224  007d 2614          	jrne	L15
 225  007f               L35:
 226                     ; 65 		Micro_Timer1 = us_TO_TICKS(PS2_BIT_TIMEOUT);
 228  007f 350f0002      	mov	_Micro_Timer1,#15
 229                     ; 67 		PS2.State = (PS2_PORT->IDR & PS2_DATA)?PS2_CMD_1:PS2_KBD_1;
 231  0083 c65006        	ld	a,20486
 232  0086 a520          	bcp	a,#32
 233  0088 2704          	jreq	L21
 234  008a a601          	ld	a,#1
 235  008c 2002          	jra	L41
 236  008e               L21:
 237  008e a641          	ld	a,#65
 238  0090               L41:
 239  0090 b707          	ld	_PS2+2,a
 241  0092               L55:
 242                     ; 90 }
 245  0092 80            	iret
 246  0093               L15:
 247                     ; 71 		if(PS2.State++ & PS2_KBD)											// Scan/respond code
 249  0093 b607          	ld	a,_PS2+2
 250  0095 3c07          	inc	_PS2+2
 251  0097 5f            	clrw	x
 252  0098 a540          	bcp	a,#64
 253  009a 2727          	jreq	L75
 254                     ; 73 			if(PS2.State == PS2_KBD_LAST)
 256  009c b607          	ld	a,_PS2+2
 257  009e a14b          	cp	a,#75
 258  00a0 2608          	jrne	L16
 259                     ; 75 				PS2.Avail = 1;
 261  00a2 35010009      	mov	_PS2+4,#1
 262                     ; 76 				PS2.State = PS2_Idle;
 264  00a6 3f07          	clr	_PS2+2
 266  00a8 20e8          	jra	L55
 267  00aa               L16:
 268                     ; 80 				PS2.ScanCode >>= 1;
 270  00aa be05          	ldw	x,_PS2
 271  00ac 54            	srlw	x
 272  00ad bf05          	ldw	_PS2,x
 273                     ; 82 				if(PS2_PORT->IDR & PS2_DATA)
 275  00af c65006        	ld	a,20486
 276  00b2 a520          	bcp	a,#32
 277  00b4 27dc          	jreq	L55
 278                     ; 83 					PS2.ScanCode |= 0x200;
 280  00b6 be05          	ldw	x,_PS2
 281  00b8 01            	rrwa	x,a
 282  00b9 aa00          	or	a,#0
 283  00bb 01            	rrwa	x,a
 284  00bc aa02          	or	a,#2
 285  00be 01            	rrwa	x,a
 286  00bf bf05          	ldw	_PS2,x
 287  00c1 20cf          	jra	L55
 288  00c3               L75:
 289                     ; 87 			if(PS2.State == PS2_CMD_LAST)
 291  00c3 b607          	ld	a,_PS2+2
 292  00c5 a10c          	cp	a,#12
 293  00c7 26c9          	jrne	L55
 294                     ; 88 				PS2.State = PS2_Idle;
 296  00c9 3f07          	clr	_PS2+2
 297  00cb 20c5          	jra	L55
 346                     ; 93 void PS2_Task(void)
 346                     ; 94 {
 348                     	switch	.text
 349  00cd               _PS2_Task:
 351  00cd 5204          	subw	sp,#4
 352       00000004      OFST:	set	4
 355                     ; 97 	if(PS2.Avail)
 357  00cf 3d09          	tnz	_PS2+4
 358  00d1 2603          	jrne	L22
 359  00d3 cc0183        	jp	L521
 360  00d6               L22:
 361                     ; 100 		sim();
 364  00d6 9b            sim
 366                     ; 101 		ScanCode = PS2.ScanCode;
 369  00d7 be05          	ldw	x,_PS2
 370  00d9 1f03          	ldw	(OFST-1,sp),x
 372                     ; 102 		PS2.Avail = 0;
 374  00db 3f09          	clr	_PS2+4
 375                     ; 103 		rim();
 378  00dd 9a            rim
 380                     ; 105 		Parity = PS2.ScanCode & 0x01;	
 383  00de b605          	ld	a,_PS2
 384  00e0 97            	ld	xl,a
 385  00e1 b606          	ld	a,_PS2+1
 386  00e3 a401          	and	a,#1
 387  00e5 5f            	clrw	x
 388                     ; 106 		ScanCode = (ScanCode >> 1) & 0xff;
 390  00e6 1e03          	ldw	x,(OFST-1,sp)
 391  00e8 54            	srlw	x
 392  00e9 01            	rrwa	x,a
 393  00ea a4ff          	and	a,#255
 394  00ec 5f            	clrw	x
 395  00ed 02            	rlwa	x,a
 396  00ee 1f03          	ldw	(OFST-1,sp),x
 397  00f0 01            	rrwa	x,a
 399                     ; 108 		if (ScanCode == PS2_KBD_CODE_RELEASE)
 401  00f1 1e03          	ldw	x,(OFST-1,sp)
 402  00f3 a300f0        	cpw	x,#240
 403  00f6 2607          	jrne	L721
 404                     ; 109 			Hotkeys.KeyAttr |= Key_Release;
 406  00f8 72100004      	bset	_Hotkeys+1,#0
 408  00fc cc0183        	jra	L521
 409  00ff               L721:
 410                     ; 110 		else if (ScanCode == PS2_KBD_CODE_EXTENDED)
 412  00ff 1e03          	ldw	x,(OFST-1,sp)
 413  0101 a300e0        	cpw	x,#224
 414  0104 2606          	jrne	L331
 415                     ; 111 			Hotkeys.KeyAttr |= Key_Extend;
 417  0106 72120004      	bset	_Hotkeys+1,#1
 419  010a 2077          	jra	L521
 420  010c               L331:
 421                     ; 114 			switch(Hotkeys.State)
 423  010c b603          	ld	a,_Hotkeys
 425                     ; 150 					break;	
 426  010e 4d            	tnz	a
 427  010f 270b          	jreq	L37
 428  0111 4a            	dec	a
 429  0112 271d          	jreq	L57
 430  0114 4a            	dec	a
 431  0115 2738          	jreq	L77
 432  0117 4a            	dec	a
 433  0118 274e          	jreq	L101
 434  011a 2063          	jra	L141
 435  011c               L37:
 436                     ; 116 				case HK_Idle:
 436                     ; 117 				  if((ScanCode == HOTKEY_SCANCODE) && !Hotkeys.KeyAttr)
 438  011c 1e03          	ldw	x,(OFST-1,sp)
 439  011e a30014        	cpw	x,#20
 440  0121 265c          	jrne	L141
 442  0123 3d04          	tnz	_Hotkeys+1
 443  0125 2658          	jrne	L141
 444                     ; 119 						Hotkeys.State = HK_KeyMake_1;
 446  0127 35010003      	mov	_Hotkeys,#1
 447                     ; 120 						Milli_Timer1 = HOTKEY_RELEASE_DELAY;
 449  012b 35190001      	mov	_Milli_Timer1,#25
 450                     ; 121 						return;
 452  012f 201b          	jra	L02
 453  0131               L57:
 454                     ; 125 				case HK_KeyMake_1:
 454                     ; 126 				  if((ScanCode == HOTKEY_SCANCODE) && (Hotkeys.KeyAttr==Key_Release) && Milli_Timer1)
 456  0131 1e03          	ldw	x,(OFST-1,sp)
 457  0133 a30014        	cpw	x,#20
 458  0136 2647          	jrne	L141
 460  0138 b604          	ld	a,_Hotkeys+1
 461  013a a101          	cp	a,#1
 462  013c 2641          	jrne	L141
 464  013e 3d01          	tnz	_Milli_Timer1
 465  0140 273d          	jreq	L141
 466                     ; 128 						Hotkeys.KeyAttr = 0;
 468  0142 3f04          	clr	_Hotkeys+1
 469                     ; 129 						Hotkeys.State = HK_KeyBreak_1;
 471  0144 35020003      	mov	_Hotkeys,#2
 472                     ; 130 						Milli_Timer1 = HOTKEY_WAIT_DELAY;				
 474  0148 35140001      	mov	_Milli_Timer1,#20
 475                     ; 131 						return;
 476  014c               L02:
 479  014c 5b04          	addw	sp,#4
 480  014e 81            	ret
 481  014f               L77:
 482                     ; 135 				case HK_KeyBreak_1:
 482                     ; 136 				  if((ScanCode == HOTKEY_SCANCODE) && !Hotkeys.KeyAttr && Milli_Timer1)
 484  014f 1e03          	ldw	x,(OFST-1,sp)
 485  0151 a30014        	cpw	x,#20
 486  0154 2629          	jrne	L141
 488  0156 3d04          	tnz	_Hotkeys+1
 489  0158 2625          	jrne	L141
 491  015a 3d01          	tnz	_Milli_Timer1
 492  015c 2721          	jreq	L141
 493                     ; 138 						Hotkeys.State = HK_KeyMake_2;
 495  015e 35030003      	mov	_Hotkeys,#3
 496                     ; 139 						Milli_Timer1 = HOTKEY_RELEASE_DELAY;				
 498  0162 35190001      	mov	_Milli_Timer1,#25
 499                     ; 140 						return;
 501  0166 20e4          	jra	L02
 502  0168               L101:
 503                     ; 144 				case HK_KeyMake_2:
 503                     ; 145 				  if((ScanCode == HOTKEY_SCANCODE) && (Hotkeys.KeyAttr==Key_Release) && Milli_Timer1)
 505  0168 1e03          	ldw	x,(OFST-1,sp)
 506  016a a30014        	cpw	x,#20
 507  016d 2610          	jrne	L141
 509  016f b604          	ld	a,_Hotkeys+1
 510  0171 a101          	cp	a,#1
 511  0173 260a          	jrne	L141
 513  0175 3d01          	tnz	_Milli_Timer1
 514  0177 2706          	jreq	L141
 515                     ; 147 						PutC('!');
 517  0179 a621          	ld	a,#33
 518  017b ad20          	call	_PutC
 520                     ; 148 						NewLine();				
 522  017d ad54          	call	_NewLine
 524  017f               L141:
 525                     ; 154 			Hotkeys.State = HK_Idle;
 527  017f 3f03          	clr	_Hotkeys
 528                     ; 155 			Hotkeys.KeyAttr = 0;
 530  0181 3f04          	clr	_Hotkeys+1
 531  0183               L521:
 532                     ; 158 }
 534  0183 20c7          	jra	L02
 557                     ; 160 void Init_Serial(void)
 557                     ; 161 {
 558                     	switch	.text
 559  0185               _Init_Serial:
 563                     ; 162 	UART1->BRR2 = UART_BRR2;
 565  0185 350a5233      	mov	21043,#10
 566                     ; 163 	UART1->BRR1 = UART_BRR1;
 568  0189 35085232      	mov	21042,#8
 569                     ; 165 	UART1->CR2 = UART1_CR2_TEN|UART1_CR2_REN;
 571  018d 350c5235      	mov	21045,#12
 572                     ; 166 }
 575  0191 81            	ret
 598                     ; 168 uint8_t GetC(void)
 598                     ; 169 {
 599                     	switch	.text
 600  0192               _GetC:
 604  0192               L571:
 605                     ; 170 	while(!Poll_Serial())
 607  0192 c65230        	ld	a,21040
 608  0195 a520          	bcp	a,#32
 609  0197 27f9          	jreq	L571
 610                     ; 172 	return(UART1->DR);
 612  0199 c65231        	ld	a,21041
 615  019c 81            	ret
 649                     ; 175 void PutC(uint8_t ch)
 649                     ; 176 {
 650                     	switch	.text
 651  019d               _PutC:
 653  019d 88            	push	a
 654       00000000      OFST:	set	0
 657  019e               L122:
 658                     ; 177 	while(!(UART1->SR & UART1_SR_TXE))
 660  019e c65230        	ld	a,21040
 661  01a1 a580          	bcp	a,#128
 662  01a3 27f9          	jreq	L122
 663                     ; 179 	UART1->DR = ch;
 665  01a5 7b01          	ld	a,(OFST+1,sp)
 666  01a7 c75231        	ld	21041,a
 667                     ; 180 }
 670  01aa 84            	pop	a
 671  01ab 81            	ret
 706                     ; 182 void Puthex(uint8_t n)
 706                     ; 183 { PutC((n<10)?n+'0':n-10+'A');
 707                     	switch	.text
 708  01ac               _Puthex:
 714  01ac a10a          	cp	a,#10
 715  01ae 2404          	jruge	L43
 716  01b0 ab30          	add	a,#48
 717  01b2 2002          	jra	L63
 718  01b4               L43:
 719  01b4 ab37          	add	a,#55
 720  01b6               L63:
 721  01b6 ade5          	call	_PutC
 723                     ; 184  }
 726  01b8 81            	ret
 761                     ; 186 void Puthex2(uint8_t n)
 761                     ; 187 { Puthex(n>>4);
 762                     	switch	.text
 763  01b9               _Puthex2:
 765  01b9 88            	push	a
 766       00000000      OFST:	set	0
 771  01ba 4e            	swap	a
 772  01bb a40f          	and	a,#15
 773  01bd aded          	call	_Puthex
 775                     ; 188   Puthex(n&0x0f);
 777  01bf 7b01          	ld	a,(OFST+1,sp)
 778  01c1 a40f          	and	a,#15
 779  01c3 ade7          	call	_Puthex
 781                     ; 189  }
 784  01c5 84            	pop	a
 785  01c6 81            	ret
 820                     ; 191 void Puthex4(uint16_t n)
 820                     ; 192 { Puthex2(n>>8);
 821                     	switch	.text
 822  01c7               _Puthex4:
 824  01c7 89            	pushw	x
 825       00000000      OFST:	set	0
 830  01c8 9e            	ld	a,xh
 831  01c9 adee          	call	_Puthex2
 833                     ; 193   Puthex2(n&0xff);
 835  01cb 7b02          	ld	a,(OFST+2,sp)
 836  01cd a4ff          	and	a,#255
 837  01cf ade8          	call	_Puthex2
 839                     ; 194  }
 842  01d1 85            	popw	x
 843  01d2 81            	ret
 867                     ; 196 void NewLine(void)
 867                     ; 197 { PutC('\x0d');
 868                     	switch	.text
 869  01d3               _NewLine:
 875  01d3 a60d          	ld	a,#13
 876  01d5 adc6          	call	_PutC
 878                     ; 198   PutC('\x0a');
 880  01d7 a60a          	ld	a,#10
 881  01d9 adc2          	call	_PutC
 883                     ; 199  }
 886  01db 81            	ret
1008                     	xdef	_Puthex
1009                     	switch	.ubsct
1010  0000               _Milli_Divider:
1011  0000 00            	ds.b	1
1012                     	xdef	_Milli_Divider
1013  0001               _Milli_Timer1:
1014  0001 00            	ds.b	1
1015                     	xdef	_Milli_Timer1
1016  0002               _Micro_Timer1:
1017  0002 00            	ds.b	1
1018                     	xdef	_Micro_Timer1
1019  0003               _Hotkeys:
1020  0003 0000          	ds.b	2
1021                     	xdef	_Hotkeys
1022  0005               _PS2:
1023  0005 0000000000    	ds.b	5
1024                     	xdef	_PS2
1025                     	xdef	_NewLine
1026                     	xdef	_Puthex4
1027                     	xdef	_Puthex2
1028                     	xdef	_PutC
1029                     	xdef	_GetC
1030                     	xdef	_Init_Serial
1031                     	xdef	_PS2_Task
1032                     	xdef	_Init_Hardware
1033                     	xdef	f_TIM4_IRQ
1034                     	xdef	f_PORTB_IRQ
1054                     	end
