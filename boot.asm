; vim: :set ft=nasm:

[org 0x7c00]

mov bx, msg
call print_string

mov bx, newline
call print_string

mov bx, second
call print_string

mov bx, newline
call print_string

; BIOS stores our boot drive in dl
mov [BOOT_DRIVE], dl

; set stack out of the way
mov bp, 0x8000
mov sp, bp

; load 5 sectors from to 0x0000(es):0 x9000(bx)
mov bx, 0x9000

; from the boot disk
mov dh, 5
mov dl, [BOOT_DRIVE]
call disk_load

mov dx, [0x9000]
call print_hex

mov bx, newline
call print_string

mov dx, [0x9000 + 512]
call print_hex

jmp $ ; loop here

%include "print_string.asm"
%include "print_hex.asm"
%include "disk_load.asm"

msg:      db "Hello, World!", 0
newline:  db 10, 13, 0
second    db "Is anybody out there? ", 0

BOOT_DRIVE: db 0

; padding and magic BIOS number
times 510-($-$$) db 0 ; pad to the 510th byte with zeros
dw 0xaa55             ; tack the magic 2-byte constant at the end

times  256 dw 0xdada
times  256 dw 0xface
