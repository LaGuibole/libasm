bits 64
section .text
global _ft_read
extern __errno_location
_ft_read:
	mov rax, 0
	syscall
	cmp rax, 0
	jl _error
	ret
_error:
	neg rax
	mov rdx, rax
	call __errno_location
	mov [rax], rdx
	mov rax, -1
	ret
