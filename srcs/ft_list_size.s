bits 64

; ------------------------------ ;
; RESB : allocate 1 byte
; RESW : allocate 2 bytes
; RESD : allocate 4 bytes
; RESQ : allocate 8 bytes
; SOURCE : https://stackoverflow.com/questions/44860003/how-many-bytes-do-resb-resw-resd-resq-allocate-in-nasm
; ------------------------------ ;

struc t_list
	pdata: resq 1
	pnext: resq 1
endstruc

section .text

global ft_list_size
; int ft_list_size(t_list *begin_list);
ft_list_size:
	xor rax, rax 					; init rax a 0
.loop:
	test	rdi, rdi 				; test = & binaire
	je		.exit
	inc		rax
	mov		rdi, [rdi + pnext]
	jmp		.loop
.exit:
	ret
