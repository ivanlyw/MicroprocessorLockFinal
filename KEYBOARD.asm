#include p18f87k22.inc

    global 	keyboard_setup, read_keyboard, delay_5ms, whichButton, First_Button, AsciiKey
    
    extern 	LCD_Setup, LCD_delay_ms							;external LCD subroutines
    extern 	LCD_Write_Message, LCD_init_message, LCD_SecondLine, LCD_TwoLine 	;external LCD subroutines
    extern 	AsciiKey_1, AsciiKey_2, AsciiKey_3, AsciiKey_4,   			;external Simple registers
    extern	keyboard_memory_compare							;external Functions subroutines
    extern 	Button1, Button2, Button3						;external Button_Press subroutines
    
acs4		udata_acs   		; reserve data space in access ram
col		res 1
row		res 1
sum		res 1
key_counter 	res 1
AsciiKey 	res 1	
DisplayKey  	res 1
asterix 	res 1
whichButton	res 1
counter 	res 1
    code



keyboard_setup
    banksel 	PADCFG1	    		;sets correct bank for pull up resistors
    bsf 	PADCFG1,REPU,BANKED 	;set PULL ups to on for PORTE
    clrf 	LATE			;write 0s to LATE register
    return
    

First_Button  				;first key press for special button functions
start_again
    movlw 	0x0F
    movwf 	TRISE			;configure PORTE 4-7 as outputs and PORTE 0-3 as inputs
    call 	LCD_delay_ms		;run to allow charge capacitance following change out output
    
    movff 	PORTE, col		;store Port E values in memory
    
    movlw 	0xF0
    movwf 	TRISE			;configure PORTE 0-3 as outputs and PORTE 4-7 as inputs
    call 	LCD_delay_ms		;run to allow charge capacitance following change out output
    movff 	PORTE, row    		;store Port E values in memory
   
    
    movf 	row, W, ACCESS		;adding keyboard rows/columns together
    addwf 	col, ACCESS
    movwf 	sum
    movff 	sum, AsciiKey
    movff 	sum, whichButton	;moves key value to register for later button routine comparison
    
    call 	LCD_delay_ms		;run to allow charge capacitance following change out output
     
    call Button1
    call Button2
    call Button3
    
    bra start_again
    
    return 
    
read_keyboard				;4 character passcode input

    call	InputPW_msg
   
    movlw 	.42			;move asterisk ascii to file reserve
    movwf  	asterix
    clrf 	AsciiKey		;ensure AsciiKey and key counter are set to 0
    clrf 	key_counter
   
    
input_more_numbers
    movlw 	0x0F
    movwf 	TRISE			;configure PORTE 4-7 as outputs and PORTE 0-3 as inputs
    call 	LCD_delay_ms		;run to allow charge capacitence following change out output
    
    movff 	PORTE, col		;store Port E values in memory
    
    movlw 	0xF0
    movwf 	TRISE			;configure PORTE 0-3 as outputs and PORTE 4-7 as inputs
    call 	LCD_delay_ms		;run to allow charge capacitance following change out output
    movff 	PORTE, row   		;store Port E values in memory
   
    
    movf 	row, W, ACCESS		;adding keyboard rows/columns together
    addwf 	col, ACCESS
    movwf 	sum
    call 	LCD_delay_ms		;run to allow charge capacitance following change out output
    
    call 	number_comparison
   
    return
    

    
Write_Message1 				;first character display
    call 	LCD_Setup
    movff 	AsciiKey, AsciiKey_1	;move input to memory for storage
    
    clrf	FSR2
    lfsr  	FSR2, DisplayKey	;load address of DisplayKey to FSR2
    movlw 	.1			
    call 	LCD_Write_Message	;write last digit of input key
    
    incf 	key_counter		;keeps track of how many characters have been input
    
    call 	delay_5ms		;delay 1 sec before turning to asterisk	    
    call 	LCD_Setup
    call 	asterisk		;replaces recent input with an asterisk
    call 	LCD_delay_ms
    
    goto input_more_numbers		;for 2nd, 3rd, and 4th character input
    
Write_Message2				;second character display
    movff 	AsciiKey, AsciiKey_2
    
    clrf 	FSR2			    
    lfsr  	FSR2, DisplayKey 
    movlw 	.1
    call 	LCD_Write_Message  
    
    incf 	key_counter
    
    call 	delay_5ms
    
    call 	LCD_Setup
    call 	asterisk		;prints asterisk from WM1
    call 	asterisk		;replaces recent input with an asterisk
    
    goto 	input_more_numbers
    
Write_Message3
    movff 	AsciiKey, AsciiKey_3
   
    clrf 	FSR2			    
    lfsr 	FSR2, DisplayKey 
    movlw 	.1
    call 	LCD_Write_Message
    

    incf 	key_counter
    
    call 	delay_5ms
    
    call 	LCD_Setup
    call 	asterisk		;prints asterisk from WM1
    call 	asterisk		;prints asterisk from WM2
    call 	asterisk		;replaces recent input with an asterisk
    
    goto 	input_more_numbers

