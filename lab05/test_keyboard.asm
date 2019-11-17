        ORG 00H
        JMP MAIN
        
        ORG 40H
MAIN:
        MOV P2, #0FFH
        MOV P1, #00H
LOOP:
        MOV P3, R1
        ;MOV P2, #01110000B
        MOV A, P2
        MOV P1, R2
        JMP LOOP

        END
