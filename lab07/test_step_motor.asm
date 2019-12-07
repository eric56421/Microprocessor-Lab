        ORG 00H
        JMP SETUP
        
        ORG 30H
SETUP:
        MOV P1, #00H
        MOV P2, #0FH
        MOV DPTR, #TABLE
        
LOOP:
        ;MOV R1, #7FH
        ;MOV P2, R1
        ;MOV A, P2
        MOV R3, #20H
SPIN:
        CALL MOTOR_SPIN
        DJNZ R3, SPIN
        ;MOV P1, R0
        JMP LOOP

MOTOR_SPIN:
        MOV R2, #04H
        ;MOV R3, #04H
SPIN_90:
        DEC R2
        MOV A, R2
        MOVC A, @A+DPTR
        MOV P1, A
        ;CALL SDELAY
        CJNE R2, #0H, SPIN_90
        ;DJNZ R3, SPIN_90
        RET

SDELAY:                  
        MOV R5, #20H    ; 1 machine cycle
SDELAY1:
        MOV R6, #10H    ; 1 machine cycle
SDELAY2:
        MOV R7, #10H   ; 1 machine cycle
SDELAY3:
        DJNZ R7, SDELAY3 ; 2 machine cycle
        DJNZ R6, SDELAY2 ; 2 machine cycle
        DJNZ R5, SDELAY1 ; 2 machine cycle
        RET             ; 2 machine cycle

TABLE:
        DB 00000001B
        DB 00000010B
        DB 00000100B
        DB 00001000B

        END
