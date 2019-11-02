;�̧Ǧb7�q��ܾ��W���0~9�A�õL���`��
;�L�k��SWITCH����DELAY TIME

        ORG 00H         ;�N�{���q00H�}�l�s

SETUP:
        MOV DPTR, #TABLE;�NTABLE�ҥN���a�}�h�iDPTR
LOOP:                   ;LOOP�O���F��8051�i�H����]		
        MOV R4, #0AH    ;�NR4�]��SHOWNUM�j��p�ƾ��A�åB������� #10
        MOV R3, #0H     ;�NR3�]���x�sTABLE ARRAY��INDEX
                        
SHOWNUM:                ;SHOWNUM����ܼƦr���榸�y�{
        MOV A, R3	;�NTABLE��INDEX�h��A
        MOVC A, @A+DPTR	;�NTABLE[R3]���ȷh��A
        MOV P2, A	;R0�h��P1�A��X��LED
        CALL DELAY      ;�I�sDELAY �Ƶ{��
        INC R3		;TABLE array index++
        CJNE R3, #0AH, SHOWNUM
                        ;�P�_R3�O�_����10�A�]�N�O�P�_SHOWNUM�O�_�]�F10��
        SJMP LOOP       ;��8051�i�J�L���j��

DELAY:                  
        MOV R5, #0FFH   ; 1 machine cycle
DELAY1:
        MOV R6, #08FH   ; 1 machine cycle
DELAY2:
        MOV R7, #18H    ; 1 machine cycle
DELAY3:
        DJNZ R7, DELAY3 ; 2 machine cycle
        DJNZ R6, DELAY2 ; 2 machine cycle
        DJNZ R5, DELAY1 ; 2 machine cycle
        RET             ; 2 machine cycle

TABLE:
        DB 00000011B    ; num 0
        DB 10011111B    ; num 1
        DB 00100101B    ; num 2
        DB 00001101B    ; num 3		
        DB 10011001B    ; num 4
        DB 01001001B    ; num 5
        DB 01000001B    ; num 6
        DB 00011011B    ; num 7
        DB 00000001B    ; num 8
        DB 00011001B    ; num 9

        END             ; �{������