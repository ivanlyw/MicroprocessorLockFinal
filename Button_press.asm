#include p18f87k22.inc
    
    global 	Button1, Button2, Button3
    extern 	First_Button, AsciiKey, read_keyboard, keyboard_memory_compare	;external KEYBOARD subroutines
    extern	Unlock_msg, NewPW_msg, ChangePW_msg, FactoryReset_msg		;external Messages subroutines
    extern	unlock, set_passcode						;external Functions subroutines
    extern	resets								;external Simple subroutine

    code

    
;AsciiKey contains the value of the first button pressed

Button1		;hold 1 then input passcode to UNLOCK
	movlw	0xEE			
	cpfseq	AsciiKey		;checks if 1 is pressed 
	
	return				;return to First_Button if not equal
	
	call	Unlock_msg		;displays 'Unlock lock' message

	goto	read_keyboard		;user inputs 4 character passcode
	call	keyboard_memory_compare	;compares input with memory
	call	unlock
	goto	First_Button

Button2	    	;hold 2 to input NEW passcode and the UNLOCKS
	
	movlw 0xED			
	cpfseq AsciiKey			;checks if 2 is pressed
	
	return				;return to First_Button if not equal
	
	call	ChangePW_msg		;displays 'Change password' message
	
	call read_keyboard		
	call keyboard_memory_compare
	
	call NewPW_msg			;displays 'New password' message
	
	goto read_keyboard
	call set_passcode		;writes stored input to memory as new passcode
	goto First_Button

Button3	    ;resets/re-initialises keyboard
	
	movlw 0xEB
	cpfseq AsciiKey			;checks if 3 is pressed
	
	return				;return to First_Button  if not equal
	
	call	FactoryReset_msg	;displays 'Factory reset' message
		
	goto	resets			;re-initialises lock
	

end
	
  

