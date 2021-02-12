; vim: :set ft=nasm:

;--------------------
; This is a program to be booted by an x86 computer.
;
; References:
;
; - http://www.cs.cmu.edu/~410-s07/p4/p4-boot.pdf
;
; == x86 boot sequence
;
; BIOS begins like so:
;
; - run a system check
; - dicover peripherials
; - discover drives and bootloaders
; - relocate one bootloader to 0x7c00 and execute it
;
; That bootloader is stage0, below.
;
;--------------------

;-------------------- Stage 0 --------------------
;
; The bootloader is constrained (along with the partition table), to
; the first sector of the disk (512 bytes). As such, the first thing
; a bootloader does is usually to load a second stage of the
; bootloader.
;
; Stage0 will:
;
; - [ ] disable interrupts
; - [ ] canonicalize %CS:%EIP
; - [ ] load segment registers (%DS, %ES, %FS, %GS, %SS)
; - [ ] set the stack pointer
; - [ ] enable interrupts
; - [ ] reset the floppy disk controller
; - [ ] read stage1 sectors from the floppy
; - [ ] jump to stage1 code
;
;-------------------------------------------------

; x86 boots up into 16-bit real mode.
;
[bits 16]

; Add a global offset, so we don't have to add 0x7c00 to all
; the addresses.
;
[org 0x7c00]

; Entry-point
;
data.stage0:
  ; BIOS stores our boot drive in dl, we take note of this.
  ;
  mov [data.boot_drive], dl

  ; Setup stack.
  ;
  ; The stack grows from high addresses to low addresses.
  ;
  mov  bp, 0x7c00
  xor  ax, ax
  mov  ds, ax
  mov  es, ax
  mov  ss, ax
  mov  sp, bp

  mov bx, data.stage0_msg
  call io.puts

  mov bx, data.stage1_msg
  call io.print

  call load_stage1
  call data.stage1

  mov bx, data.stage0_end_msg
  call io.print
  jmp $

; Helpers
;
%include "asm/io.asm"
%include "asm/disk_load.asm"

; Load up more space from disk, then jump to stage 1.
;
; We load 512 bytes * 5 = 2560 bytes = 2.56Kb
;
load_stage1:
  mov bx, data.stage1
  mov dh, 5
  mov dl, [data.boot_drive]
  call disk_load
  ret

; Data
;
data.stage0_msg:     db "stage0| BIOS has loaded stage0.", 0
data.stage1_msg:     db "stage0| Loading stage1...", 0
data.stage0_end_msg: db 10, 13, "stage0| Error - returned from stage1."
data.ok_msg:         db " ok", 0
data.newline:        db 10, 13, 0
data.boot_drive:     db 0

; Required ending.
;
; The bootloader must by 512 bytes, with 0x55aa as the last 2 bytes.
;
times 510-($-$$) db 0 ; Pad to the 510th byte with zeros
dw 0xaa55             ; Tack the magic 2-byte constant at the end


;-------------------- Stage 1 --------------------
;
; Begin executing at address 0x7ee, the second boot sector
;
; Stage 1 will:
;
; - ...
;
;-------------------------------------------------

data.stage1:
  mov bx, data.ok_msg
  call io.puts

  call forth_repl

  mov bx, data.forth_example
  call forth_exec

  mov bx, data.stage1_end_msg
  call io.print
  jmp $

%include "asm/forth.asm"

data.stage1_end_msg: db "stage1| Error - returned from forth", 0
data.forth_example:  incbin "hi.fs"
