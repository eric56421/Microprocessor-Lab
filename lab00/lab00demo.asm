        ORG 00H
        MOV R0,#36H
        MOV A,#00H
loop:
        ADD A,#1
        JMP loop
        END