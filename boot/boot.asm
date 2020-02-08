; vim: :set ft=nasm:

; After recognizing the magic numbers at the end of the boot sector, BIOS
; moves our bootsector code to 0x7c00 and executes it.

; global offset, so we don't have to add 0x7c00 to all the addresses
[org 0x7c00]

[bits 16]

init:
        ; the same one we used when linking the kernel
        KERNEL_OFFSET equ 0x1000

        ; set stack base to an address far away from 0x7c00 so that we don't
        ; get overwritten by our bootloader.
        ;
        ; if the stack is empty then sp points to bp.
        mov bp, 0x9000
        mov sp, bp

        ; BIOS stores our boot drive in dl, let's remember this
        mov [BOOT_DRIVE], dl

        mov bx, msg_real
        call print_string

        mov bx, newline
        call print_string

        call load_kernel

        call switch_to_pm
        jmp $ ; hang

; Load the first 15 sectors (512 * 15 = 7680) (excluding the boot sector) into
; address KERNEL_OFFSET.
;
; Why load 15, more than we need? Just to make sure we can
load_kernel:
        mov bx, msg_kernel
        call print_string

        mov bx, KERNEL_OFFSET
        mov dh, 15
        mov dl, [BOOT_DRIVE]

        call disk_load

        ret

%include "./boot/print_string.asm"
%include "./boot/gdt.asm"
%include "./boot/print_string_pm.asm"
%include "./boot/disk_load.asm"
%include "./boot/switch_to_pm.asm"

[bits 32]

protected_mode:
        mov ebx, msg_pm
        call print_string_pm

        ; jump to the address of our kernel code.
        ;
        ; brace yourselves.
        call KERNEL_OFFSET
        jmp $ ; hang

BOOT_DRIVE: db 0
msg_real:   db "[boot] started in 16-bit real mode...", 0
msg_pm:     db "[boot] successfully landed in 32-bit protected mode...", 0
msg_kernel: db "[boot] loading kernel into memory...", 0
newline:    db 10, 13, 0

; padding and magic BIOS number
times 510-($-$$) db 0 ; pad to the 510th byte with zeros
dw 0xaa55             ; tack the magic 2-byte constant at the end
