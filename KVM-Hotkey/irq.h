@far @interrupt void PORTB_IRQ(void);
@far @interrupt void TIM4_IRQ(void);

#define IRQ4 	PORTB_IRQ
#define IRQ23	TIM4_IRQ
