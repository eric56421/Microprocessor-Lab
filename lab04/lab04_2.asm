;依序在7x5矩陣上顯示1 2 3，並無限循環

        A_BACKUP EQU 30H    ; BACKUP A

        ORG 00H             ; 將程式從00H開始存

SETUP:
        MOV DPTR, #TABLE    ; 將TABLE所代表的地址搬進DPTR
        MOV P1, #00H        ; set P1 as output
        MOV P2, #00H        ; set P2 as output

LOOP:                       ; LOOP是為了使8051可以持續跑		
        CALL SHOW_NUMS      ; call function
        JMP LOOP
                        
SHOW_NUMS:                  ; the function show 1 2 3
        MOV R0, #0FBH       ; R0 = index of one number. set as 256(0) - 5 = 251
        MOV R4, #03H        ; R4 = counter for SHOW_NUM_123. set as 3 times
SHOW_NUM_123:               ; the loop to show 1 2 3
        XCH A, R0           ; to show next number, start index += 5
        ADD A, #05H         
        XCH A, R0           
        MOV R3, #0FFH       ; R3 = counter for LONG_SHOW_NUM loop (255)
LONG_SHOW_NUM:              ; make number displayed for a while
        MOV R2, #05H        ; R2 = counter for SHOW_NUM
        MOV R1, #10000000B  ; R1 = control which col to show
        MOV A, R0           ; A = index. Reset A with start index of one number
SHOW_NUM:                   ; loop to show one number for one time
        ;MOV P2, #00H
        MOV P2, R1          ; output to P2, control showing which col
        XCH A, R1           ; R1 >>= 1
        RR A
        XCH A, R1
        MOV A_BACKUP, A     ; backup A
        MOVC A, @A+DPTR     ; get data for the whole column
        MOV P1, A           ; output to P1, show the whole column
        CALL DELAY          ; stop for a little while
        MOV A, A_BACKUP     ; restore the index
        INC A               ; to show next col
        DJNZ R2, SHOW_NUM       ; finish showing one complete number?
        DJNZ R3, LONG_SHOW_NUM  ; finish showing same number for 255 times?
        DJNZ R4, SHOW_NUM_123   ; finish showing 1 2 3?
        RET

DELAY:                  
        MOV R5, #0FH    ; 1 machine cycle
DELAY1:
        MOV R6, #08H    ; 1 machine cycle
DELAY2:
        MOV R7, #10H    ; 1 machine cycle
DELAY3:
        DJNZ R7, DELAY3 ; 2 machine cycle
        DJNZ R6, DELAY2 ; 2 machine cycle
        DJNZ R5, DELAY1 ; 2 machine cycle
        RET             ; 2 machine cycle

TABLE:
NUM_1:
        DB 01000010B
        DB 01000010B
        DB 11111110B
        DB 00000010B
        DB 00000010B
NUM_2:
        DB 01000010B
        DB 10000110B
        DB 10001010B
        DB 10010010B
        DB 01100010B
NUM_3:
        DB 01000100B
        DB 10010010B
        DB 10010010B
        DB 10010010B
        DB 01101100B

        END             ; 程式結束