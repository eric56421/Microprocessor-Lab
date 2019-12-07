; use keyboard to control how step motor spinning
; 10 mode: 90, 180, 270, 360, keep sining for two ways        
; P1 connected to step motor.
; P2 connected to keyboard.

        KEY_VAL EQU 30H
        ROW_CNT EQU 31H

        ORG 00H
        JMP SETUP
        
        ORG 30H
SETUP:
        MOV P1, #00H            ; set P1, which is conneted to motor, as output
        MOV KEY_VAL, #00H       ; set initial value
        
MAIN:
        CALL KEY_PUSH_POLLING   ; keep polling whether key is pushed
        CALL SPIN_BY_CASE       ; spin the motor by case
        MOV P1, #00H            ; avoid motor becoming hot
        JMP MAIN

RR_90:                          ; spin clockwise for 90 degrees
        MOV R3, #20H            ; R3 is the counter for spinning 90 degrees
RR_90_LOOP:
        CALL MOTOR_SPIN_RR      
        DJNZ R3, RR_90_LOOP     ; to run 32 times
        RET

LR_90:                          ; spin counter clockwise for 90 degrees
        MOV R3, #20H            ; R3 is the counter for spinning 90 degrees
LR_90_LOOP:
        CALL MOTOR_SPIN_LR
        DJNZ R3, LR_90_LOOP     ; to run 32 times
        RET

MOTOR_SPIN_RR:                  ; the inner motor spins for a Cycle
        MOV R4, #04H            ; R4 is the index to read table
        MOV DPTR, #TABLE_RR     ; set correct table to read
        JMP SPIN                ; jump to spin region
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

SPIN_BY_CASE:
        MOV R0, KEY_VAL         ; compare KEY_VAL in switch syntax funtion
R_90:                   
        CJNE R0, #7EH, R_180
        CALL RR_90              ; R 90 degrees
        RET
R_180:
        CJNE R0, #7DH, R_270
        CALL RR_90              ; R 180 degrees
        CALL RR_90
        RET
R_270:
        CJNE R0, #7BH, R_360
        CALL RR_90              ; R 270 degrees
        CALL RR_90
        CALL RR_90
        RET
R_360:
        CJNE R0, #77H, L_90
        CALL RR_90              ; R 360 degrees
        CALL RR_90
        CALL RR_90
        CALL RR_90
        RET
L_90:
        CJNE R0, #0BEH, L_180
        CALL LR_90              ; L 90 degrees
        RET
L_180:
        CJNE R0, #0BDH, L_270
        CALL LR_90              ; L 180 degrees
        CALL LR_90
        RET
L_270:
        CJNE R0, #0BBH, L_360
        CALL LR_90              ; L 270 degrees
        CALL LR_90
        CALL LR_90
        RET
L_360:
        CJNE R0, #0B7H, R_FOREVER
        CALL LR_90              ; L 360 degrees
        CALL LR_90
        CALL LR_90
        CALL LR_90
        RET
R_FOREVER:
        CALL RR_90
        CJNE R0, #0DEH, L_FOREVER       ; keep spinning
        JMP R_FOREVER
L_FOREVER:
        CALL LR_90
        CJNE R0, #0DDH, OTHER_CASE      ; keep spinning
        JMP L_FOREVER
OTHER_CASE:
        RET                             ; no spinning

KEY_PUSH_POLLING:
        MOV ROW_CNT, #04H       ; ROW_CNT is counter for scanning 4 rows
        MOV R4, #07FH           ; R4 is bit flag to control reading which row
POLLING:
        MOV P2, R4              ; output control to P2
        MOV A, R4               ; -----V
        RR A                    ; R4 >>= 1, to read next row
        MOV R4, A               ; -----A
        MOV A, P2               ; input to A
        MOV KEY_VAL, A          ; copy input to KEY_VAL(key value)
        ANL A, #0FH             ; to get last 4 bits of KEY_VAL
        CJNE A, #0FH, POLLING_RET ; if the key is pushed, it won't equal to 0FH
        DJNZ ROW_CNT, POLLING   ; to check 4 rows
        JMP KEY_PUSH_POLLING    ; repolling from first row
POLLING_RET:
        RET

SDELAY:                  
        MOV R5, #20H            ; 1 machine cycle
SDELAY1:
        MOV R6, #10H            ; 1 machine cycle
SDELAY2:
        MOV R7, #10H            ; 1 machine cycle
SDELAY3:
        DJNZ R7, SDELAY3        ; 2 machine cycle
        DJNZ R6, SDELAY2        ; 2 machine cycle
        DJNZ R5, SDELAY1        ; 2 machine cycle
        RET                     ; 2 machine cycle

TABLE_RR:                       ; table for spinning
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
