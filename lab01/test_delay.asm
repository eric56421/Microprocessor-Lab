DELAY:
        MOV R5, #02H    ; 1 machine cycle
DELAY1:
        MOV R6, #02H    ; 1 machine cycle
DELAY2:
        MOV R7, #02H    ; 1 machine cycle
DELAY3:
        DJNZ R7, DELAY3 ; 2 machine cycle
        DJNZ R6, DELAY2 ; 2 machine cycle
        DJNZ R5, DELAY1 ; 2 machine cycle
        RET             ; 2 machine cycle


; =1+(1+(1+(2x5)+2)x159+2)x255+2 =0.84 (s)
DELAY:
        MOV R5, #0FFH    ; 1 machine cycle
DELAY1:
        MOV R6, #9FH    ; 1 machine cycle
DELAY2:
        MOV R7, #05H    ; 1 machine cycle
DELAY3:
        DJNZ R7, DELAY3 ; 2 machine cycle
        DJNZ R6, DELAY2 ; 2 machine cycle
        DJNZ R5, DELAY1 ; 2 machine cycle
        RET             ; 2 machine cycle