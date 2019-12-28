        BCD EQU 30H
        ; BCD+1, BCD+0
        HL_BIT EQU 00H

        ORG 00H
        JMP MAIN

        ORG 30H
MAIN:   
        CALL SHOW
        JMP MAIN

SHOW:
        MOV R0, #BCD
        MOV R2, #4      ; LOOP COUNTER
        MOV R3, #01111111B
        CLR HL_BIT
SHOW_TWO_DIGITS:
        MOV A, @R0
        JNB HL_BIT, SHOW_COMBINE
        SWAP A
SHOW_COMBINE:
        ORL A, #0F0H
        ANL A, R3
        MOV P2, A
        CALL SDELAY

        CPL HL_BIT
        MOV A, R3
        RR A
        MOV R3, A        
        JB HL_BIT, SHOW_NEXT_BIT
        INC R0

SHOW_NEXT_BIT:
        DJNZ R2, SHOW_TWO_DIGITS
        RET
;
SDELAY:                  
        MOV R5, #03H   ; 1 machine cycle
SDELAY1:
        MOV R6, #08H    ; 1 machine cycle
SDELAY2:
        MOV R7, #0FFH   ; 1 machine cycle
SDELAY3:
        DJNZ R7, SDELAY3 ; 2 machine cycle
        DJNZ R6, SDELAY2 ; 2 machine cycle
        DJNZ R5, SDELAY1 ; 2 machine cycle
        RET             ; 2 machine cycle

        
        END

