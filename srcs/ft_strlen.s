bits 64
section .text
global ft_strlen

ft_strlen:
	mov rax, 0 ; init rax registre accumulateur a zero
_loop:
	cmp byte[rdi + rax], 0x0 ; comparer rdi (argument de la fonction) a rax (valeur de retour)
	jz _exit ; si cmp egal a zero jump a exit
	inc rax ; sinon on incremente rax jusqu'au \0
	jmp _loop ; jump au debut de la loop
_exit:
	ret
