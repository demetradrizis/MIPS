#### Demetra Drizis ####

# Program to read the header of a valid pgm file
# Written by Xiuwen Liu for CDA 3100 - Homework #4, problem #2
# Register usage
#  You need to figure that out

.text
.globl main
main:
addu     $s7, $ra, $zero, # Save the ra

la	$a0, file_prompt  #print out the prompt for file name
li	$v0, 4		  #system call print_str
syscall

la	$a0, file_name	 #read in the file name
addi	$a1, $zero, 256  #using systecall read_str
li	$v0,  8 #We read the file name
syscall

#Note that the string includes 10 ('\n') at the  end
#We need to get rid of that first
la	$t1, file_name #Address of the file name string
addi	$t2, $zero, 10
length_loop: # of the string:
lb      $t0, 0($t1)    # load the byte at addr B into $t0.
beq	$t0, $t2, end_length_loop # if $t3 == 10, branch out of loop.
addu	$t1, $t1, 1
b       length_loop             # and repeat the loop.
end_length_loop:

sb	$zero, 0($t1)		#We change '\n' to 0
la	$a0,  file_name		#Show the file name
li	$v0, 4
syscall

la	$a0, newline		#Display a new line
li	$v0, 4
syscall

la	$a0, row_prompt
li	$v0, 4
syscall

addi	$v0, $zero, 5			# We need to read an integer
syscall
add	$s1, $v0, $zero		# We save the number of rows to s1

la	$a0, column_prompt
li	$v0, 4
syscall

addi	$v0, $zero, 5			# We need to read an integer
syscall
add	$s2, $v0, $zero		# We save the number of columns to s2

# We allocate enough space and save the addres to image
#addi	$v0, 9
#li	$a0, 1000000
#syscall
#la	$a0, image
#sw	$v0, 0($a0)

# image *read_image(char *filename, int nrow, int ncol)
#prepare parameters for the arguments
la	$a0,  file_name  #The first argument
add	$a1,  $s1, $zero #The second argument
add	$a2,  $s2, $zero #The third argument
jal	read_image

#We save the returned values
add	$s3, $v0, $zero		# We save the address of the array
beq	$v0, $zero, End_main	# If the address is zero, something is wrong

#Call your function to compute histogram
# int histogram(unsigned char *image, int nrow, int ncol, int *h)
add	$a0, $s3, $zero 	#The first argument
add	$a1,  $s1, $zero 	#The second argument
add	$a2,  $s2, $zero 	#The third argument
la	$a3,  hist_array
jal	histogram


#Call your function to print the histogram
# void print_hist(int *h)
la	$a0, hist_array
jal	print_hist

End_main:
addu    $ra, $zero, $s7  #restore $ra since the function calles
#another function
jr      $ra
add	$zero, $zero, $zero
add	$zero, $zero, $zero

########## End of main function #########
.data
#Data segment starts here
file_prompt:
.asciiz "Please enter a valid file name: "
newline:
.asciiz ".\n"
file_name:
.space	256
row_prompt:
.asciiz "Number of rows: "
column_prompt:
.asciiz "Number of columns: "
add_msg:
.asciiz "Image address:	"
.align 2
hist_array:
.word	0:256			# We define 256 words for the histogram

###### unsignched char *read_image(char *fname, int nrow, int ncol)
##### $a0 (fname): The name of the pgm file name
##### $a1 (nrow): The number of rows
##### $a2 (ncol): The number of columns in the image
##### $v0:	   memory address of the image
.text
.globl read_image
read_image:
addu	$sp, $sp, -28	#We allocate three words
sw	$a0, 4($sp)
sw	$a1, 8($sp)
sw	$a2, 12($sp)
sw	$ra, 16($sp)

add	$a1, $zero, $zero #O_RDONLY is 0
add	$a2, $zero, $zero #This parameter does not really matter
li	$v0, 13		#System call open
syscall

add	$t1, $v0, $zero
slt	$t9, $zero, $t1	 #if $t1 < 0, the file is invalid
beq	$t9, $zero, file_invalid

