File: lab06_2.asm
001: ; 搖搖棒，利用水銀開關做成interrupt，並且晃動兩次就換下一個字顯示
002: 
003:         CNT1 EQU 30H            ; count the times first word displayed
004:         CNT2 EQU 31H            ; same, but for second word
005:         CNT3 EQU 32H            ; same, but for third word
006:         
007:         ORG 00H
008:         JMP SETUP
009: 
010: ;=====SWITCH INTERRUPT INT0======
011:         ORG 03H
012:         CALL LED_SHOW           ; the function to display on LED
013:         RETI
014: 
015:         ORG 30H
016: SETUP:
017:         MOV IE, #81H            ; 1000 0001B enable interrpts for only INT0
018:         MOV CNT1, #04H          ; ---V
019:         MOV CNT2, #04H          ; set initial value
020:         MOV CNT3, #04H          ; ---A
021:         SETB IT0
022: 
023: MAIN:   JMP MAIN                ; if no interrupt, do nothing
024: 
025: ;=====LED SHOW=====
026: LED_SHOW:
027:         MOV R0, #72             ; R0 is the counter for table index
028:         MOV R1, #24             ; R1 is the counter of showing how many rows
029: LED_SHOW1:
030:         MOV A, CNT1             ; to check whether CNT1 equals to 0 
031:         JZ LED_SHOW2            ; if CNT1 is 0, jump to show next word
032:         DEC CNT1                ; CNT1--
033:         MOV DPTR, #TABLE2       ; move first word table to DPTR
034:         JMP NEXT_COLUMN         ; jump to output region
035: LED_SHOW2:
036:         MOV A, CNT2             ; to check whether CNT2 equals to 0 
037:         JZ LED_SHOW3            ; if CNT2 is 0, jump to show next word
038:         DEC CNT2                ; CNT2--
039:         MOV DPTR, #TABLE3       ; move second word table to DPTR
040:         JMP NEXT_COLUMN         ; jump to output region
041: LED_SHOW3:
042:         DEC CNT3                ; CNT3--
043:         MOV DPTR, #TABLE1       ; move third word table to DPTR
044:         MOV A, CNT3             ; to chech whether CNT3 equals to 0
045:         JNZ NEXT_COLUMN         ; if CNT3 is not 0, jump to output region
046:         MOV CNT1, #04H          ; ---V
047:         MOV CNT2, #04H          ; if CNT3 is 0, reset CNT1, CNT2, CNT3
048:         MOV CNT3, #04H          ; ---A
049: NEXT_COLUMN:                    ; Output region
050:         CALL READ_BYTE          ; get data of P0 from tableN
051:         MOV P0, A               ; output to P0
052:         CALL READ_BYTE          ; get data of P2 from tableN
053:         MOV P2, A               ; output to P2
054:         CALL READ_BYTE          ; get data of P1 from tableN
055:         MOV P1, A               ; output to P1
056:         CALL DELAY              
057:         DJNZ R1, NEXT_COLUMN    ; check whther have showed 24 rows
058:         RET
059: 
060: ;=====READ 1 BYTE FROM TABLE=====
061: READ_BYTE:
062:         DEC R0                  ; R0-- i.e. ( index of table )--
063:         MOV A, R0               ; 
064:         MOVC A, @A+DPTR         ; get data from table
065:         CPL A                   ; 1's complement
066:         RET
067: 
068: DELAY:                  
069:         MOV R5, #01H    ; 1 machine cycle
070: DELAY1:
071:         MOV R6, #10H    ; 1 machine cycle
072: DELAY2:
073:         MOV R7, #0FFH   ; 1 machine cycle
074: DELAY3:
075:         DJNZ R7, DELAY3 ; 2 machine cycle
076:         DJNZ R6, DELAY2 ; 2 machine cycle
077:         DJNZ R5, DELAY1 ; 2 machine cycle
078:         RET             ; 2 machine cycle
079: 
080: TABLE1:         ; 黃
081:         DB      0000000B,00000000B,00000000B
082:         DB      0000000B,00000011B,10001000B
083:         DB      1100000B,00000011B,10001100B
084:         DB      1110000B,00001111B,10001100B
085:         DB      0110111B,11111111B,00001100B
086:         DB      0111111B,11111111B,00001000B
087:         DB      0011010B,01001011B,00001010B
088:         DB      0011010B,01001011B,01111110B
089:         DB      0001010B,01001011B,01111111B
090:         DB      0001010B,01001011B,01111110B
091:         DB      0000010B,01001011B,01001000B
092:         DB      0000011B,11111011B,01001000B
093:         DB      0000011B,11111011B,01001000B
094:         DB      0001010B,01001011B,01001010B
095:         DB      0001110B,01001011B,01111110B
096:         DB      0011110B,01001011B,01111111B
097:         DB      0011010B,01001011B,01111110B
098:         DB      0110010B,01001011B,00001000B
099:         DB      0110111B,11111111B,00001000B
100:         DB      0100111B,11111111B,00001000B
101:         DB      1100000B,00000011B,00001000B
102:         DB      1000000B,00000011B,00001000B
103:         DB      1000000B,00000011B,00000000B
104:         DB      0000000B,00000000B,00000000B
105: 
106: TABLE2:         ; 宇
107:         DB      0000000B,00000000B,00000000B
108:         DB      0000000B,00110000B,00011000B
109:         DB      0000000B,00110000B,00111000B
110:         DB      0000000B,00110001B,01111000B
111:         DB      0000000B,00100001B,11111000B
112:         DB      0000000B,00100001B,10011000B
113:         DB      0000000B,00100001B,10011000B
114:         DB      0000000B,00100001B,00011000B
115:         DB      0000000B,00100001B,00011000B
116:         DB      0000000B,00100001B,00011000B
117:         DB      0000000B,00100001B,00011000B
118:         DB      0111111B,11111111B,00011110B
119:         DB      1111111B,11111111B,00011111B
120:         DB      1110000B,00100001B,00011011B
121:         DB      1110000B,00100001B,00011000B
122:         DB      0110000B,00100001B,00011000B
123:         DB      0110000B,00100001B,00011000B
124:         DB      0010000B,00100001B,00011000B
125:         DB      0000000B,00100001B,00011000B
126:         DB      0000000B,00100001B,00011000B
127:         DB      0000000B,00100000B,00111100B
128:         DB      0000000B,00100000B,01111100B
129:         DB      0000000B,00100000B,01100000B
130:         DB      0000000B,00000000B,00000000B
131: TABLE3:         ; 裼
132:         DB      0000000B,00000000B,00000000B
133:         DB      0001111B,11111000B,00000100B
134:         DB      0111111B,11111111B,11111110B
135:         DB      1111111B,11110111B,11111110B
136:         DB      1100000B,01110111B,11111110B
137:         DB      1110001B,11110010B,01100100B
138:         DB      0110011B,11110010B,01100100B
139:         DB      0010111B,00110110B,01100100B
140:         DB      0001110B,01110110B,01100100B
141:         DB      0011101B,11111110B,01100100B
142:         DB      0011011B,10011110B,01100100B
143:         DB      0110011B,00111111B,11111110B
144:         DB      0100110B,01110111B,11111110B
145:         DB      0101100B,11100111B,11111110B
146:         DB      0001100B,11100110B,00100000B
147:         DB      0001000B,10110110B,01110000B
148:         DB      0001000B,00111111B,11110000B
149:         DB      0000000B,00011011B,11101100B
150:         DB      1111111B,11111111B,00111110B
151:         DB      1111111B,11111110B,00100110B
152:         DB      1111111B,11111100B,00100010B
153:         DB      0000000B,00011000B,00100000B
154:         DB      0000000B,00110000B,00100000B
155:         DB      0000000B,00000000B,00000000B
156: 
157:         END
158: 
159: 
