DELAY:                  
        MOV R5, #0FFH   ; 1 machine cycle
DELAY1:
        MOV R6, #08FH   ; 1 machine cycle
DELAY2:
        MOV R7, #18H    ; 1 machine cycle
DELAY3:
        DJNZ R7, DELAY3 ; 2 machine cycle
        DJNZ R6, DELAY2 ; 2 machine cycle
        DJNZ R5, DELAY1 ; 2 machine cycle
        RET             ; 2 machine cycle