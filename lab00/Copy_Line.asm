File: lab07_2.asm
001: ; use keyboard to control how step motor spining
002: ; 10 mode: 90, 180, 270, 360, keep sining for two ways        
003: ; P1 connected to step motor.
004: ; P2 connected to keyboard.
005: 
006:         KEY_VAL EQU 30H
007:         ROW_CNT EQU 31H
008: 
009:         ORG 00H
010:         JMP SETUP
011:         
012:         ORG 30H
013: SETUP:
014:         MOV P1, #00H            ; set P1, which is conneted to motor, as output
015:         MOV KEY_VAL, #00H       ; set initial value
016:         
017: MAIN:
018:         CALL KEY_PUSH_POLLING   ; keep polling whether key is pushed
019:         CALL SPIN_BY_CASE       ; spin the motor by cas
020:         MOV P1, #00H            ; avoid motor becoming hot
021:         JMP MAIN
022: 
023: RR_90:                          ; spin clockwise for 90 degrees
024:         MOV R3, #20H            ; R3 is the counter for spining 90 degrees
025: RR_90_LOOP:
026:         CALL MOTOR_SPIN_RR      
027:         DJNZ R3, RR_90_LOOP     ; to run 32 times
028:         RET
029: 
030: LR_90:                          ; spin counter clockwise for 90 degrees
031:         MOV R3, #20H            ; R3 is the counter for spining 90 degrees
032: LR_90_LOOP:
033:         CALL MOTOR_SPIN_LR
034:         DJNZ R3, LR_90_LOOP     ; to run 32 times
035:         RET
036: 
037: MOTOR_SPIN_RR:                  ; the inner motor spins for a Cycle
038:         MOV R4, #04H            ; R4 is the index to read table
039:         MOV DPTR, #TABLE_RR     ; set correct table to read
040:         JMP SPIN                ; jmup to spin region
041: MOTOR_SPIN_LR:                  ; the inner motor spins for a Cycle
042:         MOV R4, #04H            ; R4 is the index to read table
043:         MOV DPTR, #TABLE_LR     ; set correct table to read
044: SPIN:                           ; sping region
045:         DEC R4                  ; R4--
046:         MOV A, R4               ; -----V
047:         MOVC A, @A+DPTR         ; get data from table
048:         MOV P1, A               ; -----A
049:         CALL SDELAY             ; stops for a while
050:         CJNE R4, #0H, SPIN      ; to run 4 times
051:         RET
052: 
053: SPIN_BY_CASE:
054:         MOV R0, KEY_VAL         ; compare KEY_VAL in switch syntax funtion
055: R_90:                   
056:         CJNE R0, #7EH, R_180
057:         CALL RR_90              ; R 90 degrees
058:         RET
059: R_180:
060:         CJNE R0, #7DH, R_270
061:         CALL RR_90              ; R 180 degrees
062:         CALL RR_90
063:         RET
064: R_270:
065:         CJNE R0, #7BH, R_360
066:         CALL RR_90              ; R 270 degrees
067:         CALL RR_90
068:         CALL RR_90
069:         RET
070: R_360:
071:         CJNE R0, #77H, L_90
072:         CALL RR_90              ; R 360 degrees
073:         CALL RR_90
074:         CALL RR_90
075:         CALL RR_90
076:         RET
077: L_90:
078:         CJNE R0, #0BEH, L_180
079:         CALL LR_90              ; L 90 degrees
080:         RET
081: L_180:
082:         CJNE R0, #0BDH, L_270
083:         CALL LR_90              ; L 180 degrees
084:         CALL LR_90
085:         RET
086: L_270:
087:         CJNE R0, #0BBH, L_360
088:         CALL LR_90              ; L 270 degrees
089:         CALL LR_90
090:         CALL LR_90
091:         RET
092: L_360:
093:         CJNE R0, #0B7H, R_FOREVER
094:         CALL LR_90              ; L 360 degrees
095:         CALL LR_90
096:         CALL LR_90
097:         CALL LR_90
098:         RET
099: R_FOREVER:
100:         CALL RR_90
101:         CJNE R0, #0DEH, L_FOREVER       ; keep spining
102:         JMP R_FOREVER
103: L_FOREVER:
104:         CALL LR_90
105:         CJNE R0, #0DDH, OTHER_CASE      ; keep spining
106:         JMP L_FOREVER
107: OTHER_CASE:
108:         RET                             ; no spining
109: 
110: KEY_PUSH_POLLING:
111:         MOV ROW_CNT, #04H       ; ROW_CNT is counter for scanning 4 rows
112:         MOV R4, #07FH           ; R4 is bit flag to control reading which row
113: POLLING:
114:         MOV P2, R4              ; output control to P2
115:         MOV A, R4               ; -----V
116:         RR A                    ; R4 >>= 1, to read next row
117:         MOV R4, A               ; -----A
118:         MOV A, P2               ; input to A
119:         MOV KEY_VAL, A          ; copy input to KEY_VAL(key value)
120:         ANL A, #0FH             ; to get last 4 bits of KEY_VAL
121:         CJNE A, #0FH, POLLING_RET ; if the key is pushed, it won't equal to 0FH
122:         DJNZ ROW_CNT, POLLING   ; to check 4 rows
123:         JMP KEY_PUSH_POLLING    ; repolling from first row
124: POLLING_RET:
125:         RET
126: 
127: SDELAY:                  
128:         MOV R5, #20H            ; 1 machine cycle
129: SDELAY1:
130:         MOV R6, #10H            ; 1 machine cycle
131: SDELAY2:
132:         MOV R7, #10H            ; 1 machine cycle
133: SDELAY3:
134:         DJNZ R7, SDELAY3        ; 2 machine cycle
135:         DJNZ R6, SDELAY2        ; 2 machine cycle
136:         DJNZ R5, SDELAY1        ; 2 machine cycle
137:         RET                     ; 2 machine cycle
138: 
139: TABLE_RR:                       ; table for spining
140:         DB 00001000B
141:         DB 00000100B
142:         DB 00000010B
143:         DB 00000001B
144: TABLE_LR:
145:         DB 00000001B
146:         DB 00000010B
147:         DB 00000100B
148:         DB 00001000B
149: 
150:         END
151: 
