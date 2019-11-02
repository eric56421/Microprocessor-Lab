;在四個七段顯示器上顯示一個up counter
;從9990往上


                        ; 在BIT ADDRESSABLE (00H~7FH)的地方存
        RN_BIT EQU 00H  ; RN_BIT==0取R0，RN_BIT==1取R1 
        HL_BIT EQU 01H  ; HL_BIT==0取HIGH BCD，HL_BIT==1取LOW BCD
        
        ORG 00H         ; 將程式從00H開始存
SETUP:
        MOV R0, #99H    ; start with 9990 in decimal
        MOV R1, #90H    ; R0 stores high byte, R1 stores low byte

LOOP:                   ; LOOP是為了使8051可以持續跑		
        CALL SHOW       ; show 4-digits on 7-segment display
        CALL DELAYL     ; long delay
        CALL INCRE      ; 4-digits num ++
        JMP LOOP

SHOW:
        MOV R4, #02H    ; R4 is the counter for showing R0, R1 loop
        MOV R2, #0EFH   ; 11101111, is a bit flag. First four digits control 
                        ; which digits available, the order is right to left
                        ; and 0 is available.
        SETB RN_BIT     ; RN_BIT = 1
        SETB HL_BIT     ; HL_BIT = 1
SHOW_DIGIT_LOOP:        
        CPL RN_BIT      ; RN_BIT = ~RN_BIT
SHOW_R0:
        JB RN_BIT, SHOW_R1              ; if (RN_BIT) jump to SHOW_R1
        MOV A, R0                       ; put R0 into A to show 
        JMP SHOW_CONFIG_BCD_DIGIT       ; jump to SHOW_CONFIG_BCD_DIGIT
SHOW_R1:
        MOV A, R1                       ; put R0 into A to show
SHOW_CONFIG_BCD_DIGIT:
        JNB HL_BIT, SHOW_BCD_DIGIT      ; if (!HL_BIT) jump to SHOW_BCD_DIGIT
                                        ; this part is to show high BCD
                                        ; i.e. need to right shift
        ORL A, #0FH                     ; make last four digits 1
        RR A                            ; A >>= 4
        RR A
        RR A
        RR A        
SHOW_BCD_DIGIT:        
        ORL A, #0F0H    ; make first four digits 1
        ANL A, R2       ; AND with bit flag
        MOV P2, A       ; output to port 2
        CALL DELAYS     ; call short delay. display needs time to show
        XCH A, R2       ; 
        RL A            ; switch to another digits, A <<= 1
        XCH A, R2       ; 
        CPL HL_BIT      ; switch show the other part of BCD
        JNB HL_BIT, SHOW_R0             ; show the other part of BCD of RN
        DJNZ R4, SHOW_DIGIT_LOOP        ; R0, R1 loop
        RET

INCRE:                  ; INCRE為增加數字的function
        CLR C           ; clear cy-bit, otherwise DA may cause problems
        MOV A, R1       ; to increment R1
        INC A           ; A++
        DA A            ; Decimal Adjust A
        MOV R1, A       ; store back to R1
        MOV A, R0       ; to increment R0 if needed
        JNC NEXT        ; if (!C) jump to NEXT 
        INC A           ; A++ due to R1 carry
NEXT:
        CLR C           ; clear cy-bit, otherwise DA may cause problems
        DA A            ; DA A
        MOV R0, A       ; store back R0
        RET

DELAYS:                  
        MOV R5, #01H    ; 1 machine cycle
DELAYS1:
        MOV R6, #08H    ; 1 machine cycle
DELAYS2:
        MOV R7, #0F0H   ; 1 machine cycle
DELAYS3:
        DJNZ R7, DELAYS3 ; 2 machine cycle
        DJNZ R6, DELAYS2 ; 2 machine cycle
        DJNZ R5, DELAYS1 ; 2 machine cycle
        RET             ; 2 machine cycle

DELAYL:                  
        MOV R5, #0FH    ; 1 machine cycle
DELAYL1:
        MOV R6, #0FH    ; 1 machine cycle
DELAYL2:
        MOV R7, #0AH    ; 1 machine cycle
DELAYL3:
        DJNZ R7, DELAYL3 ; 2 machine cycle
        DJNZ R6, DELAYL2 ; 2 machine cycle
        DJNZ R5, DELAYL1 ; 2 machine cycle
        RET             ; 2 machine cycle

        END             ; 程式結束