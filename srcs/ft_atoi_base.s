bits 64

section .text
global ft_atoi_base
extern ft_strlen
extern ft_putstr
extern ft_strchr

; ---------- PRINCIPE STACK -------
; ABI SysV x86_64 : a chaque call, rsp doit etre aligne sur 16 octets
; (le call pousse l’adresse de retour, 8 octets, donc on compense si besoin).
; Ici on ne joue pas avec l’alignement explicitement, on se contente de
; preserver les callee-saved et on rend ce qu’on a pris. Mais c'est ici que je ;e suis penche sur le sujet

; ----------- MAPPING ----------
; rdi = str (argument 1)
; rsi = base (argument 2)
; r12 = base (sauvegarde, callee-saved)
; r13 = str  (sauvegarde, callee-saved)
; r14d = base_len (en 32 bits, pratique pour comparaisons)
; r8d  = compteur de '-' modulo 2 (si bit 0 == 1 => resultat negatif)
; r9d  = any_digit flag (0/1) pour savoir si au moins un digit a ete lu
; rax  = accumulateur (résultat en construction)

ft_atoi_base:
    push r12                ; on garde r12/r13/r14 au chaud (callee-saved)
    push r13
    push r14

    mov r13, rdi            ; r13 = str (on fige le pointeur d’entree)
    mov r12, rsi            ; r12 = base (on fige la base)
; --------- validation de la longueur de la base -----------
    mov rdi, r12            ; strlen(base)
    call ft_strlen
    cmp rax, 2              ; base_len < 2 => base invalide
    jb .ret_zero
    mov r14d, eax           ; r14d = base_len (stocke pour la suite)
; ---------- validation de la base -------------------------
    mov rdx, r12            ; rdx = iterateur sur les caracteres de la base
.validate_loop:
    mov al, [rdx]           ; al = base[i]
    test al, al             ; fin de chaine ?
    jz .base_ok
    ; check espaces dans la base (interdits)
    cmp al, 32              ; ' '
    je .ret_zero
    cmp al, 9               ; tabulation horizontale
    jb .check_pm
    cmp al, 13              ; jusqu’à CR inclus (9..13)
    jbe .ret_zero
.check_pm:
    cmp al, 43              ; '+'
    je .ret_zero
    cmp al, 45              ; '-'
    je .ret_zero
    ; check des doublons dans la base avec strchr(base+i+1, base[i])
    mov rdi, rdx            ; rdi = &base[i]
    inc rdi                 ; rdi = &base[i+1]
    movzx rsi, al           ; rsi = caractere recherche
    call ft_strchr
    test rax, rax           ; si trouve => doublon => invalide
    jnz .ret_zero
    inc rdx                 ; i++
    jmp .validate_loop
.base_ok:
; ------------------- skip des espaces dans l'arg ---------
.skip_ws:
    mov al, [r13]           ; al = *str
    test al, al             ; fin de chaine ? => on sort
    jz .after_sign
    cmp al, 32              ; ' '
    je .bump_ws
    cmp al, 9               ; < 9 => pas un espace controlable => stop
    jb .after_sign
    cmp al, 13              ; 9..13 => whitespace => skip
    jbe .bump_ws
    jmp .after_sign
.bump_ws:
    inc r13                 ; str++
    jmp .skip_ws
; --------------- evaluer les signes - et + --------------
.after_sign:
    xor r8d, r8d            ; r8d = 0 (compteur de '-')
.sign_loop:
    mov al, [r13]           ; al = *str
    cmp al, 43              ; '+'
    je .bump_sign
    cmp al, 45              ; '-'
    jne .convert_start
    inc r8d                 ; on compte les '-' (parite => signe)
.bump_sign:
    inc r13                 ; str++ et on continue a scanner les signes
    jmp .sign_loop
; ------------------- conversion (bientot la fiiiiiin) -------
.convert_start:
    xor eax, eax            ; acc = 0 (rax construit le resultat)
    xor r9d, r9d            ; any_digit = 0 (pas encore lu de digit)
.convert_loop:
    movzx edx, byte[r13]    ; dl = *str (char courant)
    test dl, dl             ; fin de chaine ?
    jz .convert_end
    xor rcx, rcx            ; rcx = index du digit dans base (0..base_len-1)
    xor r10, r10            ; r10 utilise pour charger base[rcx]
.find_digit_loop:
    cmp rcx, r14            ; si rcx >= base_len => char pas dans base
    jge .convert_end
    mov r10b, BYTE [r12 + rcx] ; r10b = base[rcx]
    cmp dl, r10b            ; *str == base[rcx] ?
    je .digit_found
    inc rcx                 ; sinon on teste le suivant
    jmp .find_digit_loop
.digit_found:
    mov rbx, rax            ; rbx = acc (sauvegarde)
    mov r15, r14            ; r15 = base_len (copie, registre libre ici)
    imul rbx, r15           ; rbx = acc * base_len
    add rbx, rcx            ; rbx += index (valeur du digit)
    mov rax, rbx            ; acc = nouveau total
    inc r13                 ; str++ (on consomme le char converti)
    mov r9d, 1              ; any_digit = 1 (au moins un digit valide lu)
    jmp .convert_loop
.convert_end:
    test r9d, r9d           ; aucun digit valide lu ?
    jz .ret_zero            ; => retourne 0
    ; appliquer le signe apres la boucle
    test r8d, 1             ; parite du nombre de '-'
    jz .ret_ok              ; pair => positif, impair => négatif
    neg rax                 ; rax = -rax
    jmp .ret_ok
; --------------- sorties --------------------------
.invalid_early:
.invalid_late:
.ret_zero:
    xor rax, rax            ; rax = 0
.ret_ok:
    pop r14                 ; on rend les callee-saved dans l’ordre inverse
    pop r13
    pop r12
    ret

