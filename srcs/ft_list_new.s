bits 64

extern malloc

global ft_list_new

section .text

; t_list *ft_list_new(void *data);
ft_list_new:
	push rdi 				; save de *data
	mov rdi, 16 			; preparation du call malloc, taille de la struct = 16 (2 pointeurs de 8 bits)
	call malloc wrt ..plt 	; appel dynamique a malloc via PLT (table de linkage / Procedure Linkage Table)
	cmp rax, 0 				; contient l'adresse de retour de malloc, si 0 ca a echoue
	jz .exit 				; donc si 0 on return, malloc failed
	pop rdi 				; on restaure rdi, on recup data qu'on avait pousse
	mov [rax + 0], rdi 		; on ecrit le champ data : *(allocated + 0) = data
	mov qword [rax + 8], 0 	; init le champ next a NULL : *(allocated + 8) = 0
	ret 					; renvoyer l'adresse allouee
.exit:
	ret
