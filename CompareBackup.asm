#include p18f87k22.inc
    global store1, store2, store3, store4
    extern passcode1, passcode2, passcode3, passcode4
    
    acs5	udata_acs
    storeKey1  res 1
    storeKey2  res 1
    storeKey3  res 1
    storeKey4  res 1
  
    code

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