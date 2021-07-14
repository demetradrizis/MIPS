## Demetra Drizis ##
.text
.globl set

set:
    addi    $t0, $a1, -1        #i = n-1

loop:
    blt     $t0, 0, end         #if n-1 < 0, go to end
    sll     $t1, $t0, 2         #shift 2 left
    add     $t1, $a0, $t1       #add a to $t1
    sw      $a2, 0($t1)         #store a[i] into v
    addi    $t0, $t0, -1        #i--
    j       loop

end:
    move    $v0, $t0            #move $t0 into $v0
    jr      $ra                 #return address 
