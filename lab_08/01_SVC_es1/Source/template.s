;            Computer Architectures - 02LSEOV 02LSEOQ            ;
; author: 		Paolo BERNARDI - Politecnico di Torino           ;
; creation: 	11 November 2018								 ;
; last update:  1 Dicember 2020								 ;
; functionalities:												 ;
;		nothing but bringing to the reset handler				 ;

; *------- <<< Use Configuration Wizard in Context Menu >>> ------------------

; <h> Stack Configuration
;   <o> Stack Size (in Bytes) <0x0-0xFFFFFFFF:8>
; </h>

Stack_Size      EQU     0x00000200  

                AREA    STACK, NOINIT, READWRITE, ALIGN=3
				
				SPACE   Stack_Size/2    ;MSP i primi 100
Stack_Mem       SPACE   Stack_Size/2 	;PSP gli altri 100
__initial_sp		




; <h> Heap Configuration
;   <o>  Heap Size (in Bytes) <0x0-0xFFFFFFFF:8>
; </h>

Heap_Size       EQU     0x00000200

                AREA    HEAP, NOINIT, READWRITE, ALIGN=3
__heap_base
Heap_Mem        SPACE   Heap_Size
__heap_limit


                PRESERVE8
                THUMB


; Vector Table Mapped to Address 0 at Reset

                AREA    RESET, DATA, READONLY
                EXPORT  __Vectors
												; 0x10000200
__Vectors       DCD     __initial_sp              ; Top of Stack
                DCD     Reset_Handler             ; Reset Handler
                DCD     NMI_Handler               ; NMI Handler
                DCD     HardFault_Handler         ; Hard Fault Handler
                DCD     MemManage_Handler         ; MPU Fault Handler
                DCD     BusFault_Handler          ; Bus Fault Handler
                DCD     UsageFault_Handler        ; Usage Fault Handler
                DCD     0                         ; Reserved
                DCD     0                         ; Reserved
                DCD     0                         ; Reserved
                DCD     0                         ; Reserved
                DCD     SVC_Handler               ; SVCall Handler
                DCD     DebugMon_Handler          ; Debug Monitor Handler
                DCD     0                         ; Reserved
                DCD     PendSV_Handler            ; PendSV Handler
                DCD     SysTick_Handler           ; SysTick Handler

                ; External Interrupts
                DCD     WDT_IRQHandler            ; 16: Watchdog Timer
                DCD     TIMER0_IRQHandler         ; 17: Timer0
                DCD     TIMER1_IRQHandler         ; 18: Timer1
                DCD     TIMER2_IRQHandler         ; 19: Timer2
                DCD     TIMER3_IRQHandler         ; 20: Timer3
                DCD     UART0_IRQHandler          ; 21: UART0
                DCD     UART1_IRQHandler          ; 22: UART1
                DCD     UART2_IRQHandler          ; 23: UART2
                DCD     UART3_IRQHandler          ; 24: UART3
                DCD     PWM1_IRQHandler           ; 25: PWM1
                DCD     I2C0_IRQHandler           ; 26: I2C0
                DCD     I2C1_IRQHandler           ; 27: I2C1
                DCD     I2C2_IRQHandler           ; 28: I2C2
                DCD     SPI_IRQHandler            ; 29: SPI
                DCD     SSP0_IRQHandler           ; 30: SSP0
                DCD     SSP1_IRQHandler           ; 31: SSP1
                DCD     PLL0_IRQHandler           ; 32: PLL0 Lock (Main PLL)
                DCD     RTC_IRQHandler            ; 33: Real Time Clock
                DCD     EINT0_IRQHandler          ; 34: External Interrupt 0
                DCD     EINT1_IRQHandler          ; 35: External Interrupt 1
                DCD     EINT2_IRQHandler          ; 36: External Interrupt 2
                DCD     EINT3_IRQHandler          ; 37: External Interrupt 3
                DCD     ADC_IRQHandler            ; 38: A/D Converter
                DCD     BOD_IRQHandler            ; 39: Brown-Out Detect
                DCD     USB_IRQHandler            ; 40: USB
                DCD     CAN_IRQHandler            ; 41: CAN
                DCD     DMA_IRQHandler            ; 42: General Purpose DMA
                DCD     I2S_IRQHandler            ; 43: I2S
                DCD     ENET_IRQHandler           ; 44: Ethernet
                DCD     RIT_IRQHandler            ; 45: Repetitive Interrupt Timer
                DCD     MCPWM_IRQHandler          ; 46: Motor Control PWM
                DCD     QEI_IRQHandler            ; 47: Quadrature Encoder Interface
                DCD     PLL1_IRQHandler           ; 48: PLL1 Lock (USB PLL)
                DCD     USBActivity_IRQHandler    ; 49: USB Activity interrupt to wakeup
                DCD     CANActivity_IRQHandler    ; 50: CAN Activity interrupt to wakeup


                IF      :LNOT::DEF:NO_CRP
                AREA    |.ARM.__at_0x02FC|, CODE, READONLY
