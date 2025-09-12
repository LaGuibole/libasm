bits 64

section .text
global _ft_putstr
extern _ft_write
extern _ft_strlen
_ft_putstr:
	mov r8, rdi ; garder la chaine de putstr dans r8
	call _ft_strlen ; call strlen pour get la taille de la chaine
	mov rdx, rax ; passer la longueur de cette chaine dans rdx (3eme param de write)
	mov rsi, r8 ; on passe la chaine en 2eme parametre de write
	mov rdi, 1 ; on passe le fd pour write
	call _ft_write
	ret
