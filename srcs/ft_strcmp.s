bits 64
section .text
global _ft_strcmp
_ft_strcmp:
    mov r8, 0
_loop:
    mov cl, byte[rsi + r8]
    mov dl, byte[rdi + r8]
    inc r8
    cmp cl, 0x0
    jz _exit
    cmp dl, 0x0
    jz _exit_plus
    cmp cl, dl
    je _loop
    jg _exit_minus
    jl _exit_plus
_exit:
    mov rax, 0
    ret
_exit_minus:
    mov rax, -1
    ret
_exit_plus:
    mov rax, 1
    ret