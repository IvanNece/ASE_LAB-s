        .data
v1: .double 52.487, 61.085, 18.624, 94.650, 66.113, 33.489, 55.874, 73.172, 38.443, 9.879
    .double 71.749, 59.844, 87.562, 79.072, 64.065, 65.163, 55.079, 44.366, 51.774, 56.525
    .double 83.058, 76.874, 72.301, 58.043, 95.284, 33.458, 41.687, 20.500, 46.504, 49.173
    .double 71.438, 34.996

v2: .double 38.570, 12.958, 70.106, 33.767, 40.894, 19.268, 29.481, 31.237, 57.527, 33.785
    .double 99.968, 20.035, 93.562, 25.897, 15.390, 0.998, 76.945, 58.759, 65.663, 71.380
    .double 32.636, 1.715, 68.171, 59.983, 13.680, 33.951, 61.927, 38.284, 44.806, 72.889
    .double 49.640, 98.787

v3: .double 77.985, 63.056, 75.137, 6.460, 53.056, 52.880, 94.323, 93.930, 37.982, 11.766
    .double 97.039, 33.758, 36.628, 37.835, 24.605, 57.820, 95.331, 9.667, 51.083, 67.017
    .double 57.841, 16.952, 86.225, 57.644, 94.608, 85.917, 94.536, 41.234, 26.334, 83.719
    .double 15.286, 76.898

v4: .space 512  ; Alloco un array vuoto per 64 double
v5: .space 512  ; 64x8 byte
v6: .space 512  ; 64x8 byte

        .text

        ; for (i = 31; i >= 0; i--){	
	;         v4[i] = v1[i]*v1[i] – v2[i];
	;         v5[i] = v4[i]/v3[i] – v2[i];
        ;         v6[i] = (v4[i]-v1[i])*v5[i];
        ; }


main:
        daddui  r1, r0, 248      ; Imposta i = 31, con 248 byte = 31 * 8 byte

loop_i:
        ; Carica v1[i], v2[i], e v3[i] (double precision)
        l.d     f0, v1(r1)       ; Carica v1[i] in f0
        l.d     f2, v2(r1)       ; Carica v2[i] in f2
        l.d     f4, v3(r1)       ; Carica v3[i] in f4

        ; v4[i] = v1[i] * v1[i] - v2[i]
        mul.d   f6, f0, f0       ; Moltiplica v1[i] * v1[i]
        sub.d   f6, f6, f2       ; Sottrai v2[i] -> v4[i]
        s.d     f6, v4(r1)       ; Salva v4[i]

        ; v5[i] = v4[i] / v3[i] - v2[i]
        div.d   f8, f6, f4       ; Divide v4[i] / v3[i]
        sub.d   f8, f8, f2       ; Sottrai v2[i] -> v5[i]
        s.d     f8, v5(r1)       ; Salva v5[i]

        ; v6[i] = (v4[i] - v1[i]) * v5[i]
        sub.d   f10, f6, f0      ; Sottrai v1[i] da v4[i]
        mul.d   f10, f10, f8     ; Moltiplica per v5[i] -> v6[i]
        s.d     f10, v6(r1)      ; Salva v6[i]

        ; Decrementa i (vai all'elemento precedente)
        daddui  r1, r1, -8       ; Decrementa il puntatore di v1 (double = 8 byte)

        ; Controlla se i >= 0
        bgez    r1, loop_i       ; Continua se non siamo arrivati alla fine del ciclo

        j       end              ; Fine del programma

end:
        halt                     ; Ferma l'esecuzione
