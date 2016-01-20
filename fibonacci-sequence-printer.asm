# This program prompts the user for an integer, and then prints out the fibonacci sequence from 0 to that number's length.

# fibonacci.asm
# Input: None
# Output: Print to terminal N Fibonacci numbers

	

.data

fibs:	.word   0 : 9         # create an array variable named "fibs" of 9 word-length elements (4 bytes each)
#	size:	.word             # create a single integer variable named "size" that indicates the length of the array
prompt: .asciiz "Enter the size of the array to print: "

.text
	      la	$s0, fibs        	# load address of array into $s0
	      
input:      li 	$v0, 4		# prep the system to print string
		la	$a0, prompt		# load the input prompt into memory
	      syscall			# print the prompt
	      
	      li	$v0, 5		# prep the system to read variable
	      syscall
	      
	      add	$s5, $s5, $v0	# move the entered variable into a register
	      bltz 	$s5, input		# branch to input if 0 or a negative is entered
	      bgt	$s5, 9, input	# branch to input if the input is greater than 9, the specified max size
	      
#     	la   	$s5, size       	# load address of size variable into $s5	##these lines are no longer needed, since we prompt for size
#	      lw   	$s5, 0($s5)     	# load array size from its address in the register

	      li   $s2, 1           # Initialize the Fibonacci numbers with value 1, stored in $s2
	      sw   $s2, 0($s0)      # Set fibs[0] to 1
	      sw   $s2, 4($s0)      # Set fibs[1] to 1
	      addi $s1, $s5, -2     # Counter for loop, will execute (size-2) times
	      
	      # Loop to compute each Fibonacci number using the previous two Fib. numbers.
	      # On line 37, "loop" is a label
loop:	 lw   $s3, 0($s0)      # Get value from array fibs[i-2]
	      lw   $s4, 4($s0)      # Get value from array fibs[i-1]
	      add  $s2, $s3, $s4    # fibs[i] = fibs[i-1] + fibs[i-2]
	      sw   $s2, 8($s0)      # Store newly computed fibs[i] in array
	      addi $s0, $s0, 4      # increment address for next fibonacci entry
	      addi $s1, $s1, -1     # decrement loop counter
	      bgtz $s1, loop        # repeat while not finished

	      # Now the Fibonacci numbers are computed and stored in array. Print them.
	      la   $a0, fibs        # first argument for print (array)
	      add  $a1, $zero, $s5  # second argument for print (size)
	      jal  print            # call print routine (note the 'print' label on line 68)

	      # The program is finished. Exit.
	      li   $v0, 10          # system call for exit
	      syscall               

	###############################################################
	# Subroutine to print the numbers on one line. Another .data segment.
	###########################################################
	      .data
	      
space:	.asciiz  " "          				# Print a space between each pair of numbers
head:	 .asciiz  "The Fibonacci numbers are:\n" 	# Print a little helpful intro

###########################################################
# Another .text segment, for printing
###########################################################

	      .text
	      
print:	add  $t0, $zero, $a0  # starting address of array of data to be printed
	      add  $t1, $zero, $a1  # initialize loop counter to array size
	      la   $a0, head        # load address of the print heading string
	      li   $v0, 4           # specify that you're printing a string
	      syscall               # print the heading string

out:	  lw   $a0, 0($t0)      # load the integer to be printed (the current Fib. number)
	      li   $v0, 1           # specify that you're printing an integer
	      syscall               # print fibonacci number

	      la   $a0, space       # load address of spacer for syscall
	      li   $v0, 4           # specify Print String service
	      syscall               # print the spacer string

	      addi $t0, $t0, 4      # increment address of data to be printed
	      addi $t1, $t1, -1     # decrement loop counter
	      bgtz $t1, out         # repeat while not finished

	      jr   $ra              # return from subroutine
	# End of subroutine to print the numbers on one line
	###############################################################
