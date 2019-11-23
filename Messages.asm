#include p18f87k22.inc

global    Unlock_msg, ChangePW_msg, NewPW_msg, FactoryReset_msg, InputPW_msg    ;global response messages
global    CorrectPW_msg, WrongPW_msg, Lockout_msg, Welcome_msg                  ;global prompt messages
extern    LCD_init_message, LCD_Write_Message, LCD_SecondLine, LCD_Setup        ;external LCD subroutines
extern    delay_5ms
extern    myArray

ac8   udata_acs
Message1_len	res 1
Message2_len	res 1
Message3_len	res 1
Message4_len	res 1
Message5_len	res 1
Message6_len	res 1
Message7_len	res 1
Message8_len	res 1
Message9_len	res 1

code

Unlock_msg
call	LCD_Setup
call	LCD_SecondLine
Message1 data	    "Unlock lock     \n"	; message, plus carriage return
  movlw     .17
	movwf     Message1_len
	clrf	    FSR0
	lfsr	    FSR0, myArray
	movlw	    upper(Message1)	            ; address of data in PM
	movwf	    TBLPTRU		                  ; load upper bits to TBLPTRU
  movlw	    high(Message1)	            ; address of data in PM
  movwf	    TBLPTRH		                  ; load high byte to TBLPTRH
  movlw	    low(Message1)	              ; address of data in PM
  movwf	    TBLPTRL		                  ; load low byte to TBLPTRL
  movlw	    Message1_len
  call      LCD_init_message
  movlw	    Message1_len-1	            ; output message to LCD (leave out "\n")
  lfsr	    FSR2, myArray
  call	    LCD_Write_Message
  call      delay_5ms
  call	    delay_5ms
  
  return

ChangePW_msg
call	LCD_Setup
call	LCD_SecondLine
Message2 data	    "Change Passcode                 \n"	
	movlw     .33
	movwf     Message2_len
	clrf	    FSR0
	lfsr	    FSR0, myArray
	movlw	    upper(Message2)	
	movwf	    TBLPTRU		
	movlw	    high(Message2)	
	movwf	    TBLPTRH		
	movlw	    low(Message2)	
	movwf	    TBLPTRL		
	movlw	    Message2_len 
	call      LCD_init_message
	movlw	    Message2_len-1	
	lfsr	    FSR2, myArray
	call	    LCD_Write_Message
	call      delay_5ms
	call	    delay_5ms
  
  return
  
NewPW_msg  
call LCD_Setup
call LCD_SecondLine
Message3 data	    "New Passcode:   \n"	
	movlw     .17
	movwf     Message3_len
	clrf	    FSR0
	lfsr	    FSR0, myArray
	movlw	    upper(Message3)	
	movwf	    TBLPTRU		
	movlw	    high(Message3)	
	movwf	    TBLPTRH		
	movlw	    low(Message3)	
	movwf	    TBLPTRL		
	movff	    Message3_len, W
	call      LCD_init_message
	movlw	    Message3_len-1	
	movf	    Message3_len-1, W
	call	    LCD_Write_Message
	lfsr	    FSR2, myArray
	call      delay_5ms
	call      delay_5ms

  return
  
FactoryReset_msg
call	LCD_Setup
call	LCD_SecondLine
Message4 data	    "Factory Reset\n"	; message, plus carriage return
	movlw     .15
	movwf     Message4_len
	clrf	    FSR0
	lfsr	    FSR0, myArray
	movlw	    upper(Message4)	
	movwf	    TBLPTRU		
	movlw	    high(Message4)	
	movwf	    TBLPTRH		
	movlw	    low(Message4)	
	movwf	    TBLPTRL		
	movff	    Message4_len, W
	call      LCD_init_message
  movlw	    Message4_len-1	
	movf	    Message4_len-1, W
	call	    LCD_Write_Message
  lfsr	    FSR2, myArray
	call      delay_5ms
  call      delay_5ms
  
  return
  
CorrectPW_msg
call    LCD_Setup
Message5 data	    "Password correct    \n"	
    movlw	    .22
    movwf	    Message5_len
    lfsr	    FSR0, myArray
    movlw	    upper(Message5)
    movwf	    TBLPTRU		
    movlw	    high(Message5)	
    movwf	    TBLPTRH		
    movlw	    low(Message5)	
    movwf	    TBLPTRL		
    movff	    Message5_len, W
    call	    LCD_init_message
    movlw	    Message5_len-1	
    movff	    Message5_len-1, W
    lfsr	    FSR2, myArray
    call	    LCD_TwoLine           ;calls routine to allow writing across both lines
    
    call delay_5ms
    call delay_5ms
    call delay_5ms

    return
  
WrongPW_msg
call	LCD_Setup
Message6 data	    "Wrong, try again    \n"	
    movlw	    .22
    movwf	    Message6_len
    lfsr	    FSR0, myArray
    movlw	    upper(Message6)	
    movwf	    TBLPTRU		
    movlw	    high(Message6)	
    movwf	    TBLPTRH		
    movlw	    low(Message6)	
    movwf	    TBLPTRL	
    movff	    Message6_len, W
    call	    LCD_init_message
    movlw	    Message6_len-1	
    movff	    Message6_len-1, W
    lfsr	    FSR2, myArray
    call	    LCD_TwoLine

    call	delay_5ms   
    call	delay_5ms
    call	delay_5ms
    
    return
  
Lockout_msg
call	LCD_Setup
Message7 data	"Wrong, Locked!\n"	
    movlw	    .15
    movwf	    Message7_len
    lfsr      FSR0, myArray
    movlw	    upper(Message7)	
    movwf	    TBLPTRU		
    movlw	    high(Message7)	
    movwf	    TBLPTRH		
    movlw	    low(Message7)	 
    movwf	    TBLPTRL		 
    movff	    Message7_len, W
    call      LCD_init_message
    movlw	    Message7_len-1	
    movff	    Message7_len-1, W
    lfsr	    FSR2, myArray
    call	    LCD_TwoLine

    call	delay_5ms   
    call	delay_5ms
    call	delay_5ms
    
    return

InputPW_msg
call	LCD_Setup
Message8 data	    "Input Password       \n"	
    movlw	    .22
    movwf	    Message8_len
    clrf      FSR0
    lfsr	    FSR0, myArray
    movlw	    upper(Message8)	
    movwf	    TBLPTRU		
    movlw	    high(Message8)	
    movwf	    TBLPTRH		
    movlw	    low(Message8)
    movwf	    TBLPTRL		
    movff	    Message8_len, W
    call	    LCD_init_message
    movlw	    Message8_len-1	
    movff	    Message8_len-1, W
    lfsr	    FSR2, myArray
    call	    LCD_TwoLine
    
    call delay_5ms
    call delay_5ms
    call delay_5ms
    
    return
    
Welcome_msg	
Message9 data	    "Welcome, press  button to start \n"	
	movlw       .33
	movwf       Message9_len
	lfsr	      FSR0, myArray
	movlw	      upper(Message9)	
	movwf	      TBLPTRU		
	movlw	      high(Message9)
	movwf	      TBLPTRH		
	movlw	      low(Message9)	
	movwf	      TBLPTRL		
	movff	      Message9_len, W
	call        LCD_init_message
	movlw	      Message9_len-1	
	movff	      Message9_len-1, W
	lfsr	      FSR2, myArray
	call	      LCD_TwoLine
  
  return
   

  end


