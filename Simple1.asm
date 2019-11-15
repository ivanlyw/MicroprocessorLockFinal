	#include p18f87k22.inc

	;extern	UART_Setup, UART_Transmit_Message   ; external UART subroutines
	extern  LCD_Setup, LCD_Write_Message, LCD_SecondLine, LCD_init_message, myArray, LCD_TwoLine	    ; external LCD subroutines
	extern	LCD_Write_Hex			    ; external LCD subroutines
	extern  ADC_Setup, ADC_Read		    ; external ADC routines
	extern  keyboard_setup
	extern	read_keyboard, set_passcode
	extern	Button_Pressed
	;extern	keyboard_start
	extern	AsciiKey , set_passcode
	;extern	myTable, myTable_1, myArray
	
	global AsciiKey_1, AsciiKey_2, AsciiKey_3, AsciiKey_4, resets

	
acs0	udata_acs   ; reserve data space in access ram
counter	    res 1   ; reserve one byte for a counter variable
delay_count res 1   ; reserve one byte for counter in the delay routine



rst	code	0    ; reset vector
	goto	setup

pdata	code    ; a section of programme memory for storing data
	; ******* myTable, data in programme memory, and its length *****
;myTable data	    "Hello World!\n"	; message, plus carriage return
;	constant    myTable_l=.13	; length of data
	constant    SixteenBit = 0xFED2 ; Sixteen bit number for multiplication
	constant    SixteenBit1 = 0xC448

acs1	udata_acs 	
EightBit    res 1 ; reserve 1 byte for 8 bit number
AsciiKey_1   res 1
AsciiKey_2   res 1
AsciiKey_3   res 1
AsciiKey_4   res 1
Message1_len res 1

	
main	code
	; ******* Programme FLASH read Setup Code ***********************
setup	bcf	EECON1, CFGS	; point to Flash program memory  
	bsf	EECON1, EEPGD 	; access Flash program memory
;	call	UART_Setup	; setup UART
	call	LCD_Setup	; setup LCD
	call	ADC_Setup	; setup ADC
	call	keyboard_setup
	goto	start
	
	; ******* Main programme ****************************************
start 	;movlw	0XFF
	;movwf	EightBit	;multiply by FF
	;call	Eight_Sixteen
	;call	Sixteen_Sixteen
	
Message1 data	    "Welcome, press  button to start \n"	; message, plus carriage return
	movlw   .33
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
	call	LCD_TwoLine
	
resets	movlw	0x30		;initialise passcode to 0
	movwf	AsciiKey
	movwf	AsciiKey_1
	movwf	AsciiKey_2
	movwf	AsciiKey_3
	movwf	AsciiKey_4
	call	set_passcode
;	movwf	myTable_1	;initialise message lengh to 0
	;call	set_passcode
	call	Button_Pressed
	
;	lfsr	FSR0, myArray	; Load FSR0 with address in RAM	
;	movlw	upper(myTable)	; address of data in PM
;	movwf	TBLPTRU		; load upper bits to TBLPTRU
;	movlw	high(myTable)	; address of data in PM
;	movwf	TBLPTRH		; load high byte to TBLPTRH
;	movlw	low(myTable)	; address of data in PM
;	movwf	TBLPTRL		; load low byte to TBLPTRL
;	movlw	myTable_l	; bytes to read
;	movwf 	counter		; our counter register
;loop 	tblrd*+			; one byte from PM to TABLAT, increment TBLPRT
;	movff	TABLAT, POSTINC0; move data from TABLAT to (FSR0), inc FSR0	
;	decfsz	counter		; count down to zero
;	bra	loop		; keep going until finished
;		
;	movlw	myTable_l-1	; output message to LCD (leave out "\n")
;	lfsr	FSR2, myArray
;	call	LCD_Write_Message

;	movlw	myTable_l	; output message to UART
;	lfsr	FSR2, myArray
;	call	UART_Transmit_Message
	
;	movlw   high(SixteenBit) ;ForEight_Sixteen routine
;	movwf	0x20
;	movlw	low(SixteenBit)
;	movwf	0x21
;	movlw	EightBit
;	movwf	0x30
	
measure_loop
	call	ADC_Read
	movf	ADRESH,W
	call	LCD_Write_Hex
	movf	ADRESL,W
	call	LCD_Write_Hex
	goto	measure_loop		; goto current line in code

	; a delay subroutine if you need one, times around loop in delay_count
delay	decfsz	delay_count	; decrement until zero
	bra delay
	return

Eight_Sixteen
    movlw 0xFF
    movwf 0x50		;file for later comparison
    ;movf EightBit, W
    ;movwf 0x30		;move to arbitary file for storage
    movlw low(SixteenBit)
    mulwf EightBit	
    movff PRODL, 0x12	;move to arbitary file for storage
    movff PRODH, 0x14	;move to arbitary file for storage (later add to low half of high product)
    movlw high(SixteenBit)
    mulwf EightBit
    movff PRODL, 0x11	;move to arbitary file for storage (later add to high half of low product)
    movff PRODH, 0x10	;move to arbitary file for storage
    movf  0x14, W
    addwf 0x11
    movf  0x11, W
    movlw 0x00
    addwfc 0x10
    ;goto fin ;this is fucked (previously return)
    ;movf  0x10, W
    ;addlw 0x01
    ;movwf 0x10
    ;fin ;didn't previously exist
    return
    
Sixteen_Sixteen
    movlw low(SixteenBit1)
    movwf EightBit
    movff EightBit, 0x30 ;test
    call Eight_Sixteen
    movff 0x12, 0x63 ;store final answer in row 6
    movff 0x11, 0x62 ; middle digit to be added to lowest digit of nect multiplication
    movff 0x10, 0x61 ; top digit to be added to middle digit of next multiplication
    movlw high(SixteenBit1)
    movwf EightBit
    movff EightBit, 0x31 ;test
    call Eight_Sixteen
    movf 0x12, W
    addwf 0x62
    movlw 0x00
    addwfc 0x61
    movf 0x11, W
    addwf 0x61 
    movlw 0x00
    movwf 0x60
    addwfc 0x60
    movf 0x10, W
    addwf 0x60 
    return
    
   
    
 
     
	end