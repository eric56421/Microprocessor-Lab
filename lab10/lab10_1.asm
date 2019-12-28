; Connect PIN Sensor to get the distance in cm.
; With debounce switch to trigger.
; JP05 (BCD) <-> P2.0
; D02 (JP07 on debounce switch) <-> Trig (PIN Sensor)
; Echo (PIN Sensor) <-> P3.3
; 
; Ref: https://bbs.pigoo.com/forum.php?mod=viewthread&action=printable&tid=40828

        BIN EQU 30H
        ; BIN+1, BIN+0 STORE DISTANCE
        BCD EQU 32H
        ; BCD+2, BCD+1, BCD+0 STORE BCD
        HL_BIT EQU 00H
        
        ORG 00H
        JMP SETUP

        ORG 0BH         ; TIMER0
        SETB P3.5       ; send signal to timer1 (counter) ++
        CLR P3.5
        RETI

        ORG 13H         ; INT1
        JMP UPDATE

        ORG 30H
SETUP:
        MOV IP, #00000100B      ; set priority, where INT1 is high
        MOV TMOD, #11010010B    ; timer0: mode 2; timer1: mode 1, counter, gate
        MOV TH0, #198           ; 29*2 = 58us
        MOV TL0, #198
        MOV TH1, #00            ; reset
        MOV TL1, #00
        SETB TR0                ; run timer0
        SETB TR1                ; run timer1
        SETB IT1                ; set timer1 (couter) as falling edge trigger
        SETB P3.5               ; set P3.5 as output
        
        MOV IE, #10000110B      ; Interrupt Enable, set timer0 and INT1

MAIN:   
        CALL SHOW               ; SHOW on BCD
        JMP MAIN
;
UPDATE:                         ; Update the distance and BIN 2 BCD
        CLR IE1                 ; clear INT1 signal
        MOV BIN+1, TH1          ; store distance
        MOV BIN, TL1
        MOV TH1, #00H           ; reset counter
        MOV TL1, #00H
        CALL BIN2BCD            ; BIN 2 BCD
        RETI
;
BIN2BCD:                        ; Convert binary to BCD
                                ; get 1 bit from MSB and multiply by 2
        MOV BCD, #0             ; reset BCD
        MOV BCD+1, #0           ; using like array
        MOV BCD+2, #0
        MOV R2, #16             ; to process 16 bits
BIN2BCD_NEXT_BIT:               ; to get current MSB and left shift
        MOV R0, #BIN            ; R0 points to BIN
        MOV R3, #2              ; R3 is the counter. 2 for 2 bytes of BIN
BIN2BCD_LS:                     ; LEFT SHIFT
        MOV A, @R0              ; left shift BIN array
        RLC A
        MOV @R0, A
        INC R0                  ; process from low byte
        DJNZ R3, BIN2BCD_LS     ; 2 bytes long

        MOV R0, #BCD            ; R0 points to BCD
        MOV R3, #3              ; R3 is the counter. 3 for 3 bytes of BCD
BIN2BCD_DOUBLE:                 ; Multiply BCD by 2
        MOV A, @R0              ; (*R0) *= 2
        ADDC A, @R0
        DA A                    ; decimal adjust
        MOV @R0, A
        INC R0                  ; process from low byte
        DJNZ R3, BIN2BCD_DOUBLE ; 3 bytes long

        DJNZ R2, BIN2BCD_NEXT_BIT       ; next bit in BIN
        RET
;
SHOW:                           ; Show on BCD
        MOV R0, #BCD            ; R0 points BCD
        MOV R2, #4              ; LOOP COUNTER. 4 for 4 7-segments display
        MOV R3, #01111111B      ; 0 for available digit. This is the LSB one. 
        CLR HL_BIT              ; 0 <-> low byte
SHOW_DIGITS:                    ; Show one digit on 7-segment display
        MOV A, @R0              ; process (*R0)
        JNB HL_BIT, SHOW_COMBINE        ; Whether this time is to show high byte
        SWAP A                  ; A >>= 4
SHOW_COMBINE:                   ; Combine control flag with number
        ORL A, #0F0H            ; make first four digits 1
        ANL A, R3               ; combine control flag
        MOV P2, A               ; output to display
        CALL SDELAY             ; stop for display

        CPL HL_BIT              ; high->low or low->high byte
        MOV A, R3               ; to show higher (lefter) digit
        RR A                    ; A >>= 1
        MOV R3, A        
        JB HL_BIT, SHOW_NEXT_BIT        ; Wheter to read data from next byte
        INC R0

SHOW_NEXT_BIT:
        DJNZ R2, SHOW_DIGITS    ; 4 digits to show
        RET
;
SDELAY:                  
        MOV R5, #03H    ; 1 machine cycle
SDELAY1:
        MOV R6, #08H    ; 1 machine cycle
SDELAY2:
        MOV R7, #0FFH   ; 1 machine cycle
SDELAY3:
        DJNZ R7, SDELAY3 ; 2 machine cycle
        DJNZ R6, SDELAY2 ; 2 machine cycle
        DJNZ R5, SDELAY1 ; 2 machine cycle
        RET             ; 2 machine cycle


        END

