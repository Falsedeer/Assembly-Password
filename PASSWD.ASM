; password protect program in TASM asembler
; coded by Falsedeer(gamer.com.tw)

.model small
.CODE
ORG 100h
start:
    mov ah, 09h
    mov dx, OFFSET msg
    int 21h
    xor di, di
    xor al, al
    mov bx, OFFSET buff

firstchar:
    mov ah, 01h                         ;moving the first letter into buff manually
    int 21h
    cmp al, 0dh                         ;check if the first char is enter
    mov byte PTR [bx+di], al
    jnz input                           ;if not enter, jnz to input to read the rest
    jmp done                            ;exit now if the first char is enter

input:
    xor al, al                          ;reset al to hold entered letter
    mov ah, 01h                         ;read input
    int 21h
    inc di                              ;increase di by 1, mark the total input byte
    mov byte PTR [bx+di], al            ;save the char to var:input
    cmp al, 0dh                         ;check if it's a CRLF
    jnz input                           ;loop if doesn't equal.
    jmp markup   

markup:                                 ;overwrite the last byte to markup the end
    mov byte PTR [bx+di], 0             ;adding a terminate zero, overwrite CRFL
    inc di                              ;index starts from zero, so inc di to correct the value.
    mov si, di                          ;save the length in si register
    xor di, di
    mov cx, OFFSET len_passwd
    mov bx, OFFSET buff
    mov bp, OFFSET passwd

verify_char:
    xor ax, ax
    mov al, byte PTR [bp+di]
    cmp byte PTR [bx+di], al
    jnz reject                          ;if doent match, jump to error
    inc di
    cmp cx, di
    jnz verify_char

verify_len:
    cmp cx, si
    jnz reject

accept:
    mov ah, 09h
    mov dx, OFFSET msg2
    int 21h
    jmp done

reject:
    mov ah, 09h
    mov dx, OFFSET msg3                           
    int 21h
    jmp done

done:
    mov ah, 4ch
    int 21h

msg db "Please enter password: $"
msg2 db "Welcome!$"
msg3 db "Error Occured!$"                   

buff db 10 dup(0)                           ;buffer area for input data
passwd db "miraix",0
len_passwd EQU $ - passwd                   ;length of passwd

end start

