bits 64

section .text
global _ft_atoi_base
extern _ft_strlen
extern _ft_putstr
extern _ft_strchr
extern printf


; ---------- PRINCIPE STACK -------
; Pour l'ABI SysV (x86_64) pour chaque call ou syscall => rsp % 16 = 0
; Certains call font des instructions movapps qui exige que les adresses soit alignees de 16 octets
; pourquoi 16 ? => pcq le call  a deja pousse l'adresse de retour (8 octets / bits)
; c'est pour ca qu'on sub allouer espace fictif, puis add, pour rendre l'espace fictif qu'on prend

; ----------- MAPPING ----------
; rdi = str, rsi = base
; r12 = base (calle-saved)
; r13 = str (callee-saved)
; r14d = base_len
; r8d = minus_count % 2
; r9d any_digit flag (0/1)
; rax = accumulateur


_ft_atoi_base:
    push r12 ; save callee-saved pour les pointeurs 
    push r13 ; same
    push r14

    mov r13, rdi ; str
    mov r12, rsi ; base
; --------- validation de la longueur de la base -----------
    mov rdi, r12 ; on passe la base pour strlen
    call _ft_strlen
    cmp rax, 2
    jb _ret_zero ; si len < 2
    mov r14d, eax ; base_len stockee pour conversion
    ; DEBUG: affiche la valeur de r14d (base_len)
    mov rsi, r14
    mov rdi, debug_base_fmt
    mov rax, 0
    call printf
; ---------- validation de la base -------------------------
    mov rdx, r12 ; rdx = iterateur pour la base
_validate_loop:
    mov al, [rdx]
    test al, al
    jz _base_ok
    ; check espaces dans la base
    cmp al, 32
    je _ret_zero
    cmp al, 9
    jb _check_pm
    cmp al, 13
    jbe _ret_zero
_check_pm:
    cmp al, 43 ; = '+'
    je _ret_zero
    cmp al, 45 ; = '-'
    je _ret_zero
    ; check des doublons dans la base
    mov rdi, rdx
    inc rdi
    movzx rsi, al 
    call _ft_strchr
    test rax, rax
    jnz _ret_zero
    inc rdx
    jmp _validate_loop
_base_ok:
; ------------------- skip des espaces dans l'arg ---------
_skip_ws:
    mov al, [r13]
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
    inc r13
    jmp _skip_ws
; --------------- evaluer les signes - et + --------------
_after_sign:
    xor r8d, r8d
_sign_loop:
    mov al, [r13]
    cmp al, 43 ; = '+'
    je _bump_sign
    cmp al, 45 ; = '-'
    jne _convert_start
    inc r8d ; compte les '-'
_bump_sign:
    inc r13;
    jmp _sign_loop
; ------------------- conversion (bientot la fiiiiiin) ------- 
; _convert_start:
;     xor eax, eax ; registre accumulateur (acc = 0)
;     xor r9d, r9d ; any_digit = 0
; _convert_loop:
;     movzx edx, byte[r13]
;     test dl, dl
;     jz _convert_end
;     ; chercher le char dans la base => digit = index
;     mov rdi, r12
;     mov rsi, rdx
;     ; sub rsp, 8
;     call _ft_strchr
;     ; add rsp, 8
;     test rax, rax
;     jz _convert_end ; digit non trouve dans la base
;     ; digit = rax - r12
;     mov rdx, rax
;     sub rdx, r12 ; rdx = index(digit)
;     ; acc = acc * base_len + digit
;     imul rax, r14
;     add rax, rdx
;     inc r13
;     mov r9d, 1 ; au moins un digit lu
;     jmp _convert_loop
; _convert_end:
;     test r9d, r9d
;     jz _ret_zero ; auncun digit => 0
;     ; appliquer le signe
;     test r8d, 1
;     jz _ret_ok
;     neg rax
;     jmp _ret_ok
_convert_start:
    xor eax, eax ; registre accumulateur (acc = 0)
    xor r9d, r9d ; any_digit = 0
_convert_loop:
    movzx edx, byte[r13]
    test dl, dl
    jz _convert_end
    xor rcx, rcx              ; index = 0
.find_digit_loop:
    cmp rcx, r14              ; si index >= base_len, pas trouvé
    jge _convert_end
    mov al, [r12 + rcx]       ; caractère courant de la base
    cmp dl, al                ; dl = caractère à convertir
    je .digit_found
    inc rcx
    jmp .find_digit_loop
.digit_found:
    mov rbx, rax        ; sauvegarde l'accumulateur
    mov r15, r14        ; copie base_len dans r15 (r15 non utilisé)
    imul rbx, r15       ; acc * base_len
    add rbx, rcx        ; + index
    mov rax, rbx        ; rax = nouvel accumulateur

    ; DEBUG: affiche la valeur courante de rax
    push rax
    mov rdi, debug_fmt
    mov rsi, rax
    mov rax, 0
    call printf
    pop rax

    inc r13
    mov r9d, 1
    jmp _convert_loop
_convert_end:
    test r9d, r9d
    jz _ret_zero ; auncun digit => 0
    ; appliquer le signe
    test r8d, 1
    jz _ret_ok
    neg rax
    jmp _ret_ok

; --------------- sorties --------------------------
_invalid_early:
_invalid_late:
_ret_zero:
    xor rax, rax
_ret_ok:
    pop r14
    pop r13
    pop r12
    ret

section .data
debug_base_fmt: db "[DEBUG] base_len = %d\n", 0
BaseIsValid:    db 'Base Is Valid ', 0
InvalidBaseString:  db 'Invalid Base ', 0
ExitSuccess:    db 'Skip Spaces ', 0
SignIsMinus:    db 'Sign is = - ', 0
SignIsPlus:     db 'Sign is = + ', 0
debug_fmt: db "[DEBUG] rax = %ld\n", 0
