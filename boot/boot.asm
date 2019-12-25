; vim: :set ft=nasm:

; this is where the BIOS starts us at, after recognizing the magic numbers at
; the end of the boot sector
;
; this just tells nasm to start our 0's here relative to this physical offset,
; so we can say 0x0 instead of 0x7c00
[org 0x7c00]

init:
        ; our kernel start here - a little after 1MB is the tradition
        KERNEL_OFFSET equ 0x1200

        ; BIOS stores our boot drive in dl, let's remember this
        mov [BOOT_DRIVE], dl

        ; set stack a little out of the way of where the
        mov bp, 0x9000
        mov sp, bp

        mov bx, msg_real
        call print_string

        mov bx, newline
        call print_string

        call load_kernel

        ; we don't return here, so loop in case we do
        call switch_to_pm
        jmp $

%include "./boot/print_string.asm"
%include "./boot/gdt.asm"
%include "./boot/print_string_pm.asm"
%include "./boot/disk_load.asm"
%include "./boot/switch_to_pm.asm"

[bits 16]

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

[bits 32]

protected_mode:
        mov ebx, msg_pm
        call print_string_pm

        ; jump to the address of our kernel code.
        ;
        ; brace yourselves.
        call KERNEL_OFFSET
        jmp $ ; hang (we shouldn't get here, as we don't return...)

BOOT_DRIVE: db 0
msg_real:   db "[boot] started in 16-bit real mode...", 0
msg_pm:     db "[boot] successfully landed in 32-bit protected mode...", 0
msg_kernel: db "[boot] loading kernel into memory...", 0
newline:    db 10, 13, 0

; padding and magic BIOS number
times 510-($-$$) db 0 ; pad to the 510th byte with zeros
dw 0xaa55             ; tack the magic 2-byte constant at the end
