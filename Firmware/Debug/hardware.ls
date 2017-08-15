   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.11.5 - 29 Dec 2015
   3                     ; Generator (Limited) V4.4.4 - 27 Jan 2016
  15                     .const:	section	.text
  16  0000               _Mux_Tbl:
  17  0000 40            	dc.b	64
  18  0001 00            	dc.b	0
  19  0002 80            	dc.b	128
  20  0003 c0            	dc.b	192
  52                     ; 40 void Init_Hardware(void)
  52                     ; 41 {
  54                     	switch	.text
  55  0000               _Init_Hardware:
  59                     ; 42 	CLK->CKDIVR = 0;										// Clk divider, CPU divider = 1
  61  0000 725f50c6      	clr	20678
  62                     ; 43 	EXTI->CR1 = (0x02 << 2);						// PB2 Interrupt: Falling edge
  64  0004 350850a0      	mov	20640,#8
  65                     ; 44 	PS2_PORT->CR2 = PS2_CLK;						// Enable PS2_CLK interrupt
  67  0008 35105009      	mov	20489,#16
  68                     ; 47 	HDMI_PORT->DDR = HDMI_SW|USB_IN1|USB_IN2;
  70  000c 35e0500c      	mov	20492,#224
  71                     ; 48 	HDMI_PORT->CR1 = HDMI_S1|HDMI_S2|USB_IN1|USB_IN2;
  73  0010 35d8500d      	mov	20493,#216
  74                     ; 51 	GPIOA->CR1 = GPIOA->DDR = PA1|PA2|PA3;
  76  0014 350e5002      	mov	20482,#14
  77  0018 5550025003    	mov	20483,20482
  78                     ; 52 	GPIOD->CR1 = GPIOD->DDR = PD1|PD2|PD3|PD4;
  80  001d 351e5011      	mov	20497,#30
  81  0021 5550115012    	mov	20498,20497
  82                     ; 55 	TIM4->CR1 = TIM4_CR1_ARPE|TIM4_CR1_URS|TIM4_CR1_CEN;
  84  0026 35855340      	mov	21312,#133
  85                     ; 57 	TIM4->IER = TIM4_IER_UIE;					// Update IRQ enable
  87  002a 35015343      	mov	21315,#1
  88                     ; 58 	TIM4->PSCR = TIM4_PSCR;						// TIM4: 16MHz/2^TIM4_PSCR
  90  002e 35035347      	mov	21319,#3
  91                     ; 59 	TIM4->ARR = TIM4_ARR;							// Auto-reload
  93  0032 35c85348      	mov	21320,#200
  94                     ; 62 	ITC->ISPR2 = 0x03;
  96  0036 35037f71      	mov	32625,#3
  97                     ; 64 	ITC->ISPR1 = ITC->ISPR3 = ITC->ISPR4 = ITC->ISPR5 = ITC->ISPR6 = 0x00;
  99  003a 725f7f75      	clr	32629
 100  003e 725f7f74      	clr	32628
 101  0042 725f7f73      	clr	32627
 102  0046 725f7f72      	clr	32626
 103  004a 725f7f70      	clr	32624
 104                     ; 66 	PS2.State = PS2_Idle;
 106  004e 3f08          	clr	_PS2+2
 107                     ; 68 	Hotkeys.State = HK_Idle;
 109  0050 3f04          	clr	_Hotkeys
 110                     ; 69 	Hotkeys.KeyAttr = 0;
 112  0052 3f05          	clr	_Hotkeys+1
 113                     ; 71 	rim();
 116  0054 9a            rim
 118                     ; 72 }
 122  0055 81            	ret
 149                     ; 75 @far @interrupt void TIM4_IRQ(void)
 149                     ; 76 {
 151                     	switch	.text
 152  0056               f_TIM4_IRQ:
 156                     ; 77 	TIM4->SR1 &= ~TIM4_SR1_UIF;				// Clear update IRQ
 158  0056 72115344      	bres	21316,#0
 159                     ; 79 	if(Micro_Timer1)
 161  005a 3d03          	tnz	_Micro_Timer1
 162  005c 2702          	jreq	L13
 163                     ; 80 		Micro_Timer1--;
 165  005e 3a03          	dec	_Micro_Timer1
 166  0060               L13:
 167                     ; 82 	if(Milli_Divider)
 169  0060 3d00          	tnz	_Milli_Divider
 170  0062 2704          	jreq	L33
 171                     ; 83 		Milli_Divider--;
 173  0064 3a00          	dec	_Milli_Divider
 175  0066 2016          	jra	L53
 176  0068               L33:
 177                     ; 86 		if(Milli_Timer1)
 179  0068 3d02          	tnz	_Milli_Timer1
 180  006a 2702          	jreq	L73
 181                     ; 87 			Milli_Timer1--;			
 183  006c 3a02          	dec	_Milli_Timer1
 184  006e               L73:
 185                     ; 89 		if(Milli_Timer2)								// HDMI button
 187  006e 3d01          	tnz	_Milli_Timer2
 188  0070 2704          	jreq	L14
 189                     ; 90 			Milli_Timer2--;
 191  0072 3a01          	dec	_Milli_Timer2
 193  0074 2004          	jra	L34
 194  0076               L14:
 195                     ; 92 			HDMI_PORT->ODR |= HDMI_SW;		// Clear select button
 197  0076 721a500a      	bset	20490,#5
 198  007a               L34:
 199                     ; 94 		Milli_Divider = MILLI_DIVIDER_RELOAD;
 201  007a 35640000      	mov	_Milli_Divider,#100
 202  007e               L53:
 203                     ; 96 }
 206  007e 80            	iret
 230                     ; 98 @far @interrupt void PORTB_IRQ(void)
 230                     ; 99 {		
 231                     	switch	.text
 232  007f               f_PORTB_IRQ:
 236                     ; 100 	if((PS2.State == PS2_Idle)||(!Micro_Timer1))	// Start bit or resynchronized
 238  007f 3d08          	tnz	_PS2+2
 239  0081 2704          	jreq	L75
 241  0083 3d03          	tnz	_Micro_Timer1
 242  0085 2614          	jrne	L55
 243  0087               L75:
 244                     ; 103 		Micro_Timer1 = us_TO_TICKS(PS2_BIT_TIMEOUT);
 246  0087 350f0003      	mov	_Micro_Timer1,#15
 247                     ; 105 		PS2.State = (PS2_PORT->IDR & PS2_DATA)?PS2_CMD_1:PS2_KBD_1;
 249  008b c65006        	ld	a,20486
 250  008e a520          	bcp	a,#32
 251  0090 2704          	jreq	L21
 252  0092 a601          	ld	a,#1
 253  0094 2002          	jra	L41
 254  0096               L21:
 255  0096 a641          	ld	a,#65
 256  0098               L41:
 257  0098 b708          	ld	_PS2+2,a
 259  009a               L16:
 260                     ; 128 }
 263  009a 80            	iret
 264  009b               L55:
 265                     ; 109 		if(PS2.State++ & PS2_KBD)											// Scan/respond code
 267  009b b608          	ld	a,_PS2+2
 268  009d 3c08          	inc	_PS2+2
 269  009f 5f            	clrw	x
 270  00a0 a540          	bcp	a,#64
 271  00a2 2727          	jreq	L36
 272                     ; 111 			if(PS2.State == PS2_KBD_LAST)
 274  00a4 b608          	ld	a,_PS2+2
 275  00a6 a14b          	cp	a,#75
 276  00a8 2608          	jrne	L56
 277                     ; 113 				PS2.Avail = 1;
 279  00aa 3501000a      	mov	_PS2+4,#1
 280                     ; 114 				PS2.State = PS2_Idle;
 282  00ae 3f08          	clr	_PS2+2
 284  00b0 20e8          	jra	L16
 285  00b2               L56:
 286                     ; 118 				PS2.ScanCode >>= 1;
 288  00b2 be06          	ldw	x,_PS2
 289  00b4 54            	srlw	x
 290  00b5 bf06          	ldw	_PS2,x
 291                     ; 120 				if(PS2_PORT->IDR & PS2_DATA)
 293  00b7 c65006        	ld	a,20486
 294  00ba a520          	bcp	a,#32
 295  00bc 27dc          	jreq	L16
 296                     ; 121 					PS2.ScanCode |= 0x200;
 298  00be be06          	ldw	x,_PS2
 299  00c0 01            	rrwa	x,a
 300  00c1 aa00          	or	a,#0
 301  00c3 01            	rrwa	x,a
 302  00c4 aa02          	or	a,#2
 303  00c6 01            	rrwa	x,a
 304  00c7 bf06          	ldw	_PS2,x
 305  00c9 20cf          	jra	L16
 306  00cb               L36:
 307                     ; 125 			if(PS2.State == PS2_CMD_LAST)
 309  00cb b608          	ld	a,_PS2+2
 310  00cd a10c          	cp	a,#12
 311  00cf 26c9          	jrne	L16
 312                     ; 126 				PS2.State = PS2_Idle;
 314  00d1 3f08          	clr	_PS2+2
 315  00d3 20c5          	jra	L16
 375                     ; 131 void PS2_Task(void)
 375                     ; 132 {
 377                     	switch	.text
 378  00d5               _PS2_Task:
 380  00d5 5205          	subw	sp,#5
 381       00000005      OFST:	set	5
 384                     ; 136 	if(PS2.Avail)
 386  00d7 3d0a          	tnz	_PS2+4
 387  00d9 2603          	jrne	L22
 388  00db cc019b        	jp	L531
 389  00de               L22:
 390                     ; 139 		sim();
 393  00de 9b            sim
 395                     ; 140 		ScanCode = PS2.ScanCode;
 398  00df be06          	ldw	x,_PS2
 399  00e1 1f04          	ldw	(OFST-1,sp),x
 401                     ; 141 		PS2.Avail = 0;
 403  00e3 3f0a          	clr	_PS2+4
 404                     ; 142 		rim();
 407  00e5 9a            rim
 409                     ; 144 		Parity = PS2.ScanCode & 0x01;	
 412  00e6 b606          	ld	a,_PS2
 413  00e8 97            	ld	xl,a
 414  00e9 b607          	ld	a,_PS2+1
 415  00eb a401          	and	a,#1
 416  00ed 5f            	clrw	x
 417                     ; 145 		ScanCode = (ScanCode >> 1) & 0xff;
 419  00ee 1e04          	ldw	x,(OFST-1,sp)
 420  00f0 54            	srlw	x
 421  00f1 01            	rrwa	x,a
 422  00f2 a4ff          	and	a,#255
 423  00f4 5f            	clrw	x
 424  00f5 02            	rlwa	x,a
 425  00f6 1f04          	ldw	(OFST-1,sp),x
 426  00f8 01            	rrwa	x,a
 428                     ; 147 		if (ScanCode == PS2_KBD_CODE_RELEASE)
 430  00f9 1e04          	ldw	x,(OFST-1,sp)
 431  00fb a300f0        	cpw	x,#240
 432  00fe 2608          	jrne	L731
 433                     ; 148 			Hotkeys.KeyAttr |= Key_Release;
 435  0100 72100005      	bset	_Hotkeys+1,#0
 437  0104 ac9b019b      	jpf	L531
 438  0108               L731:
 439                     ; 149 		else if (ScanCode == PS2_KBD_CODE_EXTENDED)
 441  0108 1e04          	ldw	x,(OFST-1,sp)
 442  010a a300e0        	cpw	x,#224
 443  010d 2607          	jrne	L341
 444                     ; 150 			Hotkeys.KeyAttr |= Key_Extend;
 446  010f 72120005      	bset	_Hotkeys+1,#1
 448  0113 cc019b        	jra	L531
 449  0116               L341:
 450                     ; 153 			switch(Hotkeys.State)
 452  0116 b604          	ld	a,_Hotkeys
 454                     ; 196 					break;	
 455  0118 4d            	tnz	a
 456  0119 270b          	jreq	L77
 457  011b 4a            	dec	a
 458  011c 271d          	jreq	L101
 459  011e 4a            	dec	a
 460  011f 273c          	jreq	L301
 461  0121 4a            	dec	a
 462  0122 2756          	jreq	L501
 463  0124 2071          	jra	L151
 464  0126               L77:
 465                     ; 155 				case HK_Idle:					// wait for hot key press
 465                     ; 156 				  if((ScanCode == HOTKEY_SCANCODE) && !Hotkeys.KeyAttr)
 467  0126 1e04          	ldw	x,(OFST-1,sp)
 468  0128 a30014        	cpw	x,#20
 469  012b 266a          	jrne	L151
 471  012d 3d05          	tnz	_Hotkeys+1
 472  012f 2666          	jrne	L151
 473                     ; 158 						Hotkeys.State = HK_KeyMake_1;
 475  0131 35010004      	mov	_Hotkeys,#1
 476                     ; 159 						Milli_Timer1 = HOTKEY_RELEASE_DELAY;
 478  0135 35190002      	mov	_Milli_Timer1,#25
 479                     ; 160 						return;
 481  0139 201b          	jra	L02
 482  013b               L101:
 483                     ; 164 				case HK_KeyMake_1:		// wait for hot key release instead of hold
 483                     ; 165 				  if((ScanCode == HOTKEY_SCANCODE) && (Hotkeys.KeyAttr==Key_Release) && Milli_Timer1)
 485  013b 1e04          	ldw	x,(OFST-1,sp)
 486  013d a30014        	cpw	x,#20
 487  0140 2617          	jrne	L551
 489  0142 b605          	ld	a,_Hotkeys+1
 490  0144 a101          	cp	a,#1
 491  0146 2611          	jrne	L551
 493  0148 3d02          	tnz	_Milli_Timer1
 494  014a 270d          	jreq	L551
 495                     ; 167 						Hotkeys.KeyAttr = 0;
 497  014c 3f05          	clr	_Hotkeys+1
 498                     ; 168 						Hotkeys.State = HK_KeyBreak_1;
 500  014e 35020004      	mov	_Hotkeys,#2
 501                     ; 169 						Milli_Timer1 = HOTKEY_WAIT_DELAY;				
 503  0152 35140002      	mov	_Milli_Timer1,#20
 504                     ; 170 						return;
 505  0156               L02:
 508  0156 5b05          	addw	sp,#5
 509  0158 81            	ret
 510  0159               L551:
 511                     ; 173 						Hotkeys.State = HK_Idle;
 513  0159 3f04          	clr	_Hotkeys
 514  015b 203a          	jra	L151
 515  015d               L301:
 516                     ; 176 				case HK_KeyBreak_1:		// wait for hot key release
 516                     ; 177 				  if((ScanCode == HOTKEY_SCANCODE) && !Hotkeys.KeyAttr && Milli_Timer1)
 518  015d 1e04          	ldw	x,(OFST-1,sp)
 519  015f a30014        	cpw	x,#20
 520  0162 2612          	jrne	L161
 522  0164 3d05          	tnz	_Hotkeys+1
 523  0166 260e          	jrne	L161
 525  0168 3d02          	tnz	_Milli_Timer1
 526  016a 270a          	jreq	L161
 527                     ; 179 						Hotkeys.State = HK_KeyMake_2;
 529  016c 35030004      	mov	_Hotkeys,#3
 530                     ; 180 						Milli_Timer1 = HOTKEY_RELEASE_DELAY;				
 532  0170 35190002      	mov	_Milli_Timer1,#25
 533                     ; 181 						return;
 535  0174 20e0          	jra	L02
 536  0176               L161:
 537                     ; 184 						Hotkeys.State = HK_Idle;
 539  0176 3f04          	clr	_Hotkeys
 540  0178 201d          	jra	L151
 541  017a               L501:
 542                     ; 187 				case HK_KeyMake_2:		// wait for hot key press again
 542                     ; 188 				  if((ScanCode == HOTKEY_SCANCODE) && (Hotkeys.KeyAttr==Key_Release) && Milli_Timer1)
 544  017a 1e04          	ldw	x,(OFST-1,sp)
 545  017c a30014        	cpw	x,#20
 546  017f 2614          	jrne	L561
 548  0181 b605          	ld	a,_Hotkeys+1
 549  0183 a101          	cp	a,#1
 550  0185 260e          	jrne	L561
 552  0187 3d02          	tnz	_Milli_Timer1
 553  0189 270a          	jreq	L561
 554                     ; 190 						HDMI_PORT->ODR &= ~HDMI_SW;						// Press select button(active low)	
 556  018b 721b500a      	bres	20490,#5
 557                     ; 191 					  Milli_Timer2 = HDMI_SW_DELAY;					// hold for delay
 559  018f 350a0001      	mov	_Milli_Timer2,#10
 561  0193 2002          	jra	L151
 562  0195               L561:
 563                     ; 194 						Hotkeys.State = HK_Idle;
 565  0195 3f04          	clr	_Hotkeys
 566  0197               L151:
 567                     ; 200 			Hotkeys.State = HK_Idle;
 569  0197 3f04          	clr	_Hotkeys
 570                     ; 201 			Hotkeys.KeyAttr = 0;
 572  0199 3f05          	clr	_Hotkeys+1
 573  019b               L531:
 574                     ; 206 	Mux = Mux_Tbl[(HDMI_PORT->IDR & (HDMI_S2|HDMI_S1))>>HDMI_SHIFT];
 576  019b c6500b        	ld	a,20491
 577  019e 44            	srl	a
 578  019f 44            	srl	a
 579  01a0 44            	srl	a
 580  01a1 a403          	and	a,#3
 581  01a3 5f            	clrw	x
 582  01a4 97            	ld	xl,a
 583  01a5 d60000        	ld	a,(_Mux_Tbl,x)
 584  01a8 6b03          	ld	(OFST-2,sp),a
 586                     ; 209 	sim();
 589  01aa 9b            sim
 591                     ; 210 	HDMI_PORT->ODR = (HDMI_PORT->ODR & HDMI_SW)|Mux;
 594  01ab c6500a        	ld	a,20490
 595  01ae a420          	and	a,#32
 596  01b0 1a03          	or	a,(OFST-2,sp)
 597  01b2 c7500a        	ld	20490,a
 598                     ; 211 	rim();
 601  01b5 9a            rim
 603                     ; 213 }
 606  01b6 209e          	jra	L02
 747                     	xdef	_Mux_Tbl
 748                     	switch	.ubsct
 749  0000               _Milli_Divider:
 750  0000 00            	ds.b	1
 751                     	xdef	_Milli_Divider
 752  0001               _Milli_Timer2:
 753  0001 00            	ds.b	1
 754                     	xdef	_Milli_Timer2
 755  0002               _Milli_Timer1:
 756  0002 00            	ds.b	1
 757                     	xdef	_Milli_Timer1
 758  0003               _Micro_Timer1:
 759  0003 00            	ds.b	1
 760                     	xdef	_Micro_Timer1
 761  0004               _Hotkeys:
 762  0004 0000          	ds.b	2
 763                     	xdef	_Hotkeys
 764  0006               _PS2:
 765  0006 0000000000    	ds.b	5
 766                     	xdef	_PS2
 767                     	xdef	_PS2_Task
 768                     	xdef	_Init_Hardware
 769                     	xdef	f_TIM4_IRQ
 770                     	xdef	f_PORTB_IRQ
 790                     	end
