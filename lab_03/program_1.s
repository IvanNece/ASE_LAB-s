        .data
v1:     .double   4.1237, 7.2843, 16.3742, 54.2031, 8.7294, 32.1845, 5.1187, 11.3562
        .double   6.5764, 36.0248, 1.8475, 8.5032, 15.1726, 12.6404, 27.3122, 10.8361
        .double   30.4396, 16.1855, 8.3721, 1.7280, 54.6528, 18.8341, 7.5443, 75.0833
        .double   20.4496, 13.0845, 4.3121, 21.7080, 4.6028, 9.0341, 17.5443, 45.0533

v2:     .double   3.7232, 6.2248, 23.8485, 4.3978, 22.0188, 2.8833, 15.0118, 11.2382
        .double   0.4396, 70.1855, 22.3241, 20.0080, 4.8267, 15.7142, 7.2367, 5.0835
        .double   1.2391, 13.3466, 8.8821, 41.7120, 50.8030, 0.0111, 16.9008, 1.9533
        .double   28.2391, 14.3440, 3.4321, 21.1131, 6.2730, 3.0111, 11.0008, 34.9133

v3:     .double   26.2491, 33.8932, 68.9821, 0.9120, 30.8030, 9.0111, 17.0068, 2.9882
        .double   44.7142, 81.2248, 33.8485, 5.8578, 66.0188, 5.9575, 17.9118, 9.2472
        .double   84.7142, 21.2248, 13.8485, 25.8578, 6.0188, 26.3585, 88.9118, 19.2172
        .double   41.7142, 79.2248, 29.8485, 4.8578, 59.0188, 36.5575, 29.9118, 9.9002

b:      .double   3.3333

v4:     .space 256  ; spazio per memorizzare 32 valori double per v4
v5:     .space 256  ; spazio per memorizzare 32 valori double per v5
v6:     .space 256  ; spazio per memorizzare 32 valori double per v6

        .code
main:   daddi r2, r2, 256       ; imposta r2 per puntare alla fine degli array
        daddui r5, r5, 8        ; r5 usato come decremento per spostarsi all'elemento precedente (ogni valore è 8 byte)
        daddui r3, r0, 24       ; r3 = 3 * 8 per lavorare su indici multipli di 3
        daddi r6, r6, 1         ; m inizializzato a 1 in r6
        l.d F10, b(r0)          ; carica il valore di b in F10

for:    dsub r2, r2, r5         ; decrementa r2 per accedere all'elemento precedente

if:     ddiv r7, r2, r3         ; controlla se l'indice è divisibile per 3
        dmul r7, r7, r3         ; ricalcola l'indice con il risultato della divisione
        l.d F1, v1(r2)          ; carica il valore di v1[i] in F1
       

        bne r7, r2, else        ; se non è divisibile per 3, salta a 'else'

        ; Operazione se l'indice è divisibile per 3
        ; a = v1[i] / ((double) m << i) (spostamento logico)

        dsllv r6, r6, r2        ; esegui lo shift a sinistra di m in base a i
        mtc1 r6, F7             ; sposta il valore intero da r6 a F7
        cvt.d.l F7, F7          ; converte il valore intero in double precision
        div.d F8, F1, F7        ; F8 = v1[i] / (double)(m << i)

        j castM

else:   dmul r6, r6, r2         ; se l'indice non è divisibile per 3, moltiplica m per i
        mtc1 r6, F7             ; sposta il risultato in F7
        cvt.d.l F7, F7          ; converte m * i in double precision
        mul.d F8, F1, F7        ; a = v1[i] * (double)(m * i)

        ; m = (int) a
castM:  cvt.l.d F9, F8          ; converte il valore double in intero
        mfc1 r6, F9             ; sposta il risultato in r6

        l.d F2, v2(r2)          ; carica v2[i] in F2
        l.d F3, v3(r2)          ; carica v3[i] in F3

        ; v4[i] = a * v1[i] – v2[i]
        mul.d F14, F8, F1       ; F14 = a * v1[i]
        sub.d F4, F14, F2       ; F4 = F14 - v2[i]
        s.d F4, v4(r2)          ; salva il risultato in v4[i]

        ; v5[i] = v4[i] / v3[i] – b
        div.d F15, F4, F3       ; F15 = v4[i] / v3[i]
        sub.d F5, F15, F10      ; F5 = F15 - b
        s.d F5, v5(r2)          ; salva il risultato in v5[i]

        ; v6[i] = (v4[i] - v1[i]) * v5[i]
        sub.d F16, F4, F1       ; F16 = v4[i] - v1[i]
        mul.d F6, F16, F5       ; F6 = F16 * v5[i]
        s.d F6, v6(r2)          ; salva il risultato in v6[i]

        bnez r2, for            ; se r2 != 0, continua il ciclo
        nop

end:    halt                    ; termina il programma
