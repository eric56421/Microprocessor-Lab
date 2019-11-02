;依序在7段顯示器上顯示0~9，並無限循環
;無法用SWITCH控制DELAY TIME

        ORG 00H         ;將程式從00H開始存

SETUP:
        MOV DPTR, #TABLE;將TABLE所代表的地址搬進DPTR
LOOP:                   ;LOOP是為了使8051可以持續跑		
        MOV R4, #0AH    ;將R4設為SHOWNUM迴圈計數器，並且給予初值 #10
        MOV R3, #0H     ;將R3設為儲存TABLE ARRAY的INDEX
                        
SHOWNUM:                ;SHOWNUM為顯示數字的單次流程
        MOV A, R3	;將TABLE的INDEX搬到A
        MOVC A, @A+DPTR	;將TABLE[R3]的值搬到A
        MOV P2, A	;R0搬到P1，輸出到LED
        CALL DELAY      ;呼叫DELAY 副程式
        INC R3		;TABLE array index++
        CJNE R3, #0AH, SHOWNUM
                        ;判斷R3是否等於10，也就是判斷SHOWNUM是否跑了10次
        SJMP LOOP       ;使8051進入無限迴圈

DELAY:                  
        MOV R5, #0FFH   ; 1 machine cycle
DELAY1:
        MOV R6, #08FH   ; 1 machine cycle
DELAY2:
        MOV R7, #18H    ; 1 machine cycle
DELAY3:
        DJNZ R7, DELAY3 ; 2 machine cycle
        DJNZ R6, DELAY2 ; 2 machine cycle
        DJNZ R5, DELAY1 ; 2 machine cycle
        RET             ; 2 machine cycle

TABLE:
        DB 00000011B    ; num 0
        DB 10011111B    ; num 1
        DB 00100101B    ; num 2
        DB 00001101B    ; num 3		
        DB 10011001B    ; num 4
        DB 01001001B    ; num 5
        DB 01000001B    ; num 6
        DB 00011011B    ; num 7
        DB 00000001B    ; num 8
        DB 00011001B    ; num 9

        END             ; 程式結束