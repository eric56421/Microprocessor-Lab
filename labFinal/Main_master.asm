	PS1 EQU 51H  ; correct password
	PS2 EQU 52H
	PS3 EQU 53H
	PS4 EQU 54H
	PS5 EQU 55H
	PS6 EQU 56H
	PS7 EQU 57H
	PS8 EQU 58H

	PST1 EQU 59H ; input password
	PST2 EQU 5AH
	PST3 EQU 5BH
	PST4 EQU 5CH
	PST5 EQU 5DH
	PST6 EQU 5EH
	PST7 EQU 5FH
	PST8 EQU 60H

	INPUT EQU 61H
	TEMP EQU 62H
	RECEIVE_MODE EQU 63H    ; 1 -> UNLOCK
                            ; 2 -> SET PWD
                            ; 3 -> AUTO
	LEN EQU 64H
	SET_FLAG EQU 65H

    ORG 00H
    JMP SETUP

    ORG 23H
    JMP RECEIVE

	ORG 30H
;======== SETUP ========
SETUP:
    CALL SETUP_LCM
    MOV PS1,#48
    MOV PS2,#49
    MOV PS3,#50
    MOV PS4,#51
    MOV PS5,#52
    MOV PS6,#53
    MOV PS7,#54
    MOV PS8,#55

;======== MAIN & MainMenu ========
MAIN:
MAINMENU_1:
	MOV DPTR, #TLCM_1       ; MAINMENU_1
	CALL SHOW2

	CALL KEYBOARD           ; POLLING
	MOV R2,INPUT 
	CJNE R2, #4, MAINMENU_SWITCH
	JMP MAINMENU_2
MAINMENU_2:
	MOV DPTR, #TLCM_2       ; MAINMENU_2
	CALL SHOW2

	CALL KEYBOARD           ; POLLING
	MOV R2,INPUT 
	CJNE R2, #4, MAINMENU_SWITCH
	JMP MAINMENU_1

MAINMENU_SWITCH:
	MOV R2,INPUT 
	CJNE R2, #1, MAINMENU_SWITCH_1
	
	MOV SBUF,#49 ; mov the data to SBUFF
    JNB TI,$   ; wait until transmit complete
    CLR TI
	
    MOV SBUF,#10 ; send enter
    JNB TI,$
    CLR TI
    MOV SBUF,#13
    JNB TI,$
    CLR TI

	CALL UNLOCKING
	JMP MAINMENU_1
MAINMENU_SWITCH_1:
	MOV R2,INPUT 
	CJNE R2, #2, MAINMENU_SWITCH_2

	MOV SBUF,#50 ; mov the data to SBUFF
    JNB TI,$     ; wait until transmit complete
    CLR TI

    MOV SBUF,#10 ; send enter
    JNB TI,$
    CLR TI
    MOV SBUF,#13
    JNB TI,$
    CLR TI

	CALL AUTOMODE
	JMP MAINMENU_1
MAINMENU_SWITCH_2:
	MOV R2,INPUT 
	CJNE R2,#3,MAINMENU_1

    MOV SBUF,#51 ; mov the data to SBUFF
    JNB TI,$     ; wait until transmit complete
    CLR TI

    MOV SBUF,#10 ; send enter
    JNB TI,$
    CLR TI
    MOV SBUF,#13
    JNB TI,$
    CLR TI

	CALL SETTING
	JMP MAINMENU_1
;======== Main & Main Menu ========

;======== Auto Mode ========
AUTOMODE:
    ; SHOW & FIX RECEIVE_MODE
    ; FIX ISR : CLR ES
    ; DO MORE CHECK ON RECEIVE_MODE SET AND LEAVING

    SETB P2.5
    CLR P2.7
    SETB P2.6
    CLR P2.5

    CALL S_DELAY

    SETB P2.5       ; SEND SIGNAL TWO TIMES
    CLR P2.7
    SETB P2.6
    CLR P2.5
AUTOMODE_1:
    MOV R2, RECEIVE_MODE
    CJNE R2, #3, AUTOMODE_2
    JMP AUTOMODE_1
AUTOMODE_2:
    ; SEND DISABLE SIGNAL
    ; DO MORE CHECK

    RET
;======== Auto Mode ========

;======== Unlock Serail ========
UNLOCKING:
	MOV DPTR,#TLCM_3        ; SHOW UNLOCK MENU
    CALL SHOW1
	CALL SERIAL_UNLOCK
	RET
