#This is a MIPS program to calculate the result
#of the series: 1+2+3+...+n, where n is the user input
	.text
main:
	# Print input prompt
	li	$v0,4		# syscall code 4 for printing a string
	la	$a0, in_prompt	# assign the prompt string to a0 for printing
	syscall
	# Read the value of n from user and save to t0
	li	$v0,5		# syscall code 5 for reading an integer from user to v0
	syscall	
	move	$t0,$v0		# assign the value of n to t0
	ble 	$t0, 0, exit_error # branch to exit
	# Initialize counter and total registers
	li	$t1, 0		# initialize counter register, t0
	li	$t2, 0		# initialize total register, t1
	# Main loop body
loop:	addi	$t1, $t1, 1	# increase the value of the counter
	add	$t2, $t2, $t1	# update the total
	beq	$t0, $t1, exit	# if the counter value is n, exit the loop
	j	loop
	# exit block for printing the output
exit:	li	$v0, 4		# syscall code 4 for printing the output string
	la	$a0, out_string
	syscall
	# Print total
	li	$v0, 1		# syscall code 4 for printing the integer total
	move	$a0, $t2	# Assign the total to a0 for printing
	syscall
	li	$v0,10		# syscall code 10 for terminate the execution of the program
	syscall
	
exit_error: 
	li	$v0,4		# syscall code 4 for printing a string
	la	$a0, error_string	# assign the prompt string to a0 for printing
	syscall
	li	$v0,10		# syscall code 10 for terminate the execution of the program
	syscall
	
	

	.data
in_prompt:	.asciiz	"Enter the value of n: "
out_string:	.asciiz	"Total = "
error_string:	.asciiz "The value of n must be greater than or equal to 1"