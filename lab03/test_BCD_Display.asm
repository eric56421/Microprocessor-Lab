;依序在7段顯示器上顯示0~9，並無限循環
;無法用SWITCH控制DELAY TIME
;QA
;1. DA INTRODUCTION
;CALL OR JMP
;JNZ
;
;
;
;
;
;
        RN_BIT EQU 00H
        HL_BIT EQU 01H

        ORG 00H         ;將程式從00H開始存

LOOP:
        MOV P2, A
        MOV P2, #0E9H
        CALL DELAY
        MOV P2, #0D8H
        CALL DELAY
        MOV P2, #0B7H
        CALL DELAY
        MOV P2, #076H
        CALL DELAY
        ;CALL DELAY
;SUBLOOP:
;        MOV A, R0
;        CLR C
;        RLC A
;        RLC A
;        RLC A
;        RLC A
;        CPL A
;        ANL A, #0F7H
;        MOV P2, A
;        CALL DELAY
;        DJNZ R0, SUBLOOP
        JMP LOOP
        
DELAY:                  
        MOV R5, #0FH   ; 1 machine cycle
DELAY1:
        MOV R6, #0FH   ; 1 machine cycle
DELAY2:
        MOV R7, #18H    ; 1 machine cycle
DELAY3:
        DJNZ R7, DELAY3 ; 2 machine cycle
        DJNZ R6, DELAY2 ; 2 machine cycle
        DJNZ R5, DELAY1 ; 2 machine cycle
        RET             ; 2 machine cycle

        END             ; 程式結束