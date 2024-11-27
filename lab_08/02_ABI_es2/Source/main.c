// Dichiarazione di funzioni assembly e variabili esterne
extern int check_square(int x, int y, int r);     // Verifica se un punto è dentro o sul bordo di un cerchio
extern float my_division(float a, float b);       // Esegue una divisione floating-point

// Dichiarazione di variabili esterne per la matrice e le dimensioni
extern int _Matrix_Coordinates;                  // Matrice di coordinate (puntatore alla memoria)
extern int _ROWS;                                // Numero di righe nella matrice
extern int _COLUMNS;                             // Numero di colonne nella matrice

extern int _Opt_M_Coordinates;                   // Matrice ottimizzata per i risultati

volatile int raggio = 3;                         // Raggio del cerchio (costante per il calcolo)

int main(void) {
    // Dichiarazione delle variabili locali
    int x, y;                                    // Variabili per le coordinate (x, y)
    int* matrix = &_Matrix_Coordinates;          // Puntatore al primo elemento della matrice
    volatile int i, j;                           // Variabili per i loop sulle righe e colonne
    int sum = 0;                                 // Somma dei punti dentro il cerchio
    int rows = 11;                               // Numero di righe della matrice
    int columns = 22;                            // Numero di colonne della matrice

    // Itera sulla matrice per calcolare i punti all'interno del cerchio
    for (i = 0; i < rows; i++) {                 // Itera sulle righe
        for (j = 0; j < columns; j += 2) {       // Itera sulle colonne (considerando coppie x, y)
            x = matrix[i * columns + j];         // Estrae la coordinata x dalla matrice
            y = matrix[i * columns + j + 1];     // Estrae la coordinata y dalla matrice
            sum += check_square(x, y, raggio);   // Aggiunge 1 a sum se il punto è nel cerchio, 0 altrimenti
        }
    }

    // Calcola l'approssimazione di p (pi) usando la divisione floating-point
    float raggio_quadro = (float)raggio * (float)raggio; // Calcola r^2
    float final_result = my_division((float)sum, raggio_quadro); // p ˜ Area / r^2

    return 0;                                   // Termina il programma
}


