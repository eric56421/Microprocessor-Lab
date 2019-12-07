        KEY_VAL EQU 30H
        ROW_CNT EQU 31H
        
        ORG 00H
        JMP SETUP
        
        ORG 30H
SETUP:
        MOV P2, #0FH
         
LOOP:
        CALL KEY_PUSH_POLLING
        MOV A, KEY_VAL
        JMP LOOP

KEY_PUSH_POLLING:
        MOV ROW_CNT, #04H
        MOV R4, #07FH
POLLING:
        MOV P2, R4
        MOV A, R4
        RR A
        MOV R4, A
        MOV A, P2
        MOV KEY_VAL, A
        ANL A, #0FH
        CJNE A, #0FH, POLLING_RET
        DJNZ ROW_CNT, POLLING
        JMP KEY_PUSH_POLLING
POLLING_RET:
        RET

        END
