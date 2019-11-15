#include p18f87k22.inc
    
    extern read_keyboard, read1, read2, read3, read4, write1, write2, write3, write4, delay_1s, LCD_init_message, LCD_Write_Message
    global keyboard_memory_compare, set_passcode, wrong_passcode, wrong_counter
    global passcode1, passcode2, passcode3, passcode4, delay_10s
    extern AsciiKey_1, AsciiKey_2, AsciiKey_3, AsciiKey_4;, myTable,  myTable_1, myArray 
    extern LCD_Setup, myArray
    


acs2    udata_acs
wrong_counter res 1
ErrorMessage1	   res 1
ErrorMessage1_len  res 1
ErrorMessage2	   res 1
ErrorMessage2_len  res 1
passcode1	   res 1
passcode2	   res 1
passcode3	   res 1
passcode4	   res 1
Message1_len	   res 1
main code
 
set_passcode		   ;saves keyboard input to exernal memory
    movff AsciiKey_1, passcode1
    call write1
    movff AsciiKey_2, passcode2
    call write2
    movff AsciiKey_3, passcode3
    call write3
    movff AsciiKey_4, passcode4
    call write4
    return
 
keyboard_memory_compare	    ;compares keyboard input with external memory
    movlw 0x00
    movwf wrong_counter
    call read1
    movff AsciiKey_1, W
    cpfseq passcode1
    call wrong_passcode
    call read2
    movff AsciiKey_2, W
    cpfseq passcode2
    call wrong_passcode
    call read3
    movff AsciiKey_3, W
    cpfseq passcode3
    call wrong_passcode
    call read4
    movff AsciiKey_4, W
    cpfseq passcode4
    call wrong_passcode
    movlw 0x01		    ;light green LED
    movwf PORTC
    
Message1 data	    "Correct         \n"	; message, plus carriage return
    movlw   .17
    movwf   Message1_len
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
    call	LCD_Write_Message
    
    call delay_1s
    call delay_1s
    call delay_1s
    call delay_1s
    call delay_1s
    
    return
    
wrong_passcode
    incf wrong_counter
    movlw 0x02		    ;light red LED
    movwf PORTC
    call delay_1s
    movlw 0x03
    cpfslt wrong_counter
    call buzzer
    call	LCD_Setup
Message4 data	    "Wrong Passcode \n"	; message, plus carriage return
    movlw   .17
    movwf   Message1_len
    lfsr	FSR0, myArray
    movlw	upper(Message4)	; address of data in PM
    movwf	TBLPTRU		; load upper bits to TBLPTRU
    movlw	high(Message4)	; address of data in PM
    movwf	TBLPTRH		; load high byte to TBLPTRH
    movlw	low(Message4)	; address of data in PM
    movwf	TBLPTRL		; load low byte to TBLPTRL
    movff	Message1_len, W
    call	LCD_init_message
    movlw	Message1_len-1	; output message to LCD (leave out "\n")
    movff	Message1_len-1, W
    lfsr	FSR2, myArray
    call	LCD_Write_Message
	
    call	delay_1s   ;ensure message displayed for long enough
    call	read_keyboard
   
    
buzzer
    movlw 0x40	;set RB6 to high
    addwf PORTB ;move to port B without interfereing with LCD pins
local ErrorMessage2
    data	    "Wrong, Locked!\n"	; message, plus carriage return
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