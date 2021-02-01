; vim: :set ft=nasm:

; This is a program to be booted by an x86 computer.
;
; == x86 boot sequence
;
; When the computer is booted, it looks at the end of system memory for the
; BIOS (Basic Input/Output System) program, then runs it. This is a chunk of
; startup code located in read-only memory, which provides low-level access to
; the system.
;
; BIOS checks the system, locates peripherial devices, then locates bootable
; devices A bootable device is one such that the first 512 bytes ends with the
; magic number 0x55aa. That first 512 bytes is known as the Master Boot Record
; (MBR), or the device's bootloader.
;
; After the user (or the BIOS) selects a boot device, BIOS loads that device's
; bootloader into memory at address 0x7c00, then passes control to it.
;
; At this point, the CPU is executing in 16-bit real mode.
;
; == x86 bootloader
;
; At this point, the bootloader has a few jobs:
;
; 1. load more code
;
; Since 512 bytes isn't much to work with, the bootloader's main job is
; to load more code from disk into memory.
;
; Many bootloaders load yet another bootloader, in a process known as
; chaining.
;
; 2. Initialize the CPU
;
; Assorted other things, depending on what you're doing
;
; - setting up a stack (if needed, such as for C)
; - enable protected mode (drop out of real mode)
; - jumping into 32-bit mode, or later, into 64-bit
;
; References:
;
; - https://appusajeev.wordpress.com/2011/01/27/writing-a-16-bit-real-mode-os-nasm/
; - https://web.mit.edu/rhel-doc/4/RH-DOCS/rhel-rg-en-4/s1-boot-init-shutdown-process.html


; x86 BIOS begins execution in 16-bit real mode.
;
[bits 16]

; Using NASM sugar to add a global offset, so we don't have to add
; 0x7c00 to all the addresses.
;
[org 0x7c00]

init:
  mov bx, msg_real
  call print_string

  mov bx, newline
  call print_string

  jmp $ ; hang

%include "asm/print_string.asm"

msg_real:   db "[boot] started in 16-bit real mode...", 0
newline:    db 10, 13, 0

; Padding and magic BIOS number
times 510-($-$$) db 0 ; pad to the 510th byte with zeros
dw 0xaa55             ; tack the magic 2-byte constant at the end
