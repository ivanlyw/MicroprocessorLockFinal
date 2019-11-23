#include p18f87k22.inc
    
    
    global 	keyboard_memory_compare, set_passcode, wrong_passcode, wrong_counter, unlock
    global 	passcode1, passcode2, passcode3, passcode4
    
    extern 	AsciiKey_1, AsciiKey_2, AsciiKey_3, AsciiKey_4					;external Simple registers
    extern 	LCD_Setup, LCD_TwoLine, LCD_init_message, LCD_Write_Message 			;external LCD subroutines
    extern 	store1, store2, store3, store4, storeKey1, storeKey2, storeKey3, storeKey4	;external CompareBackup subroutines/registers
    extern 	read_keyboard, delay_5ms, First_Button, whichButton				;external KEYBOARD subroutines
    extern	CorrectPW_msg, WrongPW_msg, Lockout_msg						;external Messages subroutines

acs3    udata_acs
wrong_counter 	   res 1
passcode1	   res 1
passcode2	   res 1
passcode3	   res 1
passcode4	   res 1
main code


unlock	    			;sets Port D to high to unlock 
    movlw 	0xFF
    movwf 	PORTD 
    call 	delay_5ms   	;keeps unlocked for 1s
    movlw 	0x00	    	;relock
    movwf 	PORTD
    return 

set_passcode		   ;saves keyboard input to external memory
    movff 	AsciiKey_0, passcode1
    ;call 	write1
    call    	store1
    movff 	AsciiKey_2, passcode2
    ;call 	write2
    call    	store2
    movff 	AsciiKey_3, passcode3
    ;call 	write3
    call    	store3
    movff 	AsciiKey_4, passcode4
    ;call	write4
    call    	store4
    return
 
keyboard_memory_compare	    ;compares keyboard input with external memory/storedKey registers
    movlw 	0x00
    movwf 	wrong_counter
    ;call 	read1
    movf 	AsciiKey_0, W, ACCESS
    ;cpfseq 	passcode1
    cpfseq 	storeKey1
    call 	wrong_passcode
    ;call 	read2
    movf 	AsciiKey_2, W, ACCESS
    ;cpfseq 	passcode2
    cpfseq 	storeKey2
    call 	wrong_passcode
    ;call 	read3
    movf 	AsciiKey_3, W, ACCESS
    ;cpfseq 	passcode3
    cpfseq 	storeKey3
    call 	wrong_passcode
    ;call 	read4
    movf 	AsciiKey_4, W, ACCESS
    ;cpfseq 	passcode4
    cpfseq 	storeKey4
    goto 	wrong_passcode
    
    movlw 	0x01		    ;light green LED
    movwf 	PORTC
    
    call	CorrectPW_msg

    movlw 	0XEE
    cpfseq  	whichButton	    ;goes to change p/w routine if 2 was the first button pressed 
    goto    	NewPW_msg
    goto    	Welcome_msg
    
wrong_passcode
    incf 	wrong_counter
    movlw 	0x02		    ;light red LED
    movwf 	PORTC
    call 	delay_5ms
    movlw 	0x03
    cpfslt 	wrong_counter
    call 	buzzer
    
    call	WrongPW_msg

    call	read_keyboard
   
   
    
buzzer
    movlw 	0x40		;set RB6 to high
    addwf 	PORTB 		;move to port B without interfereing with LCD pins
    
    call	Lockout_msg
    
    call 	delay_50ms
    
    movlw	0x40		;set RB6 to high
    subwf	PORTB 		;turn buzzer off
    
    clrf 	wrong_counter	;clears wrong_counter 
    goto 	read_keyboard
    
 
delay_50ms
    call delay_5ms
    call delay_5ms
    call delay_5ms
    call delay_5ms
    call delay_5ms
    call delay_5ms
    call delay_5ms
    call delay_5ms
    call delay_5ms
    call delay_5ms
    return
    
	end
