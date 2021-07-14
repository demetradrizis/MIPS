## Demetra Drizis ##
.globl my_fib
.text

my_fib:
    addi    $sp, $sp, -12       # allocate stack frame of 12 bytes
    sw      $ra, 4($sp)         # save return address
    sw      $a0, 0($sp)         # save n
    sw      $s0, 8($sp)         # save $s0

    slti    $t0, $a0, 2         # fib(i) = i for i = 0, 1
    beq     $t0, $0, else
    addi    $v0, $a0, 2         # $v0 = 2 or 3
    j       exit1               # go to exit

else:
    addi    $a0, $a0, -1        # fib(n-1)
    jal     my_fib              # recursive call
    move    $s0, $v0
    lw      $a0, 0($sp)
    addi    $a0, $a0, -2        # fib(n-2)
    jal     my_fib              # recursive call
    add     $v0, $s0, $v0
    lw      $ra, 4($sp)         # restore return address
    lw      $s0, 8($sp)
    addi    $sp, $sp, 12        # free stack frame

    jr      $ra

exit1:
    addi    $sp, $sp, 12        # free stack frame
    jr      $ra                 # return to caller
