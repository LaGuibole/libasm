bits 64

section .text
global ft_strchr ; char *strchr(const char *s, int c)
ft_strchr:
	.loop:
		cmp byte[rdi], 0x0 ; on check le null terminator
		je .exit ; si trouve on exit, bout de chaine, pas d'occurence
		cmp byte[rdi], sil ; on compare rdi a sil (partie basse 8bits de rdi)
		je .char_found ; on a trouve le char
		inc rdi ; on incremente le pointeur
		jmp .loop ; sinon on continue
.exit:
	mov rax, 0x0 ; on return NULL
	ret
.char_found:
	mov rax, rdi ; on return la chaine depuis l'occurence de sil
	ret

