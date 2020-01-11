; Terminal input UPPERCASE LETTER, then return corresponding lowercase letter.
; This program has foolproof. If not in range, return new line ('\n').
; Baudrate = 2400

        CHR EQU 30H             ; Store input character

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

MAIN:   JMP $

UART:                           ; ISR-Serial
        JB RI, RI_OK            ; Distinguish TI or RI
        CLR TI
        RETI
RI_OK:
        CLR RI
        MOV CHR, SBUF           ; Get data
        CALL TRANSMIT           ; Convert and transmit
        RETI

TRANSMIT:                       ; Convert and transmit
        CLR C                   ; Clear carry flag
        MOV A, CHR              ; Whether CHR > 'Z'
        SUBB A, #91
        JNC OUT_RANGE
        CLR C                   ; Clear carry flag
        MOV A, CHR              ; Whether 'A' <= CHR
        SUBB A, #65
        JC OUT_RANGE
        
        ADD A, #97              ; Convert it into lowercase
        MOV SBUF, A             ; Transmit
        RET
OUT_RANGE:                      ; If out of range, return newline. Foolproof
        MOV SBUF, #10           ; \n
        JNB TI, $
        MOV SBUF, #13           ; \r
        RET

        END