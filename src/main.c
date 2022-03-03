#include "headers.h"
#include "gpio_func.h"

int main ( void )
{
	CLK->CKDIVR = 0x03;	//	Clock divider

	// Setting up GPIO
	GPIOB->DDR = GPIO_PIN_4 | GPIO_PIN_5;
	GPIOB->CR1 = GPIO_PIN_4 | GPIO_PIN_5;
	GPIOB->CR2 = GPIO_PIN_4 | GPIO_PIN_5;

	GPIOB->ODR |= GPIO_PIN_4;

	// Uncommenting the below line will break debugging
	// GPIOB->ODR ^= GPIO_PIN_4;
	GPIOB->ODR ^= GPIO_PIN_4;
	GPIOB->ODR ^= GPIO_PIN_4;
	GPIOB->ODR ^= GPIO_PIN_4;
	GPIOB->ODR ^= GPIO_PIN_4;
	GPIOB->ODR ^= GPIO_PIN_4;
	GPIOB->ODR ^= GPIO_PIN_4;
	GPIOB->ODR ^= GPIO_PIN_4;
	GPIOB->ODR ^= GPIO_PIN_4;
	GPIOB->ODR ^= GPIO_PIN_4;
	GPIOB->ODR ^= GPIO_PIN_4;
	GPIOB->ODR ^= GPIO_PIN_4;
	GPIOB->ODR ^= GPIO_PIN_4;
	GPIOB->ODR ^= GPIO_PIN_4;
	GPIOB->ODR ^= GPIO_PIN_4;
	GPIOB->ODR ^= GPIO_PIN_4;
	GPIOB->ODR ^= GPIO_PIN_4;
	GPIOB->ODR ^= GPIO_PIN_4;
	GPIOB->ODR ^= GPIO_PIN_4;
	GPIOB->ODR ^= GPIO_PIN_4;
	GPIOB->ODR ^= GPIO_PIN_4;
	GPIOB->ODR ^= GPIO_PIN_4;
	GPIOB->ODR ^= GPIO_PIN_4;
	GPIOB->ODR ^= GPIO_PIN_4;
	GPIOB->ODR ^= GPIO_PIN_4;
	GPIOB->ODR ^= GPIO_PIN_4;
	GPIOB->ODR ^= GPIO_PIN_4;
	GPIOB->ODR ^= GPIO_PIN_4;
	GPIOB->ODR ^= GPIO_PIN_4;
	GPIOB->ODR ^= GPIO_PIN_4;
	GPIOB->ODR ^= GPIO_PIN_4;
	GPIOB->ODR ^= GPIO_PIN_4;
	GPIOB->ODR ^= GPIO_PIN_4;
	GPIOB->ODR ^= GPIO_PIN_4;
	GPIOB->ODR ^= GPIO_PIN_4;
	GPIOB->ODR ^= GPIO_PIN_4;

	uint16_t i = 1;

	while ( 1 )
	{
		toggle_gpiob5();
		GPIOB->ODR ^= GPIO_PIN_4;
		while(i){i++;}	
		i++;
		toggle_gpiob5();
		GPIOB->ODR ^= GPIO_PIN_4;
		while(i){i++;}	
		i++;
	}
}