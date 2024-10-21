    .data
v1: .double 0.99783045, 0.00017023, 0.16671799, 0.0709082, 0.61242463, 0.42469133, 0.17273317, 0.73215372
    .double 0.62463407, 0.33296767, 0.70504857, 0.57059103, 0.74400094, 0.99591749, 0.60278553, 0.17190698
    .double 0.23427507, 0.54117202, 0.1869301, 0.08358128, 0.13213843, 0.89589847, 0.36772047, 0.91563748
    .double 0.8501072, 0.19525894, 0.19471852, 0.91940434, 0.02093211, 0.58199388, 0.42387424, 0.65274575

v2: .double 0.93657084, 0.07329205, 0.88915362, 0.16017189, 0.92359751, 0.81946783, 0.88028619, 0.34575858
    .double 0.6448122 , 0.39555511, 0.95773851, 0.81071946, 0.07811275, 0.18278347, 0.08607937, 0.08333185
    .double 0.94995279, 0.04145172, 0.48132502, 0.06408964, 0.67500968, 0.93156939, 0.07293358, 0.61116231
    .double 0.06100373, 0.86044989, 0.86806543, 0.3689608 , 0.62703852, 0.93207843, 0.23120963, 0.36967262

v3: .double 0.22298433, 0.71482593, 0.38926414, 0.40607433, 0.31468457, 0.01004551, 0.67125849, 0.80362581
    .double 0.09653675, 0.56257223, 0.04907831, 0.93897501, 0.00846443, 0.62413321, 0.22727698, 0.7578525 
    .double 0.04966427, 0.14349547, 0.02001605, 0.91046863, 0.92730684, 0.49839908, 0.37016745, 0.13606532
    .double 0.77308048, 0.62438734, 0.57767142, 0.14256951, 0.40664215, 0.85480691, 0.37757982, 0.17110586

v4: .space 256       ; Spazio allocato per memorizzare i risultati del vettore v4 (32 numeri a 8 byte ciascuno)
v5: .space 256       ; Spazio allocato per memorizzare i risultati del vettore v5
v6: .space 256       ; Spazio allocato per memorizzare i risultati del vettore v6

    .text
main:
    daddui  r1,r0,256   ; Inizializza r1 con il valore 256. Questo serve per puntare all'ultima posizione degli array v1, v2 e v3, poiché il ciclo processa gli array dall'ultima posizione alla prima.

loop:
    daddi   r1,r1,-8    ; Decrementa r1 di 8 (poiché ogni elemento di v1, v2, v3 è un numero a doppia precisione, 8 byte). Questo sposta il puntatore all'elemento precedente dell'array.

    l.d     f1,v1(r1)   ; Carica in f1 l'elemento corrente del vettore v1.
    l.d     f2,v2(r1)   ; Carica in f2 l'elemento corrente del vettore v2.
    l.d     f3,v3(r1)   ; Carica in f3 l'elemento corrente del vettore v3.

    mul.d   f4,f1,f1   
    sub.d   f4,f4,f2    
    div.d   f5,f4,f3    
    sub.d   f5,f5,f2    
    sub.d   f6,f4,f1   
    mul.d   f6,f6,f5    

    s.d     f4,v4(r1)   ; Salva il valore di f4 nell'array v4, nella posizione corrente puntata da r1.
    s.d     f5,v5(r1)   ; Salva il valore di f5 nell'array v5.
    s.d     f6,v6(r1)   ; Salva il valore di f6 nell'array v6.

    bnez    r1,loop     ; Se r1 non è zero, il ciclo continua. Questo controllerà se sono stati processati tutti gli elementi dell'array (32 elementi in totale). In ogni iterazione, r1 è decrementato di 8 finché non diventa zero.

    halt                ; Termina l'esecuzione del programma.
