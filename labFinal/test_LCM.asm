        ORG 00H
        JMP SETUP

SETUP:
        MOV P1, #00H
        MOV P2, #00H
        CALL SETUP_LCM
        CALL LCM_MAINMENU

MAIN:   JMP $

;======== Setup LCM =========
SETUP_LCM:
        MOV A, #00111000B       ; LEN:8, LINES:2, FONT:7
        CALL CMDWRT
        MOV A, #00001110B       ; DISPLAY:ON, CURSOR_UNDERLINE:ON, BLINKING:OFF
        CALL CMDWRT
        MOV A, #00000001B       ; CLEAR & RESET
        CALL CMDWRT
        MOV A, #00000110B       ; ADD TO RIGHT, DISPLAY NOT MOVING
        CALL CMDWRT

;======== CMD/DATA ========
CMDWRT:                         ; Command write
        MOV P1, A
        MOV P2, #00000100B      ; 04H, E=1, RW=0, RS=0
        MOV P2, #00000000B      ; 00H, E=0, RW=0, RS=0
        CALL DELAY_LCM
        RET

DATAWRT:                        ; ShowData write
        MOV P1, A
        MOV P2, #00000101B      ; 05H, E=1, RW=0, RS=1
        MOV P2, #00000001B      ; 01H, E=0, RW=0, RS=1
        CALL DELAY_LCM
        RET

;======== LCM Delay =========
DELAY_LCM:                  
        MOV R5, #01H    ; 1 machine cycle
DELAY_LCM1:
        MOV R6, #10H    ; 1 machine cycle
DELAY_LCM2:
        MOV R7, #0FFH   ; 1 machine cycle
DELAY_LCM3:
        DJNZ R7, DELAY_LCM3 ; 2 machine cycle
        DJNZ R6, DELAY_LCM2 ; 2 machine cycle
        DJNZ R5, DELAY_LCM1 ; 2 machine cycle
        RET             ; 2 machine cycle

;=== Main menu ===
LCM_MAINMENU:
        MOV A, #80H             ; 10000000B
        CALL CMDWRT
        MOV DPTR, #TABLE_MAINMENU
        MOV R2, #0
LCM_MAINMENU_1:
        MOV A, R2
        MOVC A, @A+DPTR
        CALL DATAWRT
        INC R2
        
        CJNE R2, #8, LCM_MAINMENU_2
        MOV A, #11000000B
        CALL CMDWRT
        JMP LCM_MAINMENU_1
LCM_MAINMENU_2:
        CJNE R2, #16, LCM_MAINMENU_1
        RET

TABLE_MAINMENU:
        DB "Smart Lock"
        DB "1.Serial Unlock"



        END
