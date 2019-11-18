#include p18f87k22.inc
    
    global unlock, Button1, Button2, Button3, Button1_reg, Button2_reg, Button3_reg, New_pw_msg
    extern Button_Pressed, AsciiKey, read_keyboard, keyboard_memory_compare, set_passcode, delay_1s, LCD_init_message, LCD_Write_Message
    extern resets, myArray, LCD_SecondLine, LCD_Setup, delay_10s, whichButton
    
acs4	udata_acs
;Message1	res 1
Message1_len	res 1
;Message2	res 1
Message2_len	res 1
Message3_len	res 1
Message4_len	res 1
Button1_reg	res 1
Button2_reg	res 1
Button3_reg	res 1
    code

unlock	    ;sets Port D to high to unlock 
    movlw 0xFF
    movwf PORTD 
    call delay_1s   ;keeps unlocked for 1s
    movlw 0x00	    ;relock
    movwf PORTD
    return 
    
Button1		;hold 1 then input passcode to UNLOCK
	movlw	0xEE	;check if 1
	cpfseq	AsciiKey
	return	;return to button pressed if not equal
	call	LCD_Setup
	call	LCD_SecondLine
Message1 data	    "Unlock lock     \n"	; message, plus carriage return
	movlw   .17
	movwf   Message1_len
	clrf	FSR0
	lfsr	FSR0, myArray
	movlw	upper(Message1)	; address of data in PM
	movwf	TBLPTRU		; load upper bits to TBLPTRU
	movlw	high(Message1)	; address of data in PM
	movwf	TBLPTRH		; load high byte to TBLPTRH
	movlw	low(Message1)	; address of data in PM
	movwf	TBLPTRL		; load low byte to TBLPTRL
	movff	Message1_len, W
	call    LCD_init_message
	movlw	Message1_len-1	; output message to LCD (leave out "\n")
	movff	Message1_len-1, W
	lfsr	FSR2, myArray
	call	LCD_Write_Message
	
	call    delay_1s
	goto	read_keyboard
	call	keyboard_memory_compare	;compares input with memory
	call	unlock
	goto	end1

Button2	    ;hold 2 to input NEW passcode and the UNLOCKS
	
	movlw 0xED
	cpfseq AsciiKey
	return	;return to button pressed if not equal
	call	LCD_Setup
	call LCD_SecondLine
	
Message2 data	    "Change Passcode                 \n"	; message, plus carriage return
	movlw   .33
	movwf   Message2_len
	clrf	FSR0
	lfsr	FSR0, myArray
	movlw	upper(Message2)	; address of data in PM
	movwf	TBLPTRU		; load upper bits to TBLPTRU
	movlw	high(Message2)	; address of data in PM
	movwf	TBLPTRH		; load high byte to TBLPTRH
	movlw	low(Message2)	; address of data in PM
	movwf	TBLPTRL		; load low byte to TBLPTRL
	movff	Message2_len, W
	call    LCD_init_message
	movlw	Message2_len-1	; output message to LCD (leave out "\n")
	movff	Message2_len-1, W
	lfsr	FSR2, myArray
	
	call	LCD_Write_Message
	call    delay_1s
	call	delay_1s
	call    delay_1s
	call	delay_1s
	
	call read_keyboard
	call keyboard_memory_compare
	call LCD_Setup
	call LCD_SecondLine
New_pw_msg
Message3 data	    "New Passcode:   \n"	; message, plus carriage return
	movlw   .17
	movwf   Message3_len
	clrf	FSR0
	lfsr	FSR0, myArray
	movlw	upper(Message3)	; address of data in PM
	movwf	TBLPTRU		; load upper bits to TBLPTRU
	movlw	high(Message3)	; address of data in PM
	movwf	TBLPTRH		; load high byte to TBLPTRH
	movlw	low(Message3)	; address of data in PM
	movwf	TBLPTRL		; load low byte to TBLPTRL
	movff	Message3_len, W
	call    LCD_init_message
	movlw	Message3_len-1	; output message to LCD (leave out "\n")
	movff	Message3_len-1, W
	call	LCD_Write_Message
	clrf	FSR2
	lfsr	FSR2, myArray
	
	call    delay_1s
	call read_keyboard
	call set_passcode	;writes stored input to memory as new pw
	goto Button_Pressed

Button3	    ;resets/re-initialises keyboard
	
	movlw 0xEB
	cpfseq AsciiKey
	return	;return to button pressed if not equal
	call	LCD_Setup
	call	LCD_SecondLine
	
Message4 data	    "Factory Reset\n"	; message, plus carriage return
	movlw   .15
	movwf   Message4_len
	clrf	FSR0
	lfsr	FSR0, myArray
	movlw	upper(Message4)	; address of data in PM
	movwf	TBLPTRU		; load upper bits to TBLPTRU
	movlw	high(Message4)	; address of data in PM
	movwf	TBLPTRH		; load high byte to TBLPTRH
	movlw	low(Message4)	; address of data in PM
	movwf	TBLPTRL		; load low byte to TBLPTRL
	movff	Message4_len, W
	call    LCD_init_message
	call	LCD_Write_Message
	call    delay_1s
	goto	resets
	
end1
	    end
	
  

