bits 64

extern malloc
extern ft_list_new
section .text
global ft_list_push_front
; void ft_list_push_front(t_list **begin_list, void *data)
ft_list_push_front:
	test rdi, rdi 				; verif si begin_list == NULL
	jz .exit					; si oui, on sort
	push rdi					; save begin_list sur la stack
	push rsi					; save data sur la stack
	mov rdi, rsi				; preparer l'arg pour ft_list_new
	call ft_list_new			; appel a lst_new pour creer un nouvel element dans la struc, lst_new realigne donc les 2 push sont pas genant, moche mais pas genant
	cmp rax, 0					; verifier le retour == NULL (allocation ratee)
	jz .exit					; si c'est le cas, on return
	pop rsi						; on restaure data (inutile ici, mais on respecte l'ordre push / pop)
	pop rdi						; on restaure begin_list
	mov rsi, [rdi]				; charger l'ancienne HEAD, rsi = *begin_list
	mov qword [rax + 8], rsi	; new->next = ancienne HEAD
	mov qword [rdi], rax		; *begin_list = new
	jmp .exit
.exit:
	ret							; contient NULL ou le new
