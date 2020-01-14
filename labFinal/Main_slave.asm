    DIST EQU 30H
    SLAVE_MODE EQU 31H  ; 0 -> DISABLED AUTO
                        ; 1 -> ENABLED AUTO
                        ; 2 -> OPEN DOOR    

    ORG 00H
    JMP SETUP

    ORG 03H
    JMP GET_CMD            ; INT0
    
    ORG 0BH   ; TIMER0
    SETB P3.5 ; send signal to timer1 (counter) ++
    CLR P3.5
    RETI    

    ORG 13H ; INT1
    JMP UPDATE    

    ORG 30H
SETUP:
    SETB IT0
    MOV IE, #10000001B
    MOV IP, #00000001B  ; INT0 HIGH PRIORITY
    MOV DIST, #100
    MOV SLAVE_MODE, #0

MAIN:
    MOV R3, SLAVE_MODE
    CJNE R3, #0, MAIN_1
    JMP MAIN
MAIN_1:
    CJNE R3, #1, MAIN_2
    CALL AUTO_MODE
    JMP MAIN
MAIN_2:
    CJNE R3, #2, MAIN_3
    CALL OPEN_DOOR
    MOV SLAVE_MODE, #0
    JMP MAIN
MAIN_3:
    MOV SLAVE_MODE, #0
    JMP MAIN

GET_CMD:                ; INT0 ISR
    PUSH ACC
    MOV A, P2
    ANL A, #03H         ; 0000 0011
    ;CLR IE0
    CALL DECODE
    POP ACC
    RETI

DECODE:
    CJNE A, #3, DECODE_1
    MOV SLAVE_MODE, #0
    RET
DECODE_1:
    MOV SLAVE_MODE, A
    RET
 
AUTO_MODE:
    CALL SETUP_SENSOR
POLLING:
    SETB P1.0
    CALL LL_DELAY
    CLR P1.0
    CALL LL_DELAY
    MOV A,DIST
    CLR C
    SUBB A,#10 ; 7CM
    JNC FAR
    CALL OPEN_DOOR
FAR:
    MOV R2, SLAVE_MODE
    CJNE R2,#1,FAR_1
    JMP POLLING
FAR_1:
    MOV IE,#10000001B
    RET

SETUP_SENSOR:
    MOV IP, #00000101B   ; set priority, where INT1 is high
    MOV TMOD, #11010010B ; timer0: mode 2; timer1: mode 1, counter, gate
    MOV TH0, #198        ; 29*2 = 58us
    MOV TL0, #198
    MOV TH1, #00         ; reset
    MOV TL1, #00
    SETB TR0             ; run timer0
    SETB TR1             ; run timer1
    SETB IT1             ; set timer1 (couter) as falling edge trigger
    SETB P3.5            ; set P3.5 as output

    MOV IE, #10000111B   ; Interrupt Enable, set timer0 and INT1
    RET

UPDATE:                       ; Update the distance and BIN 2 BCD
    CLR IE1               ; clear INT1 signal
                            ; MOV BIN+1, TH1          ; store distance
    MOV DIST, TL1
    MOV TH1, #00H         ; reset counter
    MOV TL1, #00H
    RETI

OPEN_DOOR:
    CALL MOTOR
    RET

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
    DJNZ R7,LL_DELAY2
    DJNZ R6,LL_DELAY1
    RET
      
    END
