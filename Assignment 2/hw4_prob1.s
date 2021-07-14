#### Demetra Drizis ####
.text
main:

#prompt the user to enter base
li $v0, 4
la $a0, prompt1
syscall

#get base from user input, store in $t0
li $v0, 5
syscall
move $t0, $v0

#prompt the user to enter the number in the given base
li $v0, 4
la $a0, prompt2
syscall
li $v0, 1
move $a0, $t0
syscall
li $v0, 4
la $a0, colon
syscall

#get the string input for the number in base
li $v0, 8
la $a0, str
li $a1, 50
syscall

#pass the base in a0 and address input string in a1 and call the function convert
move $a0, $t0
la $a1, str
jal convert

move $t1, $v0   #store the return value i.e. decimal value from v0 into t1

#display the message and the decimal number stored in t1
li $v0, 4
la $a0, msg1
syscall
li $v0, 1
move $a0, $t1
syscall

#exit
li $v0, 10
syscall


#Fuction accepts base in $a0 and address of input string in $a1
#The function converts the input string which is a number in given base into a decimal value
#the decimal value is returned in $v0


convert:
#starting from beginning go till end of string i.e till newline or null terminator is reached
move $t0, $a1

check_byte:
lb $t1, ($t0)
beq $t1, 0, reached_end
beq $t1, 10, reached_end
addi $t0, $t0, 1
j check_byte

reached_end:
#now t1 is pointing to end of string
sub $t0, $t0, 1 #point to the last character
li $t2, 1 #the current power of the base
li $t3, 0 #the decimal number

loop1:
blt $t0, $a1, end_loop1
lb $t1, ($t0)
#get numeric value depending on if its a digit or letter
bge $t1, 'a', letter
#it is a digit since it is not a letter
sub $t1, $t1, '0'   #subtract ascii value of '0'
j add_term

letter:
sub $t1, $t1, 'a'   #subtract ascii value of 'a' to map a-z to 10-35
addi $t1, $t1, 10


add_term:
mul $t4, $t1, $t2   #mulitply the digit with power of base
add $t3, $t3, $t4
mul $t2, $t2, $a0   #get the next power of base
sub $t0, $t0, 1     #go to previous location
j loop1
end_loop1:

#return the result in $v0
move $v0, $t3
jr $ra

.data
prompt1: .asciiz "Enter a base (between 2 and 36 in decimal): "
prompt2: .asciiz "Enter a number in base "
colon: .asciiz ": "
msg1: .asciiz "The value in decimal is: "
str: .space 50
