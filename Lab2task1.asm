.data
	# create array and different msgs/components
	A: .word 21, 50, 63, 72, 0, 95, 11, 28, 4, 5, 16, 7 
	N: .word 12
	msg1: .asciiz "print an array...\n"
	msg2: .asciiz "array has a length of "
	msg3: .asciiz "sorted array: "
	commas: .asciiz ", "
	newline: .asciiz "\n"
.text
.globl main

main:
	#initialize i to 1 for the for-loop
	li $s0, 1
	la $a0, A
	
outer_loop:
	# while i < 12, go to end_outer_loop if not
	li $t0, 12
	bge $s0, $t0, end_outer_loop
	
	# set v to A[i]
	sll $t1, $s0, 2
	add $t1, $t1, $a0
	lw $s2, 0($t1)
	
	# set j to i - 1
	sub $s1, $s0, 1


inner_loop:
	# break loop if j < 0
	bltz $s1, refresh_A
	
	#little bit of sorting logic
	sll $t2, $s1, 2
	add $t2, $t2, $a0
	lw $t3, 0($t2)
	blt $t3, $s2, refresh_A
	
	#A[j+1] = a[j]
	addi $t4, $s1, 1
	sll $t4, $t4, 2
	add $t4, $t4, $a0
	sw $t3, 0($t4)
	
	#decement j for this for-loop
	addi $s1, $s1, -1
	j inner_loop
	
refresh_A:
	addi $t5, $s1, 1 # increment j
	sll $t5, $t5, 2 #calculation
	add $t5, $t5, $a0
	sw $s2, 0($t5) #store v
	
	#logic for i
	addi $s0, $s0, 1
	j outer_loop

end_outer_loop:
	#end sort
	li $v0, 10
	
	la $s0, A
	lw $s1, N
	
	#call messages into console
	li $v0, 4
	la $a0, msg1
	syscall
	li $v0, 4
	la $a0, msg2
	syscall
	
	# print whatever is stored in $a0
	li $v0, 1
	move $a0, $s1
	syscall
	
	#print newline char
	li $v0, 4
	la $a0, newline
	syscall
	
	# print last message
	li $v0, 4
	la $a0, msg3
	syscall
	
	move $a0, $s0
	move $a1, $s1
	jal print_function
	
	li $v0, 10
	syscall
	
	
#printing logic	
print_function:
	move $t0, $a0
	move $t1, $a1
	print_loop:
		lw $a0, 0($t0)
		li $v0, 1
		syscall
		li $v0, 4
		la $a0, commas
		syscall
		
		addi $t0, $t0, 4
		addi $t1, $t1, -1
		bne $t1, $zero, print_loop
		jr $ra