        BIN EQU 30H
        BCD EQU 32H

        ORG 00H
        JMP MAIN

        ORG 30H
MAIN:
        CALL BIN2BCD
        JMP MAIN

BIN2BCD:
        MOV BCD, #0
        MOV BCD+1, #0
        MOV BCD+2, #0
        MOV R2, #16
BIN2BCD_NEXT_BIT:
        MOV R0, #BIN
        MOV R3, #2
BIN2BCD_LS:             ; LEFT SHIFT
        MOV A, @R0
        RLC A
        MOV @R0, A
        INC R0
        DJNZ R3, BIN2BCD_LS

        MOV R0, #BCD
        MOV R3, #3
BIN2BCD_DOUBLE:         ; DOUBLE THE BCD
        MOV A, @R0
        ADDC A, @R0
        DA A
        MOV @R0, A
        INC R0
        DJNZ R3, BIN2BCD_DOUBLE

        DJNZ R2, BIN2BCD_NEXT_BIT
        RET

        END

