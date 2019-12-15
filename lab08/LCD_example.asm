        ORG 0H
        MOV A, #00111000B
        CALL COMNWRT
        CALL DELAY
        MOV A, #00001110B
        CALL COMNWRT
        CALL DELAY
        MOV A, #00000001B
        CALL COMNWRT
        CALL DELAY
        MOV A, #00000110B
        CALL COMNWRT
        CALL DELAY
        MOV A, #11000100B
        CALL COMNWRT
        CALL DELAY 
        MOV A, #'Y'
        CALL DATAWRT
        CALL DELAY        
        MOV A, #'E'
        CALL DATAWRT
        CALL DELAY
        MOV A, #'S'
        CALL DATAWRT
AGAIN:  JMP AGAIN

COMNWRT:
        MOV P1, A
        CLR P2.0
        CLR P2.1
        SETB P2.2
        CALL DELAY
        CLR P2.2
        RET

DATAWRT:
        MOV P1, A
        SETB P2.0
        CLR P2.1
        SETB P2.2
        CALL DELAY
        CLR P2.2
        RET

DELAY:  MOV R3, #50
HERE2:  MOV R4, #255
HERE:   DJNZ R4, HERE
        DJNZ R3, HERE2
        RET
        
        END
