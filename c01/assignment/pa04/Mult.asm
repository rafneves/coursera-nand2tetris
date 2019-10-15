// Multiplies R0 and R1 and stores the result in R2.
// (R0, R1, R2 refer to RAM[0], RAM[1], and RAM[2], respectively.)

// As there is not easy way of acessing individual bits, we will 
// use the fact that both numbers are integers and just use the
// definition of multiplication: a*b = b + b + b + ... + b (a times).


A=0
D=M
@R0
M=D // R0 = RAM[0]

A=1
D=M
@R1
M=D // R1 = RAM[1]

@partial // partial sum
M=0

// Corner cases R0 = 0 or R1 = 0
@R0
D=M
@MULTIPLICATION_LOOP_END
D; JEQ

@R1
D=M
@MULTIPLICATION_LOOP_END
D; JEQ

// If R0 is negative, transfer the sign to the R1.
// Note that if a is negative: 
//    a*b = -abs(a)*b = abs(a)*(-b)
@R0
D=M
@MULTIPLICATION_LOOP_INITIALIZATION
D;JGT

// Switch the sign between R0 and R1.
// So we don't need to bother if we should
// increment the counter or decrement it.

D=0
D=!D		// D = 1111111111111111

@R0
M=!M
M=M+1		// R0 = -R0 (now it is positive)

@R1
M=!M		// R1 = -R1
M=M+1

(MULTIPLICATION_LOOP_INITIALIZATION)
// Initialization of multiplication loop.
@i // how much time we summed the R1 value
M=1

(MULTIPLICATION_LOOP_BEGIN)
// Check if already multiplied R1 times
@i
D=M
@R0
D=D-M
@MULTIPLICATION_LOOP_END
D;JGT

// Update the sum
@R1
D=M
@partial
M=D+M // partial += R0

@i
M=M+1

@MULTIPLICATION_LOOP_BEGIN
0; JMP


(MULTIPLICATION_LOOP_END)

// Put the result in RAM[3]
@partial
D=M
@2
M=D

// Infinite loop
@0
0; JMP

