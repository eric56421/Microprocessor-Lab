; Motor spins clockwise for 45 degrees, 
; and spins counter clockwis for 90 degrees
; P1 connected to step motor. 

        ORG 00H
        JMP SETUP
        
        ORG 30H
SETUP:
        MOV P1, #00H            ; set P1 as output
        
LOOP:
        CALL RR_45              ; R 45 degrees
        CALL DELAY              ; stops for while
        CALL LR_45              ; L 90 degress
        CALL LR_45
        CALL DELAY              ; stop for while
        JMP LOOP

RR_45:                          ; spin clockwise for 45 degrees
        MOV R3, #10H            ; R3 is the counter for spinning 45 degrees
RR_45_LOOP:
        CALL MOTOR_SPIN_RR
        DJNZ R3, RR_45_LOOP     ; to run 16 times
        RET

LR_45:                          ; spin clockwise for 45 degrees
        MOV R3, #10H            ; R3 is the counter for spinning 45 degrees
LR_45_LOOP:
        CALL MOTOR_SPIN_LR
        DJNZ R3, LR_45_LOOP     ; to run 16 times
        RET

MOTOR_SPIN_RR:                  ; the inner motor spins for a Cycle
        MOV R4, #04H            ; R4 is the index to read table
        MOV DPTR, #TABLE_RR     ; set correct table to read
        JMP SPIN                ; jmup to spin region
MOTOR_SPIN_LR:                  ; the inner motor spins for a Cycle
        MOV R4, #04H            ; R4 is the index to read table
        MOV DPTR, #TABLE_LR     ; set correct table to read
SPIN:                           ; sping region
        DEC R4                  ; R4--
        MOV A, R4               ; -----V
        MOVC A, @A+DPTR         ; get data from table
        MOV P1, A               ; -----A
        CALL SDELAY             ; stops for a while
        CJNE R4, #0H, SPIN      ; to run 4 times
        RET

SDELAY:                  
        MOV R5, #20H    ; 1 machine cycle
SDELAY1:
        MOV R6, #10H    ; 1 machine cycle
SDELAY2:
        MOV R7, #10H    ; 1 machine cycle
SDELAY3:
        DJNZ R7, SDELAY3 ; 2 machine cycle
        DJNZ R6, SDELAY2 ; 2 machine cycle
        DJNZ R5, SDELAY1 ; 2 machine cycle
        RET             ; 2 machine cycle

DELAY:                  
        MOV R5, #80H    ; 1 machine cycle
DELAY1:
        MOV R6, #80H    ; 1 machine cycle
DELAY2:
        MOV R7, #0FFH   ; 1 machine cycle
DELAY3:
        DJNZ R7, DELAY3 ; 2 machine cycle
        DJNZ R6, DELAY2 ; 2 machine cycle
        DJNZ R5, DELAY1 ; 2 machine cycle
        RET             ; 2 machine cycle

TABLE_RR:               ; table for spinning
        DB 00001000B
        DB 00000100B
        DB 00000010B
        DB 00000001B
TABLE_LR:
        DB 00000001B
        DB 00000010B
        DB 00000100B
        DB 00001000B

        END
