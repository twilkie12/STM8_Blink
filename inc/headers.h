#ifndef _HEADERS_H_
#define _HEADERS_H_

// Need this part for intellisense to work properly, the part name comes from the header file
#ifndef PARTFAMILY
	#define PARTFAMILY
	#define STM8S207
#endif

#ifndef COMPILER_DEF
	#define COMPILER_DEF
	#define __SDCC__
#endif


#include "stm8l10x.h"
#include "stm8l10x_gpio.h"


#endif