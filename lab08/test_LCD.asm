        ORG 0H
        MOV P2, #00H
        MOV A, #00111000B       ; LEN:8, LINES:2, FONT:7
        CALL COMNWRT
        ;CALL DELAY
        MOV A, #00001110B       ; DISPLAY:ON, CURSOR_UNDERLINE:ON, BLINKING:OFF
        CALL COMNWRT
        ;CALL DELAY
        MOV A, #00000001B       ; CLEAR & RESET
        CALL COMNWRT
        ;CALL DELAY
        MOV A, #00000110B       ; ADD TO RIGHT, DISPLAY NOT MOVING
        CALL COMNWRT
        ;CALL DELAY
        MOV A, #11000100B       ; SET CURSOR PLACE(0->), ROW1, COL4
        CALL COMNWRT
        ;CALL DELAY 
        MOV A, #'Y'
        CALL DATAWRT
        ;CALL DELAY        
        MOV A, #'E'
        CALL DATAWRT
        ;CALL DELAY
        MOV A, #'S'
        CALL DATAWRT
        ;CALL DELAY
        MOV A, #00011100B
        CALL COMNWRT
        CALL LDELAY
        MOV A, #00011100B
        CALL COMNWRT
        CALL LDELAY
        MOV A, #00011100B
        CALL COMNWRT
        CALL LDELAY
        MOV A, #00000010B
        CALL COMNWRT
        CALL DELAY
AGAIN:  JMP AGAIN

COMNWRT:
        MOV P1, A
        MOV P2, #00000100B      ; 04H, E=1, RW=0, RS=0
        MOV P2, #00000000B      ; 00H, E=0, RW=0, RS=0
        CALL DELAY
        RET

DATAWRT:
        MOV P1, A
        MOV P2, #00000101B      ; 05H, E=1, RW=0, RS=1
        MOV P2, #00000001B      ; 01H, E=1, RW=0, RS=1
        CALL DELAY
        RET

DELAY:                  
        MOV R5, #01H    ; 1 machine cycle
DELAY1:
        MOV R6, #10H    ; 1 machine cycle
DELAY2:
        MOV R7, #0FFH   ; 1 machine cycle
DELAY3:
        DJNZ R7, DELAY3 ; 2 machine cycle
        DJNZ R6, DELAY2 ; 2 machine cycle
        DJNZ R5, DELAY1 ; 2 machine cycle
        RET             ; 2 machine cycle

LDELAY:
DELAY_LONG:                      ; NOT 40US BUT VERY LONG
        MOV R5, #08FH    ; 1 machine cycle
DELAY_LONG1:
        MOV R6, #0FFH    ; 1 machine cycle
DELAY_LONG2:
        MOV R7, #0FFH    ; 1 machine cycle
DELAY_LONG3:
        DJNZ R7, DELAY_LONG3 ; 2 machine cycle
        DJNZ R6, DELAY_LONG2 ; 2 machine cycle
        DJNZ R5, DELAY_LONG1 ; 2 machine cycle
        RET             ; 2 machine cycle
        
        END


