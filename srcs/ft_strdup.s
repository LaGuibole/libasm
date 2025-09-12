bits 64

section .text

global _ft_strdup ; char *strdup(const char *s)
extern malloc
extern _ft_strlen
extern __errno_location

_ft_strdup:
	push r12
	mov r12, rdi ; copie de rdi
	mov r8, 0 ; iterateur pour la loop
	call _ft_strlen
	inc rax ; on inc rax pour le null terminator
	mov rdi, rax ; on passe le resultat de strlen dans rdi pour le sauver qq part
	push rax ; on push la len sur le top de la stack pour la recup dans r9 apres
	call malloc
	pop r9 ; on pop r9 pour sauvegarder la len +1 (\0)
	cmp rax, 0x0 ; on check si rax est egal a zero
	je _error
_loop:
	mov cl, byte[r12 + r8] ; copie des char
	mov byte[rax + r8], cl
	inc r8
	cmp r8, r9
	je _exit
	jmp _loop
_error:
	neg rax
	mov rdx, rax
	call __errno_location
	mov [rax], rdx
	mov rax, 0
	ret
_exit:
	pop r12 ; r12 est un registre qui doit etre preserve, donc on le pop
	ret
