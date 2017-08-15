/*
 * hardware.c
 *
 * Created: April-28-17, 5:42:00 PM
 *  Author: K. C. Lee
 * Copyright (c) 2017 by K. C. Lee
 
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

#include "hardware.h"

KBD_States PS2;
Hotkey_State Hotkeys;

uint8_t Micro_Timer1,Milli_Timer1,Milli_Timer2,Milli_Divider;

const uint8_t Mux_Tbl[]=
{
	// 		USB Mux								HDMI Mux
	0x01 << USB_SHIFT,	// 	00	Output 1
	0x00 << USB_SHIFT,	//	01	No connect
	0x02 << USB_SHIFT,	//	10	Output 2
	0x03 << USB_SHIFT		//	11	Output 3
};

void Init_Hardware(void)
{
	CLK->CKDIVR = 0;										// Clk divider, CPU divider = 1
	EXTI->CR1 = (0x02 << 2);						// PB2 Interrupt: Falling edge
	PS2_PORT->CR2 = PS2_CLK;						// Enable PS2_CLK interrupt
	
	// Button: open drain, USB: Push/pull; HDMI_S1, HDMI_S2: input+pullup
	HDMI_PORT->DDR = HDMI_SW|USB_IN1|USB_IN2;
	HDMI_PORT->CR1 = HDMI_S1|HDMI_S2|USB_IN1|USB_IN2;
	
	// unused GPIO defaults to output, push-pull
	GPIOA->CR1 = GPIOA->DDR = PA1|PA2|PA3;
	GPIOD->CR1 = GPIOD->DDR = PD1|PD2|PD3|PD4;
	
	// tim4 8-bit timer: Auto-reload, update = over/under flow, Counter enable
	TIM4->CR1 = TIM4_CR1_ARPE|TIM4_CR1_URS|TIM4_CR1_CEN;

	TIM4->IER = TIM4_IER_UIE;					// Update IRQ enable
	TIM4->PSCR = TIM4_PSCR;						// TIM4: 16MHz/2^TIM4_PSCR
	TIM4->ARR = TIM4_ARR;							// Auto-reload
	
	// IRQ4 (PORTB PS2 CLK) = level 3 (high)
	ITC->ISPR2 = 0x03;
	// Rest of IRQ level 0 (low)
	ITC->ISPR1 = ITC->ISPR3 = ITC->ISPR4 = ITC->ISPR5 = ITC->ISPR6 = 0x00;
	
	PS2.State = PS2_Idle;
	
	Hotkeys.State = HK_Idle;
	Hotkeys.KeyAttr = 0;
	// Turn on interrupts
	rim();
}

// Low priority timer interrupt: 10kHz
@far @interrupt void TIM4_IRQ(void)
{
	TIM4->SR1 &= ~TIM4_SR1_UIF;				// Clear update IRQ
	
	if(Micro_Timer1)
		Micro_Timer1--;

	if(Milli_Divider)
		Milli_Divider--;
	else
	{																	// 100Hz interrupt
		if(Milli_Timer1)
			Milli_Timer1--;			

		if(Milli_Timer2)								// HDMI button
			Milli_Timer2--;
		else
			HDMI_PORT->ODR |= HDMI_SW;		// Clear select button

		Milli_Divider = MILLI_DIVIDER_RELOAD;
	}
}

@far @interrupt void PORTB_IRQ(void)
{		
	if((PS2.State == PS2_Idle)||(!Micro_Timer1))	// Start bit or resynchronized
	{
		// rewind timer
		Micro_Timer1 = us_TO_TICKS(PS2_BIT_TIMEOUT);
		// first bit determines source: keyboard or PC
		PS2.State = (PS2_PORT->IDR & PS2_DATA)?PS2_CMD_1:PS2_KBD_1;
	}
	else
	{	
		if(PS2.State++ & PS2_KBD)											// Scan/respond code
		{
			if(PS2.State == PS2_KBD_LAST)
			{	
				PS2.Avail = 1;
				PS2.State = PS2_Idle;
			}
			else
			{
				PS2.ScanCode >>= 1;
				
				if(PS2_PORT->IDR & PS2_DATA)
					PS2.ScanCode |= 0x200;
			}
		}
		else																					// Ignore Cmd to keyboard
			if(PS2.State == PS2_CMD_LAST)
				PS2.State = PS2_Idle;
	}
}

// high level polling task
void PS2_Task(void)
{
	uint16_t ScanCode, Parity;
	uint8_t HDMI, USB;
	
	if(PS2.Avail)
	{
		// Critical section
		sim();
		ScanCode = PS2.ScanCode;
		PS2.Avail = 0;
		rim();
		
		Parity = PS2.ScanCode & 0x01;	
		ScanCode = (ScanCode >> 1) & 0xff;
		
		if (ScanCode == PS2_KBD_CODE_RELEASE)
			Hotkeys.KeyAttr |= Key_Release;
		else if (ScanCode == PS2_KBD_CODE_EXTENDED)
			Hotkeys.KeyAttr |= Key_Extend;
		else
		{
			switch(Hotkeys.State)
			{
				case HK_Idle:					// wait for hot key press
				  if((ScanCode == HOTKEY_SCANCODE) && !Hotkeys.KeyAttr)
					{
						Hotkeys.State = HK_KeyMake_1;
						Milli_Timer1 = HOTKEY_RELEASE_DELAY;
						return;
					}
					break;
					
				case HK_KeyMake_1:		// wait for hot key release instead of hold
				  if((ScanCode == HOTKEY_SCANCODE) && (Hotkeys.KeyAttr==Key_Release) && Milli_Timer1)
					{
						Hotkeys.KeyAttr = 0;
						Hotkeys.State = HK_KeyBreak_1;
						Milli_Timer1 = HOTKEY_WAIT_DELAY;				
						return;
					}
					else
						Hotkeys.State = HK_Idle;
					break;
					
				case HK_KeyBreak_1:		// wait for hot key release
				  if((ScanCode == HOTKEY_SCANCODE) && !Hotkeys.KeyAttr && Milli_Timer1)
					{
						Hotkeys.State = HK_KeyMake_2;
						Milli_Timer1 = HOTKEY_RELEASE_DELAY;				
						return;
					}
					else
						Hotkeys.State = HK_Idle;
					break;
					
				case HK_KeyMake_2:		// wait for hot key press again
				  if((ScanCode == HOTKEY_SCANCODE) && (Hotkeys.KeyAttr==Key_Release) && Milli_Timer1)
					{	
						HDMI_PORT->ODR &= ~HDMI_SW;						// Press select button(active low)	
					  Milli_Timer2 = HDMI_SW_DELAY;					// hold for delay
					}
					else
						Hotkeys.State = HK_Idle;
					
					break;	
			}
			
			// default to idle
			Hotkeys.State = HK_Idle;
			Hotkeys.KeyAttr = 0;
		}
	}
	
	HDMI = (HDMI_PORT->IDR & HDMI_SEL_MASK)>>HDMI_SHIFT;
	// HDMI Mux setting mapped to USB
	USB = Mux_Tbl[HDMI];
	
	// filters out inactive HDMI, update when USB is not adready the same port
	if(((HDMI!= HDMI_NO_CONNECT)&&(HDMI_PORT->ODR & USB_SEL_MASK)!= USB))
	{
		// Make the Read-Modify-Write I/O atomic
		sim();
		HDMI_PORT->ODR = (HDMI_PORT->ODR & HDMI_SW)|USB;
		rim();
	}
}
