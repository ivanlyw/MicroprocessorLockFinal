#include p18f87k22.inc
    global keyboard_setup, read_keyboard, delay_1s
    extern LCD_Write_Message, LCD_Setup, LCD_delay_ms, LCD_Setup, LCD_init_message, LCD_SecondLine
    global counter, sum, Button_Pressed, AsciiKey 
    extern AsciiKey_1, AsciiKey_2, AsciiKey_3, AsciiKey_4, Button1, Button2, Button3, myArray, keyboard_memory_compare

acs3	udata_acs   ; reserve data space in access ram
col	res 1
row	res 1
sum	res 1
key	res 4
key_counter res 1
AsciiKey res 1	;stores ASCII code of keyboard charaters
Message1_len    res 1
DisplayKey  res 1
asterix res 1
;myArray_2 res 0x20

counter res 1
    code



keyboard_setup
    banksel PADCFG1	    ;sets correct bank for pull up resistors
    bsf PADCFG1,REPU,BANKED ; SET PULL ups to on for PORTE
    clrf LATE		;Write 0s to LATE register
    return
    
;keyboard_start
 ;   call Button1
  ;  call Button2
   ; call Button3
    
Button_Pressed
   
start_again
    movlw 0x0F
    movwf TRISE		;configure PORTE 4-7 as outputs and PORTE 0-3 as inputs
    call LCD_delay_ms	;run to allow charge capacitance following change out output
    
    movff PORTE, col	;store Port E values in memory
    
    movlw 0xF0
    movwf TRISE		;configure PORTE 0-3 as outputs and PORTE 4-7 as inputs
    call LCD_delay_ms	;run to allow charge capacitance following change out output
    movff PORTE, row    ;store Port E values in memory
   
    
    movf row, W, ACCESS	;adding keyboard rows/columns together
    addwf col, ACCESS
    movwf sum
    movff sum, AsciiKey
     
    call LCD_delay_ms	;run to allow charge capacitance following change out output
     
    call Button1
    call Button2
    call Button3
    
    bra start_again
    
    return 
    
read_keyboard
    	call	LCD_Setup
	call	LCD_SecondLine
Message1 data	    "Input Passcode  \n"	; message, plus carriage return
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
	call    LCD_init_message
	movlw	Message1_len-1	; output message to LCD (leave out "\n")
	movff	Message1_len-1, W
	lfsr	FSR2, myArray
	call LCD_Write_Message
	
   
    movlw .42		;move asterisk ascii to file reserve
    movwf  asterix
    clrf AsciiKey	;ensure AsciiKEy and key counter are set to 0
    clrf key_counter
   
    
input_more_numbers
    movlw 0x0F
    movwf TRISE		;configure PORTE 4-7 as outputs and PORTE 0-3 as inputs
    call LCD_delay_ms	;run to allow charge capticence following change out output
    
    movff PORTE, col	;store Port E values in memory
    
    movlw 0xF0
    movwf TRISE		;configure PORTE 0-3 as outputs and PORTE 4-7 as inputs
    call LCD_delay_ms	;run to allow charge capacitance following change out output
    movff PORTE, row   ;store Port E values in memory
   
    
    movf row, W, ACCESS	;adding keyboard rows/columns together
    addwf col, ACCESS
    movwf sum
    call LCD_delay_ms	;run to allow charge capacitance following change out output
    
    call number_comparison
   
    
    return
    

    
Write_Message1 
    call LCD_Setup
    movff AsciiKey, AsciiKey_1	    ;move input to memory for storage
    
    lfsr  FSR2, DisplayKey	    ;load address of AsciiKey to FSR2
    movlw .1
    call LCD_Write_Message	    ;write last digit of input key
    
    incf key_counter
    
    call delay_1s		    ;delay 1 dec before turning to asterisk	    
    call LCD_Setup
    call asterisk
    call LCD_delay_ms
    
    goto input_more_numbers
    
Write_Message2
    ;call LCD_Setup		    ;clear LCD Display
    movff AsciiKey, AsciiKey_2
    
    ;call asterisk
    
    clrf FSR2			    ;write passcode letter
    lfsr  FSR2, DisplayKey 
    movlw .1
    call LCD_Write_Message  
    
    incf key_counter
    
    call delay_1s
    
    call LCD_Setup
    call asterisk
    call asterisk
    
    goto input_more_numbers
    
Write_Message3
    ;call LCD_Setup
    movff AsciiKey, AsciiKey_3
    
   ; call asterisk
    ;call asterisk
    
    clrf FSR2			    ;write passcode letter
    lfsr  FSR2, DisplayKey 
    movlw .1
    call LCD_Write_Message
    

    incf key_counter
    
    call delay_1s
    
    call LCD_Setup
    call asterisk
    call asterisk
    call asterisk
    
    goto input_more_numbers

    
Write_Message4
    
    movff AsciiKey, AsciiKey_4
    
    clrf FSR2			    ;write passcode letter
    lfsr  FSR2, DisplayKey 
    movlw .1
    call LCD_Write_Message
    
    call delay_1s
    
    call LCD_Setup
    call asterisk
    call asterisk
    call asterisk
    call asterisk
    goto keyboard_memory_compare
    
