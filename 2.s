.section .data
input_buffer1:
    .space 256
input_buffer2:
    .space 256
ciphertext: 
    .space 11

prompt:
    .ascii "Enter a string: "
    prompt_len = . - prompt

.section .text
.globl _start
_start:
    # print prompt message
    movl $4, %eax   # system call number for write
    movl $1, %ebx   # file descriptor for stdout
    movl $prompt, %ecx   # message to print
    movl $prompt_len, %edx   # message length
    int $0x80      # invoke system call

    # read input string from user
    movl $3, %eax   # system call number for read
    movl $0, %ebx   # file descriptor for stdin
    movl $input_buffer1, %ecx   # buffer to read into
    movl $255, %edx   # maximum bytes to read
    int $0x80      # invoke system call

    # print prompt message
    movl $4, %eax   # system call number for write
    movl $1, %ebx   # file descriptor for stdout
    movl $prompt, %ecx   # message to print
    movl $prompt_len, %edx   # message length
    int $0x80      # invoke system call

    # read input string from user
    movl $3, %eax   # system call number for read
    movl $0, %ebx   # file descriptor for stdin
    movl $input_buffer2, %ecx   # buffer to read into
    movl $255, %edx   # maximum bytes to read
    int $0x80      # invoke system call

    # print input string back to user
    movl $4, %eax   # system call number for write
    movl $1, %ebx   # file descriptor for stdout
    movl $input_buffer1, %ecx   # message to print
    movl %edx, %edx   # message length
    int $0x80      # invoke system call

    # print input string back to user
    movl $4, %eax   # system call number for write
    movl $1, %ebx   # file descriptor for stdout
    movl $input_buffer2, %ecx   # message to print
    movl %edx, %edx   # message length
    int $0x80      # invoke system call

    # Convert the key from ASCII to integer
    movl $input_buffer2, %eax
    subl $48, (%eax)
    movl (%eax), %ebx


    #====================================================================
    # Loop through each character of the input_buffer1
    movl $0, %ecx    # Counter i = 0
    movb input_buffer2, %dl    # Load the encryption input_buffer2
loop:
    movb input_buffer1(%ecx), %al    # Load a character from input_buffer1 into AL
    cmpb $0, %al                # Check for end of string
    je done
    addb %dl, %al               # Encrypt the character by adding the input_buffer2
    movb %al, ciphertext(%ecx)  # Store the encrypted character in ciphertext
    incl %ecx                   # Increment the counter i
    jmp loop

done:
    # Terminate the ciphertext string
    movb $0, ciphertext(%ecx)

    # Display the ciphertext
    movl $4, %eax             # System call for write
    movl $1, %ebx             # Standard output file descriptor
    movl $ciphertext, %ecx    # Pointer to the ciphertext string
    movl $11, %edx            # Length of the ciphertext string
    int $0x80                 # Call the kerne
    #====================================================================
    
    # exit program
    movl $1, %eax   # system call number for exit
    xorl %ebx, %ebx   # exit status
    int $0x80      # invoke system call
