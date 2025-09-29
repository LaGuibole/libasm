bits 64

struc t_list
	pdata: resq 1
	pnext: resq 1
endstruc

section .text
global ft_list_sort

ft_list_sort:
	push rbp
	mov rbp, rsp
	sub rsp, 0x18
	mov rdi, qword[rdi]
	mov qword[rbp - 0x8], rdi
	mov qword[rbp - 0x10], rsi
	test rdi, rdi
	je .exit
	mov r8, rdi
.loop:
	cmp qword[r8 + pnext], 0x0		; si next == NULL
	je .exit
	mov rdi, qword[r8 + pdata] 		; charger data dans rdi
	mov rdx, qword[r8 + pnext] 		; charger le next
	mov rsi, qword[r8 + pdata] 		; charger next->data
	mov rdx, qword[r8 + pnext]
	mov qword[rbp - 0x18], r8
	call rdx
	mov r8, qword[rbp - 0x18]
	cmp eax, 0x0
	jg .swap
	mov r8, qword[r8 + pnext]
	jmp .loop
.swap:
	mov r9, qword[r8 + pdata] 		; lst->data
	mov rdx, qword[r8 + pnext] 		; lst->next dans rdx
	mov rcx, qword[rdx + pdata]
	mov qword[r8 + pdata], rcx
	mov qword[rdx + pdata], r9
	mov r8, qword[rbp - 0x8]
	jmp .loop
.exit:
	leave
	ret
