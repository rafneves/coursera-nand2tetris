// Pseudo-code:
// 	while (true) {
// 		if (RAM[KBD] == 0x0) {
// 			// No key was pressed, so clear the screen.
// 			fillvalue=0000000000000000;
// 		} else {
// 			fillvalue=1111111111111111;
// 		}
//		
// 		for (address=SCREEN; i<SCREEN + 32*(256 - 1)*(32 - 1); address+=16) {
// 		}
// 	}
// 

(READ_KEYBOARD)
@KBD
D=M		// Save the keys pressed code.

// Decide if the screen must be cleared or blackened.
@KEY_PRESSED_NO
D; JEQ 		// if no key was pressed go to KEY_PRESSED_NO.

(KEY_PRESSED_YES)
@fillvalue
M=0 
M=!M // blacken all the register pixels.
@UPDATE_SCREEN
0;JMP

(KEY_PRESSED_NO)
@fillvalue
M=0 // clear all the register pixels

(UPDATE_SCREEN)
// Define the maxddress
// There are 256 lines and 32 16-bit-wide-columns.
// So the maximum offset is: 32*(256-1) + 32 = 8191
// Thus the maxaddress will be SCREEN + 8191.

@8191
D=A
@SCREEN
D=D+A
@maxaddress
M=D


// Initialization of address.
@SCREEN
D=A
@address
M=D

(LOOP_BEGIN)
@address
D=M
@maxaddress
D=D-M // D=address - maxaddress

@LOOP_END
D; JGT // if (address >= maxaddress) go out of the loop.

// Let's white to the screen
// Get the value to be written to
@fillvalue
D=M

//// Change the bits in SCREEN memory mapping.
@address
A=M
M=D

// Increment address by 16 bits.
@address
M=M+1 // address += 1

@LOOP_BEGIN
0; JMP

// End of the loop.
(LOOP_END)


// Infinite loop
@READ_KEYBOARD
0; JMP //if (true) goto for READ_KEYBOARD.

(END)
@END
M=0
