## Demetra Drizis ##
.text
.globl my_middle
	addi	$sp, $sp, -12
	sw	$s6, 0($sp)
	sw	$s0, 4($sp)
	sw	$s1, 8($sp)

my_middle:
    addi $s6, $a1, -1				#$s6 = N-1
    li $s0, 0						#i = 0
L1:
    li $s1, 0						#j = 0
L2:
    sll $t0, $s1, 2					#$t0 = j * 4
    add $t0, $t0, $a0				#$t0 is the address of $a0
    lw $t1, 0($t0)					#t1 = A[j]
    lw $t2, 4($t0)					#t2 = A[j+1]
    bgt $t2, $t1, L3				#if A[j] > A[j+1] goto L3
    sw $t1, 4($t0)					#swap
    sw $t2, 0($t0)					#swap
L3:
    addi $s1, $s1, 1				#j = j + 1
    sub $t7, $s6, $s0				#$t7 will get N - 1 - i
    bne $s1, $t7, L2				#if j != N-1-i, inner loop again
    addi $s0, $s0, 1				#i = i + 1
    bne $s0, $s6, L1				#if i != N-1, outer loop again

    andi $t5, $a1, 1				#check odd/even
    beq $t5, $zero, even
    bne $t5, $zero, odd

even:
    div $t6, $a1, 2 				#$t6 = number of elements in the array / 2
    sll $t7, $t6, 2					#$t7 = $t6 * 4
    addi $t8, $t7, 4				#$t8 = $t7 + 4
    add $t7, $t7, $a0 				#address of median number 1
    add $t8, $t8, $a0 				#address of median 2
    lw $v0, -4($t7)				    #$t9 = $a0[$t7]
    lw $v1, -4($t8)					#$t10 = $a0[$t8]
    #add $s0, $s0, $s1				#$a0[$t7] + $a0[$t8]
    #srl $v0, $s0, 1                 #$v0 = $t9 / 2
	lw	$s6, 0($sp)
	lw	$s0, 4($sp)
	lw	$s1, 8($sp)
	addi	$sp, $sp, 12
    jr $ra

odd:
    addi $t8, $a1, -1				#$t11 = number of elements in the arrary -1
    div $t8, $t8, 2					#$t11 = $t11 / 2
    addi $t8, $t8, 1				#$t11 = $t11 + 1
    sll $t9, $t8, 2					#$t12 = $t11 * 4
    add $t9, $t9, $a0               #$t12 = $a0[$t11]
    lw $v0, -4($t9) #$v0 = $a0[$t11]
    add $v1, $zero, $zero	
	lw	$s6, 0($sp)
	lw	$s0, 4($sp)
	lw	$s1, 8($sp)
	addi	$sp, $sp, 20
    jr $ra
