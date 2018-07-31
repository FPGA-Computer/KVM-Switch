   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.11.5 - 29 Dec 2015
   3                     ; Generator (Limited) V4.4.4 - 27 Jan 2016
  45                     ; 3 void main(void)
  45                     ; 4 {
  47                     	switch	.text
  48  0000               _main:
  52                     ; 5 	Init_Hardware();
  54  0000 cd0000        	call	_Init_Hardware
  56  0003               L12:
  57                     ; 9 		PS2_Task();
  59  0003 cd0000        	call	_PS2_Task
  62  0006 20fb          	jra	L12
  75                     	xdef	_main
  76                     	xref	_PS2_Task
  77                     	xref	_Init_Hardware
  96                     	end