;=========== SETTING =============
SETTING:
    MOV DPTR, #TLCM_4
    CALL SHOW2

    CALL KEYBOARD
    MOV R2, INPUT
    CJNE R2, #1, SETTING_1
    CALL SET_PASSWORD
	RET
SETTING_1:
    CJNE R2, #2, SETTING_2
    CALL SET_MUSIC
    RET
SETTING_2:
    JMP SETTING
;=========== SETTING =============

SET_MUSIC:
SET_MUSIC1:
    MOV DPTR, #TLCM_6
    CALL SHOW2

    CALL KEYBOARD
    


; ========== RECEIVE_ISR ===========
RECEIVE:             ; receive isr!!!!!!!!!!!!
    PUSH 0E0H
    CLR RI
    MOV A,SBUF       ; get data from SBUFF
    MOV R2,RECEIVE_MODE
    CJNE R2,#1,NEXT1 ; SERIAL_UNLOCK
    CALL ENTERING_PASSWORD
    CALL ADDSTAR
    POP 0E0H
    RETI
NEXT1:
    CJNE R2,#2,NEXT2 ; SET_PASSWORD
    CALL ENTERING_PASSWORD
    CALL ADDSTAR
    POP 0E0H
    RETI
NEXT2:
    CJNE R2,#3,NEXT3 ; AUTO_MODE
    POP 0E0H
    RETI
NEXT3:
    POP 0E0H
    RETI             ; RETI!!!!!!!!!!!!!!!!!!!
; ========== RECEIVE_ISR ===========

; ======= DELAY =======
S_DELAY:
    MOV R6,#0FFH
S_DELAY1:
    MOV R7,#5H
S_DELAY2:
    DJNZ R7,S_DELAY2
    DJNZ R6,S_DELAY1
    RET
; ======= DELAY =======

; =========== KEYBOARD ============
KEYBOARD:            ; (int &INPUT) this is a function!!!!!!!!!!!!!!
ROW1:
    MOV P0,#07FH     ; scan row1
    CALL S_DELAY
    MOV A,P0
    ANL A,#0FH
    MOV INPUT,#1
    CJNE A,#0FH,EXIT ; if there is a button be pushed, in row1
ROW2:
    MOV P0,#0BFH     ; scan row2
    CALL S_DELAY
    MOV A,P0
    ANL A,#0FH
    MOV INPUT,#2
    CJNE A,#0FH,EXIT ; if there is a button be pushed, in row2
ROW3:
    MOV P0,#0DFH     ; scan row3
    CALL S_DELAY
    MOV A,P0
    ANL A,#0FH
    MOV INPUT,#3
    CJNE A,#0FH,EXIT ; if there is a button be pushed, in row3
ROW4:
    MOV P0,#0EFH     ; scan row4
    CALL S_DELAY
    MOV A,P0
    ANL A,#0FH
    MOV INPUT,#4
    CJNE A,#0FH,EXIT ; if there is a button be pushed in row4

    JMP KEYBOARD

EXIT:
    RET              ; function return!!!!!!!!!!!!!!!!!
; =========== KEYBOARD ============

; ====== ENTERING PASSWORD =======

ENTERING_PASSWORD: ; this is a function!!!!!!!!!!!
    MOV @R1,A
    INC LEN
    INC R1
TRANSMIT:
    MOV SBUF,A     ; mov the data to SBUFF
    JNB TI,$       ; wait until transmit complete
    CLR TI
    RET            ; function return !!!!!!!!!!!!!

; ====== ENTERING PASSWORD =======

; ======== SET_PASSWORD ==========
SET_PASSWORD:
    MOV DPTR, #TLCM_5
    CALL SHOW1

    MOV RECEIVE_MODE,#2 ; unlock mode
    MOV LEN,#0
    MOV R0,#51H         ; start from password1
    MOV R1,#59H         ; start from password1

    MOV	TMOD,#00100000B ; Timer1,Mode2
    MOV	TL1,#0E6H       ; baud rate = 2400
    MOV	TH1,#0E6H       ; initial = E6H

    MOV A,PCON          ; SMOD = 1
    SETB ACC.7
    MOV PCON,A

    SETB EA             ; enable interrupt
    CLR RI              ; clear receive flag
    SETB PS             ; set serial interrupt to high priority

    CLR SM2             ; serial mode 1
    SETB SM1
    CLR SM0

    SETB TR1            ; start timer1
    CLR A               ; set all register to 0
    SETB ES             ; enable serial interrupt
    SETB REN            ; start receiving

