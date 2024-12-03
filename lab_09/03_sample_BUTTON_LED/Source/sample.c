/*----------------------------------------------------------------------------
 * Name:    sample.c
 * Purpose: to control led through EINT buttons 
 *        	- key1 switches on LED10 
 *				  - key2 switches off all LEDs 
 *			    - int0 switches on LED 11
 * Note(s): this version supports the LANDTIGER Emulator
 * Author: 	Paolo BERNARDI - PoliTO - last modified 07/12/2020
 *----------------------------------------------------------------------------
 *
 * This software is supplied "AS IS" without warranties of any kind.
 *
 * Copyright (c) 2017 Politecnico di Torino. All rights reserved.
 *----------------------------------------------------------------------------*/
                  
#include <stdio.h>
#include "LPC17xx.H"                    /* LPC17xx definitions                */
#include "led/led.h"
#include "button_EXINT/button.h"

/* Led external variables from funct_led */
extern unsigned char led_value;					/* defined in funct_led								*/
#ifdef SIMULATOR
extern uint8_t ScaleFlag; // <- ScaleFlag needs to visible in order for the emulator to find the symbol (can be placed also inside system_LPC17xx.h but since it is RO, it needs more work)
#endif

/*----------------------------------------------------------------------------
  Main Program
 *----------------------------------------------------------------------------*/
 
int main (void) {
  
  SystemInit();  												/* Inizializzazione del sistema (es. configurazione PLL) */
  LED_init();                           /* Inizializzazione dei LED per la visualizzazione dello stato */
  BUTTON_init();												/* Inizializzazione dei pulsanti per l'interazione */
	
	// Stato iniziale (seed) dell'LFSR: utilizziamo un unsigned char per rappresentare 8 bit
	unsigned char current_state = 0b10101010;
	
	// Mostra lo stato iniziale attraverso i LED
	display_state(current_state);
	
	while (1) {                           /* Loop infinito per eseguire il programma continuamente */	
  }

}

