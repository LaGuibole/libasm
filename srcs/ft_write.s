bits 64
section .text
global _ft_write

extern __errno_location
_ft_write: 
	mov rax, 1
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

