File: lab05_2.asm
001: ; Keyboard with 7-segment display showing number on the right side.
002: ; And left shift original digits.
003: 
004: 
005:         DIGIT_0 EQU 30H ; Digit_0 is the rightest digit on 7-segment display
006:         DIGIT_1 EQU 31H
007:         DIGIT_2 EQU 32H
008:         DIGIT_3 EQU 33H
009:         NUM_L EQU 34H
010:         NUM_H EQU 35H
011:         NUM EQU 36H
012:         IS_CLICKED EQU 00H
013:         
014:         ORG 00H
015:         JMP SETUP
016: 
017:         ORG 40H
018: SETUP:
019:         MOV P2, #0FFH   ; P2 reads column data. Set P2 as input mode
020:         MOV P3, #00H    ; P3 controls which col to read. Set P3 as output mode
021: 
022: MAIN:
023:         CALL GET_KEY    
024:         CALL SHOW
025:         JMP MAIN
026: 
027: GET_KEY:
028:         MOV R1, #0FEH   ; R1 controls reads which col. First check the rightest
029:         MOV R2, #04H    ; R2 is the counter of LOOP_GET_KEY_COL
030:         MOV P3, R1      ; Control reads which col
031:         CLR IS_CLICKED  ; Clear IS_CLICKED flag
032:         JMP LOOP_GET_KEY_ROW    ; Jump to check button of that col
033: LOOP_GET_KEY_COL:
034:         XCH A, R1       ; ----------V
035:         RL A            ; Read next col (to left)
036:         XCH A, R1       ; ----------A
037:         MOV P3, R1      ; Control reads which col
038: LOOP_GET_KEY_ROW:
039:         MOV P2, #0FFH   ; Set P2 as input mode
040:         MOV R0, P2      ; R0 store P2        
041: ROW_0:
042:         CJNE R0, #0F7H, ROW_1   ; Whether the first(hightest) button is clicked.
043:         MOV NUM, #0CH           ; Set num to 12
044:         SETB IS_CLICKED         ; Set flag
045:         JMP GET_KEY_RETURN      ; Jump to Return part
046: ROW_1:
047:         CJNE R0, #0FBH, ROW_2   ; Whether the second is clicked.
048:         MOV NUM, #08H           ; Set num to 8
049:         SETB IS_CLICKED         ; Set flag
050:         JMP GET_KEY_RETURN      ; Jump to Return part
051: ROW_2:
052:         CJNE R0, #0FDH, ROW_3   ; Whether the third is clicked.
053:         MOV NUM, #04H           ; Set num to 4
054:         SETB IS_CLICKED         ; Set flag
055:         JMP GET_KEY_RETURN      ; Jump to Return part
056: ROW_3:
057:         CJNE R0, #0FEH, ROW_NO  ; Whether the fourth is clicked.
058:         MOV NUM, #00H           ; Set num to 0
059:         SETB IS_CLICKED         ; Set flag
060:         JMP GET_KEY_RETURN      ; Jump to Return part
061: ROW_NO:
062:         DJNZ R2, LOOP_GET_KEY_COL       ; If no clicked, check next col
063:         RET                     ; If all are not clicked, don't change num
064: GET_KEY_RETURN:
065:         MOV A, NUM              ; To configure NUM
066:         ADD A, R2               ; Make it to correct value by adding offset
067:         DEC A                   ; The offset has extra 1
068:         DA A                    ; Make it BCD display
069:         MOV NUM, A              ; Restore to NUM
070:         RET
071: 
072: SHOW:
073:         MOV R4, #60H            ; R4 is the counter to show 96 times the num
074:         MOV A, NUM              ; To separate the num get
075:         MOV NUM_L, #0FH         ; To get the low part of num
076:         ANL NUM_L, A
077:         MOV NUM_H, #0FH         ; To get the high part of num
078:         SWAP A                  ; Make it to be low part
079:         ANL NUM_H, A
080:         JNB IS_CLICKED, OUTPUT  ; If it's not clicked, output original one
081:         CALL SHIFT_DIGIT        ; Left shift one digit
082: SHOW_DIGIT_H:
083:         MOV DPTR, #DIGIT_H_DATA ; Set DPTR to data of high digit
084:         MOV A, NUM_H            ; Move the index
085:         MOVC A, @A+DPTR         ; Get the output control data of high digit
086:         JZ SHOW_DIGIT_L         ; If it's not two digits #, jump to SHOW_DIGIT_L
087:         MOV DIGIT_0, A          ; Store to the DIGIT_1
088:         CALL SHIFT_DIGIT
089: SHOW_DIGIT_L:        
090:         MOV DPTR, #DIGIT_L_DATA ; Set DPTR to data of low digit
091:         MOV A, NUM_L            ; Move the index
092:         MOVC A, @A+DPTR         ; Get the output control data of low digit
093:         MOV DIGIT_0, A          ; Store to the DIGIT_0
094: OUTPUT:                         ; Port 1 connected to 7-segment display
095:         ANL DIGIT_0, #0FH       ; ----------------v
096:         ORL DIGIT_0, #70H       ; Get low part of value
097:         MOV P1, DIGIT_0         ; Set correct digit to show
098:         CALL SDELAY             ; Output to Port 1
099:         ANL DIGIT_1, #0FH       ; Stops for a while
100:         ORL DIGIT_1, #0B0H
101:         MOV P1, DIGIT_1         
102:         CALL SDELAY
103:         ANL DIGIT_2, #0FH
104:         ORL DIGIT_2, #0D0H
105:         MOV P1, DIGIT_2        
106:         CALL SDELAY
107:         ANL DIGIT_3, #0FH
108:         ORL DIGIT_3, #0E0H
109:         MOV P1, DIGIT_3        
110:         CALL SDELAY
111:         DJNZ R4, OUTPUT         ; -----------------A
112:         RET
113: 
114: SHIFT_DIGIT:
115:         PUSH DIGIT_2            ; Left shift 7-segments digits by push and pop
116:         PUSH DIGIT_1
117:         PUSH DIGIT_0
118:         POP DIGIT_1
119:         POP DIGIT_2
120:         POP DIGIT_3
121:         RET
122: 
123: SDELAY:                  
124:         MOV R5, #1H     ; 1 machine cycle
125: SDELAY1:
126:         MOV R6, #4H     ; 1 machine cycle
127: SDELAY2:
128:         MOV R7, #0FFH   ; 1 machine cycle
129: SDELAY3:
130:         DJNZ R7, SDELAY3 ; 2 machine cycle
131:         DJNZ R6, SDELAY2 ; 2 machine cycle
132:         DJNZ R5, SDELAY1 ; 2 machine cycle
133:         RET             ; 2 machine cycle
134: 
135: DIGIT_L_DATA:
136:         DB 00H
137:         DB 01H
138:         DB 02H
139:         DB 03H
140:         DB 04H
141:         DB 05H
142:         DB 06H
143:         DB 07H
144:         DB 08H
145:         DB 09H
146: DIGIT_H_DATA: 
147:         DB 00H
148:         DB 01H
149: 
150:         END
151: 
