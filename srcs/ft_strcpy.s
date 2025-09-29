bits 64
section .text
global ft_strcpy
ft_strcpy:
	mov r8, 0 ; on init notre iterateur, ici r8 -> Scratch register.  These were added in 64-bit mode, so they have numbers, not names.
.loop:
	mov cl, byte[rsi + r8] ; il faut un registre temporaire pour stocker (char)src->dest cl pcq 8-bit char register, l pour partie basse
	mov byte[rdi + r8], cl ; on offset le pointeur de rdi pour y ecrire a l'adresse le char de src (soit 1 byte=8bits)
	cmp cl, 0x0 ; on compare le char contenu dans cl au null terminator
	jz .exit ; si = 0 (jump if zero)
	inc r8 ; on incremente l'iterateur
	jmp .loop ; on retourne faire un tour youhou
.exit:
	mov rax, rdi ; on passe le valeur du pointeur de dest dans le registre rax
	ret
