	# This program computes x^k, where x is a single-precision, floating-point number, and k is an integer.
	# The program has user-interactivity, by prompting the user for their numbers. It does not loop.

	.data
prompt:		.asciiz "This program computes x^k.\n"
xprompt:	.asciiz "Please enter x, in the form of a float: "
kprompt:	.asciiz "Please enter k, in the form of an int: "
exit:		.asciiz "The result is: "
newline:	.asciiz "\n"

.text

li $v0, 4
la $a0, prompt
syscall

li $v0, 4
la $a0, xprompt
syscall

# No need to save the base, because the 'read float' service stores the read-in float in $f0

li $v0, 6
syscall

li $v0, 4
la $a0, kprompt
syscall

li $v0, 5
syscall

# Save the exponent
move $s1, $v0

add.s $f6, $f0, $f12

loop:
	beq $s1, 1, done
	mul.s $f0, $f0, $f6
	subi $s1, $s1, 1
	j loop
done:
	li $v0, 4
	la $a0, exit
	syscall
	
	li $v0, 2
	add.s $f12, $f0, $f4
	syscall
	
	li $v0, 10
	syscall
