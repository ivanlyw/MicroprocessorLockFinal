#include p18f87k22.inc
	
	code
	org 0x0
	goto	start
	
	org 0x100		    ; Main code starts here at address 0x100


	
setup	bcf	EECON1, CFGS	    ; point to Flash program memory
	bsf	EECON1, EEPGD	    ; access Flash program memory
	bra	start
	
bytes	db	"+", "y"	    ; 2 bytes of data to be written

start	movlw	0x1		    ; for 250ns delay cp
	movwf	0x100, ACCESS	    ; delay const address
	movlw	0x0		    ; set all PORTH to output (LED on)
	movwf	TRISH, ACCESS	    ;
	movlw	0x0		    ; set all PORTJ to output (LED on)
	movwf	TRISJ, ACCESS	    ;
	movlw	high(bytes)	    ; high byte of 'bytes'
	movwf	TBLPTRH		    ; address of data in PM
	movlw	low(bytes)	    ; low byte of 'bytes'
	movwf	TBLPTRL		    ; address of data in PM
	setf	LATD, ACCESS	    ; set all of PORTD high		    
	movlw	0x0		    ; set all PORTD to output
	movwf	TRISD, ACCESS	    ; 
	call	write		    ; write bytes
	call	read		    ; read bytes and display on PORTH and POROTJ
	goto	0x0		    ; end program

read	movlw	0xFF		    ; set all PORTE to input
	movwf	TRISE, ACCESS	    ;
	movlw	b'1110'		    ; CP2,OE2*,CP1,OE1*
	movwf	PORTD, ACCESS	    ; set memory 1 to output (read to PORTE)
	
	movff	PORTE, PORTH	    ; copy the byte from PORTE to PORTH
	call	delb
	clrf	LATH, ACCESS
	
	movlw	b'1011'		    ; CP2,OE2*,CP1,OE1*
	movwf	PORTD, ACCESS	    ; set memory 2 to output (read to PORTE)
	movff	PORTE, PORTJ	    ; copy the byte from PORTE to PORTJ
	call	delb
	clrf	LATJ, ACCESS
	return
	
write	movlw	b'1111'		    ; CP2,OE2*,CP1,OE1*
	movwf	PORTD, ACCESS	    ; set memory 1 to input (write from PORTE)
	movlw	0x0		    ; set all PORTE to output
	movwf	TRISE, ACCESS
	
	tblrd*+			    ; copy first byte to TABLAT and increment
	movff	TABLAT, LATE	    ; copy the byte to LATE
	call	clock1		    ; flick clock pulse to write
	tblrd*+			    ; copy second byte to TABLAT and increment
	movff	TABLAT, LATE	    ; copy the byte to LATE
	call	clock2		    ; flick clock pulse to write
	
	movlw	0xFF		    ; set all PORTE to input
	movwf	TRISE, ACCESS	    ; reset PORTE
	return
	
delay	decfsz	0x100		    ; decrement constant until 0
	bra	delay		    ;
	movlw	0x1		    ; reset constant
	movwf	0x100		    ;
	return
	
delb	movlw	upper(0x3FFFFF)	    ; load 22-bit number into
	movwf	0x15		    ; FR 0x15
	;movlw	high(0x3FFFFF)	    ;
	movlw	0xFF	    ;
	movwf	0x16		    ; and FR 0x16
	movlw	low(0x3FFFFF)	    ;
	movwf	0x17		    ; and FR 0x17
	
	movlw	0x00		    ; W=0
dloop	decf	0x17, f		    ; no carry when 0x00 -> 0xff
	subwfb	0x16, f		    ; "
	subwfb	0x15, f		    ; "
	bc	dloop		    ; if carry, then loop again
	return			    ; carry not set so return

clock1	movlw	b'1101'		    ; CP2,OE2*,CP1,OE1*
	movwf	PORTD, ACCESS	    ; set cp1 to low
	call	delay		    ; delay for ~250 ns
	movlw	b'1111'		    ; set cp1 to high
	movwf	PORTD, ACCESS	    ; 
	return

clock2	movlw	b'0111'		    ; CP2,OE2*,CP1,OE1*
	movwf	PORTD, ACCESS	    ; set cp2 to low
	call	delay		    ; delay for ~250 ns
	movlw	b'1111'		    ; set cp1 to high
	movwf	PORTD, ACCESS	    ;
	return
	
finish
	end


