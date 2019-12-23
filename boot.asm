; vim: :set ft=nasm:

[org 0x7c00]

mov bx, msg
call print_string

mov bx, newline
call print_string

mov bx, second
call print_string

jmp $ ; loop here

msg:      db "Hello, World!", 0
newline:  db 10, 13, 0
second    db "Is anybody out there? ", 0

%include "print_string.asm"

; padding and magic BIOS number
times 510-($-$$) db 0 ; pad to the 510th byte with zeros
dw 0xaa55             ; tack the magic 2-byte constant at the end
