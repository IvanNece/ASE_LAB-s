#include "button.h"
#include "lpc17xx.h"
#include "../led/led.h"

#define LED_PORT LPC_GPIO2      // Porta GPIO2 utilizzata per controllare i LED
#define LED_MASK 0x000000FF     // Maschera per limitare l'uso degli 8 LED (bit 0-7)

// Definizioni principali
unsigned char state = 0xAA;     // Stato iniziale dell'LFSR (seed 0b10101010)
// Variabili volatili per garantire che non vengano ottimizzate dal compilatore
volatile unsigned char initial_state = 0xAA;	// Stato iniziale per verificare il ciclo (esercizio 1.b)
volatile unsigned char taps = 0x1D;            // Taps iniziali per l'LFSR (taps nei bit 0, 2, 3, 4)
int output_bit = 0;                            // Bit di output calcolato dall'LFSR

// Funzione esterna implementata in assembly (calcolo dello stato successivo dell'LFSR)
extern unsigned char next_state(unsigned char current_state, unsigned char taps, int *output_bit);

/**
 * Funzione per visualizzare lo stato corrente sui LED
 * @param state Stato attuale (unsigned char, 8 bit)
 */
void display_state(unsigned char state) {
    // Pulisce lo stato precedente sui LED
    LED_PORT->FIOCLR = LED_MASK; // Spegne tutti i LED
    // Imposta lo stato corrente sui LED
    LED_PORT->FIOSET = state;
}

/**
 * Gestore dell'interrupt per il pulsante KEY0 (EINT0)
 * Accende un LED (solo per debugging o segnalazione)
 */
void EINT0_IRQHandler (void)	  
{
	LED_On(0);                     // Accendi il LED 0 come indicatore
    LPC_SC->EXTINT &= (1 << 0);    // Pulisce l'interrupt in sospeso
}

/**
 * Ritardo per gestire il debounce del pulsante
 * (evita rimbalzi elettrici durante la pressione del tasto)
 */
void debounce_delay(void) {
	volatile uint32_t i = 0;
    for (i = 0; i < 1000000; i++) {
        __NOP(); // Istruzione di No Operation (ritardo vuoto)
    }
}

/**
 * Gestore dell'interrupt per il pulsante KEY1 (EINT1)
 * Calcola il prossimo stato dell'LFSR e aggiorna i LED
 */
void EINT1_IRQHandler (void)	  
{
	debounce_delay();              // Gestione del debounce
	
	// Calcola lo stato successivo usando la funzione next_state
	state = next_state(state, taps, &output_bit);
	
	// Mostra lo stato aggiornato sui LED
	display_state(state);
	
	LPC_SC->EXTINT &= (1 << 1);    // Pulisce l'interrupt in sospeso
}

/**
 * Funzione per gestire la sequenza LFSR fino a tornare allo stato iniziale
 */
void key2_state() {
    do {
        // Calcola il prossimo stato
        state = next_state(state, taps, &output_bit);
        
				debounce_delay();     // Attendi
        // Effetto visivo: accendi temporaneamente tutti i LED
        display_state(0xFF);  // Accendi tutti i LED
        
        
        // Mostra lo stato corrente sui LED
        display_state(state);
        debounce_delay();     // Attendi
    } while (state != initial_state); // Continua finché non ritorni allo stato iniziale
}

/**
 * Gestore dell'interrupt per il pulsante KEY2 (EINT2)
 * Esegue la sequenza LFSR completa e verifica il ritorno allo stato iniziale
 */
void EINT2_IRQHandler (void)	  
{	
	debounce_delay();             // Gestione del debounce
	
	key2_state();                 // Esegui la sequenza fino al ritorno allo stato iniziale
	
    LPC_SC->EXTINT &= (1 << 2);   // Pulisce l'interrupt in sospeso
}
