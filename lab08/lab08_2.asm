; show animation on LCD
; P1 : Data port
; P2 : E, RW, RS

        SET_CUR_POS EQU 10000111B

        ORG 00H
        JMP SETUP

        ORG 30H
SETUP:
        MOV P1, 00H             ; set P1 as output
        MOV P2, 00H             ; set P2 as output
        MOV A, #00111000B       ; LEN:8, LINES:2, FONT:7
        CALL CMDWRT
        MOV A, #00001100B       ; DISPLAY:ON, CURSOR_UNDERLINE:OFF, BLINKING:OFF
        CALL CMDWRT
        MOV A, #00000001B       ; CLEAR & RESET
        CALL CMDWRT
        MOV A, #00000110B       ; ADD TO RIGHT, DISPLAY NOT MOVING
        CALL CMDWRT
        CALL SETUP_ANI          ; to load custom characters

MAIN:
        CALL SHOW_ANI
        JMP MAIN

SETUP_ANI:                      ; To load custom chars (animation)
        MOV DPTR, #TABLE_ANI    ; DPTR point to animation table
        MOV R1, #40H            ; ADDRESS OF FIRST CUSTOM CHAR
        MOV A, R1               ; to set where to store custom char
        CALL CMDWRT
        MOV R0, #00H            ; R0 is the index of table
SETUP_ANI_LOOP:
        MOV A, R0               ; ---V
        MOVC A, @A+DPTR         ; get data from table
        CALL DATAWRT            ; ---A
        INC R0                  ; index++
        CJNE R0, #30H, SETUP_ANI_LOOP   ; to load 48 frames
        RET

SHOW_ANI:                       ; Show a whole set of animation
        MOV R0, #00H            ; R0 is the index (address) of CGRAM in LCD
SHOW_ANI_LOOP_UP:               ; Loop of forward animation
        MOV A, #SET_CUR_POS     ; to fix the position of animation
        CALL CMDWRT
        MOV A, R0               ; show the char (frame) stored in that address
        CALL DATAWRT
        CALL DELAY              ; stop for a while
        INC R0                  ; index++
        CJNE R0, #06H, SHOW_ANI_LOOP_UP         ; to show forward part
SHOW_ANI_LOOP_DOWN:             ; Loop of backward animation
        DEC R0                  ; index--
        MOV A, #SET_CUR_POS     ; to fix the position of animation
        CALL CMDWRT
        MOV A, R0               ; show the char (frame) stored in that address
        CALL DATAWRT
        CALL DELAY              ; stop for a while
        CJNE R0, #00H, SHOW_ANI_LOOP_DOWN       ; to show backward part
        RET

CMDWRT:                         ; Command write
        MOV P1, A
        MOV P2, #00000100B      ; 04H, E=1, RW=0, RS=0
        MOV P2, #00000000B      ; 00H, E=0, RW=0, RS=0
        CALL DELAY3MS
        RET

DATAWRT:                        ; ShowData write
        MOV P1, A
        MOV P2, #00000101B      ; 05H, E=1, RW=0, RS=1
        MOV P2, #00000001B      ; 01H, E=1, RW=0, RS=1
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

DELAY:                  
        MOV R5, #06H            ; 1 machine cycle
DELAY1:
        MOV R6, #0FFH           ; 1 machine cycle
DELAY2:
        MOV R7, #0FFH           ; 1 machine cycle
DELAY3:
        DJNZ R7, DELAY3         ; 2 machine cycle
        DJNZ R6, DELAY2         ; 2 machine cycle
        DJNZ R5, DELAY1         ; 2 machine cycle
        RET                     ; 2 machine cycle

TABLE_ANI:
        DB 14H, 14H, 1FH, 05H, 06H, 0AH, 0AH, 11H
        DB 14H, 14H, 1FH, 05H, 05H, 0AH, 0AH, 11H
        DB 14H, 14H, 1FH, 05H, 04H, 0AH, 0AH, 11H
        DB 14H, 15H, 1EH, 04H, 04H, 0AH, 0AH, 11H
        DB 15H, 15H, 1EH, 04H, 04H, 0AH, 0AH, 11H
        DB 17H, 15H, 1EH, 04H, 04H, 0AH, 0AH, 11H

        END