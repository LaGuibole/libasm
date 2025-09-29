bits 64

section .text
global ft_strdup              ; char *strdup(const char *s)
extern malloc
extern ft_strlen
extern __errno_location        ; glibc: returns int *errno

; SysV x86-64 ABI, Linux
ft_strdup:
    ; rdi = src
    mov     r12, rdi           ; garder src dans un callee-saved
    xor     r8, r8             ; i = 0

    ; Alignement OK ici: à l'entrée rsp%16 == 8, on n'a rien push → call safe
    call    ft_strlen         ; rax = len(src)

    inc     rax                ; len+1 pour le '\0'
    push    r12                ; 1er push (impair)
    mov     rdi, rax           ; malloc(len+1)
    push    rax                ; 2e push (pair) -> alignement OK pour le prochain call
    call    malloc wrt ..plt
    pop     r9                 ; r9 = len+1

    test    rax, rax
    jz      .error             ; malloc a échoué

    ; rax = dest, r12 = src, r9 = len+1
    xor     r8, r8
.copy_loop:
    mov     cl, byte [r12 + r8]
    mov     byte [rax + r8], cl
    inc     r8
    cmp     r8, r9
    jne     .copy_loop

    pop     r12                ; restaurer callee-saved
    ret

.error:
    ; Ici on a encore r12 sur la pile (1 push impaire).
    ; Avant call: réaligner la pile à 16 via un padding de 8 octets.
    mov     edx, 12            ; ENOMEM
    sub     rsp, 8             ; aligner
    call    __errno_location   ; rax = &errno
    add     rsp, 8             ; désaligner symétriquement
    mov     dword [rax], edx   ; *errno = ENOMEM
    xor     rax, rax           ; return NULL
    pop     r12
    ret
