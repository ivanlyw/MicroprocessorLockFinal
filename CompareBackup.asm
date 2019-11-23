#include p18f87k22.inc
    global      store1, store2, store3, store4, storeKey1, storeKey2, storeKey3, storeKey4
    extern      passcode1, passcode2, passcode3, passcode4
    
acs1	udata_acs
storeKey1  res 1
storeKey2  res 1
storeKey3  res 1
storeKey4  res 1
  
    code
    
;Backup routine that doesn't rely on external memory 
;Each correct passcode character is stored in respective storeKey registers

store1
    movff   passcode1, storeKey1
    return
    
store2
    movff   passcode2, storeKey2
    return
    
store3
    movff   passcode3, storeKey3
    return
    
store4
    movff   passcode4, storeKey4
    return
    
    
    end
