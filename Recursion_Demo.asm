.text
.globl main

main:
  # Read input
  li $v0, 4 # system call code to print a string
  la $a0, userPrompt # load address of the prompt
  syscall # print the prompt

  li $v0, 5 # system call code for read integer
  syscall # read integer into $v0

  # Call the RDemo function
  move $a0, $v0 # pass the input value as an argument
  jal RDemo # jump to the RDemo function

  # Exit program
  li $v0, 10
  syscall

RDemo:
  # temporary variable register
  addi $sp, $sp, -8 # decrement
  sw $ra, 4($sp) # save return address
  sw $a0, 0($sp) # save argument

  lw $t0, 0($sp) # load argument
  bge $t0, 1, else_statement # branch to else_statement if n >= 1


  lw $ra, 4($sp) # load return address
  lw $a0, 0($sp) # load argument
  addi $sp, $sp, 8 # increment
  jr $ra # jump to return

  else_statement:
    li $v0, 1 # system call code for print integer
    lw $a0, 0($sp) # load argument
    syscall # print n
    li $v0, 4
    la $a0, userOutput
    syscall #print space

    # Recursive call RDemo with n-1
    lw $t0, 0($sp) # load argument
    addi $t0, $t0, -1 # decrement n
    move $a0, $t0 # pass n-1 as an argument
    jal RDemo # call RDemo

    # Print n
    li $v0, 1 # system call code for print integer
    lw $a0, 0($sp) # load the argument
    syscall # print n
    li $v0, 4
    la $a0, userOutput
    syscall #print space

    # Return from the function
    lw $ra, 4($sp) # load return address
    lw $a0, 0($sp) # load argument
    addi $sp, $sp, 8 # increment
    jr $ra # jump to return
    
.data
userPrompt: .asciiz "Enter an integer: "
userOutput: .asciiz " "

