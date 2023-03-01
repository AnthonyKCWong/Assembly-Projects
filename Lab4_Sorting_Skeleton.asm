.data
### Declare myArray, an array of length 20 and initialize with 0. ###
myArray: .word 0:20

### Declare appropriate strings and the space character for I/O prompts ###
prompt1: .asciiz "How many integers? (maximum 20): "
prompt2: .asciiz "Enter the integers: "
output: .asciiz "Here is the sorted list: "
space: .asciiz " "

.text

main:
	li $v0, 4
	la $a0, prompt1
	syscall
	
	li $v0, 5
	syscall
	move $t2, $v0	# t2 = n value
	### call the procedure for reading the array ###
	jal read_array
	### Save the size of the array as returned in v0 from the read_array procedure to s0 ###
	move $s0, $v0
	### Assign appropriate values to a0 and a1 that will be the arguments for the sort procedure. ###
	### Check the description of the sort procedure ###
	la $a0, myArray
	move $a1, $s0

	### call the sort procedure ###
	jal sort
	### move s0 to a1. a1 will be used by the print_array procedure ###
	move $a1, $s0

	### call the print_array procedure ###
	jal print_array
	j exit

read_array:
	### Read value of n and then read n integers to myArray. Use appropriate input prompts ###
	li $v0, 4
	la $a0, prompt2
	syscall
	
	### you need to create a while loop ###
	### Use t registers for counters and array indices ###
	li $t0, 0	# t0 = counter
	la $t1, myArray	# t1 = address of myArray

	
while_loop:
	beq $t0, $t2, loop_exit

	li	$v0, 5
    	syscall
	
	sw $v0, 0($t1)
	addi $t0, $t0, 1
	addi $t1, $t1, 4

	j while_loop
	### the size of the array (n) will be saved to v0 before returning to main ####
loop_exit:
	move $v0, $t2
	jr $ra

sort:    # Two arguments: a0 for the starting address of the array; a1 is the number of integers
	addi $sp,$sp,-20      # make room on stack for 5 registers
        sw $ra, 16($sp)        # save $ra on stack
        sw $s3,12($sp)         # save $s3 on stack
        sw $s2, 8($sp)         # save $s2 on stack
        sw $s1, 4($sp)         # save $s1 on stack
	sw $s0, 0($sp)         # save $s0 on stack
        move $s2, $a0           # save $a0 into $s2
        move $s3, $a1           # save $a1 into $s3
        move $s0, $zero         # i = 0
for1tst: 
	slt  $t0, $s0, $s3      # $t0 = 0 if $s0 ≥ $s3 (i ≥ n)
        beq  $t0, $zero, exit1  # go to exit1 if $s0 ≥ $s3 (i ≥ n)
        addi $s1, $s0,-1       # j = i – 1
for2tst:
	slti $t0, $s1, 0        # $t0 = 1 if $s1 < 0 (j < 0)
        bne  $t0, $zero, exit2  # go to exit2 if $s1 < 0 (j < 0)
        sll  $t1, $s1, 2        # $t1 = j * 4
        add  $t2, $s2, $t1      # $t2 = v + (j * 4)
        lw   $t3, 0($t2)        # $t3 = v[j]
        lw   $t4, 4($t2)        # $t4 = v[j + 1]
        slt  $t0, $t4, $t3      # $t0 = 0 if $t4 ≥ $t3
        beq  $t0, $zero, exit2  # go to exit2 if $t4 ≥ $t3
        move $a0, $s2           # 1st param of swap is v (old $a0)
        move $a1, $s1           # 2nd param of swap is j
        jal  swap               # call swap procedure
        addi $s1, $s1,-1      # j –= 1
        j    for2tst            # jump to test of inner loop
exit2:  
	addi $s0, $s0, 1        # i += 1
        j    for1tst            # jump to test of outer loop
exit1: 
	lw $s0, 0($sp)  # restore $s0 from stack
        lw $s1, 4($sp)         # restore $s1 from stack
        lw $s2, 8($sp)         # restore $s2 from stack
        lw $s3,12($sp)         # restore $s3 from stack
        lw $ra,16($sp)         # restore $ra from stack
        addi $sp,$sp, 20       # restore stack pointer
        jr $ra                 # return to calling routine
swap: 
	sll $t1, $a1, 2   # $t1 = k * 4
      	add $t1, $a0, $t1 # $t1 = v+(k*4) (address of v[k])
	lw $t0, 0($t1)    # $t0 (temp) = v[k]
	lw $t2, 4($t1)    # $t2 = v[k+1]
        sw $t2, 0($t1)    # v[k] = $t2 (v[k+1])
        sw $t0, 4($t1)    # v[k+1] = $t0 (temp)
        jr $ra            # return to calling routine


print_array:
	li $v0, 4
	la $a0, output
	syscall
	
	### print the sorted array, myArray. The size of the array will be in a1. Use appropriate output text. ###
	
	### you need to create a while loop ###
	### Use t registers for counters and array indices ###
	li $t0, 0	# t0 = counter
	la $t1, myArray	# t1 = address of myArray
	
print_loop:
	beq $t0, $a1, print_exit

	lw $a0, 0($t1)	
    	li $v0, 1
    	syscall
	la 	$a0, space     	
    	li 	$v0, 4		
    	syscall
	addi $t0, $t0, 1
	addi $t1, $t1, 4

	j print_loop

print_exit:
	jr $ra
exit:
	li $v0, 10
	syscall
