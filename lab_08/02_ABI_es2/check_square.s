                AREA checksquare, CODE, READONLY    ; Definisce una sezione di codice chiamata "checksquare"
                EXPORT check_square                 ; Esporta la funzione per l'uso esterno

check_square    PROC
                ; Salva i registri volatili per preservare lo stato corrente
                PUSH {r4-r8, r10-r11, lr}           ; Salva R4-R8, R10-R11, e il link register (LR)

                ; La funzione riceve:
                ; R0 = x (coordinata x del punto)
                ; R1 = y (coordinata y del punto)
                ; R2 = r (raggio del cerchio)

                ; Calcola x^2 e salva in R7
                MUL     r7, r0, r0                  ; Moltiplica x per sé stesso: r7 = x^2

                ; Calcola y^2 e salva in R8
                MUL     r8, r1, r1                  ; Moltiplica y per sé stesso: r8 = y^2

                ; Somma x^2 e y^2
                ADD     r7, r7, r8                  ; Somma i valori: r7 = x^2 + y^2

                ; Calcola r^2 e salva in R9
                MUL     r9, r2, r2                  ; Moltiplica raggio per sé stesso: r9 = r^2

                ; Confronta x^2 + y^2 con r^2
                CMP     r7, r9                      ; Confronta r7 (x^2 + y^2) con r9 (r^2)

                ; Ritorna il risultato
                MOVLE   r0, #1                      ; Se x^2 + y^2 <= r^2, imposta R0 = 1 (il punto è dentro o sul bordo)
                MOVGT   r0, #0                      ; Altrimenti, imposta R0 = 0 (il punto è fuori)

                ; Ripristina i registri volatili e ritorna al chiamante
                POP     {r4-r8, r10-r11, pc}        ; Ripristina i registri e salta a LR
                ENDP

                END                                 ; Fine del file assembly
