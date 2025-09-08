bits 64

section .text

global ft_strcpy

ft_strcpy:
	mov r8, 0
_loop:
	mov cl, byte[rsi + r8]
	mov byte[rdi + r8], cl
	cmp cl, 0x0
	jz _exit
	inc r8
	jmp _loop
_exit:
	mov rax, rdi
	ret
