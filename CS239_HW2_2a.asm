            .data
menu0:      .asciiz "\n   Options Menu \n\n"         
menu1:      .asciiz "1. Enter a value, x, between 10 and 50 \n"         
menu2:      .asciiz "2. Enter a value, y, between 1000000 and 50000000 \n"         
menu3:      .asciiz "3. Compute \n"         
menu4:      .asciiz "4. Quit \n\n"
menu6:      .asciiz "Enter option --> "
error1:	    .asciiz "\nThat is not in between 10 and 50!"
error2:	    .asciiz "\nThat is not in between 1000000 and 50000000!"
result1:    .asciiz "x = "
result2:    .asciiz "     y = "
newline:    .asciiz " \n"         
result3:    .asciiz "y + x = "
result4:    .asciiz "y - x = " 
result5:    .asciiz "x * y = "
result6:    .asciiz "y/x = "
result7:    .asciiz "y % x = "
result8:    .asciiz "x/y = " 
result9:    .asciiz "x^5 = " 
menuerror:  .asciiz "Error:  must enter option 1 to 5 ! \n "

            .text
main:
########## First, initialize the variables used in this program.
        addi $t0, $zero, 1          # variable: option
        addi $t1, $zero, 0          # variable: x
        addi $t2, $zero, 0          # variable: y
        addi $t3, $zero, 0          # variable: y + x
        addi $t4, $zero, 0          # variable: y - x
        addi $t5, $zero, 0          # variable: x * y
        addi $t6, $zero, 0          # variable: y/x
        addi $t7, $zero, 0          # variable: y % x
        addi $s0, $zero, 0          # variable: x/y
        addi $s1, $zero, 0          # variable: x^5
        addi $s2, $zero, 50000000
        
        ########
menuloop:        
        jal printmenu
        li       $v0, 5              # PRINT_STRING
	syscall
	add      $t0, $zero, $v0           # " ! = "
        bne      $t0, 1, opt2Query
        jal enterx
        b   menuloop
        
opt2Query:        
        bne $t0, 2, opt3Query
        jal entery
        b   menuloop
        
opt3Query:        
        bne $t0, 3, opt4Query
        jal computexy
        b   menuloop
        
opt4Query:        
        bne $t0, 4, errprint        
        b   done
        
        ########## Print the error string for user selecting an invalid option                                            
errprint:                 
        li       $v0, 4              # PRINT_STRING
	la       $a0, menuerror      # ... text of error message
	syscall
        b menuloop        
        
        ########## Print out, line by line, the options menu                                        
printmenu:
        li       $v0, 4               # PRINT_STRING
	la       $a0, menu0           # The following are the lines
	syscall                       #    of the options menu.
	la       $a0, menu1           #    Print these in sequence
	syscall
	la       $a0, menu2           
	syscall
	la       $a0, menu3           
	syscall 
	la       $a0, menu4           
	syscall 
	
	la       $a0, menu6           # ...done with menu
	syscall

	jr $ra
########## Option 1:  Read x
enterx:
        li       $v0, 5              # READ_INT
	syscall
	add      $t1, $zero, $v0     # x = $t1 <-- $v0
	ble 	 $t1, 9, errorx
	bge	 $t1, 51, errorx
        jr       $ra		
        
        
########## Option 2:  Read y
entery: 
        li       $v0, 5              # READ_INT
	syscall
	add      $t2, $zero, $v0     # y = $t2 <-- $v0
	ble 	 $t2, 999999, errory
	bge	 $t2, 50000001, errory
        jr       $ra		

########## Option 3: compute
computexy: 
        add $t3, $t1, $t2
        sub $t4, $t2, $t1
        mul $t5, $t1, $t2		
        #mflo $t5	
        div $t2, $t1	
        mflo $t6
        mfhi $t7
        div $t1, $t2
        mflo $s0
        mul $s1, $t1, $t1
        #mflo $s1
        mul $s1, $s1, $s1
        mflo $s1
        mul $s1, $s1, $t1
       # mflo $s1
        b   resultline
        
########## Print:  x = ____    y = _____     x op y = _____
resultline: 
        li       $v0, 4              # PRINT_STRING
	la       $a0, result1        # "x =  "
	syscall
       	li       $v0, 1              # PRINT_INT
	add      $a0, $zero, $t1     # x, or $t1
	syscall
        li       $v0, 4              # PRINT_STRING
	la       $a0, result2        # "y = "
	syscall
       	li       $v0, 1              # PRINT_INT
	add      $a0, $zero, $t2     # y, or $t2
	syscall
	li       $v0, 4              # PRINT_STRING
	la       $a0, newline        # " \n "
	syscall
        li       $v0, 4              # PRINT_STRING
	la       $a0, result3        # "y + x = "
	syscall
       	li       $v0, 1              # PRINT_INT
	add      $a0, $zero, $t3     # y + x, or $t3
	syscall
	li       $v0, 4              # PRINT_STRING
	la       $a0, newline        # " \n "
	syscall
	
	##my work
	li       $v0, 4              # PRINT_STRING
	la       $a0, result4        # "y - x= "
	syscall
       	li       $v0, 1              # PRINT_INT
	add      $a0, $zero, $t4     # x + y, or $t4
	syscall
	li       $v0, 4              # PRINT_STRING
	la       $a0, newline        # " \n "
	syscall
	
	li       $v0, 4              # PRINT_STRING
	la       $a0, result5        # "y * x= "
	syscall
       	li       $v0, 1              # PRINT_INT
	add      $a0, $zero, $t5     # x * y, or $t5
	syscall
	li       $v0, 4              # PRINT_STRING
	la       $a0, newline        # " \n "
	syscall
	
	li       $v0, 4              # PRINT_STRING
	la       $a0, result6        # "y / x= "
	syscall
       	li       $v0, 1              # PRINT_INT
	add      $a0, $zero, $t6     # y/x, or $t6
	syscall
	li       $v0, 4              # PRINT_STRING
	la       $a0, newline        # " \n "
	syscall
	
	li       $v0, 4              # PRINT_STRING
	la       $a0, result7        # "y % x= "
	syscall
       	li       $v0, 1              # PRINT_INT
	add      $a0, $zero, $t7     # y%x, or $t7
	syscall
	li       $v0, 4              # PRINT_STRING
	la       $a0, newline        # " \n "
	syscall
	
	li       $v0, 4              # PRINT_STRING
	la       $a0, result8        # "x / y= "
	syscall
       	li       $v0, 1              # PRINT_INT
	add      $a0, $zero, $s0     # x/y, or $s0
	syscall
	li       $v0, 4              # PRINT_STRING
	la       $a0, newline        # " \n "
	syscall
	
	li       $v0, 4              # PRINT_STRING
	la       $a0, result9        # "x ^5= "
	syscall
       	li       $v0, 1              # PRINT_INT
	add      $a0, $zero, $s1     # x^5, or $s1
	syscall
	li       $v0, 4              # PRINT_STRING
	la       $a0, newline        # " \n "
	syscall
	####
	
        li       $v0, 4              # PRINT_STRING
	la       $a0, newline        # " \n "
	syscall
        jr $ra  
        
errorx:    
 	li       $v0, 4              # PRINT_STRING
	la       $a0, error1        # " \n "
	syscall
        b 	menuloop   
        
errory:    
 	li       $v0, 4              # PRINT_STRING
	la       $a0, error2        # " \n "
	syscall
        b 	menuloop  

##########   Exiting the menu ... we're done!
done:
       	li       $v0, 10             # EXIT
	syscall
