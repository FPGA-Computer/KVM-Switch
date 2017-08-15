/*
 * stm8_interrupt_vector.c
 *
 * Created: February-03-17, 4:56:38 PM
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

#include "irq.h"
#include "stm8_interrupt_vector.h"

typedef struct
{
	unsigned char irq;
	void @far (*irq_handler)(void);
} irq_vectors;

extern void _stext();
@far @interrupt void Default_IRQ_Handler(void)
{
}

const irq_vectors _vectab[] =
{
	{0x82,(void @far (*)(void))_stext}, /* reset */
	{0x82,TRAP},   // trap
  {0x82,IRQ0},   // irq0
  {0x82,IRQ1},   // irq1
  {0x82,IRQ2},   // irq2
  {0x82,IRQ3},   // irq3
  {0x82,IRQ4},   // irq4
  {0x82,IRQ5},   // irq5
  {0x82,IRQ6},   // irq6
  {0x82,IRQ7},   // irq7
  {0x82,IRQ8},   // irq8
  {0x82,IRQ9},   // irq9
  {0x82,IRQ10},  // irq10
  {0x82,IRQ11},  // irq11
  {0x82,IRQ12},  // irq12
  {0x82,IRQ13},  // irq13
  {0x82,IRQ14},  // irq14
  {0x82,IRQ15},  // irq15
  {0x82,IRQ16},  // irq16
  {0x82,IRQ17},  // irq17
  {0x82,IRQ18},  // irq18
  {0x82,IRQ19},  // irq19
  {0x82,IRQ20},  // irq20
  {0x82,IRQ21},  // irq21
  {0x82,IRQ22},  // irq22
  {0x82,IRQ23},  // irq23
  {0x82,IRQ24},  // irq24
  {0x82,IRQ25},  // irq25
  {0x82,IRQ26},  // irq26
  {0x82,IRQ27},  // irq27
  {0x82,IRQ28},  // irq28
  {0x82,IRQ29},  // irq29
};
