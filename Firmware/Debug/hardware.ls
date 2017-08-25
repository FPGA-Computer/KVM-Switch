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
 384                     ; 131 void PS2_Task(void)
 384                     ; 132 {
 386                     	switch	.text
 387  00d5               _PS2_Task:
 389  00d5 5206          	subw	sp,#6
 390       00000006      OFST:	set	6
 393                     ; 136 	if(PS2.Avail)
 395  00d7 3d0a          	tnz	_PS2+4
 396  00d9 2603          	jrne	L22
 397  00db cc01a4        	jp	L141
 398  00de               L22:
 399                     ; 139 		sim();
 402  00de 9b            sim
 404                     ; 140 		ScanCode = PS2.ScanCode;
 407  00df be06          	ldw	x,_PS2
 408  00e1 1f05          	ldw	(OFST-1,sp),x
 410                     ; 141 		PS2.Avail = 0;
 412  00e3 3f0a          	clr	_PS2+4
 413                     ; 142 		rim();
 416  00e5 9a            rim
 418                     ; 144 		Parity = PS2.ScanCode & 0x01;	
 421  00e6 b606          	ld	a,_PS2
 422  00e8 97            	ld	xl,a
 423  00e9 b607          	ld	a,_PS2+1
 424  00eb a401          	and	a,#1
 425  00ed 5f            	clrw	x
 426                     ; 145 		ScanCode = (ScanCode >> 1) & 0xff;
 428  00ee 1e05          	ldw	x,(OFST-1,sp)
 429  00f0 54            	srlw	x
 430  00f1 01            	rrwa	x,a
 431  00f2 a4ff          	and	a,#255
 432  00f4 5f            	clrw	x
 433  00f5 02            	rlwa	x,a
 434  00f6 1f05          	ldw	(OFST-1,sp),x
 435  00f8 01            	rrwa	x,a
 437                     ; 147 		if (ScanCode == PS2_KBD_CODE_RELEASE)
 439  00f9 1e05          	ldw	x,(OFST-1,sp)
 440  00fb a300f0        	cpw	x,#240
 441  00fe 2608          	jrne	L341
 442                     ; 148 			Hotkeys.KeyAttr |= Key_Release;
 444  0100 72100005      	bset	_Hotkeys+1,#0
 446  0104 aca401a4      	jpf	L141
 447  0108               L341:
 448                     ; 149 		else if (ScanCode == PS2_KBD_CODE_EXTENDED)
 450  0108 1e05          	ldw	x,(OFST-1,sp)
 451  010a a300e0        	cpw	x,#224
 452  010d 2608          	jrne	L741
 453                     ; 150 			Hotkeys.KeyAttr |= Key_Extend;
 455  010f 72120005      	bset	_Hotkeys+1,#1
 457  0113 aca401a4      	jpf	L141
 458  0117               L741:
 459                     ; 153 			switch(Hotkeys.State)
 461  0117 b604          	ld	a,_Hotkeys
 463                     ; 202 					break;
 464  0119 4d            	tnz	a
 465  011a 270b          	jreq	L77
 466  011c 4a            	dec	a
 467  011d 271d          	jreq	L101
 468  011f 4a            	dec	a
 469  0120 273c          	jreq	L301
 470  0122 4a            	dec	a
 471  0123 2756          	jreq	L501
 472  0125 2079          	jra	L551
 473  0127               L77:
 474                     ; 155 				case HK_Idle:					// wait for hot key press
 474                     ; 156 				  if((ScanCode == HOTKEY_SCANCODE) && !Hotkeys.KeyAttr)
 476  0127 1e05          	ldw	x,(OFST-1,sp)
 477  0129 a30014        	cpw	x,#20
 478  012c 2672          	jrne	L551
 480  012e 3d05          	tnz	_Hotkeys+1
 481  0130 266e          	jrne	L551
 482                     ; 158 						Hotkeys.State = HK_KeyMake_1;
 484  0132 35010004      	mov	_Hotkeys,#1
 485                     ; 159 						Milli_Timer1 = HOTKEY_RELEASE_DELAY;
 487  0136 35190002      	mov	_Milli_Timer1,#25
 488                     ; 160 						return;
 490  013a 201b          	jra	L02
 491  013c               L101:
 492                     ; 164 				case HK_KeyMake_1:		// wait for hot key release instead of hold
 492                     ; 165 				  if((ScanCode == HOTKEY_SCANCODE) && (Hotkeys.KeyAttr==Key_Release) && Milli_Timer1)
 494  013c 1e05          	ldw	x,(OFST-1,sp)
 495  013e a30014        	cpw	x,#20
 496  0141 2617          	jrne	L161
 498  0143 b605          	ld	a,_Hotkeys+1
 499  0145 a101          	cp	a,#1
 500  0147 2611          	jrne	L161
 502  0149 3d02          	tnz	_Milli_Timer1
 503  014b 270d          	jreq	L161
 504                     ; 167 						Hotkeys.KeyAttr = 0;
 506  014d 3f05          	clr	_Hotkeys+1
 507                     ; 168 						Hotkeys.State = HK_KeyBreak_1;
 509  014f 35020004      	mov	_Hotkeys,#2
 510                     ; 169 						Milli_Timer1 = HOTKEY_WAIT_DELAY;				
 512  0153 35140002      	mov	_Milli_Timer1,#20
 513                     ; 170 						return;
 514  0157               L02:
 517  0157 5b06          	addw	sp,#6
 518  0159 81            	ret
 519  015a               L161:
 520                     ; 173 						Hotkeys.State = HK_Idle;
 522  015a 3f04          	clr	_Hotkeys
 523  015c 2042          	jra	L551
 524  015e               L301:
 525                     ; 176 				case HK_KeyBreak_1:		// wait for hot key release
 525                     ; 177 				  if((ScanCode == HOTKEY_SCANCODE) && !Hotkeys.KeyAttr && Milli_Timer1)
 527  015e 1e05          	ldw	x,(OFST-1,sp)
 528  0160 a30014        	cpw	x,#20
 529  0163 2612          	jrne	L561
 531  0165 3d05          	tnz	_Hotkeys+1
 532  0167 260e          	jrne	L561
 534  0169 3d02          	tnz	_Milli_Timer1
 535  016b 270a          	jreq	L561
 536                     ; 179 						Hotkeys.State = HK_KeyMake_2;
 538  016d 35030004      	mov	_Hotkeys,#3
 539                     ; 180 						Milli_Timer1 = HOTKEY_RELEASE_DELAY;				
 541  0171 35190002      	mov	_Milli_Timer1,#25
 542                     ; 181 						return;
 544  0175 20e0          	jra	L02
 545  0177               L561:
 546                     ; 184 						Hotkeys.State = HK_Idle;
 548  0177 3f04          	clr	_Hotkeys
 549  0179 2025          	jra	L551
 550  017b               L501:
 551                     ; 187 				case HK_KeyMake_2:		// wait for hot key press again
 551                     ; 188 				  if((ScanCode == HOTKEY_SCANCODE) && (Hotkeys.KeyAttr==Key_Release) && Milli_Timer1)
 553  017b 1e05          	ldw	x,(OFST-1,sp)
 554  017d a30014        	cpw	x,#20
 555  0180 261c          	jrne	L171
 557  0182 b605          	ld	a,_Hotkeys+1
 558  0184 a101          	cp	a,#1
 559  0186 2616          	jrne	L171
 561  0188 3d02          	tnz	_Milli_Timer1
 562  018a 2712          	jreq	L171
 563                     ; 191 						Milli_Timer1 = HOTKEY_USB_WAIT;
 565  018c 35030002      	mov	_Milli_Timer1,#3
 566  0190               L371:
 567                     ; 193 					  while(Milli_Timer1)
 570  0190 3d02          	tnz	_Milli_Timer1
 571  0192 26fc          	jrne	L371
 572                     ; 196 						HDMI_PORT->ODR &= ~HDMI_SW;						// Press select button(active low)	
 574  0194 721b500a      	bres	20490,#5
 575                     ; 197 					  Milli_Timer2 = HDMI_SW_DELAY;					// hold for delay
 577  0198 350a0001      	mov	_Milli_Timer2,#10
 579  019c 2002          	jra	L551
 580  019e               L171:
 581                     ; 200 						Hotkeys.State = HK_Idle;
 583  019e 3f04          	clr	_Hotkeys
 584  01a0               L551:
 585                     ; 206 			Hotkeys.State = HK_Idle;
 587  01a0 3f04          	clr	_Hotkeys
 588                     ; 207 			Hotkeys.KeyAttr = 0;
 590  01a2 3f05          	clr	_Hotkeys+1
 591  01a4               L141:
 592                     ; 211 	HDMI = (HDMI_PORT->IDR & HDMI_SEL_MASK)>>HDMI_SHIFT;
 594  01a4 c6500b        	ld	a,20491
 595  01a7 44            	srl	a
 596  01a8 44            	srl	a
 597  01a9 44            	srl	a
 598  01aa a403          	and	a,#3
 599  01ac 6b03          	ld	(OFST-3,sp),a
 601                     ; 213 	USB = Mux_Tbl[HDMI];
 603  01ae 7b03          	ld	a,(OFST-3,sp)
 604  01b0 5f            	clrw	x
 605  01b1 97            	ld	xl,a
 606  01b2 d60000        	ld	a,(_Mux_Tbl,x)
 607  01b5 6b04          	ld	(OFST-2,sp),a
 609                     ; 216 	if(((HDMI!= HDMI_NO_CONNECT)&&(HDMI_PORT->ODR & USB_SEL_MASK)!= USB))
 611  01b7 7b03          	ld	a,(OFST-3,sp)
 612  01b9 a101          	cp	a,#1
 613  01bb 2715          	jreq	L302
 615  01bd c6500a        	ld	a,20490
 616  01c0 a4c0          	and	a,#192
 617  01c2 1104          	cp	a,(OFST-2,sp)
 618  01c4 270c          	jreq	L302
 619                     ; 219 		sim();
 622  01c6 9b            sim
 624                     ; 220 		HDMI_PORT->ODR = (HDMI_PORT->ODR & HDMI_SW)|USB;
 627  01c7 c6500a        	ld	a,20490
 628  01ca a420          	and	a,#32
 629  01cc 1a04          	or	a,(OFST-2,sp)
 630  01ce c7500a        	ld	20490,a
 631                     ; 221 		rim();
 634  01d1 9a            rim
 637  01d2               L302:
 638                     ; 223 }
 640  01d2 2083          	jra	L02
 781                     	xdef	_Mux_Tbl
 782                     	switch	.ubsct
 783  0000               _Milli_Divider:
 784  0000 00            	ds.b	1
 785                     	xdef	_Milli_Divider
 786  0001               _Milli_Timer2:
 787  0001 00            	ds.b	1
 788                     	xdef	_Milli_Timer2
 789  0002               _Milli_Timer1:
 790  0002 00            	ds.b	1
 791                     	xdef	_Milli_Timer1
 792  0003               _Micro_Timer1:
 793  0003 00            	ds.b	1
 794                     	xdef	_Micro_Timer1
 795  0004               _Hotkeys:
 796  0004 0000          	ds.b	2
 797                     	xdef	_Hotkeys
 798  0006               _PS2:
 799  0006 0000000000    	ds.b	5
 800                     	xdef	_PS2
 801                     	xdef	_PS2_Task
 802                     	xdef	_Init_Hardware
 803                     	xdef	f_TIM4_IRQ
 804                     	xdef	f_PORTB_IRQ
 824                     	end
