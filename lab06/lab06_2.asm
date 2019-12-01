; 搖搖棒，利用水銀開關做成interrupt，並且晃動兩次就換下一個字顯示

        CNT1 EQU 30H            ; count the times first word displayed
        CNT2 EQU 31H            ; same, but for second word
        CNT3 EQU 32H            ; same, but for third word
        
        ORG 00H
        JMP SETUP

;=====SWITCH INTERRUPT INT0======
        ORG 03H
        CALL LED_SHOW           ; the function to display on LED
        RETI

        ORG 30H
SETUP:
        MOV IE, #81H            ; 1000 0001B enable interrpts for only INT0
        MOV CNT1, #04H          ; ---V
        MOV CNT2, #04H          ; set initial value
        MOV CNT3, #04H          ; ---A
        SETB IT0

MAIN:   JMP MAIN                ; if no interrupt, do nothing

;=====LED SHOW=====
LED_SHOW:
        MOV R0, #72             ; R0 is the counter for table index
        MOV R1, #24             ; R1 is the counter of showing how many rows
LED_SHOW1:
        MOV A, CNT1             ; to check whether CNT1 equals to 0 
        JZ LED_SHOW2            ; if CNT1 is 0, jump to show next word
        DEC CNT1                ; CNT1--
        MOV DPTR, #TABLE2       ; move first word table to DPTR
        JMP NEXT_COLUMN         ; jump to output reigon
LED_SHOW2:
        MOV A, CNT2             ; to check whether CNT2 equals to 0 
        JZ LED_SHOW3            ; if CNT2 is 0, jump to show next word
        DEC CNT2                ; CNT2--
        MOV DPTR, #TABLE3       ; move second word table to DPTR
        JMP NEXT_COLUMN         ; jump to output reigon
LED_SHOW3:
        DEC CNT3                ; CNT3--
        MOV DPTR, #TABLE1       ; move third word table to DPTR
        MOV A, CNT3             ; to chech whether CNT3 equals to 0
        JNZ NEXT_COLUMN         ; if CNT3 is not 0, jump to output region
        MOV CNT1, #04H          ; ---V
        MOV CNT2, #04H          ; if CNT3 is 0, reset CNT1, CNT2, CNT3
        MOV CNT3, #04H          ; ---A
NEXT_COLUMN:                    ; Output region
        CALL READ_BYTE          ; get data of P0 from tableN
        MOV P0, A               ; output to P0
        CALL READ_BYTE          ; get data of P2 from tableN
        MOV P2, A               ; output to P2
        CALL READ_BYTE          ; get data of P1 from tableN
        MOV P1, A               ; output to P1
        CALL DELAY              
        DJNZ R1, NEXT_COLUMN    ; check whther have showed 24 rows
        RET

;=====READ 1 BYTE FROM TABLE=====
READ_BYTE:
        DEC R0                  ; R0-- i.e. ( index of table )--
        MOV A, R0               ; 
        MOVC A, @A+DPTR         ; get data from table
        CPL A                   ; 1's complement
        RET

DELAY:                  
        MOV R5, #01H    ; 1 machine cycle
DELAY1:
        MOV R6, #10H    ; 1 machine cycle
DELAY2:
        MOV R7, #0FFH   ; 1 machine cycle
DELAY3:
        DJNZ R7, DELAY3 ; 2 machine cycle
        DJNZ R6, DELAY2 ; 2 machine cycle
        DJNZ R5, DELAY1 ; 2 machine cycle
        RET             ; 2 machine cycle

TABLE1:         ; 黃
        DB      0000000B,00000001B,00000000B
        DB      0000000B,00000011B,10001000B
        DB      1100000B,00000011B,10001100B
        DB      1110000B,00001111B,10001100B
        DB      0110111B,11111111B,00001100B
        DB      0111111B,11111111B,00001000B
        DB      0011010B,01001011B,00001010B
        DB      0011010B,01001011B,01111110B
        DB      0001010B,01001011B,01111111B
        DB      0001010B,01001011B,01111110B
        DB      0000010B,01001011B,01001000B
        DB      0000011B,11111011B,01001000B
        DB      0000011B,11111011B,01001000B
        DB      0001010B,01001011B,01001010B
        DB      0001110B,01001011B,01111110B
        DB      0011110B,01001011B,01111111B
        DB      0011010B,01001011B,01111110B
        DB      0110010B,01001011B,00001000B
        DB      0110111B,11111111B,00001000B
        DB      0100111B,11111111B,00001000B
        DB      1100000B,00000011B,00001000B
        DB      1000000B,00000011B,00001000B
        DB      1000000B,00000011B,00000000B
        DB      0000000B,00000001B,00000000B

TABLE2:         ; 宇
        DB      0000000B,00100000B,00000000B
        DB      0000000B,00110000B,00011000B
        DB      0000000B,00110000B,00111000B
        DB      0000000B,00110001B,01111000B
        DB      0000000B,00100001B,11111000B
        DB      0000000B,00100001B,10011000B
        DB      0000000B,00100001B,10011000B
        DB      0000000B,00100001B,00011000B
        DB      0000000B,00100001B,00011000B
        DB      0000000B,00100001B,00011000B
        DB      0000000B,00100001B,00011000B
        DB      0111111B,11111111B,00011110B
        DB      1111111B,11111111B,00011111B
        DB      1110000B,00100001B,00011011B
        DB      1110000B,00100001B,00011000B
        DB      0110000B,00100001B,00011000B
        DB      0110000B,00100001B,00011000B
        DB      0010000B,00100001B,00011000B
        DB      0000000B,00100001B,00011000B
        DB      0000000B,00100001B,00011000B
        DB      0000000B,00100000B,00111100B
        DB      0000000B,00100000B,01111100B
        DB      0000000B,00100000B,01100000B
        DB      0000000B,00100000B,01000000B
TABLE3:         ; 裼
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

