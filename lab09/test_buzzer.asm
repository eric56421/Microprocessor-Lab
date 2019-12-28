        ORG 00H
        JMP SETUP

        ORG 0BH                 ; TIMER 0
        CALL ISR_TIMER0
        RETI

        ORG 1BH                 ; TIMER 1
        CALL ISR_TIMER1
        RETI

ISR_TIMER0:
        SETB P3.5
        CLR P3.5
        RET

ISR_TIMER1:
        ;CALL BUZZE
        ;CALL BUZZE
        CALL DELAY_LOOP  
        CALL DELAY_LOOP
        CALL SETUP_TIMER
        RET

        ORG 30H
SETUP:
        MOV P1, #00H
        ;MOV TMOD, #01010001B
        ;MOV IE, #10001010B
        ;CALL SETUP_TIMER

MAIN:
        ;SETB P1.0
        CALL TEST_DUTY
        CALL DELAY_LOOP
        CALL DELAY_LOOP
        CALL DELAY_LOOP
        CALL DELAY_LOOP
        CALL DELAY_LOOP
        CALL DELAY_LOOP
        CALL DELAY_LOOP
        CALL DELAY_LOOP
        CALL DELAY_LOOP
        
        CALL DELAY_LOOP
        CALL DELAY_LOOP
        CALL DELAY_LOOP
        CALL DELAY_LOOP
        
        CALL DELAY_LOOP
        CALL DELAY_LOOP
        CALL DELAY_LOOP
        CALL DELAY_LOOP
        
        CALL DELAY_LOOP
        CALL DELAY_LOOP
        CALL DELAY_LOOP
        CALL DELAY_LOOP
        
        
        ;SETB TR1
        JMP MAIN  
;HERE:   JMP HERE
       
SETUP_TIMER:
        MOV TH1, #0FFH
        MOV TL1, #0D3H
        MOV TH0, #00H
        MOV TL0, #01H
        SETB TR1
        SETB TR0
        RET

DELAY_LOOP:
        MOV R4, #0FFH
HERE:   CALL DELAY
        DJNZ R4, HERE
        RET

TEST_DUTY:
        CALL BUZZE13
        CALL DELAY_LOOP
        CALL DELAY_LOOP
        CALL DELAY_LOOP
        CALL DELAY_LOOP
        CALL DELAY_LOOP
        CALL DELAY_LOOP
        CALL DELAY_LOOP
        CALL DELAY_LOOP
        CALL DELAY_LOOP
        CALL DELAY_LOOP
        CALL DELAY_LOOP
        CALL DELAY_LOOP
        CALL DELAY_LOOP
        CALL DELAY_LOOP
        CALL DELAY_LOOP
        CALL DELAY_LOOP
        CALL DELAY_LOOP
        CALL DELAY_LOOP
        CALL DELAY_LOOP
        CALL DELAY_LOOP
        CALL DELAY_LOOP
        CALL DELAY_LOOP
        CALL DELAY_LOOP
        CALL DELAY_LOOP
        CALL DELAY_LOOP
        CALL DELAY_LOOP
        CALL DELAY_LOOP
        CALL DELAY_LOOP
        
        
        CALL BUZZE31
        CALL DELAY_LOOP
        CALL DELAY_LOOP
        CALL DELAY_LOOP
        CALL DELAY_LOOP
        CALL DELAY_LOOP
        CALL DELAY_LOOP
        CALL DELAY_LOOP
        CALL DELAY_LOOP
        CALL DELAY_LOOP
        CALL DELAY_LOOP
        CALL DELAY_LOOP
        CALL DELAY_LOOP
        CALL DELAY_LOOP
        CALL DELAY_LOOP
        CALL DELAY_LOOP
        CALL DELAY_LOOP
        CALL DELAY_LOOP
        CALL DELAY_LOOP
        CALL DELAY_LOOP
        CALL DELAY_LOOP
        CALL DELAY_LOOP
        CALL DELAY_LOOP
        CALL DELAY_LOOP
        CALL DELAY_LOOP
        
        
        RET

BUZZE13:
        MOV R4, #0FFH
BUZZE13_LOOP:
        SETB P1.0
        CALL DELAY
        CLR P1.0
        CALL DELAY
        CALL DELAY
        CALL DELAY
        CALL DELAY
        CALL DELAY
        CALL DELAY
        CALL DELAY
        CALL DELAY
        CALL DELAY
        DJNZ R4, BUZZE13_LOOP
        RET

BUZZE22:
        MOV R4, #0FFH
BUZZE22_LOOP:
        SETB P1.0
        CALL DELAY
        CALL DELAY
        CALL DELAY
        CALL DELAY
        CALL DELAY
        CLR P1.0
        CALL DELAY
        CALL DELAY
        CALL DELAY
        CALL DELAY
        CALL DELAY
        DJNZ R4, BUZZE22_LOOP
        RET

BUZZE31:
        MOV R4, #0FFH
BUZZE31_LOOP:
        SETB P1.0
        CALL DELAY
        CALL DELAY
        CALL DELAY
        CALL DELAY
        CALL DELAY
        CALL DELAY
        CALL DELAY
        CALL DELAY
        CALL DELAY
        CLR P1.0
        CALL DELAY
        DJNZ R4, BUZZE31_LOOP
        RET

DELAY:                  
        MOV R5, #01H   ; 1 machine cycle
DELAY1:
        MOV R6, #01H   ; 1 machine cycle
DELAY2:
        MOV R7, #0FFH    ; 1 machine cycle
DELAY3:
        DJNZ R7, DELAY3 ; 2 machine cycle
        DJNZ R6, DELAY2 ; 2 machine cycle
        DJNZ R5, DELAY1 ; 2 machine cycle
        RET             ; 2 machine cycle

        END
