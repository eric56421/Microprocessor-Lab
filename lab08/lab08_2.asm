        
        SET_CUR_POS EQU 10000111B

        ORG 00H
        JMP SETUP

        ORG 30H
SETUP:
        MOV P1, 00H
        MOV P2, 00H
        MOV A, #00111000B       ; LEN:8, LINES:2, FONT:7
        CALL CMDWRT
        MOV A, #00001100B       ; DISPLAY:ON, CURSOR_UNDERLINE:OFF, BLINKING:OFF
        CALL CMDWRT
        MOV A, #00000001B       ; CLEAR & RESET
        CALL CMDWRT
        MOV A, #00000110B       ; ADD TO RIGHT, DISPLAY NOT MOVING
        CALL CMDWRT
        CALL SETUP_ANI

MAIN:
        CALL SHOW_ANI
        JMP MAIN

SETUP_ANI:
        MOV DPTR, #TABLE_ANI
        MOV R1, #40H            ; FIRST CUSTOM CHAR
        MOV A, R1
        CALL CMDWRT
        MOV R0, #00H
SETUP_ANI_LOOP:
        MOV A, R0
        MOVC A, @A+DPTR
        CALL DATAWRT
        INC R0
        CJNE R0, #30H, SETUP_ANI_LOOP
        RET

SHOW_ANI:
        MOV R0, #00H
SHOW_ANI_LOOP_UP:
        MOV A, #SET_CUR_POS
        CALL CMDWRT
        MOV A, R0
        CALL DATAWRT
        CALL DELAY
        INC R0
        CJNE R0, #06H, SHOW_ANI_LOOP_UP
SHOW_ANI_LOOP_DOWN:
        DEC R0
        MOV A, #SET_CUR_POS
        CALL CMDWRT
        MOV A, R0
        CALL DATAWRT
        CALL DELAY
        CJNE R0, #00H, SHOW_ANI_LOOP_DOWN
        RET

CMDWRT:
        MOV P1, A
        MOV P2, #00000100B      ; 04H, E=1, RW=0, RS=0
        MOV P2, #00000000B      ; 00H, E=0, RW=0, RS=0
        CALL DELAY3MS
        RET

DATAWRT:
        MOV P1, A
        MOV P2, #00000101B      ; 05H, E=1, RW=0, RS=1
        MOV P2, #00000001B      ; 01H, E=1, RW=0, RS=1
        CALL DELAY3MS
        RET

DELAY3MS:                  
        MOV R5, #01H    ; 1 machine cycle
DELAY3MS1:
        MOV R6, #10H    ; 1 machine cycle
DELAY3MS2:
        MOV R7, #0FFH   ; 1 machine cycle
DELAY3MS3:
        DJNZ R7, DELAY3MS3 ; 2 machine cycle
        DJNZ R6, DELAY3MS2 ; 2 machine cycle
        DJNZ R5, DELAY3MS1 ; 2 machine cycle
        RET             ; 2 machine cycle

DELAY:                  
        MOV R5, #06H    ; 1 machine cycle
DELAY1:
        MOV R6, #0FFH    ; 1 machine cycle
DELAY2:
        MOV R7, #0FFH   ; 1 machine cycle
DELAY3:
        DJNZ R7, DELAY3 ; 2 machine cycle
        DJNZ R6, DELAY2 ; 2 machine cycle
        DJNZ R5, DELAY1 ; 2 machine cycle
        RET             ; 2 machine cycle

TABLE_ANI:
        DB 14H, 14H, 1FH, 05H, 06H, 0AH, 0AH, 11H
        DB 14H, 14H, 1FH, 05H, 05H, 0AH, 0AH, 11H
        DB 14H, 14H, 1FH, 05H, 04H, 0AH, 0AH, 11H
        DB 14H, 15H, 1EH, 04H, 04H, 0AH, 0AH, 11H
        DB 15H, 15H, 1EH, 04H, 04H, 0AH, 0AH, 11H
        DB 17H, 15H, 1EH, 04H, 04H, 0AH, 0AH, 11H

        END