asterisk				    ;write asterix subroutine
    clrf  FSR2
    lfsr  FSR2, asterix		    ;write asterix
    movlw .1
    call LCD_Write_Message
    return
    
delay_1s			    ;30 millisecond delay
    call delay_10ms		    ; delay given in ms in W
    ;call delay_10ms
    ;call delay_10ms
	return

delay_10ms
    call LCD_delay_ms		    ; delay given in ms in W
    call LCD_delay_ms
    call LCD_delay_ms
    call LCD_delay_ms
    call LCD_delay_ms
    ;call LCD_delay_ms
    ;call LCD_delay_ms
    ;call LCD_delay_ms
    ;call LCD_delay_ms
    ;call LCD_delay_ms
	return
	
counter_comparison
    movlw 0x00
    cpfsgt key_counter
    goto Write_Message1
    movlw 0x01
    cpfsgt key_counter
    goto Write_Message2
    movlw 0x02
    cpfsgt key_counter
    goto Write_Message3
    movlw 0x03
    cpfsgt key_counter
    goto Write_Message4
    ;return
 
number_comparison
num_EE    
    movlw  0xEE		;hardcoding all 16 possible variations
    cpfseq sum		;skips is input equal
    goto   num_ED	;if not equal to EE runs through variations until it is equal
    movff  sum, AsciiKey
    movlw  .1		;corresponding keyboard value
    movwf key
    movlw .49
    movwf DisplayKey
    
    call counter_comparison
    
num_ED
    movlw  0xED	
    cpfseq sum		
    goto   num_EB
    movff  sum, AsciiKey
    movlw  .2		
    movwf  key
    movlw .50
    movwf DisplayKey
    
    call counter_comparison
    
num_EB
    movlw  0xEB	
    cpfseq sum		
    goto   num_E7
    movff  sum, AsciiKey
    movlw  .3		
    movwf  key
    movlw .51
    movwf DisplayKey
    
    call counter_comparison
    

num_E7
    movlw  0xE7
    cpfseq sum		
    goto   num_DE
    movff  sum, AsciiKey
    movlw  0x0F		
    movwf  key
    movlw .70
    movwf DisplayKey
    
    call counter_comparison
    

num_DE
    movlw  0xDE
    cpfseq sum		
    goto   num_DD
    movff  sum, AsciiKey
    movlw  .4	
    movwf  key
    movlw .52
    movwf DisplayKey
    
    call counter_comparison
    
    
num_DD
    movlw  0xDD
    cpfseq sum		
    goto   num_DB
    movff  sum, AsciiKey
    movlw  .5	
    movwf  key
    movlw .53
    movwf DisplayKey
    
    call counter_comparison
    

num_DB
    movlw  0xDB
    cpfseq sum		
    goto   num_D7
    movff  sum, AsciiKey
    movlw  .6	
    movwf  key
    movlw .54
    movwf DisplayKey
    
    call counter_comparison
    

num_D7
    movlw  0xD7
    cpfseq sum		
    goto   num_BE
    movff  sum, AsciiKey
    movlw  0x0E	
    movwf  key
    movlw .69
    movwf DisplayKey
    
    call counter_comparison
    
    
num_BE
    movlw  0xBE
    cpfseq sum		
    goto   num_BD
    movff  sum, AsciiKey
    movlw  .7	
    movwf  key
    movlw .55
    movwf DisplayKey
    
   call counter_comparison
    

num_BD
    movlw  0xBD
    cpfseq sum		
    goto   num_BB
    movff  sum, AsciiKey
    movlw  .8	
    movwf  key
    movlw .56
    movwf DisplayKey
    
    call counter_comparison
    

num_BB
    movlw  0xBB
    cpfseq sum		
    goto   num_B7
    movff  sum, AsciiKey
    movlw  .9	
    movwf  key
    movlw .57
    movwf DisplayKey
    
    call counter_comparison
    

num_B7
    movlw  0xB7
    cpfseq sum		
    goto   num_7E
    movff  sum, AsciiKey
    movlw  0x0D	
    movwf  key
    movlw .68
    movwf DisplayKey
    
    call counter_comparison
    

num_7E
    movlw  0x7E
    cpfseq sum		
    goto   num_7D
    movff  sum, AsciiKey
    movlw  0x0A	
    movwf  key
    movlw .65
    movwf DisplayKey
    
    call counter_comparison
    

num_7D
    movlw  0x7D
    cpfseq sum	
    goto   num_7B
    movff  sum, AsciiKey
    movlw  .0
    movwf  key
    movlw .48
    movwf DisplayKey
    
    call counter_comparison
    
 
num_7B
    movlw  0x7B
    cpfseq sum		
    goto   num_77
    movff  sum, AsciiKey
    movlw  0x0B
    movwf  key
    movlw .66
    movwf DisplayKey
    
    call counter_comparison
    

num_77	
    movlw  0x77
    cpfseq sum
    goto input_more_numbers
    movff  sum, AsciiKey
    movwf  key
    movlw .67
    movwf DisplayKey
    
    call counter_comparison

	end


