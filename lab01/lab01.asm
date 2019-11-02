        ORG 00H         ;將程式從00H開始存

LOOP:                   ;LOOP是為了使8051可以持續跑
        MOV R0, #7FH    ;將R0設為儲存LED的記憶體空間，並且給予初值 #7FH(0111 1111)，綠色燈是輸出0亮
        MOV R4, #08H    ;將R4設為SUBLOOP的迴圈計數器，並且給予初值 #8H
SUBLOOP:                ;SUBLOOP為跑馬燈的單次流程，LED從左至右亮一遍
        MOV P1, R0      ;R0搬到P1，輸出到LED
        CALL DELAY      ;呼叫DELAY 副程式
        MOV A, R0       ;VVV
        RR A            ;藉由 A 將 R0 的值 RIGHT SHIFT 1
        MOV R0, A       ;^^^
        DJNZ R4, SUBLOOP;判斷R4是否等於0，也就是判斷SUBLOOP是否跑了8次

        SJMP LOOP       ;使8051進入無限迴圈

DELAY:                  ; Dealy time = [ 1 + (1 + (1 + (2)*5 + 2)*159 + 2)*255 + 2] / 6
                        ;            = 527853 / 6 = 87975 us = 0.87975 s
        MOV R5, #0FFH   ; 1 machine cycle
DELAY1:
        MOV R6, #9FH    ; 1 machine cycle
DELAY2:
        MOV R7, #05H    ; 1 machine cycle
DELAY3:
        DJNZ R7, DELAY3 ; 2 machine cycle
        DJNZ R6, DELAY2 ; 2 machine cycle
        DJNZ R5, DELAY1 ; 2 machine cycle
        RET             ; 2 machine cycle

        END             ;程式結束


DELAY:                  ; Dealy time = [ 1 + (1 + (1 + (2)*198 + 2)*50 + 2)*75 + 2] / 6
                        ;            = 1.496478 s
        MOV R5, #4BH    ; 1 machine cycle
DELAY1:
        MOV R6, #32H    ; 1 machine cycle
DELAY2:
        MOV R7, #0C6H   ; 1 machine cycle
DELAY3:
        DJNZ R7, DELAY3 ; 2 machine cycle
        DJNZ R6, DELAY2 ; 2 machine cycle
        DJNZ R5, DELAY1 ; 2 machine cycle
        RET             ; 2 machine cycle
