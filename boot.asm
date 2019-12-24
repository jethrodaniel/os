; vim: :set ft=nasm:

[org 0x7c00]

; set stack out of the way
mov bp, 0x9000
mov sp, bp

mov bx, msg_real
call print_string

mov bx, newline
call print_string

; note: we dont' return
call switch_to_pm

jmp $

%include "print_string.asm"
%include "gdt.asm"
%include "print_string_pm.asm"
;%include "print_hex.asm"
;%include "disk_load.asm"
%include "switch_to_pm.asm"

[bits 32]

BEGIN_PM:
        mov ebx, msg_pm
        call print_string_pm

        ; hang
        jmp $

msg_real: db "Started in 16-bit real mode... Is anybody out there?", 0
msg_pm:   db "successfully landed in 32-bit protected mode", 0
newline:  db 10, 13, 0

; padding and magic BIOS number
times 510-($-$$) db 0 ; pad to the 510th byte with zeros
dw 0xaa55             ; tack the magic 2-byte constant at the end
