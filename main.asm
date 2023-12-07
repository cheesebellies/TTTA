;*******************************************************
; PROGRAM NAME - Tic Tac Toe
;
; PROGRAMMER - David Weir
;
; COMPILE - nasm -f elf64 -F dwarf -g Lab.asm
;           ld -m elf_x86_64 -o lab Lab.o
;
; SYSTEM - Replit
;
; DATE - Started Dec. 7, 2023
;
; ISSUES - Don't use negative values when inputting numbers. No inputting numbers larger than 19 digits
;
; DESCRIPTION - Two player Tic Tac Toe
; *******************************************************


global _start                               ;Linker instructions

section .text                               ;Main code


    pnum:                                   ;Number printing function
        POP r15                             ;Saving return adress in r15
        POP r14                             ;Saving number to be printed in r14
        PUSH r14                            ;Saving number to be printed on stack
        call cdigits                        ;Counting digits of number
        POP rbx                             ;Saving number of digits to rbx
        mov r8, 10                          ;Saving 10 to r8
        PUSH r8                             ;Saving 10 to stack
        PUSH rbx                            ;Saving number of digits to stack
        call pow                            ;Getting 10^number of digits, for use in printing function
        POP r8                              ;Saving that number to r8
        mov r9, 10                          ;Saving 10 in r9
        pnumwork:                           ;Looping function for actually printing number
            mov rax, r14                    ;Saving number to print (r14) to rax
            xor rdx, rdx                    ;Making rdx 0, so division doesnt mess up
            div r8                          ;Dividing rax by r8
            mov r10, rax                    ;Saving result to r10
            imul rax, r8                    ;Multiplying result with r8, so we can subtract it from the number we're printing. EG: num is 123, r8 is 100, rax is 1, then subtracting 100 from 123, so we can loop with 23 as num.
            sub r14, rax                    ;Subtracting multiplication result from num
            mov rax, r10                    ;Moving result back to rax
            add rax, 48                     ;Adding 48 to rax for unicode, otherwise, printing, for example, 1, wouldent print one but unicode char with code 1
            mov [temp_var], rax             ;Save result of division to variable, for printing
            mov rax, 1                      ;System write 
            mov rdi, 1                      ;Stdout 
            mov rsi, temp_var               ;Message to be sent
            mov rdx, temp_var_len           ;Message length
            syscall                         ;Printing message
            xor rdx, rdx                    ;Making rdx 0
            mov rax, r8                     ;Making rax r8
            div r9                          ;Dividing r8 by 10
            mov r8, rax                     ;Making r8 the division result, so when looping we keep up with each digit in the number to print
            mov rax, r14                    ;Moving number to print to rax
            cmp r8, 0                       ;Comparing it with zero
            jnz pnumwork                    ;If it is zero, stop looping, else, loop
        PUSH r15                            ;Pushing return address to top of stack
        ret                                 ;Return to location the function was called from


    cdigits:                                ;Digit counting function
        POP rbx                             ;Saving return adress to rbx
        POP rax                             ;Getting number to count digits of, saving to rax
        mov r8, 10                          ;Making r8 10
        mov r9, 0                           ;Making r9 0
        cdigitswork:                        ;Looping function
            xor rdx, rdx                    ;Making rdx 0
            div r8                          ;Dividing number to count digits of by 10
            inc r9                          ;Incrementing r9 (number of digits counter variable)
            cmp rax, 0                      ;Comparing division result with 0
            jnz cdigitswork                 ;If rax is 0, exit looping function, else, loop.
        PUSH r9                             ;Push result number to stack
        PUSH rbx                            ;Push return adress to stack
        ret                                 ;Return to location the function was called from

    pow:                                    ;Function to get a number to the power of another
        POP r8                              ;Save return adress to r8
        POP r9                              ;Save exponent to r9
        POP r10                             ;Save base to r10
        mov r11, r10                        ;Make r11 equal to r10
        mov rax, r9                         ;Make rax equal r9 for comparison below
        dec r9                              ;Make r9 one smaller for compatibility with looping function
        jnz powwork                         ;If number isn't zero, go to looping function
        jmp powfi                           ;Jump to exit of function if number is zero
        powwork:                            ;Looping function
            imul r10, r11                   ;Multiply base by copy of itself
            dec r9                          ;Decrement loop counter
            mov rax, r9                     ;Make rax equal r9 for comparison below
            jnz powwork                     ;If negative, exit looping function, else, loop
        powfi:                              ;Jump here when done with function, to avoid running powwork
            xor rdx, rdx                    ;Make rdx zero
            mov rax, r10                    ;Make rax equal to result
            div r11                         ;Divide by base
            mov r10, rax                    ;Move result back to r10
            PUSH r10                        ;Push result to stack
            PUSH r8                         ;Push return adress to stack
            ret                             ;Return to location the function was called from


    _start:
        mov rax, 12342
        PUSH rax
        call pnum
        mov    eax, 60                      ;System exit code
        mov    rdi, 0                       ;Success code
        syscall                             ;Exit program

section .data                               ;Data for use in program

newline: db 0x0A
newlinelen: equ $-newline
dnewline: db 0x0A, 0x0A
dnewlinelen: equ $-dnewline
temp_var: times 64 db 0                     ;Save number printing variable with a buffer
temp_var_len: equ $-temp_var                ;Save the length of temp_var
temp_var_i: times 64 db 0                   ;Save number input variable with a buffer
temp_var_len_i: equ $-temp_var_i            ;Save the length of temp_var_i