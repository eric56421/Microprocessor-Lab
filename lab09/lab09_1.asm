        
        V_TH1 EQU 30H
        V_TL1 EQU 31H
        V_TH0 EQU 32H
        V_TL0 EQU 33H
        INDEX EQU 34H 
        
        ORG 00H
        JMP SETUP

        ORG 0BH                 ; TIMER 0
        CALL BUZZE
        RETI

        ORG 1BH                 ; TIMER 1
        CALL BUZZE_NOTE
        RETI


        ORG 30H
SETUP:
        MOV P1, #00H
        MOV TMOD, #01010001B    ; timer0 : 16bit, timer1 : 16bit, as counter
        MOV IE, #10001010B      ; interrupt enable
        MOV DPTR, #TABLE
        MOV INDEX, #00H
        MOV V_TH1, #0FFH
        MOV V_TL1, #99H

        CALL BUZZE_NOTE
        CALL BUZZE

MAIN:   JMP MAIN

BUZZE:
        CALL RUN_TIMER0         ; load TH0 and TL0
        CPL P1.0
        SETB P3.5               ; send a signal to timer1 to count++
        CLR P3.5
        RET

BUZZE_NOTE:
        CALL NEXT_NOTE          ; get next note
        CALL RUN_TIMER1         ; load TH1 and TL1
        RET

RUN_TIMER0:                     ; set timer0
        MOV TH0, V_TH0
        MOV TL0, V_TL0
        SETB TR0
        RET

RUN_TIMER1:                     ; set timer1
        MOV TH1, V_TH1
        MOV TL1, V_TL1
        SETB TR1
        RET

NEXT_NOTE:
        CJNE R0, #30, GET_NOTE  ; whether play for 15 notes?
        MOV INDEX, #00H         ; if yes, replay from first note
GET_NOTE:
        CLR TR0                 ; stop for a while
        CALL DELAY
        SETB TR0
        MOV A, INDEX            ; get TH0 value from table
        MOVC A, @A+DPTR
        MOV V_TH0, A
        INC INDEX               ; get TL0 value from table
        MOV A, INDEX
        MOVC A, @A+DPTR
        MOV V_TL0, A
        INC INDEX
        MOV R0, INDEX
        RET

DELAY:                  
        MOV R5, #4H   ; 1 machine cycle
DELAY1:
        MOV R6, #40H   ; 1 machine cycle
DELAY2:
        MOV R7, #0FFH    ; 1 machine cycle
DELAY3:
        DJNZ R7, DELAY3 ; 2 machine cycle
        DJNZ R6, DELAY2 ; 2 machine cycle
        DJNZ R5, DELAY1 ; 2 machine cycle
        RET             ; 2 machine cycle

TABLE:
        DB 0FAH, 13H    ;E 3034
        DB 0FAH, 13H    ;E 3034
        DB 0FAH, 69H    ;F 2863
        DB 0FBH, 05H    ;G 2551
        DB 0FBH, 05H    ;G 2551
        DB 0FAH, 69H    ;F 2863
        DB 0FAH, 13H    ;E 3822
        DB 0F9H, 5AH    ;D 3405
        DB 0F8H, 89H    ;C 3822
        DB 0F8H, 89H    ;C 3822
        DB 0F9H, 5AH    ;D 3405
        DB 0FAH, 13H    ;E 3034
        DB 0FAH, 13H    ;E 3034
        DB 0F9H, 5AH    ;D 3405
        DB 0F9H, 5AH    ;D 3405

        END
