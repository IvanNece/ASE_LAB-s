        .data
v1:     .byte 2, 6, -3, 11, 9, 18, -13, 16, 5, 1
v2: 	.byte 4, 2, -13, 3, 9, 9, 7, 16, 4, 7
v3: 	.space 10       ; Allocare spazio per il terzo array (massimo 10 elementi)
v1_len: .word   10      ; Lunghezza di v1
v2_len: .word   10      ; Lunghezza di v2
flag1: 	.space 1
flag2: 	.space 1
flag3: 	.space 1


        .code
        ; Inizializza i registri per gli indirizzi di v1, v2, v3 e i contatori
        daddui  r1, r0, v1       ; Indirizzo del primo elemento di v1
        daddui  r2, r0, v2       ; Indirizzo del primo elemento di v2
        daddui  r3, r0, v3       ; Indirizzo del primo elemento di v3
        daddui  r4, r0, 0        ; Contatore per v1 (i)
        daddui  r5, r0, 0        ; Contatore per v3 (indice di v3)
        lw      r6, v1_len       ; Carica la lunghezza di v1
        lw      r7, v2_len       ; Carica la lunghezza di v2


loop_v1:
        ; Controlla se abbiamo finito di processare tutti gli elementi di v1
        slt     r8, r4, r6       ; r8 = 1 se r4 < r6 (ci sono ancora elementi da controllare)
        beqz    r8, end_loop_v1  ; Se r8 è 0, esci dal ciclo (fine v1)

        ; Carica l'elemento corrente di v1
        lb      r9, 0(r1)        ; Carica il valore di v1[i] in r9

        ; Inizializza il contatore per v2
        daddui  r10, r0, 0       ; Contatore per v2 (j)
        daddui  r11, r2, 0       ; Puntatore all'inizio di v2

loop_v2:
        ; Controlla se abbiamo finito di processare tutti gli elementi di v2
        slt     r12, r10, r7     ; r12 = 1 se r10 < r7 (ci sono ancora elementi da controllare)
        beqz    r12, end_loop_v2 ; Se r12 è 0, esci dal ciclo (fine v2)

        ; Carica l'elemento corrente di v2
        lb      r13, 0(r11)      ; Carica il valore di v2[j] in r13

        ; Controlla se v1[i] == v2[j]
        bne     r9, r13, next_v2 ; Se non sono uguali, vai al prossimo elemento di v2

        ; Salva il valore in v3
        sb      r9, 0(r3)        ; Salva il valore di v1[i] in v3
        daddui  r3, r3, 1        ; Incrementa il puntatore di v3
        daddui  r5, r5, 1        ; Incrementa l'indice di v3
        j       end_loop_v2      ; Termina il ciclo di v2 dopo aver trovato una corrispondenza

next_v2:
        ; Passa al prossimo elemento di v2
        daddui  r11, r11, 1      ; Incrementa il puntatore di v2
        daddui  r10, r10, 1      ; Incrementa il contatore j
        j       loop_v2          ; Ritorna al ciclo di v2

end_loop_v2:
        ; Passa al prossimo elemento di v1
        daddui  r1, r1, 1        ; Incrementa il puntatore di v1
        daddui  r4, r4, 1        ; Incrementa il contatore i
        j       loop_v1          ; Ritorna al ciclo di v1

end_loop_v1:
        ; Fine del programma
        halt                    ; Termina l'esecuzione
        
