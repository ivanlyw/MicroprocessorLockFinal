	#include p18f87k22.inc
	
	code
	org 0x0
	goto	setup
	
	org 0x100		    ; Main code starts here at address 0x100

	; ******* Programme FLASH read Setup Code ****  
setup	bcf	EECON1, CFGS	; point to Flash program memory  
	bsf	EECON1, EEPGD 	; access Flash program memory
	goto	start
	; ******* My data and where to put it in RAM *
myTable data	"This is just some data"
	constant 	myArray=0x400	; Address in RAM for data
	constant 	counter  =0x20	; Address of counter variable
	constant	delayTime=0x22	; Address for delay counter
	constant	highmemory=0x10 ;Address for high half of 16 bit memory
	constant	lowmemory=0x11 ;Address for low memory
	; ******* Main programme *********************
start 	lfsr	FSR0, myArray	; Load FSR0 with address in RAM	
	movlw	upper(myTable)	; address of data in PM
	movwf	TBLPTRU		; load upper bits to TBLPTRU
	movlw	high(myTable)	; address of data in PM
	movwf	TBLPTRH		; load high byte to TBLPTRH
	movlw	low(myTable)	; address of data in PM
	movwf	TBLPTRL		; load low byte to TBLPTRL
	movlw	.255		; 256 bytes to read
	movwf 	counter	; our counter register
	movlw 0x00		; Set portC as output
	movwf TRISC
loop 	tblrd*+			; move one byte from PM to TABLAT, increment TBLPRT
	movff	TABLAT, POSTINC0	; move read data from TABLAT to (FSR0), increment FSR0	
	;movwf counter, ACCESS
	
	movlw high(0xFFFF)
	movwf highmemory
	movlw low(0xFFFF)
	movwf lowmemory
	movwf delayTime
	call BigDelay
	call light
	decfsz	counter	; count down to zero
	bra	loop		; keep going until finished
	
	goto	0
	
delay   decfsz delayTime
	bra delay
	return
	
BigDelay 
	movlw 0x00
dloop   decf lowmemory,f
	subwfb highmemory, f
	bc dloop
	return
	
light   movff counter,PORTC
	;movfw counter
	;movwf LATC, ACCESS
	;movff counter, PORTC
	return
	
	end
