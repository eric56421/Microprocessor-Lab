File: lab03_2.asm
01: ;在四個七段顯示器上顯示一個讀秒 down counter
02: ;60 ~ 0 -> 60  盡量將 delay 弄在剛好60秒
03: 
04:         ORG 00H         ; 將程式從00H開始存
05: SETUP:
06:         MOV R1, #10H                    ; start with 10 sec
07:         JMP DOWN_COUNTER                ; show initial value
08:         
09: LOOP:                   ; LOOP是為了使8051可以持續跑
10:         MOV R1, #60H    ; R1 is the 61 times loop counter
11: DOWN_COUNTER:
12:         CALL SHOW       ; show 4-digits on 7-segment display
13:         CALL DELAYL     ; long delay
14:         CALL DECRE      ; second num --
15:         CJNE R1, #0F9H, DOWN_COUNTER    ; run for 61 times
16:         JMP LOOP        ; recount from 60
17: 
18: SHOW:
19: SHOW_HIG_BCD:
20:         MOV A, R1       ; put R0 into A to show
21:         ORL A, #0FH     ; make last four bits 1
22:         RR A            ; A >>= 4
23:         RR A
24:         RR A
25:         RR A
26:         ANL A, #0FH     ; make first four bits 0
27:         JZ SHOW_LOW_BCD ; if (!A) jump to SHOW_LOW_BCD i.e. no need to show
28:         ORL A, #0B0H    ; AND with bit flag
29:         MOV P2, A       ; output to port 2
30: SHOW_LOW_BCD:
31:         CALL DELAYS     ; call short delay. display needs time to show
32:         MOV A, R1       ; put R0 into A to show
33:         ORL A, #0F0H    ; make first four bits 1
34:         ANL A, #7FH     ; AND with bit flag
35:         MOV P2, A       ; output to port 2
36:         RET
37: 
38: DECRE:                  ; DECRE為減少數字的function
39:         MOV A, R1       ; determine R1 is equal to times of ten
40:         ANL A, #0FH     ; make first four bits 0
41:         JZ NEXT         ; if (!A) jump to NEXT i.e. need BCD substraction
42:         DEC R1          ; R1--
43:         RET
44: NEXT:        
45:         MOV A, R1       ; to sub r1
46:         ADD A, #0F9H    ; BCD substraction
47:         MOV R1, A       ; store back to R1
48:         RET
49: 
50: DELAYS:                  
51:         MOV R5, #0A0H   ; 1 machine cycle
52: DELAYS1:
53:         MOV R6, #0FH    ; 1 machine cycle
54: DELAYS2:
55:         MOV R7, #0F0H   ; 1 machine cycle
56: DELAYS3:
57:         DJNZ R7, DELAYS3 ; 2 machine cycle
58:         DJNZ R6, DELAYS2 ; 2 machine cycle
59:         DJNZ R5, DELAYS1 ; 2 machine cycle
60:         RET             ; 2 machine cycle
61: 
62: DELAYL:                  
63:         MOV R5, #0F0H   ; 1 machine cycle
64: DELAYL1:
65:         MOV R6, #0F0H   ; 1 machine cycle
66: DELAYL2:
67:         MOV R7, #029H   ; 1 machine cycle
68: DELAYL3:
69:         DJNZ R7, DELAYL3 ; 2 machine cycle
70:         DJNZ R6, DELAYL2 ; 2 machine cycle
71:         DJNZ R5, DELAYL1 ; 2 machine cycle
72:         RET             ; 2 machine cycle
73: 
74:         END             ; 程式結束