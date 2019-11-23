# Microprocessors

An assembly program for a passcode-locking system for the PIC18 controller with input received from a keypad connected to Port E to be displayed on an LCD display on the PIC18 board.

Compares the input passcode with a stored passcode in program memory

Special buttons 1, 2, and 3 correspond to unlocking the lock, changing the passcode, and resetting the lock. These buttons are pressed first before entering the 4-character passcode. 

Correct attempts lead to a voltage been sent to Port F where it is amplified in order to disengage a lock connected to it.

Incorrect attempts will cause the program to redirect the user to try again.

Multiple incorrect attempts will result in the user being locked out for a specific amount of time before being able to retry.
