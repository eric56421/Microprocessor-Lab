        ORG 00H         ;�N�{���q00H�}�l�s

LOOP:                   ;LOOP�O���F��8051�i�H����]
        MOV R0, #7FH    ;�NR0�]���x�sLED���O����Ŷ��A�åB������� #7FH(0111 1111)�A���O�O��X0�G
        MOV R4, #08H    ;�NR4�]��SUBLOOP���j��p�ƾ��A�åB������� #8H
SUBLOOP:                ;SUBLOOP���]���O���榸�y�{�ALED�q���ܥk�G�@�M
        MOV P1, R0      ;R0�h��P1�A��X��LED
        CALL DELAY      ;�I�sDELAY �Ƶ{��
        MOV A, R0       ;VVV
        RR A            ;�ǥ� A �N R0 ���� RIGHT SHIFT 1
        MOV R0, A       ;^^^
        DJNZ R4, SUBLOOP;�P�_R4�O�_����0�A�]�N�O�P�_SUBLOOP�O�_�]�F8��

        SJMP LOOP       ;��8051�i�J�L���j��

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

        END             ;�{������


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
