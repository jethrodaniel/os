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
; - setting up a stack
; - enable protected mode (drop out of real mode)
; - jumping into 32-bit mode, or later, into 64-bit
;
; References:
;
; - http://www.cs.cmu.edu/~410-s07/p4/p4-boot.pdf
; - https://appusajeev.wordpress.com/2011/01/27/writing-a-16-bit-real-mode-os-nasm/
; - https://web.mit.edu/rhel-doc/4/RH-DOCS/rhel-rg-en-4/s1-boot-init-shutdown-process.html
;
; == 16-bit mode
;
; The x86 16 bit mode ...
;
; == Interrupts
;
; - the list: http://www.ctyme.com/rbrown.htm

;------------------------;

[bits 16]

; Add a global offset, so we don't have to add 0x7c00 to all the addresses.
;
[org 0x7c00]

;---------------------
; Macros
;---------------------

%include "asm/macros.asm"

;---------------------
; Entry-point
;---------------------

init:
  ; Setup stack.
  ;
  ; set stack base to an address far away from 0x7c00 so that we don't
  ; get overwritten by our bootloader.
  ;
  ; if the stack is empty then sp points to bp.
  mov bp, 0x9000
  mov sp, bp

  ; BIOS stores our boot drive in dl
  mov [data.boot_drive], dl

  mov bx, data.startup_msg
  call io.puts

  call repl

  mov bx, data.got_to_end_msg
  call io.print
  jmp $ ; hang

;---------------------
; Other assembly files
;---------------------

%include "asm/io.asm"
%include "asm/repl.asm"

;---------------------
; Data
;---------------------

data.startup_msg: db "[boot] System started in 16-bit real mode", 0
data.exit_msg:    db "[boot] Exited.", 0
data.newline:     db 10, 13, 0
data.repl_msg:    db "Enter a command below, and it will be evaluated", 0
data.prompt:      db "? ", 0
data.result_prompt:  db "=> ", 0
data.got_to_end_msg: db "Unexpected kernel exit"
data.boot_drive: db 0
data.input: resb 25 ; 25 characters of user input

;---------------------
; Required ending
;---------------------

times 510-($-$$) db 0 ; Pad to the 510th byte with zeros
dw 0xaa55             ; Tack the magic 2-byte constant at the end
