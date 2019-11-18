	#include p18f87k22.inc
	
	
	org 0x0

	
	org 0x100		    ; Main code starts here at address 0x100
acs0	udata_acs   ; reserve data space in access ram
counter1 res 1
counter2 res 1
memory1 res 1
memory2 res 1
    code

	movlw 0xFF
	movwf counter1
	movwf counter2
	movlw 0xEE
	movwf memory1
	movlw 0xEC
	movwf memory2
	
loop	movlw 0x40
	addwf PORTB
	call piezocounter
	movlw 0xEE
	movwf memory1
	movlw 0xEC
	movwf memory2
	subwf PORTB
	
	decf counter1,f	;decrments low memory by 1
	subwfb counter2, f
	movlw 0x00
	cpfseq counter2
	bra loop
	return
	
piezocounter

	movlw 0x00		;delay function so allows time for clock pulse to go to leading edge
dloop   decf memory1,f	;decrments low memory by 1
	subwfb memory2, f	;when low memory hits zero carry flag takes 256 bits from high memory
	bc dloop
	return
	
	end
