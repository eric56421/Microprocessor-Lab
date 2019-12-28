
        KEY_VAL EQU 30H
        IND_VAL EQU 31H
        TH0_V   EQU 32H
        TL0_V   EQU 33H
        ROW_CNT EQU 34H

        ORG 00H
        JMP SETUP

        ORG 0BH                 ; TIMER 0
        JMP BUZZE

        ORG 1BH                 ; TIMER 1
        JMP BUZZE_100

        ORG 30H
SETUP:
        CLR TR0
        MOV P1, #00H
        MOV TMOD, #01010001B    ; timer0 : 16bit, timer1 : 16bit, as counter
        MOV IE, #10001010B      ; interrupt enable
        CLR TR1
        MOV DPTR, #TABLE

MAIN:
        CALL KEY_PUSH_POLLING   ; keep scanning whether the key is pushed
        CALL SET_IND_BY_CASE    ; set index by case
        CALL SET_BUZZE          ; set TH0, TL0
        JMP MAIN

BUZZE:
        MOV TH0, TH0_V          ; set TH0
        MOV TL0, TL0_V          ; set TL0
        SETB TR0                ; timer0 run
        CPL P1.0
        SETB P3.5               ; send a signal to timer1 to count++ 
        CLR P3.5
        RETI

BUZZE_100:                      ; stop buzzing
        CLR TR0
        CLR TR1
        CLR P1.0
        RETI

KEY_PUSH_POLLING:
        MOV ROW_CNT, #04H       ; ROW_CNT is counter for scanning 4 rows
        MOV R4, #07FH           ; R4 is bit flag to control reading which row
POLLING:
        MOV P2, R4              ; output control to P2
        CALL DELAY              ; stop fro keyboard
        MOV A, R4               ; -----V
        RR A                    ; R4 >>= 1, to read next row
        MOV R4, A               ; -----A
        MOV A, P2               ; input to A
        MOV KEY_VAL, A          ; copy input to KEY_VAL(key value)
        ANL A, #0FH             ; to get last 4 bits of KEY_VAL
        CJNE A, #0FH, POLLING_RET  ; if the key is pushed, it won't equal to 0FH  
        DJNZ ROW_CNT, POLLING   ; to check 4 rows
        JMP KEY_PUSH_POLLING    ; repolling from first row    
POLLING_RET:
        RET

SET_IND_BY_CASE:                ; set index by case (which button), like switch
        MOV R0, KEY_VAL
R2C1:
        CJNE R0, #0BEH, R3C1
        MOV IND_VAL, #0
        RET
R3C1:
        CJNE R0, #0DEH, R4C1
        MOV IND_VAL, #2
        RET
R4C1:
        CJNE R0, #0EEH, R2C2
        MOV IND_VAL, #4
        RET
R2C2:
        CJNE R0, #0BDH, R3C2
        MOV IND_VAL, #6
        RET
R3C2:
        CJNE R0, #0DDH, R4C2
        MOV IND_VAL, #8
        RET
R4C2:
        CJNE R0, #0EDH, R2C3
        MOV IND_VAL, #10
        RET
R2C3:
        CJNE R0, #0BBH, R3C3
        MOV IND_VAL, #12
        RET
R3C3:
        CJNE R0, #0DBH, R4C3
        MOV IND_VAL, #14
        RET
R4C3:
        CJNE R0, #0EBH, R2C4
        MOV IND_VAL, #16
        RET
R2C4:
        CJNE R0, #0B7H, R3C4
        MOV IND_VAL, #18
        RET
R3C4:
        CJNE R0, #0D7H, R4C4
        MOV IND_VAL, #20
        RET
R4C4:
        MOV IND_VAL, #22
        RET

SET_BUZZE:                      ; according to index to get note data from table
        MOV A, IND_VAL          ; to set TH0
        MOVC A, @A+DPTR
        MOV TH0_V, A
        MOV TH0, A

        INC IND_VAL             ; to set TL0
        MOV A, IND_VAL
        MOVC A, @A+DPTR
        MOV TL0_V, A
        MOV TL0, A

        MOV TH1, #0FFH          ;buzze for 100 TIMES
        MOV TL1, #09CH

        SETB TR0                ; timer0 run
        SETB TR1                ; timer1 run
        RET

DELAY:
        MOV R6,#0FFH
DELAY1:
        MOV R7,#05H
DELAY2:
        DJNZ R7,DELAY2
        DJNZ R6,DELAY1
        RET

TABLE:
        DB 0FBH, 4CH
        DB 0FAH, 13H
        DB 0F8H, 89H
        DB 0FBH, 90H
        DB 0FAH, 69H
        DB 0F8H, 0F4H
        DB 0FBH, 0D0H
        DB 0FAH, 0B9H
        DB 0F9H, 5AH
        DB 0FCH, 0CH
        DB 0FBH, 05H
        DB 0F9H, 0B9H

        END

