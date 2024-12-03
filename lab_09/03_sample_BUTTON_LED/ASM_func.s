        AREA compute_states, CODE, READONLY

next_state
        EXPORT next_state       ; Esporta la funzione per l'utilizzo esterno
        PUSH    {LR}            ; Salva il link register (LR) per il ritorno

        ; *** Inizializzazione delle variabili ***
        MOV     R3, #0          ; R3 = output_bit, inizialmente impostato a 0
        MOV     R12, R0         ; R12 = copia di current_state per manipolazioni
        MOV     R4, #8          ; R4 = contatore di bit (8-bit LFSR)

compute_output_bit
        ; *** Controlla se il tap corrente è attivo ***
        ANDS    R5, R1, #1      ; R5 = LSB di taps (bit meno significativo di taps)
        BEQ     next_tap        ; Salta al prossimo bit se il tap non è attivo

        ; *** XOR tra output_bit e bit corrente dello stato ***
        ANDS    R6, R12, #1     ; R6 = LSB di current_state (estrai il bit meno significativo)
        EOR     R3, R3, R6      ; XOR tra R3 (output_bit) e R6 (bit del current_state)

next_tap
        ; *** Shift dei taps e dello stato ***
        LSRS    R1, R1, #1      ; Sposta i taps a destra di 1 posizione
        LSRS    R12, R12, #1    ; Sposta la copia di current_state a destra di 1 posizione

        ; *** Decrementa il contatore di bit ***
        SUBS    R4, R4, #1      ; Decrementa il contatore dei bit (R4)
        BNE     compute_output_bit ; Ripeti finché tutti gli 8 bit sono elaborati

        ; *** Memorizza il bit di output ***
        STR     R3, [R2]        ; Salva il valore calcolato di output_bit nella memoria puntata da R2

        ; *** Calcola il nuovo stato ***
        LSRS    R0, R0, #1      ; Sposta current_state a destra (per eliminare il bit meno significativo)
        ORR     R0, R0, R3, LSL #7 ; Inserisce output_bit come MSB (bit più significativo)

        ; *** Mantieni il risultato entro 8 bit ***
        AND     R0, R0, #0xFF   ; Applica una maschera per limitare R0 a 8 bit

        ; *** Ritorna ***
        POP     {LR}            ; Ripristina il link register (LR)
        BX      LR              ; Ritorna alla funzione chiamante con il nuovo stato in R0

        END
