; vim: :set ft=nasm:

[BITS 16]

; subroutine to read from a disk into memory.
;
; ```
; dx = the hexadecimal value to print
; ```
;
; Usage
;
; ```
; mov dx, 0x1fb6
; call disk_load
; ```
;
disk_load:
        ; push dx onto the stack (how many sectors were requested)
        push dx

        ; BIOS read sector function
        mov ah, 0x02

        ; read dh sectors
        mov al, dh

        ; select cylinder 0
        mov ch, 0x00

        ; select head 0
        mov dh, 0x00

        ; start reading from the second sector (after the bootloader)
        mov cl, 0x02

        ; BIOS interrupt
        int 0x13

        ; jump if read error
        jc disk_error

        ; restore dx from the stack
        pop dx

        ; if sectors read (al) != sectors expected (dh), raise an error
        cmp dh, al
        jne disk_error

        ; return from subroutine
        ret

disk_error:
        mov bx, DISK_ERROR_MSG
        call print_string
        jmp $

DISK_ERROR_MSG:
        db "Disk read error!", 0
