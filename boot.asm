; vim: :set ft=nasm:

[org 0x7c00]

mov ah, 0x0e ; int 10/ah = 0eh -> scrolling teletype BIOS routine

mov bx, msg
mov al, [bx]
int 0x10

jmp $ ; loop here

msg:
  db "hello, world!"

; padding and magic BIOS number
times 510-($-$$) db 0 ; pad to the 510th byte with zeros
dw 0xaa55             ; tack the magic 2-byte constant at the end
