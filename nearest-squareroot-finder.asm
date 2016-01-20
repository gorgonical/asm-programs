# This program prompts the user for a double-precision float, and it computes the integer whose square is as close as possible to the given float.

.data
intro:		.asciiz "Welcome to the sort-of square-root finder!\nEnter the number you want to find the nearest integer square root of: "
result:		.asciiz "The result is: "
.text
li $v0, 4
la $a0, intro
syscall
li $v0, 7
syscall

jal squareroot

move $v0, $t0 # Save the result

li $v0, 4
la $a0, result
syscall
li $v0, 1
move $a0, $t0
syscall

li $v0, 10
syscall


# We know the float is currently in $f0
squareroot:
	li $t0, 0
sqrtmain:
	mul $t1, $t0, $t0
	mtc1 $t1, $f2
	cvt.d.w $f2, $f2
	c.eq.d 0, $f2, $f0
	bc1t 0, sqrteq
	c.lt.d 1, $f2, $f0
	bc1f 1, sqrtdone
	addi $t0, $t0, 1
	j sqrtmain
	
sqrtdone:
	subi $t0, $t0, 1
sqrteq:	
	move $v0, $t0
	
	jr $ra
