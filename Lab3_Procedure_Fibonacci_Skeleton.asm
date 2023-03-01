#This is a MIPS program to print first n numbers fo the fibonacci sequence. n will be user input. 
#As the first two number of the sequence are given (0 and 1), n must be >=3
#Two restrictions: 
#$s0 must store the value of n in the main program. 
#$s0 must also be used as the register for storing the temporary/local result of the addition in the procedure

	.text
main:
	# Print input prompt
	li	$v0,4		# syscall code = 4 for printing a string
	la	$a0, in_prompt	# assign the prompt string to a0 for printing
	syscall
	# Read the value of n from user and save to t0
	li	$v0,5		# syscall code = 5 for reading an integer from user to v0
	syscall	

### Set s0 with the user input & if invalid (<=2) jumpt to exit_error ###	
	move 	$s0, $v0
	ble 	$s0,2,exit_error 
### Set proper argument register and call the procedure print_numnber to show the first two numbers of the sequence (0 & 1)###
	li $a0, 0
	jal print_number
	li $a0, 1
	jal print_number

	li $t0, 2		# initialize counter register t0
	
### Load the first two numbers (0 & 1) to s1 & s2 ###	
	li $s1, 0
	li $s2, 1


loop:

### set the argument registers (a0 and a1) to the last two values in the sequence for addition, and then call proedure add_two###
	move $a0, $s1
	move $a1, $s2
	jal add_two
	move $s1, $s2		# s1 now stores the last value in the sequence
	move $s2, $v0		# s2 now new value as returned from the addition procedure
	move $a0, $v0		# update a0 for printing the returned value
	jal print_number

### Increment the counter and compare it with user input. If equal, jumpt to exit.###
	
	addi $t0, $t0, 1
	beq $t0, $s0, exit
	j loop			# Go to the start of the loop

add_two:

### Push the value of s0 in the stack ###

	addi $sp, $sp, -4
	sw $s0,0($sp)
	add $s0, $a0, $a1	# s0 now holds the result of the addition
	
### Set the register that will hold the reutrn value	with the result of the addition ###
	
	move $v0, $s0
	lw $s0, 0($sp)

### Pop the value of s0 from the stack ###
	addi $sp, $sp, 4
	jr $ra			# return to the caller
			# segement for printing an integer
print_number:	

### Write the syscall code for printing the integer ###

	li	$v0, 1
	syscall

	# syscall for printing a space character
	li	$v0,4		
	la	$a0, space	
	syscall
	jr $ra 		#return to the caller
	
	# exit block for wrong value of the input 
exit_error:
	li	$v0, 4		# syscall code = 4 for printing the error message
	la	$a0, error_string
	syscall
	li	$v0,10		# syscall code = 10 for terminate the execution of the program
	syscall
	# exit block for the program 
exit:
	li	$v0,10		# syscall code = 10 for terminate the execution of the program
	syscall
	
	.data
in_prompt:	.asciiz	"how many numbers in the sequence you want to see (must be at least 3): "
error_string:	.asciiz "The number ust be greater than or equal to 3"
space:		.asciiz " "
