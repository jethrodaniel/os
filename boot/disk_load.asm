; vim: :set ft=nasm:

[bits 16]

; subroutine to read from a disk into memory
;
; reads a specified number of sectors, grabs cylinder 0, head 0, and
; start reading the second sector (after the bootloader)

; ```
; dh = how many sectors
; bx =
; ```
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
        jc disk_read_error

        ; restore dx from the stack
        pop dx

        ; if sectors read (al) != sectors expected (dh), raise an error
        cmp dh, al
        jne disk_sectors_error

        ; return from subroutine
        ret

disk_read_error:
        mov bx, _newline
        call print_string

        mov bx, DISK_READ_ERROR_MSG
        call print_string

        jmp disk_error

disk_sectors_error:
        mov bx, _newline
        call print_string

        mov bx, DISK_SECTORS_ERROR_MSG
        call print_string

        jmp disk_error

disk_error:
        mov bx, _newline
        call print_string

        ; halt here
        jmp $

DISK_READ_ERROR_MSG:    db "[disk error]: read", 0
DISK_SECTORS_ERROR_MSG: db "[disk error]: sectors read != sectors expected", 0
_newline:               db 10, 13, 0
