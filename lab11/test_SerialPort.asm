        ORG 00H
        JMP SETUP

        ORG 23H
        JMP COPY

        ORG 30H
SETUP:
        MOV TMOD, #00100000B
        MOV TH1, #0E6H
        MOV TL1, #0E6H
        SETB TR1
        ORL PCON, #80H
        CLR SM2
        SETB SM1
        CLR SM0
        SETB REN
        MOV IE, #10010000B
        SETB PS
        MOV SBUF, #'A'
        ;CLR TI
;
MAIN:
        ;MOV A, #"H"
        ;MOV SBUF, A
        ;CLR TI
HERE:   ;JNB TI, HERE
        ;CLR TI
        JMP MAIN
;
COPY:
        JB RI, COPY_NEXT
        CLR TI
        RETI
COPY_NEXT:
        CLR RI
        MOV A, SBUF
        ;CLR TI
        MOV SBUF, A
        ;MOV SBUF, #'A'
        RETI

        END

