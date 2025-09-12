bits 64
section .text
global _ft_atoi_base
extern __errno_location
extern _ft_strlen
extern _ft_write
extern _ft_putstr
extern _ft_strchr
_ft_atoi_base: ; int ft_atoi_base(const char *str, char *str_base)

; MAPPING
; rax = accumulateur en resultat
; rcx = base_len
; rdx = signe (+1 / -1)
; r8 - r11 = temporaires

_validate_base_len:
	mov rcx, 0 ; permet de recup la len de la base
	push rdi
	mov	rdi, rsi ; on passe le deuxieme param de atoi base dans rdi pour le call strlen
	call _ft_strlen
	pop rdi
	mov rcx, rax ; on passe la len dans rcx
	cmp rcx, 2
	jl _invalid_base_error ; si < 2 error
_check_base_chars:
    push rdi ; push rsi et rdi pour pouvoir les restaurer plus tard
    push rsi
	mov rdi, rsi ; inversion des params pour strchr
_check_base_chars_loop:
    mov sil, byte[rdi] ; le char a check
    lea rdi, [rdi + 1] ; on stock dans rdi le reste de la chaine a checker et l'offset du pointeur
    cmp byte[rdi], 0x0 ;
    je _base_is_valid
	push rdi ; rdi est ecrase par strchr, push / pop pour garder l'etat
    call _ft_strchr
	pop rdi
    cmp rax, 0x0
    je _check_base_chars_loop
    jne _double_base_error
_invalid_base_error:
	mov rdi, InvalidBaseString ; on passe la string dans rdi pour pouvoir l'utiliser avec putstr
	call _ft_putstr
	mov rax, 0 ; on set le return a 0, error
	ret
_double_base_error:
	pop rdi
	pop rsi
	mov rdi, DoubleBaseChar ; on passe la strind dans rdi pour putstr
	call _ft_putstr
	mov rax, 0 ; on set le return a 0, error
	ret
_base_is_valid:
	pop rdi
	pop rsi
	mov rdi, BaseIsValid
	call _ft_putstr
	mov rax, 0
	ret
BaseIsValid:
	db 'Base is Valid', 0
InvalidBaseString:
	db 'Invalid base', 0
DoubleBaseChar:
	db 'Double in base', 0
