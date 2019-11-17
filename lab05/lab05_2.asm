; Keyboard with 7-segment display showing number on the right side.

        DIGIT_0 EQU 30H ; Digit_0 is the rightest digit on 7-segment display
        DIGIT_1 EQU 31H
        DIGTI_2 EQU 32H
        DIGIT_3 EQU 33H
        NUM_L EQU 34H
        NUM_H EQU 35H
        NUM EQU 36H
        
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
        JMP GET_KEY_RETURN      ; Jump to Return part
ROW_1:
        CJNE R0, #0FBH, ROW_2   ; Whether the second is clicked.
        MOV NUM, #08H           ; Set num to 8
        JMP GET_KEY_RETURN      ; Jump to Return part
ROW_2:
        CJNE R0, #0FDH, ROW_3   ; Whether the third is clicked.
        MOV NUM, #04H           ; Set num to 4
        JMP GET_KEY_RETURN      ; Jump to Return part
ROW_3:
        CJNE R0, #0FEH, ROW_NO  ; Whether the fourth is clicked.
        MOV NUM, #00H           ; Set num to 0
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
        MOV R4, #18H            ; R4 is the counter to show 20 times the num
        MOV A, NUM              ; To separate the num get
        MOV NUM_L, #0FH         ; To get the low part of num
        ANL NUM_L, A
        MOV NUM_H, #0FH         ; To get the high part of num
        SWAP A                  ; Make it to be low part
        ANL NUM_H, A
SHOW_DIGIT_L:        
        MOV DPTR, #DIGIT_L_DATA ; Set DPTR to data of low digit
        MOV A, NUM_L            ; Move the index
        MOVC A, @A+DPTR         ; Get the output control data of low digit
        MOV DIGIT_0, A          ; Store to the DIGIT_0
SHOW_DIGIT_H:
        MOV DPTR, #DIGIT_H_DATA ; Set DPTR to data of high digit
        MOV A, NUM_H            ; Move the index
        MOVC A, @A+DPTR         ; Get the output control data of high digit
        MOV DIGIT_1, A          ; Store to the DIGIT_1
OUTPUT:                         ; Port 1 connected to 7-segment display
        MOV P1, DIGIT_0         ; -----------------V
        CALL SDELAY             ; Output to 7-segment display
        MOV P1, DIGIT_1         ; And stops for a little while
        CALL SDELAY             ; 
        DJNZ R4, OUTPUT         ; -----------------A
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
