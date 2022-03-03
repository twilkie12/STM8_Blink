#include "gpio_func.h"

void toggle_gpiob5( void )
{
	GPIOB->ODR ^= GPIO_PIN_5;
	return;
}