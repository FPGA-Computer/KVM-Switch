#include "hardware.h"

KBD_States PS2;
Hotkey_State Hotkeys;

uint8_t Micro_Timer1,Milli_Timer1,Milli_Divider;

void Init_Hardware(void)
{
	CLK->CKDIVR = 0;									// Clk divider, CPU divider = 1
	EXTI->CR1 = 0x02 << 2;						// PB2 Interrupt: Falling edge
	PS2_PORT->CR2 = PS2_CLK;					// Enable PS2_CLK interrupt
	
	// All GPIO defaults to output, push-pull
	GPIOA->CR1 = GPIOA->DDR = PA1|PA2|PA3;
	GPIOC->CR1 = GPIOC->DDR = PC3|PC4|PC5|PC6|PC7;
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
	
	Init_Serial();
	
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
				case HK_Idle:
				  if((ScanCode == HOTKEY_SCANCODE) && !Hotkeys.KeyAttr)
					{
						Hotkeys.State = HK_KeyMake_1;
						Milli_Timer1 = HOTKEY_RELEASE_DELAY;
						return;
					}
					break;
					
				case HK_KeyMake_1:
				  if((ScanCode == HOTKEY_SCANCODE) && (Hotkeys.KeyAttr==Key_Release) && Milli_Timer1)
					{
						Hotkeys.KeyAttr = 0;
						Hotkeys.State = HK_KeyBreak_1;
						Milli_Timer1 = HOTKEY_WAIT_DELAY;				
						return;
					}
					break;
					
				case HK_KeyBreak_1:
				  if((ScanCode == HOTKEY_SCANCODE) && !Hotkeys.KeyAttr && Milli_Timer1)
					{
						Hotkeys.State = HK_KeyMake_2;
						Milli_Timer1 = HOTKEY_RELEASE_DELAY;				
						return;
					}
					break;
					
				case HK_KeyMake_2:
				  if((ScanCode == HOTKEY_SCANCODE) && (Hotkeys.KeyAttr==Key_Release) && Milli_Timer1)
					{						
						PutC('!');
						NewLine();				
					}
					break;	
			}
			
			// default to idle
			Hotkeys.State = HK_Idle;
			Hotkeys.KeyAttr = 0;
		}
	}
}

void Init_Serial(void)
{
	UART1->BRR2 = UART_BRR2;
	UART1->BRR1 = UART_BRR1;
	// tx, rx enable
	UART1->CR2 = UART1_CR2_TEN|UART1_CR2_REN;
}

uint8_t GetC(void)
{
	while(!Poll_Serial())
	  ;
	return(UART1->DR);
}

void PutC(uint8_t ch)
{
	while(!(UART1->SR & UART1_SR_TXE))
	  ;
	UART1->DR = ch;
}

void Puthex(uint8_t n)
{ PutC((n<10)?n+'0':n-10+'A');
 }

void Puthex2(uint8_t n)
{ Puthex(n>>4);
  Puthex(n&0x0f);
 }

void Puthex4(uint16_t n)
{ Puthex2(n>>8);
  Puthex2(n&0xff);
 }
 
void NewLine(void)
{ PutC('\x0d');
  PutC('\x0a');
 }
 