bits 64

section .text
global _ft_atoi_base
extern _ft_strlen
extern _ft_putstr
extern _ft_strchr

; ----------- MAPPING ----------
; r12 = base
; r13 = str


_ft_atoi_base:
    push r12 ; save callee-saved pour les pointeurs 
    push r13 ; same

    mov r13, rdi ; str
    mov r12, rsi ; base
; --------- validation de la longueur de la base -----------
    mov rdi, r12 ; on passe la base pour strlen
    sub rsp, 8
    call _ft_strlen
    add rsp, 8
    cmp rax, 2
    jb _invalid_early ; si len < 2
; ---------- validation de la base -------------------------
    mov rdx, r12 ; rdx = iterateur pour la base
_validate_loop:
    mov al, byte[rdx]
    test al, al
    jz _base_ok
    ; check espaces dans la base
    cmp al, 32
    je _invalid_late
    cmp al, 9
    jb _check_pm
    cmp al, 13
    jbe _invalid_late
_check_pm:
    cmp al, 43 ; = '+'
    je _invalid_late
    cmp al, 45 ; = '-'
    je _invalid_late
    ; check des doublons dans la base
    mov rdi, rdx
    inc rdi
    movzx rsi, al 
    sub rsp, 8
    call _ft_strchr
    add rsp, 8
    test rax, rax
    jnz _invalid_late
    inc rdx
    jmp _validate_loop
_base_ok:
    ; debug 
    mov rdi, BaseIsValid
    sub rsp, 8
    call _ft_putstr
    add rsp, 8
; ------------------- skip des espaces dans l'arg ---------
    mov rdi, r13
_skip_ws:
    mov al, byte[rdi]
    test al, al
    jz _after_sign
    cmp al, 32
    je _bump_ws
    cmp al, 9
    jb _after_sign
    cmp al, 13
    jbe _bump_ws
    jmp _after_sign
_bump_ws:
    inc rdi
    jmp _skip_ws
_after_sign_prelude:
    mov r13, rdi ; garde arg apres espaces si besoin pour debug a la convert
    mov rdi, ExitSuccess
    sub rsp, 8
    call _ft_putstr
    add rsp, 8
; --------------- evaluer les signes - et + --------------
_after_sign:
    xor r8d, r8d
_sign_loop:
    mov al, byte[rdi]
    cmp al, 43 ; = '+'
    je _bump_sign
    cmp al, 45 ; = '-'
    jne _end_sign
    inc r8d ; compte les '-'
_bump_sign:
    inc rdi;
    jmp _sign_loop
_end_sign:
    ; debug du signe
    test r8d, 1
    jz _print_plus
    mov rdi, SignIsMinus
    sub rsp, 8
    call _ft_putstr
    add rsp, 8
    jmp _ret_ok
_print_plus:
    mov rdi, SignIsPlus
    sub rsp, 8
    call _ft_putstr
    add rsp, 8
    jmp _ret_ok
; --------------- sorties --------------------------
_invalid_early:
    mov rdi, InvalidBaseString
    sub rsp, 8
    call _ft_putstr
    add rsp, 8
    xor rax, rax
    jmp _epilogue_clean
_invalid_late:
    mov rdi, InvalidBaseString
    sub rsp, 8
    call _ft_putstr
    add rsp, 8
    xor rax, rax
    jmp _epilogue_clean
_ret_ok:
    xor rax, rax
_epilogue_clean:
    pop r13
    pop r12
    ret

section .data
BaseIsValid:    db 'Base Is Valid ', 0
InvalidBaseString:  db 'Invalid Base ', 0
ExitSuccess:    db 'Skip Spaces ', 0
SignIsMinus:    db 'Sign is = - ', 0
SignIsPlus:     db 'Sign is = + ', 0