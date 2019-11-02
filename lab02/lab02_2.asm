;依序在7段顯示器上顯示學號"-0710758"，並無限循環
;可用SWITCH控制DELAY TIME

        ORG 00H         ;將程式從00H開始存

SETUP:
        MOV DPTR, #TABLE;將TABLE所代表的地址搬進DPTR
        MOV P1, #0FFH   ;將P1設為 #0FFH，將Port 2設為Input模式
LOOP:                   ;LOOP是為了使8051可以持續跑		
        MOV R7, P1      ;R7 IS THE COUNTER OF DELAY2
        MOV R4, #0AH    ;將R4設為SHOWNUM迴圈計數器，並且給予初值8
        MOV R3, #0H     ;將R3設為儲存TABLE ARRAY的INDEX
                        
SHOWNUM:                ;SHOWNUM為顯示數字的單次流程
        MOV A, R3		;將TABLE的INDEX搬到A
        MOVC A, @A+DPTR	;將TABLE[R3]的值搬到A
        MOV P2, A	    ;R0搬到P1，輸出到LED
        CALL DELAY      ;呼叫DELAY 副程式
        INC R3			;TABLE array index++
        CJNE R3, #8H, SHOWNUM
                        ;判斷R3是否等於8，也就是判斷SHOWNUM是否跑了8次
        SJMP LOOP       ;使8051進入無限迴圈

DELAY:                  
        MOV R5, #0FFH   ; 1 machine cycle
DELAY1:
        MOV R6, #08FH   ; 1 machine cycle
DELAY2:
        MOV R7, P1      ; 1 machine cycle
        INC R7	        ; 1 machine cycle 
                        ; To avoid counter is zero. 
DELAY3:
        DJNZ R7, DELAY3 ; 2 machine cycle
        DJNZ R6, DELAY2 ; 2 machine cycle
        DJNZ R5, DELAY1 ; 2 machine cycle
        RET             ; 2 machine cycle

TABLE:
        DB 11111101B    ; symbol '-'
        DB 00000011B    ; num 0
        DB 00011011B    ; num 7
        DB 10011111B    ; num 1
        DB 00000011B    ; num 0		
        DB 00011011B    ; num 7
        DB 01001001B    ; num 5
        DB 00000001B    ; num 8

        END             ; 程式結束