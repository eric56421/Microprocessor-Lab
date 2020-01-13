    DIST EQU 30H
    SLAVE_MODE EQU 31H  ; 0 -> DISABLED AUTO
                        ; 1 -> ENABLED AUTO
                        ; 2 -> OPEN DOOR

    ORG 00H
    JMP SETUP

    ORG 03H
    JMP GET_CMD            ; INT0
    
    ORG 0BH
    JMP TIMER0          ; timer0 interrupt
    
    ORG 13H
    JMP DISTANCE        ; counter1 interrupt
    
    ORG 30H
SETUP:
    MOV IE, #10000111B  ; INT0, TIMER0, INT1
    MOV IP, #00000001B  ; INT0 HIGH PRIORITY
MAIN:
    MOV R3, SLAVE_MODE
    CJNE R3, #0, MAIN_1
    JMP MAIN
MAIN_1:
    CJNE R3, #1, MAIN_2
    CALL AUTO_MODE
    JMP MAIN
MAIN_2:
    CALL OPEN_DOOR
    JMP MAIN

GET_CMD:                ; INT0 ISR
    MOV A, P2
    ANL A, #03H         ; 0000 0011
    CALL DECODE
    RETI

DECODE:
    CJNE A, #0, DECODE_1    ; disable auto
    MOV SLAVE_MODE, #0
    RET
DECODE_1:
    CJNE A, #1, DECODE_2    ; enable auto
    MOV SLAVE_MODE, #1
    RET
DECODE_2:
    CJNE A, #2, DECODE_3    ; OPEN DOOR
    MOV SLAVE_MODE, #2
    RET
DECODE_3:
    MOV SLAVE_MODE, #0
    RET
 
AUTO_MODE:
;======= setup sensor =======
    MOV R0,#00H         ; start counting distance = 0
    SETB EA             ; enable all interrupt
    SETB ET0            ; enable timer0
    CLR PT0             ; set timer0 to lower priority
    CLR TF0             ; clear all the flag in timer0

    SETB EX1            ; enable timer0
    SETB PX1            ; set INT1 to higher priority
    SETB IT1            ; falling-edge trigger
    CLR TF1
    MOV P1,#0           ; set P1.0 = input port

    MOV TMOD,#11100010B ; set timer0 = mode2, counter1 = mode1
    MOV TH0,#227        ; timer0 will interrupt every 29us
    MOV TL0,#227        ; auto reload to TL0

    MOV TH1,#0
    MOV TL1,#0
    SETB TR0
    SETB TR1

POLLING:
    SETB P1.0
    CALL L_DELAY
    CLR P1.0
    MOV A,DIST
    CLR C
    SUBB A,#7           ; 7CM
    JNC FAR
    CALL OPEN_DOOR
FAR:
    MOV R2, SLAVE_MODE
    CJNE R2,#1,POLLING
    RET

TIMER0:
    CPL P3.5            ; output the opposite volt
    CLR TF0             ; clear timer flag
    RETI

DISTANCE:
    MOV DIST,TL1        ; getting distance
    MOV TL1,#0
    MOV TH1,#0
    CLR IE1
    CLR TF1             ; overflow flag
;UPDATE:                         ; Update the distance and BIN 2 BCD
;        CLR IE1                 ; clear INT1 signal
;        MOV BIN+1, TH1          ; store distance
;        MOV BIN, TL1
;        MOV TH1, #00H           ; reset counter
;        MOV TL1, #00H
;        CALL BIN2BCD            ; BIN 2 BCD
;        RETI

OPEN_DOOR:
    CALL MOTOR
    ; CALL ANIMATE

MOTOR:
    MOV A,#00010001B
    MOV R4,#0
LEFT:                   ; OPNE DOOR
    MOV P0,A
    CALL LL_DELAY
    RL A
    INC R4
    CJNE R4,#128,LEFT
    MOV R4,#0

    CALL LL_DELAY
    CALL LL_DELAY
    CALL LL_DELAY
RIGHT:                  ; CLOSE DOOR
    MOV P0,A
    CALL LL_DELAY
    RR A
    INC R4
    CJNE R4,#128,RIGHT
    MOV R4,#0
    RET

LL_DELAY:
    MOV R6,#240
LL_DELAY1:
    MOV R7,#255
LL_DELAY2:
    DJNZ R7,DELAY2
    DJNZ R6,DELAY1
    RET

L_DELAY:                ; delay subroutine
    MOV R6,#0FH
L_DELAY1:
    MOV R7,#0FH
L_DELAY2:
    DJNZ R7,L_DELAY2
    DJNZ R6,L_DELAY1
    RET
      
    END