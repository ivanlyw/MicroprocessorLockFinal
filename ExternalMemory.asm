#include p18f87k22.inc
	global 		read1, read2, read3, read4, write1, write2, write3, write4
	extern 		passcode1, passcode2, passcode3, passcode4
	
	constant	highmemory=0x10 	;Address for high half of 16 bit memory
	constant	lowmemory=0x11  	;Address for low memory

acs2	udata_acs
passcode1 res 1
passcode2 res 1
passcode3 res 1
passcode4 res 1
 
code

    
Memory_Setup
	setf TRISD 			;tri-state Port D
	banksel PADCFG1 		;PADCFG1 is not in Access Bank!!
	bsf PADCFG1, RDPU, BANKED 	;Port D pull-ups on
	movlb 0x00 			;set BSR back to Bank 0
	
	movlw	0xFF		   	;both input, clock high 
	movwf	PORTJ, ACCESS 
	movlw	0x0		    	;setting Port D to outputs
	movwf	TRISJ, ACCESS
	;movlw	0x0a
	;movwf	PORTJ
	movlw	0x0
	movwf	TRISD, ACCESS	    	;setting Port D to output
	
	return

write1
	movlw	passcode1
	movwf	LATJ	    		;write to register Lat j
	movlw	0xFD	    		;set OE1 to low
	movwf	PORTH
	call	bigdelay
	movlw	0xFF	    		;set OE2 back up
	movwf	PORTH
	setf	TRISJ	   		;set Port J to tristate
	return

read1	
	movlw	0xFE
	movwf	PORTH			;set CP1 low
	call	bigdelay
	movff	PORTJ, passcode1	;store passcode in file for compare
	movlw	0xFF			;set CP1 back up
	movwf	PORTH
	setf	TRISJ			;Set Port J to tristate
	return
	
write2
	movlw	passcode2
	movwf	LATJ	    
	movlw	0xFB	    		;set OE2 to low
	movwf	PORTH
	call	bigdelay
	movlw	0xFF		    	;set OE2 back up
	movwf	PORTH
	setf	TRISJ	    
	return

read2	
	movlw	0xF7
	movwf	PORTH			;set CP2 low
	call	bigdelay
	movff	PORTJ, passcode2	
	movlw	0xFF			;set CP2 back up
	movwf	PORTH
	setf	TRISJ		
	return

write3
	movlw	passcode3
	movwf	LATJ	    
	movlw	0xEF	    		;set OE3 to low
	movwf	PORTH
	call	bigdelay
	movlw	0xFF	    		;set OE3 back up
	movwf	PORTH
	setf	TRISJ	    
	return

read3	
	movlw	0xDF
	movwf	PORTH			;set CP3 low
	call	bigdelay
	movff	PORTJ, passcode3	
	movlw	0xFF			;set CP3 back up
	movwf	PORTH
	setf	TRISJ		
	return

write4
	movlw	passcode4
	movwf	LATJ	    
	movlw	0xBF	    		;set OE4 to low
	movwf	PORTH
	call	bigdelay
	movlw	0xFF	    		;set OE4 back up
	movwf	PORTH
	setf	TRISJ	    
	return

read4	
	movlw	0x7F
	movwf	PORTH			;set CP4 low
	call	bigdelay
	movff	PORTJ, passcode4	
	movlw	0x7F			;set CP4 back up
	movwf	PORTH
	setf	TRISJ		
	return
	
bigdelay	
	movlw 0x00			;delay function so allows time for clock pulse to go to leading edge
dloop   decf lowmemory,f		;decrements low memory by 1
	subwfb highmemory, f		;when low memory hits zero carry flag takes 256 bits from high memory
	bc dloop
	return
	
	end
