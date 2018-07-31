   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.11.5 - 29 Dec 2015
   3                     ; Generator (Limited) V4.4.4 - 27 Jan 2016
  45                     ; 34 @far @interrupt void Default_IRQ_Handler(void)
  45                     ; 35 {
  46                     	switch	.text
  47  0000               f_Default_IRQ_Handler:
  51                     ; 36 }
  54  0000 80            	iret
  56                     .const:	section	.text
  57  0000               __vectab:
  58  0000 82            	dc.b	130
  60  0001 00            	dc.b	page(__stext)
  61  0002 0000          	dc.w	__stext
  62  0004 82            	dc.b	130
  64  0005 00            	dc.b	page(f_Default_IRQ_Handler)
  65  0006 0000          	dc.w	f_Default_IRQ_Handler
  66  0008 82            	dc.b	130
  68  0009 00            	dc.b	page(f_Default_IRQ_Handler)
  69  000a 0000          	dc.w	f_Default_IRQ_Handler
  70  000c 82            	dc.b	130
  72  000d 00            	dc.b	page(f_Default_IRQ_Handler)
  73  000e 0000          	dc.w	f_Default_IRQ_Handler
  74  0010 82            	dc.b	130
  76  0011 00            	dc.b	page(f_Default_IRQ_Handler)
  77  0012 0000          	dc.w	f_Default_IRQ_Handler
  78  0014 82            	dc.b	130
  80  0015 00            	dc.b	page(f_Default_IRQ_Handler)
  81  0016 0000          	dc.w	f_Default_IRQ_Handler
  82  0018 82            	dc.b	130
  84  0019 00            	dc.b	page(f_PORTB_IRQ)
  85  001a 0000          	dc.w	f_PORTB_IRQ
  86  001c 82            	dc.b	130
  88  001d 00            	dc.b	page(f_Default_IRQ_Handler)
  89  001e 0000          	dc.w	f_Default_IRQ_Handler
  90  0020 82            	dc.b	130
  92  0021 00            	dc.b	page(f_Default_IRQ_Handler)
  93  0022 0000          	dc.w	f_Default_IRQ_Handler
  94  0024 82            	dc.b	130
  96  0025 00            	dc.b	page(f_Default_IRQ_Handler)
  97  0026 0000          	dc.w	f_Default_IRQ_Handler
  98  0028 82            	dc.b	130
 100  0029 00            	dc.b	page(f_Default_IRQ_Handler)
 101  002a 0000          	dc.w	f_Default_IRQ_Handler
 102  002c 82            	dc.b	130
 104  002d 00            	dc.b	page(f_Default_IRQ_Handler)
 105  002e 0000          	dc.w	f_Default_IRQ_Handler
 106  0030 82            	dc.b	130
 108  0031 00            	dc.b	page(f_Default_IRQ_Handler)
 109  0032 0000          	dc.w	f_Default_IRQ_Handler
 110  0034 82            	dc.b	130
 112  0035 00            	dc.b	page(f_Default_IRQ_Handler)
 113  0036 0000          	dc.w	f_Default_IRQ_Handler
 114  0038 82            	dc.b	130
 116  0039 00            	dc.b	page(f_Default_IRQ_Handler)
 117  003a 0000          	dc.w	f_Default_IRQ_Handler
 118  003c 82            	dc.b	130
 120  003d 00            	dc.b	page(f_Default_IRQ_Handler)
 121  003e 0000          	dc.w	f_Default_IRQ_Handler
 122  0040 82            	dc.b	130
 124  0041 00            	dc.b	page(f_Default_IRQ_Handler)
 125  0042 0000          	dc.w	f_Default_IRQ_Handler
 126  0044 82            	dc.b	130
 128  0045 00            	dc.b	page(f_Default_IRQ_Handler)
 129  0046 0000          	dc.w	f_Default_IRQ_Handler
 130  0048 82            	dc.b	130
 132  0049 00            	dc.b	page(f_Default_IRQ_Handler)
 133  004a 0000          	dc.w	f_Default_IRQ_Handler
 134  004c 82            	dc.b	130
 136  004d 00            	dc.b	page(f_Default_IRQ_Handler)
 137  004e 0000          	dc.w	f_Default_IRQ_Handler
 138  0050 82            	dc.b	130
 140  0051 00            	dc.b	page(f_Default_IRQ_Handler)
 141  0052 0000          	dc.w	f_Default_IRQ_Handler
 142  0054 82            	dc.b	130
 144  0055 00            	dc.b	page(f_Default_IRQ_Handler)
 145  0056 0000          	dc.w	f_Default_IRQ_Handler
 146  0058 82            	dc.b	130
 148  0059 00            	dc.b	page(f_Default_IRQ_Handler)
 149  005a 0000          	dc.w	f_Default_IRQ_Handler
 150  005c 82            	dc.b	130
 152  005d 00            	dc.b	page(f_Default_IRQ_Handler)
 153  005e 0000          	dc.w	f_Default_IRQ_Handler
 154  0060 82            	dc.b	130
 156  0061 00            	dc.b	page(f_Default_IRQ_Handler)
 157  0062 0000          	dc.w	f_Default_IRQ_Handler
 158  0064 82            	dc.b	130
 160  0065 00            	dc.b	page(f_TIM4_IRQ)
 161  0066 0000          	dc.w	f_TIM4_IRQ
 162  0068 82            	dc.b	130
 164  0069 00            	dc.b	page(f_Default_IRQ_Handler)
 165  006a 0000          	dc.w	f_Default_IRQ_Handler
 166  006c 82            	dc.b	130
 168  006d 00            	dc.b	page(f_Default_IRQ_Handler)
 169  006e 0000          	dc.w	f_Default_IRQ_Handler
 170  0070 82            	dc.b	130
 172  0071 00            	dc.b	page(f_Default_IRQ_Handler)
 173  0072 0000          	dc.w	f_Default_IRQ_Handler
 174  0074 82            	dc.b	130
 176  0075 00            	dc.b	page(f_Default_IRQ_Handler)
 177  0076 0000          	dc.w	f_Default_IRQ_Handler
 178  0078 82            	dc.b	130
 180  0079 00            	dc.b	page(f_Default_IRQ_Handler)
 181  007a 0000          	dc.w	f_Default_IRQ_Handler
 182  007c 82            	dc.b	130
 184  007d 00            	dc.b	page(f_Default_IRQ_Handler)
 185  007e 0000          	dc.w	f_Default_IRQ_Handler
 235                     	xdef	__vectab
 236                     	xdef	f_Default_IRQ_Handler
 237                     	xref	__stext
 238                     	xref	f_TIM4_IRQ
 239                     	xref	f_PORTB_IRQ
 258                     	end
