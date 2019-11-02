;在四個七段顯示器上顯示一個讀秒 down counter
;60 ~ 0 -> 60  盡量將 delay 弄在剛好60秒

        ORG 00H         ; 將程式從00H開始存
SETUP:
        MOV R1, #10H                    ; start with 10 sec
        JMP DOWN_COUNTER                ; show initial value
        
LOOP:                   ; LOOP是為了使8051可以持續跑
        MOV R1, #60H    ; R1 is the 61 times loop counter
DOWN_COUNTER:
        CALL SHOW       ; show 4-digits on 7-segment display
        ;CALL DELAYL     ; long delay
        CALL DECRE      ; second num --
        CJNE R1, #0F9H, DOWN_COUNTER    ; run for 61 times
        JMP LOOP        ; recount from 60

SHOW:
        MOV R0, #0FFH
SHOW_HIG_BCD:        
        MOV A, R1       ; put R1 into A to show
        ORL A, #0FH     ; make last four bits 1
        RR A            ; A >>= 4
        RR A
        RR A
        RR A
        ANL A, #0FH     ; make first four bits 0
        JZ SHOW_LOW_BCD_1       ; if (!A) jump to SHOW_LOW_BCD i.e. no need to show
        ORL A, #0B0H    ; AND with bit flag
        MOV P2, A       ; output to port 2
        CALL DELAYS
        JMP SHOW_LOW_BCD_2
SHOW_LOW_BCD_1:
        CALL DELAYS     ; call short delay. display needs time to show
SHOW_LOW_BCD_2:
        MOV A, R1       ; put R1 into A to show
        ORL A, #0F0H    ; make first four bits 1
        ANL A, #7FH     ; AND with bit flag
        MOV P2, A       ; output to port 2
        CALL DELAYS
        DJNZ R0, SHOW_HIG_BCD
        RET

DECRE:                  ; DECRE為減少數字的function
        MOV A, R1       ; determine R1 is equal to times of ten
        ANL A, #0FH     ; make first four bits 0
        JZ NEXT         ; if (!A) jump to NEXT i.e. need BCD substraction
        DEC R1          ; R1--
        RET
NEXT:        
        MOV A, R1       ; to sub r1
        ADD A, #0F9H    ; BCD substraction
        MOV R1, A       ; store back to R1
        RET

DELAYS:                  
        MOV R5, #03H   ; 1 machine cycle
DELAYS1:
        MOV R6, #08H    ; 1 machine cycle
DELAYS2:
        MOV R7, #0FFH   ; 1 machine cycle
DELAYS3:
        DJNZ R7, DELAYS3 ; 2 machine cycle
        DJNZ R6, DELAYS2 ; 2 machine cycle
        DJNZ R5, DELAYS1 ; 2 machine cycle
        RET             ; 2 machine cycle

DELAYL:                  
        MOV R5, #0A0H   ; 1 machine cycle
DELAYL1:
        MOV R6, #080H   ; 1 machine cycle
DELAYL2:
        MOV R7, #080H   ; 1 machine cycle
DELAYL3:
        DJNZ R7, DELAYL3 ; 2 machine cycle
        DJNZ R6, DELAYL2 ; 2 machine cycle
        DJNZ R5, DELAYL1 ; 2 machine cycle
        RET             ; 2 machine cycle

        END             ; 程式結束