#include p18f87k22.inc
    
    extern read_keyboard, delay_1s, LCD_init_message, LCD_Write_Message
    global keyboard_memory_compare, set_passcode, wrong_passcode, wrong_counter
    global passcode1, passcode2, passcode3, passcode4, delay_10s
    extern AsciiKey_0, AsciiKey_2, AsciiKey_3, AsciiKey_4;, myTable,  myTable_1, myArray 
    extern LCD_Setup, myArray, LCD_TwoLine, Button_Pressed, whichButton
    extern store1, store2, store3, store4, storeKey1, storeKey2, storeKey3, storeKey4, Welcome_msg, New_pw_msg


acs2    udata_acs
wrong_counter res 1
;ErrorMessage1	   res 1
ErrorMessage1_len  res 1
;ErrorMessage2	   res 1
ErrorMessage2_len  res 1
passcode1	   res 1
passcode2	   res 1
passcode3	   res 1
passcode4	   res 1
Message1_len	   res 1
Message4_len	   res 1
main code
 
set_passcode		   ;saves keyboard input to exernal memory
    movff AsciiKey_0, passcode1
    ;call write1
    call    store1
    movff AsciiKey_2, passcode2
    ;call write2
    call    store2
    movff AsciiKey_3, passcode3
    ;call write3
    call    store3
    movff AsciiKey_4, passcode4
    ;call write4
    call    store4
    return
 
keyboard_memory_compare	    ;compares keyboard input with external memory
    movlw 0x00
    movwf wrong_counter
    ;call read1
    movf AsciiKey_0, W, ACCESS
    ;cpfseq passcode1
    cpfseq storeKey1
    call wrong_passcode
    ;call read2
    movf AsciiKey_2, W, ACCESS
    ;cpfseq passcode2
    cpfseq storeKey2
    call wrong_passcode
    ;call read3
    movf AsciiKey_3, W, ACCESS
    ;cpfseq passcode3
    cpfseq storeKey3
    call wrong_passcode
    ;call read4
    movf AsciiKey_4, W, ACCESS
    ;cpfseq passcode4
    cpfseq storeKey4
    call wrong_passcode
    
    movlw 0x01		    ;light green LED
    movwf PORTC
    
    call    LCD_Setup
Message1 data	    "Password correct    \n"	; message, plus carriage return
    movlw	.22
    movwf	Message1_len
    lfsr	FSR0, myArray
    movlw	upper(Message1)	; address of data in PM
    movwf	TBLPTRU		; load upper bits to TBLPTRU
    movlw	high(Message1)	; address of data in PM
    movwf	TBLPTRH		; load high byte to TBLPTRH
    movlw	low(Message1)	; address of data in PM
    movwf	TBLPTRL		; load low byte to TBLPTRL
    movff	Message1_len, W
    call	LCD_init_message
    movlw	Message1_len-1	; output message to LCD (leave out "\n")
    movff	Message1_len-1, W
    lfsr	FSR2, myArray
    call	LCD_TwoLine
    
    call delay_1s
    call delay_1s
    call delay_1s
    ;call delay_1s
    ;call delay_1s
    call    LCD_Setup
    movlw   0XEE
    cpfseq  whichButton	    ;goes to change p/w routine if two was the first button pressed 
    goto    New_pw_msg
    goto    Welcome_msg
    
wrong_passcode
    incf wrong_counter
    movlw 0x02		    ;light red LED
    movwf PORTC
    call delay_1s
    movlw 0x03
    cpfslt wrong_counter
    call buzzer
    call	LCD_Setup
Message4 data	    "Factory Reset        \n"	; message, plus carriage return
    movlw	.22
    movwf	Message4_len
    lfsr	FSR0, myArray
    movlw	upper(Message4)	; address of data in PM
    movwf	TBLPTRU		; load upper bits to TBLPTRU
    movlw	high(Message4)	; address of data in PM
    movwf	TBLPTRH		; load high byte to TBLPTRH
    movlw	low(Message4)	; address of data in PM
    movwf	TBLPTRL		; load low byte to TBLPTRL
    movff	Message4_len, W
    call	LCD_init_message
    movlw	Message4_len-1	; output message to LCD (leave out "\n")
    movff	Message4_len-1, W
    lfsr	FSR2, myArray
    call	LCD_TwoLine
    ;call	LCD_Write_Message
	
    call	delay_1s   ;ensure message displayed for long enough
    call	delay_1s
;    call	delay_1s
;    call	delay_1s    
;    call	delay_1s
    call	read_keyboard
   
   
    
buzzer
    movlw 0x40	;set RB6 to high
    addwf PORTB ;move to port B without interfereing with LCD pins
ErrorMessage2 data	"Wrong, Locked!\n"	; message, plus carriage return
    movlw	.15
    movwf	ErrorMessage2_len
    movlw	upper(ErrorMessage2)	; address of data in PM
    movwf	TBLPTRU		; load upper bits to TBLPTRU
    movlw	high(ErrorMessage2)	; address of data in PM
    movwf	TBLPTRH		; load high byte to TBLPTRH
    movlw	low(ErrorMessage2)	; address of data in PM
    movwf	TBLPTRL		; load low byte to TBLPTRL
    movff	ErrorMessage2_len, W
    call LCD_init_message
    call LCD_Write_Message
    call delay_10s
    
    movlw 0x40	;set RB6 to high
    subwf PORTB ;trun buzzer off
    clrf wrong_counter
    goto read_keyboard
    
 
delay_10s
    call delay_1s
    call delay_1s
    call delay_1s
    call delay_1s
    call delay_1s
    call delay_1s
    call delay_1s
    call delay_1s
    call delay_1s
    call delay_1s
    call delay_1s
    return
    
	end