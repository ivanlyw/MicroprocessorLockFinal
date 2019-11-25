#include p18f87k22.inc

global 	AsciiKey_1, AsciiKey_2, AsciiKey_3, AsciiKey_4, resets				
extern	LCD_Setup, LCD_Write_Message, LCD_SecondLine, LCD_init_message, LCD_TwoLine   	; external LCD subroutines
extern  keyboard_setup, First_Button, whichButton, AsciiKey				; external KEYBOARD subroutines
extern	set_passcode									; external Functions subroutines
extern	Welcome_msg									; external Messages subroutines
			
acs6		udata_acs   	; reserve data space in access ram
counter	    	res 1   
delay_count 	res 1   
AsciiKey_1   	res 1
AsciiKey_2   	res 1
AsciiKey_3   	res 1
AsciiKey_4   	res 1

rst	code	0    		; reset vector
	goto	setup
main	code
	; ******* Programme FLASH read Setup Code ***********************
setup	bcf	EECON1, CFGS	; point to Flash program memory  
	bsf	EECON1, EEPGD 	; access Flash program memory
	call	LCD_Setup	; setup LCD
	call	ADC_Setup	; setup ADC
	call	keyboard_setup
	goto	start
	
	; ******* Main programme ***************************************
		
resets	movlw	0x7D		;initialise passcode to 0000
	movwf	AsciiKey
	movwf	AsciiKey_1
	movwf	AsciiKey_2
	movwf	AsciiKey_3
	movwf	AsciiKey_4
	call	set_passcode
	
	call	Welcome_msg	;displays welcome message
	
	clrf	whichButton	;clears register to allow for value to be loaded into
	call	First_Button	;checks first button pressed to call corresponding special button routine	
     
	end
