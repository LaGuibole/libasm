bits 64

section .text
global _ft_atoi_base
extern _ft_strlen
extern _ft_putstr
extern _ft_strchr

_ft_atoi_base:

_validate_base:
	; check de la len de la base
	mov rcx, 0
	push rdi
	mov rdi, rsi
	call _ft_strlen
	pop rdi
	mov rcx, rax
	cmp rcx, 2
	jl _invalid_base
	; len evaluee, on check les espaces etc
	push rdi
	push rsi
	mov rdi, rsi
	_validate_base_loop:
		movzx rsi, byte[rdi]
		lea rdi, [rdi + 1]
		cmp byte[rdi], 0x0
		je _base_is_valid
		cmp byte[rdi], 32
		je _invalid_base
		cmp byte[rdi], 9
		jg _is_operator
			_is_operator:
				mov r8b, byte[rdi]
				sub r8, 9
				cmp r8, 4
				jl _invalid_base
		push rdi
		call _ft_strchr
		pop rdi
		cmp rax, 0x0
		je _validate_base_loop
		jne _invalid_base
	; les espaces et les doublons sont maintenant geres dans la base

_skip_spaces:
	_skip_space_loop:
		cmp byte[rdi], 32
		je _skip_space_loop
		cmp byte[rdi], 9
		jg _is_operator_bis
			_is_operator_bis:
				mov r9b, byte[rdi]
				inc rdi
				sub r9, 9
				cmp r9, 4
				jl _skip_space_loop
	mov rax, r9
	jmp _exit
_exit:
	ret
_base_is_valid:
	mov rdi, BaseIsValid
	call _ft_putstr
	pop rsi
	pop rdi
	jmp _skip_spaces
_invalid_base:
	mov rdi, InvalidBaseString
	call _ft_putstr
	pop rsi
	pop rdi
	mov rax, 0
	ret
BaseIsValid:
	db 'Base is Valid', 0
InvalidBaseString:
	db 'Invalid base', 0

; WARNING : pour le moment, si la base est vide segfault a cause des pop rdi rsi dans _invalid_base
