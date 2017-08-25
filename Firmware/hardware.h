/*
 * hardware.h
 *
 * Created: 22/12/2016 6:03:25 AM
 *  Author: K. C. Lee
 * Copyright (c) 2016 by K. C. Lee
 
 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with this program.

 If not, see http://www.gnu.org/licenses/gpl-3.0.en.html 
 */ 

#ifndef HARDWARE_H_
#define HARDWARE_H_

#ifndef __CSMC__
#define __CSMC__
#endif
#define STM8S003

#include "stm8s.h"
#include <stdio.h>

// STM8S003F3P6
enum _PA { PA1=0x02, PA2=0x04, PA3=0x08 };
enum _PB { PB4=0x10, PB5=0x20 };
enum _PC { PC3=0x08, PC4=0x10, PC5=0x20, PC6=0x40, PC7=0x80 };
enum _PD { PD1=0x02, PD2=0x04, PD3=0x08, PD4=0x10, PD5=0x20, PD6=0x40 };

#include "irq.h"

#define PS2_CLK									PB4
#define PS2_DATA								PB5
#define PS2_PORT								GPIOB

#define HDMI_S1									PC3
#define HDMI_S2									PC4

#define HDMI_SW									PC5

#define USB_IN1									PC6
#define USB_IN2									PC7
#define HDMI_PORT								GPIOC

#define HDMI_NO_CONNECT					0x01
#define USB_NO_CONNECT					0x00

#define HDMI_SEL_MASK						(HDMI_S1 | HDMI_S2)
#define USB_SEL_MASK						(USB_IN1 | USB_IN2)

#define HDMI_SHIFT							3
#define USB_SHIFT								6

#define PS2_KBD									0x40
#define PS2_CMD									0x00

#define PS2_KBD_BITS						10
#define PS2_CMD_BITS						11

#define PS2_BIT_TIMEOUT					1500		// us

enum Key_States
{
	PS2_Idle = 0,
	PS2_KBD_1 = PS2_KBD+1,
	PS2_KBD_LAST = PS2_KBD_1+PS2_KBD_BITS,
	PS2_CMD_1 = PS2_CMD+1,
	PS2_CMD_LAST = PS2_CMD_1+PS2_CMD_BITS
};

enum Hotkey_States
{
	HK_Idle,
	HK_KeyMake_1,
	HK_KeyBreak_1,
	HK_KeyMake_2
};

enum KeyAttrib
{
	Key_Regular = 0x00,
	Key_Release = 0x01,
	Key_Extend	= 0x02
};

typedef struct
{
	volatile	uint16_t	ScanCode;
						uint8_t 	State;
						uint8_t		Attrib;
	volatile 	uint8_t		Avail;
} KBD_States;

#define PS2_KBD_CODE_EXTENDED   0xe0
#define PS2_KBD_CODE_RELEASE    0xf0

#define HOTKEY_SCANCODE					0x14

#define HOTKEY_RELEASE_DELAY		ms_TO_TICKS(250)
#define HOTKEY_WAIT_DELAY				ms_TO_TICKS(200)
#define HOTKEY_USB_WAIT					ms_TO_TICKS(30)
#define HDMI_SW_DELAY						ms_TO_TICKS(100)

typedef struct
{
	uint8_t State;
	uint8_t KeyAttr;
} Hotkey_State;

#define TIM4_PSCR								3
#define TIM4_ARR 								200
#define MILLI_DIVIDER_RELOAD		100

// 16MHz/2^TIM4_PSCR/TIM4_ARR = 10kHz (100us per tick)
// 10kHz/MILLI_DIVIDER_RELOAD = 100Hz (10ms per tick)

// Minimum delay
#define us_TO_TICKS(X)					((X)/100)
#define ms_TO_TICKS(X)					((X)/10)

void Init_Hardware(void);
void PS2_Task(void);

// uart 115200
#define UART_BAUD								115200UL
#define UART_BRR_DIV						((int)(HSI_VALUE/UART_BAUD+0.5))
#define UART_BRR1								((UART_BRR_DIV & 0x0ff0)>>4)
#define UART_BRR2								(((UART_BRR_DIV & 0xf000)>>8)|(UART_BRR_DIV & 0x0f))

void Init_Serial(void);
uint8_t GetC(void);
void PutC(uint8_t ch);
void Puthex2(uint8_t n);
void Puthex4(uint16_t n);
void NewLine(void);

#define Poll_Serial()	(UART1->SR & UART1_SR_RXNE)
#define Get_Char()		(UART1->DR)

#endif
