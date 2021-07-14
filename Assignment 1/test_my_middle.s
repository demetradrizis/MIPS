# Program to test if a median function works properly
# Written by Xiuwen Liu for CDA 3100 - Homework #3, problem #3
# Register usage
# $s7 - save $ra
# $s1 - used as a temporary register
# $a0 - for function parameter / syscall parameter
# $v0 - syscall number / function return value

.text
.globl main
main:
addu    $s7, $ra, $zero, # Save the ra
la	$a0, int_prompt
li	$v0, 4
syscall
li	$v0,  5
syscall
bgtz	$v0, positive
sub	$v0, $zero, $v0
bgtz    $v0, positive
li	$v0, 1
positive:
slti	$s1, $v0, 101	# is $v0 <= 100
bne	$s1, $zero, within_limit
li	$v0, 100
within_limit:
add	$s2, $v0, $zero  #sace the value to s2
add	$a1, $v0,  $zero #save the value to a1
la	$a0, array_a	 # the address of the array
jal	my_middle
add	$s1, $v0, $zero   # We save the result first
add	$s6, $v1, $zero
la	$a0, median_msg
li      $v0, 4
syscall
add	$a0, $s1, $zero	  # $a0 is the integer to be printed
li      $v0, 1		  # system call to print an integer
syscall			  # print int
la      $a0, whitesp
li      $v0, 4
syscall
add     $a0, $s6, $zero   # $a0 is the integer to be printed
li      $v0, 1            # system call to print an integer
syscall                   # print int

la	$a0, newline
li	$v0, 4
syscall

la	$s4, middle1
sll	$s3, $s2, 2
add	$s4, $s4, $s3
lw	$s4, -4($s4)
beq	$s4, $s1, Correct1
la	$a0, wrong_message
j	end_output
Correct1:
la      $s4, middle2
sll     $s3, $s2, 2
add     $s4, $s4, $s3
lw      $s4, -4($s4)
beq     $s4, $s6, Correct
la      $a0, wrong_message
j       end_output
Correct:
la	$a0, correct_message
end_output:
li      $v0, 4
syscall
la	$a0, newline1
li      $v0, 4
syscall

la	$s1, array_a
la      $s2, array_b
add     $s4, $zero, $zero
Copyloop:
lw	$s6, 0($s2)
sw	$s6,  0($s1)
addiu	$s1, $s1, 4
addiu	$s2, $s2, 4
addi	$s4, $s4, 1
slti	$s6, $s4, 100
bne	$s6, $zero, Copyloop
addu    $ra, $zero, $s7  #restore $ra since the function calles
#another function
jr      $ra
add	$zero, $zero, $zero
add	$zero, $zero, $zero
########## End of main function #########
.data
#Data segment starts here
median_msg:
.asciiz "The middle(s) from your function are "
newline:
.asciiz ".\n"
newline1:
.asciiz "\n"
whitesp:
.asciiz " "
int_prompt:
.asciiz "Please enter an integer: "
wrong_message:
.asciiz "Your middle(s) are incorrect."
correct_message:
.asciiz "Your middle(s) are correct."
array_a:
.align 2
.word 7, 16, 291, 272, 287, 113, 372, 378, 159, 259
.word 380, 190, 137, 236, 390, 200, 239, 14, 25, 32
.word 396, 338, 194, 143, 142, 11, 88, 284, 256, 76
.word 46, 181, 63, 247, 393, 36, 342, 51, 250, 126
.word 343, 261, 75, 244, 39, 241, 320, 180, 265, 215
.word 102, 17, 343, 134, 189, 5, 273, 217, 135, 186
.word 356, 45, 54, 148, 253, 337, 20, 154, 68, 315
.word 359, 80, 72, 161, 201, 103, 209, 122, 3, 266
.word 262, 28, 251, 149, 131, 66, 147, 123, 338, 71
.word 256, 17, 235, 3, 152, 60, 394, 128, 73, 193
.word -5, -4, -3, -2, -1
array_b:
.align 2
.word 7, 16, 291, 272, 287, 113, 372, 378, 159, 259
.word 380, 190, 137, 236, 390, 200, 239, 14, 25, 32
.word 396, 338, 194, 143, 142, 11, 88, 284, 256, 76
.word 46, 181, 63, 247, 393, 36, 342, 51, 250, 126
.word 343, 261, 75, 244, 39, 241, 320, 180, 265, 215
.word 102, 17, 343, 134, 189, 5, 273, 217, 135, 186
.word 356, 45, 54, 148, 253, 337, 20, 154, 68, 315
.word 359, 80, 72, 161, 201, 103, 209, 122, 3, 266
.word 262, 28, 251, 149, 131, 66, 147, 123, 338, 71
.word 256, 17, 235, 3, 152, 60, 394, 128, 73, 193
.word -5, -4, -3, -2, -1
middle1:
.word 7, 7, 16, 16, 272, 113, 272, 272, 272, 259
.word 272, 259, 259, 236, 259, 236, 239, 236, 236, 200
.word 236, 236, 236, 200, 200, 194, 194, 194, 200, 194
.word 194, 190, 190, 190, 194, 190, 194, 190, 194, 190
.word 194, 194, 194, 194, 194, 194, 200, 194, 200, 200
.word 200, 194, 200, 194, 194, 190, 194, 194, 194, 190
.word 194, 190, 190, 189, 190, 190, 190, 189, 189, 189
.word 190, 189, 189, 186, 189, 186, 189, 186, 186, 186
.word 189, 186, 189, 186, 186, 181, 181, 180, 181, 180
.word 181, 180, 181, 180, 180, 161, 180, 161, 161, 161
middle2:
.word 0, 16, 0, 272, 0, 272, 0, 287, 0, 272
.word 0, 272, 0, 259, 0, 259, 0, 239, 0, 236
.word 0, 239, 0, 236, 0, 200, 0, 200, 0, 200
.word 0, 194, 0, 194, 0, 194, 0, 194, 0, 194
.word 0, 200, 0, 200, 0, 200, 0, 200, 0, 215
.word 0, 200, 0, 200, 0, 194, 0, 200, 0, 194
.word 0, 194, 0, 190, 0, 194, 0, 190, 0, 190
.word 0, 190, 0, 189, 0, 189, 0, 189, 0, 189
.word 0, 189, 0, 189, 0, 186, 0, 181, 0, 181
.word 0, 181, 0, 181, 0, 180, 0, 180, 0, 180