CRP_Key         DCD     0xFFFFFFFF
                ENDIF


                AREA    |.text|, CODE, READONLY


; Reset Handler
Reset_Handler   PROC
                EXPORT  Reset_Handler             [WEAK] 
                IMPORT __main

                ; Questa è la funzione chiamata automaticamente all'avvio del microcontrollore
                ; dopo un reset. Si occupa di configurare lo stack, la modalità operativa
                ; e poi trasferire il controllo alla funzione `__main`.

                ; Configurazione iniziale del processore prima di eseguire `__main`
                
                ; Imposta il registro CONTROL per abilitare la modalità User e PSP
                MOV     R0, #3                    ; R0 = 3 (0011 in binario)
                                                ; Bit 0 = 1 -> Passa alla modalità User (non privilegiata)
                                                ; Bit 1 = 1 -> Usa il Process Stack Pointer (PSP)

                MSR     CONTROL, R0               ; Scrive il valore di R0 nel registro CONTROL
                                                ; Cambia la modalità operativa a User Mode e seleziona il PSP

                ; Configura lo Stack Pointer
                LDR     SP, =Stack_Mem            ; Carica l'indirizzo della memoria dello stack (PSP)
                                                ; nel registro SP. Questa memoria è definita nella sezione STACK
                                                ; ed è dedicata al contesto User Mode.

                ; Avvia il codice principale
                LDR     R0, =__main               ; Carica l'indirizzo della funzione `__main` nel registro R0
                                                ; La funzione `__main` è il punto di ingresso dell'ambiente C.
                                                ; Si occupa di inizializzare i segmenti dati e chiamare `main()`.

                BX      R0                        ; Salta all'indirizzo contenuto in R0 (cioè `__main`)
                                                ; BX garantisce che venga usata la modalità Thumb per il codice.
                
                ENDP                              ; Fine della funzione Reset_Handler

; Aggiunta di una Supervisor Call (SVC)
; Questa è un'istruzione di interruzione software che richiede un servizio privilegiato.
; Il numero SVC specifica quale servizio è richiesto. Qui il numero è 0x10.
; SVC può essere utilizzato per implementare il metodo
; di codifica a ripetizione (3,1) o altre funzionalità.

                ; Genera una chiamata SVC
                SVC     0x10                     ; Invoca il gestore SVC (Supervisor Call)
                                                ; Questo provoca un'interruzione che passa al gestore SVC_Handler,
                                                ; dove si implementano funzioni privilegiate come la codifica dei dati.

	
				
			
				
InfLoop         B      	InfLoop		;Ritorniamo perdendo tutti i privilegi.
                ENDP
					

				


; Dummy Exception Handlers (infinite loops which can be modified)

NMI_Handler     PROC
                EXPORT  NMI_Handler               [WEAK]
                B       .
                ENDP
HardFault_Handler\
                PROC
                EXPORT  HardFault_Handler         [WEAK]
                B       .
                ENDP
MemManage_Handler\
                PROC
                EXPORT  MemManage_Handler         [WEAK]
                B       .
                ENDP
BusFault_Handler\
                PROC
                EXPORT  BusFault_Handler          [WEAK]
                B       .
                ENDP
UsageFault_Handler\
                PROC
                EXPORT  UsageFault_Handler        [WEAK]
                B       .
                ENDP
					
;--------------------------------------------------------------------------------------------------------------
					