HERE2:                  ; entering the confirm password
    MOV R2,LEN
    CJNE R2,#8,HERE2
    CLR ES              ; disable serial port
    CLR REN

    MOV SBUF,#10        ; send enter
    JNB TI,$
    CLR TI
    MOV SBUF,#13
    JNB TI,$
    CLR TI

    MOV R0,#51H         ; start from password1
    MOV R1,#59H         ; start from password1
    CALL CHECK1
    MOV R2,SET_FLAG
    CJNE R2,#1,RETURN2  ; if the confirm password is not correct

    MOV DPTR, #TLCM_9   ; SHOW "ENTER NEW PWD"
    CALL SHOW1

    MOV LEN,#0
    MOV R0,#51H         ; start from password1
    MOV R1,#59H         ; start from password1

    SETB ES             ; enable serial interrupt
    SETB REN            ; start receiving
HERE3:                  ; entering the new password
    MOV R2,LEN
    CJNE R2,#8,HERE3
    CLR ES              ; disable serial port
    CLR REN

    MOV SBUF,#10        ; send enter
    JNB TI,$
    CLR TI
    MOV SBUF,#13
    JNB TI,$
    CLR TI

    MOV LEN,#0
    MOV R0,#51H         ; start from password1
    MOV R1,#59H         ; start from password1
    CALL SET_NEW
    CLR ES              ; disable serial port
    CLR REN

RETURN2:
    RET

CHECK1:           ; this is a function!!!!!!!!!!!
    CLR C
    MOV A,@R1     ; get the input password
    SUBB A,@R0    ; compare to correct password
    JZ CHECK_LEN1 ; iF nth password correct, check the length
WRONG1:
    MOV SET_FLAG,#0
    MOV LEN,#0    ; clear the length
    MOV R0,#51H   ; start from correct password1
    MOV R1,#59H   ; start from input password1
    RET
CHECK_LEN1:
    INC R0
    INC R1
    DJNZ LEN,CHECK1
CORRECT1:
    MOV SET_FLAG,#1
    MOV LEN,#0    ; clear the length
    MOV R0,#51H   ; start from password1
    MOV R1,#59H   ; start from password1

    MOV SBUF,#10  ; send enter
    JNB TI,$
    CLR TI
    MOV SBUF,#13
    JNB TI,$
    CLR TI
    RET

SET_NEW:          ; set new password
    MOV A,@R1
    MOV @R0,A
    INC R0
    INC R1
    INC LEN
    MOV R2,LEN
    CJNE R2,#8,SET_NEW

    MOV LEN,#8    ; clear the length
    MOV R0,#51H   ; start from password1
    MOV R1,#59H   ; start from password1
SHOW:             ; show new password
    MOV A,@R0
    MOV SBUF,A
    JNB TI,$
    CLR TI
    INC R0
    DJNZ LEN,SHOW

    MOV SBUF,#10  ; send enter
    JNB TI,$
    CLR TI
    MOV SBUF,#13
    JNB TI,$
    CLR TI

    RET

; ======== SET_PASSWORD ==========

; ======= SERIAL_UNLOCK ========
SERIAL_UNLOCK:          ; void(void) this is a function!!!!!!!!!!!!
    MOV RECEIVE_MODE,#1 ; unlock mode
    MOV LEN,#0
    MOV R0,#51H         ; start from password1
    MOV R1,#59H         ; start from password1

    MOV	TMOD,#00100000B ; Timer1,Mode2
    MOV	TL1,#0E6H       ; baud rate = 2400
    MOV	TH1,#0E6H       ; initial = E6H

    MOV A,PCON          ; SMOD = 1
    SETB ACC.7
    MOV PCON,A

    SETB EA             ; enable interrupt
    CLR RI              ; clear receive flag
    SETB PS             ; set serial interrupt to high priority

    CLR SM2             ; serial mode 1
    SETB SM1
    CLR SM0

    SETB TR1            ; start timer1
    CLR A               ; set all register to 0
    SETB ES             ; enable serial interrupt
    SETB REN            ; start receiving
HERE1:
    MOV R2,LEN
    CJNE R2,#8,HERE1
    CLR ES              ; disable serial port
    CLR REN             ; disable receiving

    MOV SBUF,#10        ; send enter
    JNB TI,$
    CLR TI
    MOV SBUF,#13
    JNB TI,$
    CLR TI

    MOV R0,#51H         ; start from password1
    MOV R1,#59H         ; start from password1
    CALL CHECK          ; check the password
    RET                 ; retrun!!!!!!!!!!!!!!!!!!!!