sw	$v0, 0($sp)	#This is the file descriptor
#Here the file is opened
# Read the values to
lw	$a0, 0($sp)	#File descriptor
la	$a1, image
sw	$a1, 20($sp)	# We save the address to the stack
lw	$a2, 12($sp)
lw	$t1, 8($sp)
mul	$a2, $a2, $t1	# nrow x ncol = total number of pixels
sw	$a2, 24($sp)

li	$v0, 14
syscall
#The first pixel value
la	$a0, first_value_msg
li	$v0, 4
syscall

lw	$a1, 20($sp)
lbu	$a0, 0($a1)
li	$v0, 1
syscall

la	$a0, newline
li	$v0, 4
syscall
#The last pixel value
la	$a0, last_value_msg
li	$v0, 4
syscall

lw	$a1, 20($sp)
lw	$a2, 24($sp)
addu	$a1, $a1, $a2
lbu	$a0, -1($a1)
li	$v0, 1
syscall

la	$a0, newline
li	$v0, 4
syscall

lw	$a0, 0($sp)	#File descriptor
li	$v0, 16		#System call close
syscall

lw	$v0, 20($sp)	#Restore the return address
j	return_main


file_invalid:
addi	$v0, $zero, 4
la	$a0, invalid_file_msg
syscall

add	$v0, $zero, $zero
return_main:
lw	$ra, 16($sp)
addu	$sp, $sp, 28	#We restore the stack pointer

jr 	$ra
add	$zero, $zero, $zero
add	$zero, $zero, $zero

.data
invalid_file_msg:
.asciiz	"Can not open the file for reading.\n"
first_value_msg:
.asciiz "First pixel value: "
last_value_msg:
.asciiz	"Last pixel value: "

.text
# void print_hist(int *h)
# Print out the 256 counts in the array (the histogram)
.globl	print_hist
print_hist:
jr	$ra

.data
colon:
.asciiz	": "

.text
.globl histogram

# int histogram(unsigned char *image, int nrow, int ncol, int *h)
# Compute the histogram of the image and save the results in h


#### Function by: Demetra Drizis ####

histogram:
add $t0, $zero, $zero	#i
la $t1, hist

add $t2, $zero, $zero
loop:				#this creates an empty histogram
bge $t0, 256, clean
sll $t2, $t0, 2
add $t2, $t1, $t2	#add histogram[0] + index
sw $zero, ($t2)		#store zero
add $t0, $t0, 1		#add 1 to counter
j loop

lw $a0, 0($t2)		#used for data checking to print out
li $v0, 1		#empty histogram
syscall

la $a0, aspace
li $v0, 4
syscall
j loop
clean:
la $a0, newline	#used for printing empty histogram
li $v0, 4
syscall

add $t6, $zero, $zero
add $t3, $zero, $zero	#i
mul $t4, $s1, $s2	#rows*columns
add $t5, $s3, $zero	#p
add $t8, $zero, $zero

fill_h:				#this fills the histogram with pixel
bge $t3, $t4, done	#counters

lbu $t6, 0($t5)		#load byte from image
sll $t6, $t6, 2		#convert to int

la $t7, hist		#load base addres hist
add $t6, $t6, $t7	# go t hist[p]

lw $t7, 0($t6)		#load the int
addi $t7, $t7, 1	#increment the int
sw $t7, 0($t6)		#store the int

add $t8,$t8, 1

addiu $t5, $t5, 1 	#move to next byte

add $t3, $t3, 1
j fill_h
done:

printhist:
add $t2, $zero, $zero
add $t0, $zero $zero
la $t1 hist
ploop:				#this prints complete histogram
bge $t0, 256, pf
move  $a0, $t0
li $v0, 1
syscall
li $v0,4
la $a0, colons
syscall

sll $t2, $t0, 2
add $t2, $t1, $t2	#add histogram[0] + index
add $t0, $t0, 1		#add 1 to counter
#j loop

lw $a0, 0($t2)
li $v0, 1
syscall

la $a0, aspace          # prints space
li $v0, 4
syscall
li $v0,4
la $a0, newline         #prints new line
syscall

j ploop
pf:
li $v0,4
la $a0, newline
syscall

jr $ra

add $t1, $zero, $zero	#k
.data
.align  2
hist:
.space 1024
aspace:
.asciiz " "
colons:
.asciiz ": "

.data
.align 2
image:	.space  250000
