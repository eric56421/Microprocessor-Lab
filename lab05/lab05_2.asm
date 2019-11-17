; Keyboard with 7-segment display showing number on the right side.
; And left shift original digits.


        DIGIT_0 EQU 30H ; Digit_0 is the rightest digit on 7-segment display
        DIGIT_1 EQU 31H
        DIGIT_2 EQU 32H
        DIGIT_3 EQU 33H
        NUM_L EQU 34H
        NUM_H EQU 35H
        NUM EQU 36H
        IS_CLICKED EQU 00H
        
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
        MOV R1, #0FEH   ; R1 controls reads which col. First check the rightest
        MOV R2, #04H    ; R2 is the counter of LOOP_GET_KEY_COL
        MOV P3, R1      ; Control reads which col
        CLR IS_CLICKED  ; Clear IS_CLICKED flag
        JMP LOOP_GET_KEY_ROW    ; Jump to check button of that col
LOOP_GET_KEY_COL:
        XCH A, R1       ; ----------V
        RL A            ; Read next col (to left)
        XCH A, R1       ; ----------A
        MOV P3, R1      ; Control reads which col
LOOP_GET_KEY_ROW:
        MOV P2, #0FFH   ; Set P2 as input mode
        MOV R0, P2      ; R0 store P2        
ROW_0:
        CJNE R0, #0F7H, ROW_1   ; Whether the first(hightest) button is clicked.
        MOV NUM, #0CH           ; Set num to 12
        SETB IS_CLICKED         ; Set flag
        JMP GET_KEY_RETURN      ; Jump to Return part
ROW_1:
        CJNE R0, #0FBH, ROW_2   ; Whether the second is clicked.
        MOV NUM, #08H           ; Set num to 8
        SETB IS_CLICKED         ; Set flag
        JMP GET_KEY_RETURN      ; Jump to Return part
ROW_2:
        CJNE R0, #0FDH, ROW_3   ; Whether the third is clicked.
        MOV NUM, #04H           ; Set num to 4
        SETB IS_CLICKED         ; Set flag
        JMP GET_KEY_RETURN      ; Jump to Return part
ROW_3:
        CJNE R0, #0FEH, ROW_NO  ; Whether the fourth is clicked.
        MOV NUM, #00H           ; Set num to 0
        SETB IS_CLICKED         ; Set flag
        JMP GET_KEY_RETURN      ; Jump to Return part
ROW_NO:
        DJNZ R2, LOOP_GET_KEY_COL       ; If no clicked, check next col
        RET                     ; If all are not clicked, don't change num
GET_KEY_RETURN:
        MOV A, NUM              ; To configure NUM
        ADD A, R2               ; Make it to correct value by adding offset
        DEC A                   ; The offset has extra 1
        DA A                    ; Make it BCD display
        MOV NUM, A              ; Restore to NUM
        RET

SHOW:
        MOV R4, #60H            ; R4 is the counter to show 96 times the num
        MOV A, NUM              ; To separate the num get
        MOV NUM_L, #0FH         ; To get the low part of num
        ANL NUM_L, A
        MOV NUM_H, #0FH         ; To get the high part of num
        SWAP A                  ; Make it to be low part
        ANL NUM_H, A
        JNB IS_CLICKED, OUTPUT  ; If it's not clicked, output original one
        CALL SHIFT_DIGIT        ; Left shift one digit
SHOW_DIGIT_H:
        MOV DPTR, #DIGIT_H_DATA ; Set DPTR to data of high digit
        MOV A, NUM_H            ; Move the index
        MOVC A, @A+DPTR         ; Get the output control data of high digit
        JZ SHOW_DIGIT_L         ; If it's not two digits #, jump to SHOW_DIGIT_L
        MOV DIGIT_0, A          ; Store to the DIGIT_1
        CALL SHIFT_DIGIT
SHOW_DIGIT_L:        
        MOV DPTR, #DIGIT_L_DATA ; Set DPTR to data of low digit
        MOV A, NUM_L            ; Move the index
        MOVC A, @A+DPTR         ; Get the output control data of low digit
        MOV DIGIT_0, A          ; Store to the DIGIT_0
OUTPUT:                         ; Port 1 connected to 7-segment display
        ANL DIGIT_0, #0FH       ; ----------------v
        ORL DIGIT_0, #70H       ; Get low part of value
        MOV P1, DIGIT_0         ; Set correct digit to show
        CALL SDELAY             ; Output to Port 1
        ANL DIGIT_1, #0FH       ; Stops for a while
        ORL DIGIT_1, #0B0H
        MOV P1, DIGIT_1         
        CALL SDELAY
        ANL DIGIT_2, #0FH
        ORL DIGIT_2, #0D0H
        MOV P1, DIGIT_2        
        CALL SDELAY
        ANL DIGIT_3, #0FH
        ORL DIGIT_3, #0E0H
        MOV P1, DIGIT_3        
        CALL SDELAY
        DJNZ R4, OUTPUT         ; -----------------A
        RET

SHIFT_DIGIT:
        PUSH DIGIT_2            ; Left shift 7-segments digits by push and pop
        PUSH DIGIT_1
        PUSH DIGIT_0
        POP DIGIT_1
        POP DIGIT_2
        POP DIGIT_3
        RET

SDELAY:                  
        MOV R5, #1H     ; 1 machine cycle
SDELAY1:
        MOV R6, #4H     ; 1 machine cycle
SDELAY2:
        MOV R7, #0FFH   ; 1 machine cycle
SDELAY3:
        DJNZ R7, SDELAY3 ; 2 machine cycle
        DJNZ R6, SDELAY2 ; 2 machine cycle
        DJNZ R5, SDELAY1 ; 2 machine cycle
        RET             ; 2 machine cycle

DIGIT_L_DATA:
        DB 00H
        DB 01H
        DB 02H
        DB 03H
        DB 04H
        DB 05H
        DB 06H
        DB 07H
        DB 08H
        DB 09H
DIGIT_H_DATA: 
        DB 00H
        DB 01H

        END
