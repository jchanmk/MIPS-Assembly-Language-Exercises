	        .data
fact:           .word   1, 1, 2, 6, 24, 120
recip:          .float  1.0, 0.5, 0.25, 0.125, 0.0625, 0.03125, 0.015625, 0.0078125
x:              .float  3.141592
zeros:          .float  0.0
                .align  3
zerod:          .double 0.0
                .align  3
oned:           .double 1.0
factsize:       .word   6
recipsize:      .word   8
fibarraysize:   .word   160
fibarray:       .space  40
harmonic:       .space  8192
harmonicsize:   .word   1024

sum_comment:    .asciiz "The sum of all these reciprocals is:   "
line_of_stars:  .asciiz "\n* * * * * * * * * * * * * * * * * * *\n"
new_line:       .asciiz "\n"

# Main body
	        .text
main:
        lw      $t0, fact     # array address
        lw      $t1, factsize # size (number of elements) of array
        li      $t2, 4        # jump in array index offset
        li      $t3, 0        # incrementing array index offset

loop_fact:   
        li      $v0, 1
	lw      $a0, fact($t3)
	syscall
       	li      $v0, 4
       	la      $a0, new_line
	syscall
	
	add  $t3, $t3, $t2
	mul  $t0, $t1, $t2
	bgt  $t0, $t3, loop_fact

       	li    $v0, 4
       	la    $a0, line_of_stars
	syscall

#################################################

        lw      $t0, recip      # array address
        lw      $t1, recipsize  # size (number of elements) of array
        li      $t2, 4          # jump in array index offset
        li      $t3, 0          # incrementing array index offset
        l.s     $f1, zeros      # sum
        l.s     $f2, zeros      # sum

loop_recip:
        li      $v0, 2
        l.s     $f1, recip($t3)
        add.s   $f2, $f2, $f1
        mov.s   $f12, $f1
        syscall
       	li      $v0, 4
       	la      $a0, new_line
	syscall
	
	add  $t3, $t3, $t2
	mul  $t0, $t1, $t2
	bgt  $t0, $t3, loop_recip
	
       	li    $v0, 4
       	la    $a0, sum_comment
	syscall
	li      $v0, 2
        mov.s     $f12, $f2
        syscall
       	li      $v0, 4
       	la      $a0, new_line
	syscall

       	li    $v0, 4
       	la    $a0, line_of_stars
	syscall

################################################

        lw      $t0, fibarray     # array address
        lw      $t1, fibarraysize # size (number of elements) of array
        li      $t2, 4            # jump in array index offset
        li      $t3, 0            # counter
        li      $t4, 1            # fib_previous
        li      $t5, 1            # fib_current
        
        sw      $t4, fibarray($t3)
        add     $t3, $t3, $t2
        sw      $t5, fibarray($t3)
        add     $t3, $t3, $t2
loop_fib: 
        add     $t6, $t4, $t5
        sw      $t6, fibarray($t3)
        add     $t3, $t3, $t2
        move    $t4, $t5
        move    $t5, $t6
        bgt     $t1, $t3, loop_fib
        
        li      $t3, 0
        
loop_fib_2:
        li      $v0, 1
	lw      $a0, fibarray($t3)
	syscall
	add     $t3, $t3, $t2
       	li      $v0, 4
       	la      $a0, new_line
	syscall
	bgt     $t1, $t3, loop_fib_2

       	li    $v0, 4
       	la    $a0, line_of_stars
	syscall

####################################################

        lw      $t0, harmonic      # array address
        lw      $t1, harmonicsize  # size (number of elements) of array
        li      $t2, 8             # jump in array index offset
        li      $t3, 0             # incrementing array index offset
        l.d     $f0, oned          # Constant: 1.0
        l.d     $f2, oned          # index:       k
        l.d     $f4, oned          # reciprocal:  1/k
        l.d     $f6, zerod         # sum:  1 + 1/2 + 1/3 + ... 1/k + ...

harmonic_recip:
        div.d   $f4, $f0, $f2
        add.d   $f2, $f2, $f0
        add.d   $f6, $f6, $f4
        li      $v0, 3
        mov.d   $f12, $f4
        syscall
       	li      $v0, 4
       	la      $a0, new_line
	syscall
	
	add  $t3, $t3, $t2
	mul  $t0, $t1, $t2
	bgt  $t0, $t3, harmonic_recip
	
       	li    $v0, 4
       	la    $a0, sum_comment
	syscall
	li      $v0, 3
        mov.d     $f12, $f6
        syscall
       	li      $v0, 4
       	la      $a0, new_line
	syscall

       	li    $v0, 4
       	la    $a0, line_of_stars
	syscall

done:
       	li      $v0, 10
	syscall