SVC_Handler     PROC
                EXPORT  SVC_Handler               [WEAK]
					
				LDR		SP, =Stack_Mem	; Assegno all' SP un valore adeguato in memoria xke inizialmente a 0 e li abbiamo codice 
				
				STMFD SP!, {R0-R12, LR} ; Push brutta sono in MSP
				; Check the less significant byte in the LR to understand which was the SP used before the SVC
				
				MOV R12, R0 ; Salva l'ID dell'SVC in R12
				
				TST LR, #4   ; Per determinare se vengo da MSP e PSP (fa un L AND)
				
				MRSEQ R1, MSP ; 0000
				MRSNE R1, PSP ; 0100
				
				LDREQ R0, [R1, #20*4] 
				LDRNE R0, [R1, #6*4]  ; Se arrivo da PSP, ci spostiamo di 6 posizioni.
			
				LDR R0, [R0, #-4]        ; Carica il messaggio binario da R0.
				BIC R0, #0xFF000000 
				LSR R0, #16
				
				; R3 lo usiamo come registro di riferimento con i primi tre bit MS a 1
				MOV R3, #0xE0000000 ; 2_111000..00

				MOV R2, #0 ; Inizializza R2 per il messaggio codificato.

main_loop 		
				; Ciclo per processare i bit di R0 (messaggio originale).
				CMP R0,#0
				BEQ exit
				; Guarda se LSB di R0 è 1 o no
				TST R0, #1
				; Se LSB è 1, aggiungi tre uno nel messaggio codificato.
				ADDNE R2, R2, R3
				LSR R2, R2, #3 ; Shift dei tre bit ripetuti.
				LSR R0, R0, #1 ; Shift di un bit del messaggio originale.
				
				B main_loop
							
exit
				; Salva il messaggio codificato sullo stack
				STMFD SP!, {R2}          ; Spingi il messaggio codificato (R2) sullo stack.
				
				; Ripristina il messaggio codificato nel registro R0 come valore di ritorno
				LDMFD SP!, {R0}          ; Carica il messaggio codificato (da R2) in R0.

				; CMP con l'ID originale salvato in R12.
				CMP R12, #0x10           ; Confronta con l'ID dell'SVC.
				BNE uscita
				NOP
				
uscita			LDMFD SP!, {R0-R12, LR} ; Restore dei registri e ritorno.
				BX LR
                ENDP
					
;--------------------------------------------------------------------------------------------------------------	

DebugMon_Handler\
                PROC
                EXPORT  DebugMon_Handler          [WEAK]
                B       .
                ENDP
PendSV_Handler  PROC
                EXPORT  PendSV_Handler            [WEAK]
                B       .
                ENDP
SysTick_Handler PROC
                EXPORT  SysTick_Handler           [WEAK]
                B       .
                ENDP

Default_Handler PROC

                EXPORT  WDT_IRQHandler            [WEAK]
                EXPORT  TIMER0_IRQHandler         [WEAK]
                EXPORT  TIMER1_IRQHandler         [WEAK]
                EXPORT  TIMER2_IRQHandler         [WEAK]
                EXPORT  TIMER3_IRQHandler         [WEAK]
                EXPORT  UART0_IRQHandler          [WEAK]
                EXPORT  UART1_IRQHandler          [WEAK]
                EXPORT  UART2_IRQHandler          [WEAK]
                EXPORT  UART3_IRQHandler          [WEAK]
                EXPORT  PWM1_IRQHandler           [WEAK]
                EXPORT  I2C0_IRQHandler           [WEAK]
                EXPORT  I2C1_IRQHandler           [WEAK]
                EXPORT  I2C2_IRQHandler           [WEAK]
                EXPORT  SPI_IRQHandler            [WEAK]
                EXPORT  SSP0_IRQHandler           [WEAK]
                EXPORT  SSP1_IRQHandler           [WEAK]
                EXPORT  PLL0_IRQHandler           [WEAK]
                EXPORT  RTC_IRQHandler            [WEAK]
                EXPORT  EINT0_IRQHandler          [WEAK]
                EXPORT  EINT1_IRQHandler          [WEAK]
                EXPORT  EINT2_IRQHandler          [WEAK]
                EXPORT  EINT3_IRQHandler          [WEAK]
                EXPORT  ADC_IRQHandler            [WEAK]
                EXPORT  BOD_IRQHandler            [WEAK]
                EXPORT  USB_IRQHandler            [WEAK]
                EXPORT  CAN_IRQHandler            [WEAK]
                EXPORT  DMA_IRQHandler            [WEAK]
                EXPORT  I2S_IRQHandler            [WEAK]
                EXPORT  ENET_IRQHandler           [WEAK]
                EXPORT  RIT_IRQHandler            [WEAK]
                EXPORT  MCPWM_IRQHandler          [WEAK]
                EXPORT  QEI_IRQHandler            [WEAK]
                EXPORT  PLL1_IRQHandler           [WEAK]
                EXPORT  USBActivity_IRQHandler    [WEAK]
                EXPORT  CANActivity_IRQHandler    [WEAK]

WDT_IRQHandler
TIMER0_IRQHandler
TIMER1_IRQHandler
TIMER2_IRQHandler
TIMER3_IRQHandler
UART0_IRQHandler
UART1_IRQHandler
UART2_IRQHandler
UART3_IRQHandler
PWM1_IRQHandler
I2C0_IRQHandler
I2C1_IRQHandler
I2C2_IRQHandler
SPI_IRQHandler
SSP0_IRQHandler
SSP1_IRQHandler
PLL0_IRQHandler
RTC_IRQHandler
EINT0_IRQHandler
EINT1_IRQHandler
EINT2_IRQHandler
EINT3_IRQHandler
ADC_IRQHandler
BOD_IRQHandler
USB_IRQHandler
CAN_IRQHandler
DMA_IRQHandler
I2S_IRQHandler
ENET_IRQHandler
RIT_IRQHandler
MCPWM_IRQHandler
QEI_IRQHandler
PLL1_IRQHandler
USBActivity_IRQHandler
CANActivity_IRQHandler

                B       .

                ENDP


                ALIGN


; User Initial Stack & Heap

                EXPORT  __initial_sp
                EXPORT  __heap_base
                EXPORT  __heap_limit                

                END
