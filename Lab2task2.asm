.data 
	# Load arrays, length, messages, and components to build the output string.
	A:.word 21, 50, 63, 72, 0, 95, 11, 28, 4, 5, 16, 7
	N:.word 12
	msg1:.asciiz "printing an array...\n"
	msg2:.asciiz "array has a length of "
	msg3:.asciiz "sorted array: "
	commas:.asciiz ", "
	newline:.asciiz "\n"
	size:.word 12
	
.text
.globl main

main:
	# Call bubble_sort function to sort the array A.
	la $a0, A          # Load address of array A into $a0.
	li $a1, 12         # Load length of array A into $a1.
	jal bubble_sort    # Jump and link to bubble_sort function.

	# Prepare for printing messages and sorted array.
	la $s0, A          # Load address of array A into $s0.
	lw $s1, N          # Load length of array A into $s1.
	
	li $v0, 4
	# Print message indicating printing an array.
	la $a0, msg1       # Load address of message 1 into $a0.
	syscall            # Print message 1.

	# Print message indicating the length of the array.
	li $v0, 4          # Load syscall code for printing string into $v0.
	la $a0, msg2       # Load address of message 2 into $a0.
	syscall            # Print message 2.

	# Print length of the array.
	li $v0, 1          # Load syscall code for printing integer into $v0.
	move $a0, $s1      # Load length of array A into $a0.
	syscall            # Print length of the array.

	# Print newline character.
	li $v0, 4          # Load syscall code for printing string into $v0.
	la $a0, newline    # Load address of newline character into $a0.
	syscall            # Print newline character.

	# Print message indicating the sorted array.
	li $v0, 4          # Load syscall code for printing string into $v0.
	la $a0, msg3       # Load address of message 3 into $a0.
	syscall            # Print message 3.

	# Call print_function to print the sorted array.
	move $a0, $s0      # Load address of array A into $a0.
	move $a1, $s1      # Load length of array A into $a1.
	jal print_function # Jump and link to print_function.

	# Exit program.
	li $v0, 10         # Load syscall code for exit into $v0.
	syscall            # Exit program.

# Function to print the elements of an array.
print_function:
	move $t0, $a0      # Copy address of array into $t0.
	move $t1, $a1      # Copy length of array into $t1.

	print_loop:
		lw $a0, 0($t0)   # Load value at current address into $a0.
		li $v0, 1        # Load syscall code for printing integer into $v0.
		syscall          # Print value.

		li $v0, 4        # Load syscall code for printing string into $v0.
		la $a0, commas  # Load address of commas string into $a0.
		syscall          # Print commas.

		addi $t0, $t0, 4 # Move to next element in the array.
		addi $t1, $t1, -1 # Decrease remaining count.
		bne $t1, $zero, print_loop # Continue loop if not finished.
		jr $ra           # Return to caller.

# Function to swap two elements in an array.
swap:
	sll $t1, $a1, 2     # Calculate offset for second element.
	add $t1, $a0, $t1  # Add offset to array address.

	lw $t0, 0($t1)     # Load value of second element into $t0.
	lw $t2, 4($t1)     # Load value of first element into $t2.

	sw $t2, 0($t1)     # Store value of first element into second element.
	sw $t0, 4($t1)     # Store value of second element into first element.

# Function to perform bubble sort on an array.
# Function to perform bubble sort on an array.
bubble_sort:
    # Save necessary registers and allocate space on stack.
    addi $sp, $sp, -20 # Allocate 20 bytes on stack.
    sw $ra, 16($sp)     # Save return address.
    sw $s3, 12($sp)     # Save $s3.
    sw $s2, 8($sp)      # Save $s2.
    sw $s1, 4($sp)      # Save $s1.
    sw $s0, 0($sp)      # Save $s0.

    move $s2, $a0       # Copy address of array into $s2.
    move $s3, $a1       # Copy length of array into $s3.
    move $s0, $zero     # Initialize $s0 to 0.

    # Outer loop for iterating over array.
    loop1:
        slt $t0, $s0, $s3   # Check if outer loop index < length.
        beq $t0, $zero, exit_loop1 # Exit loop if index >= length.

        addi $s1, $s0, -1   # Initialize inner loop index.

        # Inner loop for performing comparisons and swapping.
        loop2:
            slti $t0, $s1, 0    # Check if inner loop index < 0.
            bne $t0, $zero, exit_loop2 # Exit loop if index < 0.

            sll $t1, $s1, 2      # Calculate offset for current element.
            add $t2, $s2, $t1    # Add offset to array address.
            lw $t3, 0($t2)       # Load value of current element.

            lw $t4, 4($t2)       # Load value of next element.
            slt $t0, $t4, $t3    # Compare current and next elements.
            beq $t0, $zero, exit_loop2 # Exit loop if next element >= current.

            move $a0, $s2        # Prepare arguments for swap function.
            move $a1, $s1
            jal swap             # Call swap function.

            addi $s1, $s1, -1   # Move to previous element.
            j loop2              # Repeat inner loop.

        exit_loop2:
            addi $s0, $s0, 1    # Move to next element.
            j loop1              # Repeat outer loop.

    exit_loop1:
        # Restore saved registers and deallocate space on stack.
        lw $s0, 0($sp)       # Restore $s0.
        lw $s1, 4($sp)       # Restore $s1.
        lw $s2, 8($sp)      # Restore $s2.
        lw $s3, 12($sp)      # Restore $s3.
        lw $ra, 16($sp)      # Restore return address.
        addi $sp, $sp, 20    # Deallocate 20 bytes on stack.
        jr $ra              # Return to caller.
