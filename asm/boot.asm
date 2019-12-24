; vim: :set ft=nasm:

[org 0x7c00]

KERNEL_OFFSET equ 0x1200

mov [BOOT_DRIVE], dl

; set stack out of the way
mov bp, 0x9000
mov sp, bp

mov bx, msg_real
call print_string

mov bx, newline
call print_string

call load_kernel

; note: we don't return
call switch_to_pm

;jmp $

%include "./asm/print_string.asm"
%include "./asm/gdt.asm"
%include "./asm/print_string_pm.asm"
%include "./asm/disk_load.asm"
%include "./asm/switch_to_pm.asm"

[bits 16]

load_kernel:
        mov bx, msg_kernel
        call print_string

        mov bx, KERNEL_OFFSET
        mov dh, 15
        mov dl, [BOOT_DRIVE]

        call disk_load

        ret

[bits 32]

BEGIN_PM:
        mov ebx, msg_pm
        call print_string_pm

        ; jump to the address of our kernel code.
        ;
        ; brace yourselves.
        call KERNEL_OFFSET

        ; hang
        jmp $

BOOT_DRIVE: db 0
msg_real:   db "Started in 16-bit real mode... Is anybody out there?", 0
msg_pm:     db "Successfully landed in 32-bit protected mode, yay!", 0
msg_kernel: db "Loading kernel into memory...", 0
newline:    db 10, 13, 0

; padding and magic BIOS number
times 510-($-$$) db 0 ; pad to the 510th byte with zeros
dw 0xaa55             ; tack the magic 2-byte constant at the end
