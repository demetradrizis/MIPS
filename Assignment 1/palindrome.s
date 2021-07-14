## Demetra Drizis ##
.text
.globl palindrome


strlen:
# arguments:
# a0 = string

li      $v0,    0                           #set return value to 0
strlen_loop:
lb      $t0,    0($a0)                      #load byte from beginning of the string
beq     $t0,    $0,     strlen_exit         #when character value is 0 we have
#reached the end of the string
addi    $a0,    $a0,    1                   #shift pointer to string one space right
addi    $v0,    $v0,    1                   #increment return value by one
j       strlen_loop

strlen_exit:
# returns:
# INTEGER (string length)
jr      $ra                                 #return

palindrome:
# arguments:
# a0 = string
sub     $sp,    $sp,    8                   #allocate memory on stack
sw      $ra     0($sp)                      #save return address
sw      $a0     4($sp)                      #save argumrnt value

jal     strlen                              #call strlen
move    $t0,    $v0                         #save result

lw      $a0     4($sp)                      #load argument
move    $t1,    $a0                         #save its value to t1

li      $t2,    1                           #set counter to 1
li      $v0,    1                           #prepare return value
div     $t3,    $t0,    2                   #calculate string length / 2
addi    $t3,    $t3,    1                   #add one more in case of even number
palindrome_loop:
bge     $t2,    $t3     palindrome_exit      #when counter reaches half of the string length - exit
lb      $t4,    0($a0)                      #get character from beginning

sub     $t5,    $t0,    $t2                 #subtract counter from the string length
add     $t6,    $t5,    $t1                 #add index from the end of the string to start address
lb      $t7,    0($t6)                      #get corresponding character from the end of the string

beq     $t4,    $t7, palindrome_continue    #check to determine are the characters exact match

upper:
slti    $t8, $t4, 91
beq     $t8, $zero, lower
add     $t4, $t4, 32                         #adds 32 to the character value to lowercase it
beq     $t4,    $t7, palindrome_continue    #check to determine are the characters exact match


lower:
add     $t4, $t4, -32                           #subtracts 32 from the character value to capitalize it
beq     $t4,    $t7, palindrome_continue    #check to determine are the characters exact match
li      $v0,    0                           #if not return 0, immediately
j       palindrome_exit


palindrome_continue:
addi    $a0,    $a0,    1                   #shift pointer to string one space right
addi    $t2,    $t2,    1                   #increment counter by one
j       palindrome_loop

palindrome_exit:
# returns:
# TRUE (1) or FALSE (0)
lw      $ra     0($sp)                      #load return address
addi    $sp,    $sp,    8                   #free stack
jr      $ra                                 #return
