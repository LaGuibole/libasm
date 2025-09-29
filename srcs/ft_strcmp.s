bits 64
section .text
global ft_strcmp
ft_strcmp:
    mov r8, 0
.loop:
    mov cl, byte[rsi + r8]
    mov dl, byte[rdi + r8]
    inc r8
    cmp cl, dl
    jg .exit_minus
    jl .exit_plus
    cmp cl, 0x0
    jz .exit
    cmp dl, 0x0
    jz .exit_plus
    cmp cl, dl
    je .loop
.exit:
    mov rax, 0
    ret
.exit_minus:
    mov rax, -1
    ret
.exit_plus:
    mov rax, 1
    ret
