; show student ID on LCD with Label
; P1 : Data port
; P2 : E, RW, RS

        ORG 00H
        JMP SETUP

        ORG 30H
SETUP:
        ;MOV P1, #00H             ; set P1 as output
        ;MOV P2, #00H             ; set P2 as output
        MOV A, #00111000B       ; LEN:8, LINES:2, FONT:7
        CALL CMDWRT
        MOV A, #00001110B       ; DISPLAY:ON, CURSOR_UNDERLINE:ON, BLINKING:OFF
        CALL CMDWRT
        MOV A, #00000001B       ; CLEAR & RESET
        CALL CMDWRT
        MOV A, #00000110B       ; ADD TO RIGHT, DISPLAY NOT MOVING
        CALL CMDWRT

MAIN:
        CALL SHOW_ID            ; show student ID on first row
        CALL SHOW_LABEL         ; show label on second row
HERE:   JMP HERE

SHOW_ID:
        MOV A, #10000000B       ; SET CURSOR PLACE(0->), ROW0, COL0
        CALL CMDWRT             
        MOV R0, #00H            ; R0 is the index of table
        MOV DPTR, #TABLE_ID     ; DPTR point to ID table
SHOW_ID_LOOP:                   
        MOV A, R0               ; ---V
        MOVC A, @A+DPTR         ; get data from table
        CALL DATAWRT            ; ---A
        INC R0                  ; index++
        CJNE R0, #07H, SHOW_ID_LOOP     ; to show 7 characters
        RET

SHOW_LABEL:
        MOV A, #11000000B       ; SET CURSOR PLACE(0->), ROW1, COL0
        CALL CMDWRT             
        MOV R0, #00H            ; R0 is the index of table
        MOV DPTR, #TABLE_LABEL  ; DPTR point to LABEL table
SHOW_LABEL_LOOP:                   
        MOV A, R0               ; ---V
        MOVC A, @A+DPTR         ; get data from table
        CALL DATAWRT            ; ---A
        INC R0                  ; index++
        CJNE R0, #10H, SHOW_LABEL_LOOP  ; to show 16 characters
        RET

CMDWRT:                         ; Command write
        MOV P2, A
        ;CLR P1.0
        ;SETB P1.2
        ;SETB P1.2
        ;CLR P1.2
        MOV P1, #00000100B      ; 04H, E=1, RW=0, RS=0
        MOV P1, #00000000B      ; 00H, E=0, RW=0, RS=0
        CALL DELAY3MS
        RET

DATAWRT:                        ; ShowData write
        MOV P2, A
        ;SETB P1.0
        ;SETB P1.2
        ;SETB P1.2
        ;CLR P1.2
        MOV P1, #00000101B      ; 05H, E=1, RW=0, RS=1
        MOV P1, #00000001B      ; 01H, E=1, RW=0, RS=1
        CALL DELAY3MS
        RET

DELAY3MS:                  
        MOV R5, #01H            ; 1 machine cycle
DELAY3MS1:
        MOV R6, #10H            ; 1 machine cycle
DELAY3MS2:
        MOV R7, #0FFH           ; 1 machine cycle
DELAY3MS3:
        DJNZ R7, DELAY3MS3      ; 2 machine cycle
        DJNZ R6, DELAY3MS2      ; 2 machine cycle
        DJNZ R5, DELAY3MS1      ; 2 machine cycle
        RET                     ; 2 machine cycle

TABLE_ID:
        DB "071FUCK"
TABLE_LABEL:
        DB "^^ Student ID ^^"

        END