
# Program to test if a fib function works properly
# Written by Xiuwen Liu for CDA 3100 - Homework #3, problem #4
# Register usage
# $s7 - save $ra
# $s1 - s6 - used as a temporary register
# $a0 - for function parameter / syscall parameter
# $v0 - syscall number / function return value

.text
.globl main

main:
addu    $s7, $ra, $zero, # Save the ra
la	$a0, int_prompt	 # Display the prompt
li	$v0, 4
syscall

li	$v0,  5		 # Read an integer from the user
syscall
bgtz	$v0, positive	 # If the number is not positive,
# we negate the number.
sub	$v0, $zero, $v0
positive:
slti	$s1, $v0, 1001	# is $v0 <= 1000
bne	$s1, $zero, within_limit
li	$v0, 1000
within_limit:
add	$s2, $v0,  $zero #save the value to s2 for later use
add	$a0, $v0,  $zero #save the value to a0
jal	my_fib

add	$s1, $v0, $zero   # We save the result first

la	$a0, fib_msg
li      $v0, 4
syscall
add	$a0, $s1, $zero	  # $a0 is the integer to be printed
li      $v0, 1		  # system call to print an integer
syscall			  # print int
la	$a0, newline
li	$v0, 4
syscall

la	$t1, array_fib	  # $t1 is the address of the array we save to
addi	$s3, $zero, 2
sw	$s3, 0($t1)
addi	$s4, $zero, 3
sw	$s4, 4($t1)
add	$s5, $zero, $zero
fib_loop:
slti	$s6, $s5, 501
beq	$s6, $zero, fib_loop_done
addiu	$t1, $t1, 8
addu	$s3, $s3, $s4
sw	$s3, 0($t1)
addu	$s4, $s3, $s4
sw	$s4, 4($t1)
addi	$s5, $s5, 1
j	fib_loop
fib_loop_done:
la	$s4, array_fib
sll	$s2, $s2, 2
add	$s4, $s4, $s2
lw	$s4, 0($s4)
beq     $s4, $s1, Correct
la      $a0, wrong_message
j       End_output
Correct:
la      $a0, correct_message
End_output:
li      $v0, 4
syscall

la      $a0, newline
li      $v0, 4
syscall



addu    $ra, $zero, $s7  #restore $ra since the function calles
#another function
jr      $ra
add	$zero, $zero, $zero
add	$zero, $zero, $zero


########## End of main function #########
.data
#Data segment starts here
fib_msg:
.asciiz "The result from your fib function is "
newline:
.asciiz ".\n"
int_prompt:
.asciiz "Please enter an integer (between 0 and 1000, overflow happens when larger than 46): "
wrong_message:
.asciiz "Your result is incorrect"
correct_message:
.asciiz "Your result is correct"

array_fib:
.align 2
.space 4096
