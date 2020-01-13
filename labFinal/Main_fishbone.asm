        ORG 30H
;======== MAIN & MainMenu ========
MAIN:
MAINMEUN_1:
        MOV DPTR, #TLCM_1       ; MAINMENU_1
        CALL SHOW2

        CALL KEYBOARD           ; POLLING
        CJNE INPUT, #4, MAINMENU_SWITCH
        ;JMP MAINMENU_2
MAINMENU_2:
        MOV DPTR, #TLCM_2       ; MAINMENU_2
        CALL SHOW2

        CALL KEYBOARD           ; POLLING
        CJNE INPUT, #4, MAINMEUN_SWITCH
        JMP MAINMEUN_1

MAINMENU_SWITCH:
        CJNE INPUT, #1, MAINMENU_SWITCH_1
        CALL UNLOCKING
        JMP MAINMEUN_1
MAINMENU_SWITCH_1:
        CJNE INPUT, #2, MAINMENU_SWITCH_2
        CALL AUTOMODE
        JMP MAINMENU_1
MAINMENU_SWITCH_2:
        CJNE INPUT, #3, MAINMEUN_1
        CALL SETTING
        JMP MAINMEUN_1

;======== Unlock Serail ========

        END