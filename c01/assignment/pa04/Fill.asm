// Pseudo-code:
// 	out=0
// 	while (out == 0) {
// 		if (RAM[KBD] == 0x0) {
// 			// No key was pressed, so clear the screen.
// 			fillvalue=0000000000000000;
// 		} else {
// 			fillvalue=1111111111111111;
// 		}
//
// 		for (row=0; row < maxrow; ++row) {
//			address = SCREEN
// 			for (column=0; column < maxcolumn; ++column) {
// 				set_ram_region(address, fillvalue)
// 				adress= address + column
// 			}
//			address = address + 32
// 		}
// 	}
// 

@out
M=0		// out=0

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
//// Update the screen
//// We will use fillvalue to fill all registers in the screen 
//// memory map.
//
//// For the exercise we can treat this as a single rowar loop, as we will
//// know that we will fill *all the screen* with the same pattern.
//// But just for exercise let's split between going trough all rows and columns.


//// Initialization of for(row=0; row < maxrow; row++)
@row
M=0 // row=0

@column
M=0 // column=0

// Define the max row number (counting starts from 0).
@255
D=A
@maxrow
M=D // maxrow=255

// Define the max column group number (counting starts from 0).
@31
D=A
@maxcolumn
M=D // maxcolumn=31

@SCREEN
D=A
@rowaddress
M=D	// rowaddress = screen base rowaddress


(ROWLOOP_BEGIN)
@row
D=M
@maxrow
D=D-M // D=row - maxrow

@ROWLOOP_END
D; JGT // if (row >= maxrow) go out of the loop.

// Start of the column loop inside.
@column
M=0 // column=0

// Start of the column loop.
(COLUMNLOOP_BEGIN)
// Check if column < maxcolumn
@column
D=M;
@maxcolumn
D=D-M
@COLUMNLOOP_END
D; JGT

// Compute the columnaddress
@column
D=M
@rowaddress
D=D+M
@columnaddress
M=D


// Let's white to the screen
// Get the value to be written to

@fillvalue
D=M

//// Change the bits in SCREEN memory mapping.
@columnaddress
A=M
M=D

// Increment column
@column
M=M+1 // column = column + 1

// LOOP
@COLUMNLOOP_BEGIN
0; JMP

// End of the column loop.
(COLUMNLOOP_END)

// Increment rowaddress by 32 registers.
@32
D=A
@rowaddress
M=D+M // rowaddress = rowaddress + 32

@row
M=M+1

@ROWLOOP_BEGIN
0;JMP
// End of row loop inside.
(ROWLOOP_END)


// Infinite loop
@out
D=M
@READ_KEYBOARD
M; JEQ //if (out == 0) goto for READ_KEYBOARD.

(END)
@END
M=0
