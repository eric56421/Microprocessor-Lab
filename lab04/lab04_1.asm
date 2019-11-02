;使7x5矩陣成為跑馬燈，並無限循環
;從左上點開始，每次亮一個，往下亮，之後再往右，並循環

        ORG 00H         ; 將程式從00H開始存

SETUP:
        MOV P2, #00H    ; set P1 as output
        MOV P1, #00H    ; set P2 as output
        
LOOP:                   ; LOOP是為了使8051可以持續跑		
        CALL SHOW       ; call function
        JMP LOOP

SHOW:                   ; function to show complete marquee for one time
        MOV R4, #05H    ; R4 = counter for loop SHOW_COL (5)
        MOV R2, #10000000B      ; R2 = control which col to show
SHOW_COL:               ; loop to show 5 col
        MOV R3, #07H    ; R3 = counter for loop SHOW_ROW (7)
        MOV R1, #10000000B      ; R1 = data for the col to show
        MOV P2, R2      ; output to P2, control showing which col
        MOV A, R2       ; R2 >>= 1, to show next col
        RR A
        MOV R2, A
SHOW_ROW:               ; loop to show one col for 7 dots
        MOV P1, R1      ; output to P1, show one dot
        CALL DELAY      ; stop for a little while
        MOV A, R1       ; R1 >>= 1, to show next dot
        RR A
        MOV R1, A
        DJNZ R3, SHOW_ROW       ; finish showing a whole col?
        DJNZ R4, SHOW_COL       ; finish showing 5 cols?
        RET        

DELAY:                  
        MOV R5, #0FFH   ; 1 machine cycle
DELAY1:
        MOV R6, #08FH   ; 1 machine cycle
DELAY2:
        MOV R7, #18H    ; 1 machine cycle
DELAY3:
        DJNZ R7, DELAY3 ; 2 machine cycle
        DJNZ R6, DELAY2 ; 2 machine cycle
        DJNZ R5, DELAY1 ; 2 machine cycle
        RET             ; 2 machine cycle

        END             ; 程式結束