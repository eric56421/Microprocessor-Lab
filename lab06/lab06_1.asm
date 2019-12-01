; ·n·n΄Ξ€WΕγ₯ά "γό"
               
        ORG 00H
        JMP SETUP

;=====SWITCH INTERRUPT=======
        ORG 03H
        CALL LED_SHOW           ; the function to display on LED
        RETI

        ORG 30H
SETUP:
        MOV IE, #81H            ; 1000 0001B enable interrpts for only INT0
        SETB IT0

MAIN:   JMP MAIN                ; if no interrupt, do nothing

;=====LED SHOW====================================
LED_SHOW:
        MOV R0, #72             ; R0 is the counter for table index
        MOV R1, #24             ; R1 is the counter of showing how many rows
        MOV DPTR, #TABLE        ; move the word table to DPTR
NEXT_COLUMN:                    ; Output region
        CALL READ_BYTE          ; get data of P0 from table
        MOV P0, A               ; output to P0
        CALL READ_BYTE          ; get data of P2 from table
        MOV P2, A               ; output to P2
        CALL READ_BYTE          ; get data of P1 from table
        MOV P1, A               ; output to P1
        CALL DELAY                            
        DJNZ R1, NEXT_COLUMN    ; check whther have showed 24 rows
        RET

;=====READ 1 BYTE FROM TABLE=======================
READ_BYTE:
        DEC R0                  ; R0-- i.e. ( index of table )--
        MOV A, R0               ; 
        MOVC A, @A+DPTR         ; get data from table
        CPL A                   ; 1's complement
        RET

DELAY:                  
        MOV R5, #01H    ; 1 machine cycle
DELAY1:
        MOV R6, #20H    ; 1 machine cycle
DELAY2:
        MOV R7, #0FFH    ; 1 machine cycle
DELAY3:
        DJNZ R7, DELAY3 ; 2 machine cycle
        DJNZ R6, DELAY2 ; 2 machine cycle
        DJNZ R5, DELAY1 ; 2 machine cycle
        RET             ; 2 machine cycle

TABLE:          ; γό
        DB      0000000B,00110000B,00000000B
        DB      0001111B,11111000B,00000100B
        DB      0111111B,11111111B,11111110B
        DB      1111111B,11110111B,11111110B
        DB      1100000B,01110111B,11111110B
        DB      1110001B,11110010B,01100100B
        DB      0110011B,11110010B,01100100B
        DB      0010111B,00110110B,01100100B
        DB      0001110B,01110110B,01100100B
        DB      0011101B,11111110B,01100100B
        DB      0011011B,10011110B,01100100B
        DB      0110011B,00111111B,11111110B
        DB      0100110B,01110111B,11111110B
        DB      0101100B,11100111B,11111110B
        DB      0001100B,11100110B,00100000B
        DB      0001000B,10110110B,01110000B
        DB      0001000B,00111111B,11110000B
        DB      0000000B,00011011B,11101100B
        DB      1111111B,11111111B,00111110B
        DB      1111111B,11111110B,00100110B
        DB      1111111B,11111100B,00100010B
        DB      0000000B,00011000B,00100000B
        DB      0000000B,00110000B,00100000B
        DB      0000000B,00100000B,00100000B

        END