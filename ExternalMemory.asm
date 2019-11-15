#include p18f87k22.inc
	global read1, read2, read3, read4, write1, write2, write3, write4
	extern passcode1, passcode2, passcode3, passcode4
	
	
main	code	

	constant	highmemory=0x10 ;Address for high half of 16 bit memory
	constant	lowmemory=0x11  ;Address for low memory

	movlw high(0xAAAA)	    ;reads highest charaters of 16 bit word
	movwf highmemory 
	movlw low(0xAAAA)	    ;reads lowest charaters of 16 bit word
	movwf lowmemory

write1
	movlw	passcode1
	movwf	LATJ	    ;Write to register Lat J
	movlw	0xFE	    ;set OE1 to low
	movwf	PORTH
	call	bigdelay
	movlw	0xFF	    ;set OE1 back up
	movwf	PORTH
	setf	TRISE	    ;Set port e to tristate
	return
	
read1	
	movlw	0xFD
	movwf	PORTH		;set CP1low
	call	bigdelay
	movff	PORTJ, passcode1	;store passcode in file for compare
	movlw	0xFF		;set CP1 back up
	movwf	PORTH
	setf	TRISJ		;Set port e to tristate
	return
	
write2
	movlw	passcode2
	movwf	LATJ	    ;Write to register Lat E
	movlw	0xFB	    ;set OE2 to low
	movwf	PORTH
	call	bigdelay
	movlw	0xFF	    ;set OE2 back up
	movwf	PORTH
	setf	TRISJ	    ;Set port e to tristate
	return

read2	
	movlw	0xF7
	movwf	PORTH		;set CP2 low
	call	bigdelay
	movff	PORTJ, passcode2	;store passcode in file for compare
	movlw	0xFF		;set CP1 back up
	movwf	PORTH
	setf	TRISJ		;Set port e to tristate
	return

write3
	movlw	passcode3
	movwf	LATJ	    ;Write to register Lat E
	movlw	0xEF	    ;set OE3 to low
	movwf	PORTH
	call	bigdelay
	movlw	0xFF	    ;set OE3 back up
	movwf	PORTH
	setf	TRISJ	    ;Set port e to tristate
	return

read3	
	movlw	0xDF
	movwf	PORTH		;set CP3 low
	call	bigdelay
	movff	PORTJ, passcode3	;store passcode in file for compare
	movlw	0xFF		;set CP3 back up
	movwf	PORTH
	setf	TRISJ		;Set port e to tristate
	return

write4
	movlw	passcode4
	movwf	LATJ	    ;Write to register Lat E
	movlw	0xBF	    ;set OE4 to low
	movwf	PORTH
	call	bigdelay
	movlw	0xFF	    ;set OE4 back up
	movwf	PORTH
	setf	TRISJ	    ;Set port e to tristate
	return

read4	
	movlw	0x7F
	movwf	PORTH		;set CP4 low
	call	bigdelay
	movff	PORTJ, passcode4	;store passcode in file for compare
	movlw	0x7F		;set CP4 back up
	movwf	PORTH
	setf	TRISJ		;Set port e to tristate
	return
	
bigdelay	
	movlw 0x00		;delay function so allows time for clock pulse to go to leading edge
dloop   decf lowmemory,f	;decrments low memory by 1
	subwfb highmemory, f	;when low memory hits zero carry flag takes 256 bits from high memory
	bc dloop
	return
	
	end