CHECK:                  ; this is a function!!!!!!!!!!!
    CLR C
    MOV A,@R1           ; get the input password
    SUBB A,@R0          ; compare to correct password
    JZ CHECK_LEN        ; iF nth password correct, check the length
WRONG:
    MOV LEN,#0          ; clear the length
    MOV R0,#51H         ; start from correct password1
    MOV R1,#59H         ; start from input password1
    RET
CHECK_LEN:
    INC R0
    INC R1
    DJNZ LEN,CHECK
CORRECT:
    ; CALL OPEN_DOOR      ; open the door

    MOV SBUF,#10        ; send enter
    JNB TI,$
    CLR TI
    MOV SBUF,#13
    JNB TI,$
    CLR TI

    MOV LEN,#0          ; clear the length
    MOV R0,#51H         ; start from password1
    MOV R1,#59H         ; start from password1
    RET
; ======= SERIAL_UNLOCK ========


; ======== LCM Function ========
; Note to the setting.
; ======== Setup LCM =========
SETUP_LCM:
        ;MOV P2, #00H
        ;MOV P1, #00H
		MOV A, #00000001B   ; CLEAR & RESET
		CALL CMDWRT
		MOV A, #00000110B   ; ADD TO RIGHT, DISPLAY NOT MOVING
		CALL CMDWRT
		MOV A, #00001100B   ; DISPLAY:ON, CURSOR_UNDERLINE:OFF, BLINKING:OFF
		CALL CMDWRT
		MOV A, #00111000B   ; LEN:8, LINES:2, FONT:7
		CALL CMDWRT
		RET

		; ======== CMD/DATA ========
CMDWRT:                     ; Command write
		MOV P2, A
        ;CLR P2.0
        ;SETB P2.2
        ;CLR P2.2
		MOV P1, #00000100B  ; 04H, E=1, RW=0, RS=0
		MOV P1, #00000000B  ; 00H, E=0, RW=0, RS=0
		CALL DELAY_LCM
		RET

DATAWRT:                    ; ShowData write
		MOV P2, A
        ;SETB P2.0
        ;SETB P2.2
        ;CLR P2.2
		MOV P1, #00000101B  ; 05H, E=1, RW=0, RS=1
		MOV P1, #00000001B  ; 01H, E=0, RW=0, RS=1
		CALL DELAY_LCM
		RET

		; ======== LCM Delay =========
DELAY_LCM:
		MOV R5, #01H        ; 1 machine cycle
DELAY_LCM1:
		MOV R6, #10H        ; 1 machine cycle
DELAY_LCM2:
		MOV R7, #0FFH       ; 1 machine cycle
DELAY_LCM3:
		DJNZ R7, DELAY_LCM3 ; 2 machine cycle
		DJNZ R6, DELAY_LCM2 ; 2 machine cycle
		DJNZ R5, DELAY_LCM1 ; 2 machine cycle
		RET                 ; 2 machine cycle

							; === Show on LCM 1 line ===
SHOW1:
		MOV A, #80H         ; SET CURSOR TO HOME
		CALL CMDWRT
		MOV R3, #0
SHOW1_1:
		MOV A, R3
		MOVC A, @A+DPTR
		CALL DATAWRT
		INC R3

		CJNE R3, #16, SHOW1_2
		MOV A, #11000000B   ; SET CURSOR TO SECOND LINE
		CALL CMDWRT
		JMP SHOW1_1
SHOW1_2:
		CJNE R3, #32, SHOW1_1
        MOV A, #11000000B   ; SET CURSOR TO SECOND LINE
		CALL CMDWRT
		RET

		; === Show on LCM 2 lines ===
SHOW2:
		MOV A, #80H         ; SET CURSOR TO HOME
		CALL CMDWRT
		MOV R3, #0
SHOW2_1:
		MOV A, R3
		MOVC A, @A+DPTR
		CALL DATAWRT
		INC R3

		CJNE R3, #16, SHOW2_2
		MOV A, #11000000B   ; SET CURSOR TO SECOND LINE
		CALL CMDWRT
		JMP SHOW2_1
SHOW2_2:
		CJNE R3, #32, SHOW2_1
		RET

		; === Add Star * ===
ADDSTAR:
		MOV A, #'*'
		CALL DATAWRT
		RET

		; ======== Table ========
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
        DB "                "
TLCM_4:                 ; Setting
        DB "1.Set Password  "
        DB "2.Set Music     "
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
TLCM_5:                 ; Set Password
        DB "Origin password:"
        DB "                "
TLCM_9:
        DB "New password:   "
        DB "                "


	END