        
        DH EQU 30H
        DL EQU 31H
        
        ORG 00H
        JMP SETUP

        ORG 0BH         ; TIMER0
        SETB P3.5
        CLR P3.5
        RETI

        ORG 13H         ; INT1
        JMP UPDATE

        ORG 30H
SETUP:
        MOV IP, #00000100B
        MOV TMOD, #11010010B
        MOV TH0, #227
        MOV TL0, #227
        MOV TH1, #00
        MOV TL1, #00
        SETB TR0
        SETB TR1
        SETB IT1
        SETB P3.5
        
        MOV IE, #10001110B

MAIN:   
        ;CLR TR1
        ;
        JMP MAIN

UPDATE:
        CLR IE1
        MOV DH, TH1
        MOV DL, TL1
        MOV TH1, #00H
        MOV TL1, #00H
        ;SETB TR1

        RETI

        END

