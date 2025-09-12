bits 64

section .text
global _ft_strchr ; char *strchr(const char *s, int c)
_ft_strchr:
	_loop:
		cmp byte[rdi], sil ; on compare rdi a sil (partie basse 8bits de rdi)
		je _char_found ; on a trouve le char
		inc rdi ; on incremente le pointeur
		cmp byte[rdi], 0x0 ; on check le null terminator
		je _exit ; si trouve on exit, bout de chaine, pas d'occurence
		jmp _loop ; sinon on continue
_exit:
	mov rax, 0x0 ; on return NULL
	ret
_char_found:
	mov rax, rdi ; on return la chaine depuis l'occurence de sil
	ret