Write_Message4
    movff 	AsciiKey, AsciiKey_4
    
    clrf 	FSR2			   
    lfsr  	FSR2, DisplayKey 
    movlw 	.1
    call 	LCD_Write_Message
    
    call 	delay_5ms
    
    call 	LCD_Setup
    call 	asterisk		;prints asterisk from WM1
    call 	asterisk		;prints asterisk from WM2
    call 	asterisk		;prints asterisk from WM3
    call 	asterisk		;replaces recent input with an asterisk
    
    goto 	keyboard_memory_compare	;compares 4 input characters with stored passcode registers
    
    
asterisk				;write asterisk subroutine
    clrf  	FSR2
    lfsr  	FSR2, asterix		;write asterix
    movlw 	.1
    call 	LCD_Write_Message
    return
    
delay_5ms
    call 	LCD_delay_ms		
    call 	LCD_delay_ms
    call 	LCD_delay_ms
    call 	LCD_delay_ms
    call 	LCD_delay_ms
    return
	
counter_comparison			;determines which nth character is being input
    movlw 	0x00			
    cpfsgt 	key_counter		;if key_counter is 0, means 1st character, goto WM1
    goto 	Write_Message1
    movlw 	0x01
    cpfsgt 	key_counter		;if key_counter is 1, means 2nd character, goto WM2
    goto 	Write_Message2
    movlw 	0x02
    cpfsgt 	key_counter		;if key_counter is 2, means 3rd character, goto WM3
    goto 	Write_Message3
    movlw 	0x03
    cpfsgt 	key_counter		;if key_counter is 3, means 4th character, goto WM4
    goto 	Write_Message4
    
 
number_comparison			;cycles through all possible unique hex values for each key

num_EE    
    movlw  	0xEE			;hardcoding all 16 possible variations
    cpfseq 	sum			;skips is input equal
    goto   	num_ED			;if not equal to EE runs through variations until it is equal
    movff  	sum, AsciiKey
    movlw 	.49			;corresponding ASCII value of key
    movwf 	DisplayKey		
    
    call 	counter_comparison
    
num_ED
    movlw  	0xED	
    cpfseq 	sum		
    goto   	num_EB
    movff  	sum, AsciiKey
    movlw 	.50
    movwf 	DisplayKey
    
    call 	counter_comparison
    
num_EB
    movlw  	0xEB	
    cpfseq 	sum		
    goto   	num_E7
    movff  	sum, AsciiKey
    movlw 	.51
    movwf 	DisplayKey
    
    call 	counter_comparison
    

num_E7
    movlw  	0xE7
    cpfseq 	sum		
    goto   	num_DE
    movff  	sum, AsciiKey
    movlw 	.70
    movwf 	DisplayKey
    
    call 	counter_comparison
    

num_DE
    movlw  	0xDE
    cpfseq 	sum		
    goto   	num_DD
    movff  	sum, AsciiKey
    movlw 	.52
    movwf 	DisplayKey
    
    call 	counter_comparison
    
    
num_DD
    movlw  	0xDD
    cpfseq 	sum		
    goto   	num_DB
    movff  	sum, AsciiKey
    movlw 	.53
    movwf 	DisplayKey
    
    call 	counter_comparison
    

num_DB
    movlw  	0xDB
    cpfseq 	sum		
    goto   	num_D7
    movff  	sum, AsciiKey
    movlw 	.54
    movwf 	DisplayKey
    
    call 	counter_comparison
    

num_D7
    movlw  	0xD7
    cpfseq 	sum		
    goto   	num_BE
    movff  	sum, AsciiKey
    movlw 	.69
    movwf 	DisplayKey
    
    call 	counter_comparison
    
    
num_BE
    movlw  	0xBE
    cpfseq 	sum		
    goto   	num_BD
    movff  	sum, AsciiKey
    movlw 	.55
    movwf 	DisplayKey
    
   call 	counter_comparison
    

num_BD
    movlw  	0xBD
    cpfseq 	sum		
    goto   	num_BB
    movff  	sum, AsciiKey
    movlw 	.56
    movwf 	DisplayKey
    
    call 	counter_comparison
    

num_BB
    movlw  	0xBB
    cpfseq 	sum		
    goto   	num_B7
    movff  	sum, AsciiKey
    movlw 	.57
    movwf 	DisplayKey
    
    call 	counter_comparison
    

num_B7
    movlw  	0xB7
    cpfseq 	sum		
    goto   	num_7E
    movff  	sum, AsciiKey
    movlw 	.68
    movwf 	DisplayKey
    
    call 	counter_comparison
    

num_7E
    movlw  	0x7E
    cpfseq 	sum		
    goto   	num_7D
    movff  	sum, AsciiKey
    movlw 	.65
    movwf 	DisplayKey
    
    call 	counter_comparison
    

num_7D
    movlw  	0x7D
    cpfseq 	sum	
    goto   	num_7B
    movff  	sum, AsciiKey
    movlw 	.48
    movwf 	DisplayKey
    
    call 	counter_comparison
    
 
num_7B
    movlw  	0x7B
    cpfseq 	sum		
    goto   	num_77
    movff  	sum, AsciiKey
    movlw 	.66
    movwf 	DisplayKey
    
    call 	counter_comparison
    

num_77	
    movlw  	0x77
    cpfseq 	sum
    goto 	input_more_numbers		;only reaches here if no button is pressed, loops back to input stage 		
    movff  	sum, AsciiKey
    movlw 	.67
    movwf 	DisplayKey
    
    call 	counter_comparison

	end
