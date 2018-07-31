#include "hardware.h"

void main(void)
{
	Init_Hardware();
	
	while(1)
	{
		PS2_Task();
	}
}
