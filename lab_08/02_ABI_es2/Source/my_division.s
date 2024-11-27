                AREA division, CODE, READONLY    ; Definisce una sezione di codice chiamata "division"
                EXPORT my_division               ; Esporta la funzione my_division per uso esterno

my_division     PROC
                ; Salva i registri volatili e il link register (LR)
                PUSH    {r4-r7, LR}              ; Salva R4-R7 e LR per preservare il contesto del chiamante

                ; Importa la funzione di libreria ARM per la divisione floating-point
                IMPORT  __aeabi_fdiv             ; Dichiarazione della funzione di libreria __aeabi_fdiv

                ; Esegue la divisione floating-point
                ; I parametri della funzione (numeratore e denominatore) sono già in R0 e R1
                LDR     r4, =__aeabi_fdiv        ; Carica l'indirizzo della funzione __aeabi_fdiv in R4
                BLX     r4                       ; Salta alla funzione __aeabi_fdiv (branch and link exchange)

                ; Il risultato della divisione è automaticamente restituito in R0

                ; Ripristina i registri salvati e ritorna al chiamante
                POP     {r4-r7, PC}              ; Ripristina R4-R7 e salta all'indirizzo di ritorno (PC)
                ENDP

                END                              ; Fine del file assembly
