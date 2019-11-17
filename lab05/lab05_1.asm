

        DIGIT_0 EQU 30H
        DIGIT_1 EQU 31H
        DIGTI_2 EQU 32H
        DIGIT_3 EQU 33H
        NUM_L EQU 34H
        NUM_H EQU 35H
        NUM EQU 36H
        IS_GET EQU 00H

        ORG 00H
        JMP SETUP

        ORG 40H
SETUP:
        MOV P2, #0FFH   ; P2 reads column data. Set P2 as input mode
        MOV P3, #00H    ; P3 controls which col to read. Set P3 as output mode

MAIN:
        CALL GET_KEY
        CALL SHOW
        JMP MAIN

GET_KEY:
        MOV R1, #0FEH   ; R1 controls reads which col
        MOV R2, #04H    ; R2 is the counter of LOOP_GET_KEY_COL
        MOV P3, R1
        JMP LOOP_GET_KEY_ROW
LOOP_GET_KEY_COL:
        XCH A, R1
        RL A
        XCH A, R1
        MOV P3, R1
LOOP_GET_KEY_ROW:
        MOV P2, #0FFH
        MOV R0, P2      ; R0 store P2        
ROW_0:
        CJNE R0, #0F7H, ROW_1
        MOV NUM, #0CH
        SETB IS_GET
        JMP GET_KEY_RETURN
ROW_1:
        CJNE R0, #0FBH, ROW_2
        MOV NUM, #08H
        SETB IS_GET
        JMP GET_KEY_RETURN
ROW_2:
        CJNE R0, #0FDH, ROW_3
        MOV NUM, #04H
        SETB IS_GET
        JMP GET_KEY_RETURN
ROW_3:
        CJNE R0, #0FEH, ROW_NO
        MOV NUM, #00H
        SETB IS_GET
        JMP GET_KEY_RETURN
ROW_NO:
        CLR IS_GET
        DJNZ R2, LOOP_GET_KEY_COL
        RET
GET_KEY_RETURN:
        MOV A, NUM
        ADD A, R2
        DEC A
        DA A
        MOV NUM, A
        ;CLR C
        ;CLR AC
        RET

SHOW:
        MOV R4, #18H
        MOV A, NUM
        MOV NUM_L, #0FH
        ANL NUM_L, A
        MOV NUM_H, #0FH
        SWAP A
        ANL NUM_H, A
SHOW_DIGIT_L:
        MOV DPTR, #DIGIT_L_DATA
        MOV A, NUM_L
        MOVC A, @A+DPTR
        MOV DIGIT_0, A
SHOW_DIGIT_H:
        MOV DPTR, #DIGIT_H_DATA
        MOV A, NUM_H
        MOVC A, @A+DPTR
        MOV DIGIT_1, A
OUTPUT:
        MOV P1, DIGIT_0
        CALL SDELAY
        MOV P1, DIGIT_1
        CALL SDELAY
        DJNZ R4, OUTPUT
        RET

SDELAY:                  
        MOV R5, #1H    ; 1 machine cycle
SDELAY1:
        MOV R6, #4H    ; 1 machine cycle
SDELAY2:
        MOV R7, #0FFH   ; 1 machine cycle
SDELAY3:
        DJNZ R7, SDELAY3 ; 2 machine cycle
        DJNZ R6, SDELAY2 ; 2 machine cycle
        DJNZ R5, SDELAY1 ; 2 machine cycle
        RET             ; 2 machine cycle

DIGIT_L_DATA:
        DB 70H
        DB 71H
        DB 72H
        DB 73H
        DB 74H
        DB 75H
        DB 76H
        DB 77H
        DB 78H
        DB 79H
DIGIT_H_DATA: 
        DB 0F0H
        DB 0B1H

        END
