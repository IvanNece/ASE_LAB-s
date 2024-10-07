        .data
v1:     .byte 2, 6, -3, 11, 9, 18, -13, 16, 5, 1
v2: 	.byte 4, 2, -13, 3, 9, 9, 7, 16, 4, 7
v3: 	.space 10       ; Allocare spazio per il terzo array (massimo 10 elementi)
flag1: 	.space 1
flag2: 	.space 1
flag3: 	.space 1


        .text
        ; Inizializza i registri per gli indirizzi di v1, v2, v3 e i contatori
        daddui  r1, r0, v1       ; Indirizzo del primo elemento di v1
        daddui  r2, r0, v2       ; Indirizzo del primo elemento di v2
        daddui  r3, r0, v3       ; Indirizzo del primo elemento di v3
        daddui  r4, r0, 0        ; Contatore per v1 (i)
        daddui  r5, r0, 0        ; Contatore per v3 (indice di v3)

        ; Carica le lunghezze di v1 e v2
        daddui  r6, r0, 10       ; Lunghezza di v1
        daddui  r7, r0, 10       ; Lunghezza di v2

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

        ; Verifica se v3 è vuoto e imposta flag1
        daddui  r14, r0, 0        ; Inizializza contatore per verificare elementi in v3
        daddui  r15, r0, v3       ; Indirizzo del primo elemento di v3
        daddui  r16, r0, 1        ; Inizializza flag1 a 1 (ipotesi: v3 vuoto)

check_v3_empty:
        beq     r14, r5, set_flag1 ; Se il contatore ha raggiunto l'indice attuale di v3, termina
        lb      r17, 0(r15)       ; Carica il valore corrente di v3
        bne     r17, r0, v3_not_empty ; Se il valore è diverso da 0, v3 non è vuoto
        daddui  r15, r15, 1       ; Incrementa il puntatore di v3
        daddui  r14, r14, 1       ; Incrementa il contatore
        j       check_v3_empty    ; Continua a controllare

v3_not_empty:
        daddui  r16, r0, 0        ; Imposta flag1 a 0 se v3 non è vuoto

set_flag1:
        sb      r16, flag1(r0)    ; Salva il valore di flag1

        ; Verifica se gli elementi di v3 sono in ordine crescente o decrescente
        beqz    r5, end_check_flags ; Se v3 è vuoto, salta la verifica dei flag2 e flag3

        daddui  r14, r0, v3       ; Inizializza il puntatore di v3
        daddui  r15, r14, 1       ; Puntatore al secondo elemento di v3
        daddui  r18, r0, 1        ; Inizializza flag2 a 1 (ipotesi: crescente)
        daddui  r19, r0, 1        ; Inizializza flag3 a 1 (ipotesi: decrescente)

check_v3_order:
        slt     r20, r15, r3      ; Verifica se siamo ancora entro la lunghezza di v3
        beqz    r20, set_flags2_3 ; Se abbiamo controllato tutti gli elementi, imposta i flag

        lb      r21, 0(r14)       ; Carica l'elemento corrente di v3
        lb      r22, 0(r15)       ; Carica il prossimo elemento di v3

        ; Verifica se v3[i+1] > v3[i]
        slt     r23, r21, r22
        beqz    r23, not_increasing ; Se non è vero, disabilita flag2
        j       check_decreasing

not_increasing:
        daddui  r18, r0, 0        ; Disabilita flag2

check_decreasing:
        ; Verifica se v3[i+1] < v3[i]
        slt     r23, r22, r21
        beqz    r23, not_decreasing ; Se non è vero, disabilita flag3
        j       update_pointers

not_decreasing:
        daddui  r19, r0, 0        ; Disabilita flag3

update_pointers:
        daddui  r14, r14, 1       ; Incrementa il puntatore per il valore corrente
        daddui  r15, r15, 1       ; Incrementa il puntatore per il prossimo valore
        j       check_v3_order    ; Continua la verifica

set_flags2_3:
        sb      r18, flag2(r0)    ; Salva il valore di flag2
        sb      r19, flag3(r0)    ; Salva il valore di flag3

end_check_flags:
        ; Fine del programma
        halt                      ; Termina l'esecuzione

        
