;======== LCM Function ========
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
        ;RET

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

;=== Main Menu 1 ===
SHOW1:
        MOV A, #80H             ; SET CURSOR TO HOME
        CALL CMDWRT
        MOV DPTR, #TLCM_1
        MOV R2, #0
SHOW1_1:
        MOV A, R2
        MOVC A, @A+DPTR
        CALL DATAWRT
        INC R2
        
        CJNE R2, #8, SHOW1_2
        MOV A, #11000000B       ; SET CURSOR TO SECOND LINE
        CALL CMDWRT
        JMP SHOW1_1
SHOW1_2:
        CJNE R2, #16, SHOW1_1
        RET

;=== Main Menu 2 ===
SHOW2:
        MOV A, #80H             ; SET CURSOR TO HOME
        CALL CMDWRT
        MOV DPTR, #TLCM_2
        MOV R2, #0
SHOW2_1:
        MOV A, R2
        MOVC A, @A+DPTR
        CALL DATAWRT
        INC R2
        
        CJNE R2, #8, SHOW2_2
        MOV A, #11000000B       ; SET CURSOR TO SECOND LINE
        CALL CMDWRT
        JMP SHOW2_1
SHOW2_2:
        CJNE R2, #16, SHOW2_1
        RET
;;TO DO: SHOW3...

TLCM_1:                 ; MAINMENU_1
        DB "Smart Lock      "
        DB "1.Serial Unlock"
        DB 07EH
TLCM_2:                 ; MAINMENU_2
        DB "2.Auto Mode     "
        DB "3.Setting      "
        DB 07FH
TLCM_3:                 ; Serial Unlock
        DB "Serial Unlocking"
TLCM_4:                 ; Setting
        DB "1.Set Password  "
        DB "2.Set Music     "
TLCM_5:                 ; Set Password
        DB "Input Password  "
TLCM_6:                 ; SetMusic_1
        DB "Set new music   "
        DB "1. xxx         "
        DB 07EH
TLCM_7:                 ; SetMusic_2
        DB "2. xxx          "
        DB "3. xxx         "
        DB 07FH
TLCM_8:                 ; AutoMode
        DB "Be close to open"
        ;DB ""          ; "Open or close"
                        ; depends on RFID


        END
