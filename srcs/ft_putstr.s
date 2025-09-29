bits 64

section .text
global ft_putstr
extern ft_write
extern ft_strlen
ft_putstr:
	mov r8, rdi ; garder la chaine de putstr dans r8
	call ft_strlen ; call strlen pour get la taille de la chaine
	mov rdx, rax ; passer la longueur de cette chaine dans rdx (3eme param de write)
	mov rsi, r8 ; on passe la chaine en 2eme parametre de write
	mov rdi, 1 ; on passe le fd pour write
	call ft_write
	ret
