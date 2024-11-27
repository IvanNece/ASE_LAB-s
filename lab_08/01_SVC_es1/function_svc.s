
                AREA svc_code, CODE, READONLY     ; Define a code section
                EXPORT call_svc                   ; Export the call_svc function

call_svc        PROC                              ; Start of procedure
                PUSH    {R0}                      ; Save R0 on the stack
                MOV     R0, #3                    ; Configure PSP and User mode (optional)
                MSR     CONTROL, R0               ; Write to CONTROL register
                SVC     0x10                      ; Invoke SVC with number 0x10
                POP     {R0}                      ; Restore R0 from the stack
                BX      LR                        ; Return to the caller
                ENDP                              ; End of procedure

                END