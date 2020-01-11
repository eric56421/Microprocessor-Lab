; Terminal inputs 0-9, then output to 7-segment display with shifting.
; JP05 <-> P2.7
; Baudrate = 2400

        ; BCD[4]
        BCD EQU 30H             ; 4 bytes array
                
        ORG 00H
        JMP SETUP

        ORG 23H
        JMP UART

        ORG 30H
SETUP:
        MOV TMOD, #00100000B    ; Timer1 Mode 2
        MOV TH1, #0E6H          ; Due to 12MHz, 256-230 = 26
        SETB TR1                ; Timer1 run
        ORL PCON, #80H          ; SMOD 1
        CLR SM2                 ; Serial Mode 1
        SETB SM1                
        CLR SM0                 
        SETB REN                ; Enable receive
        MOV IE, #10010000B      ; Enable Serial interrpt
        SETB PS                 ; Set Serial high priority
        MOV SBUF, #'S'          ; Start

        MOV BCD+0, #0F1H        ; Initial value
        MOV BCD+1, #0F2H
        MOV BCD+2, #0F3H
        MOV BCD+3, #0F4H

MAIN:
        CALL DISPLAY            ; Display on 7-segment
        JMP MAIN

UART:                           ; ISR-Serial
        JB RI, RI_OK            ; Distinguish TI or RI
        CLR TI
        RETI
RI_OK:
        CLR RI
        MOV A, SBUF             ; Get data
        MOV SBUF, A             ; Return to terminal
        CALL SHIFT              ; Shift digits
        RETI

SHIFT:                          ; Left shift digits
        SUBB A, #48             ; ASCII to number
        MOV BCD+3, BCD+2        ; Left shift one digits
        MOV BCD+2, BCD+1
        MOV BCD+1, BCD+0
        MOV BCD+0, A
        RET

DISPLAY:
        MOV R0, #BCD            ; R0 points to BCD
        MOV R2, #4              ; R2 is counter, 4 digits
        MOV R3, #01111111B      ; 0 is available bit. This one is LSB
DISPLAY_1:
        MOV A, @R0              ; A = *R0
        ORL A, #0F0H            ; Make first four digits 1
        ANL A, R3               ; Combine control bits
        MOV P2, A               ; Output
        CALL SDELAY

        MOV A, R3
        RR A                    ; R3 >>= 1
        MOV R3, A
        INC R0                  ; R0++

        DJNZ R2, DISPLAY_1      ; Run for four digits
        RET

SDELAY:                  
        MOV R5, #03H            ; 1 machine cycle
SDELAY1:
        MOV R6, #08H            ; 1 machine cycle
SDELAY2:
        MOV R7, #0FFH           ; 1 machine cycle
SDELAY3:
        DJNZ R7, SDELAY3        ; 2 machine cycle
        DJNZ R6, SDELAY2        ; 2 machine cycle
        DJNZ R5, SDELAY1        ; 2 machine cycle
        RET                     ; 2 machine cycle

        END