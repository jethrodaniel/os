; vim: :set ft=nasm:

[bits 16]

;---------------------
; BIOS
;---------------------

; Initialize tty mode to allow printing to the screen.
;
%macro bios.init_tty_mode 0
  mov ah, 0x0e
%endmacro

; BIOS call to read an ASCII character into `al`.
;
%macro bios.read_char_into_al 0
  mov ah, 00h
  int 16h
%endmacro

; BIOS call to print the ASCII character in `al`.
;
%macro bios.print_char_in_al 0
  int 0x10
%endmacro

;---------------------
; Subroutines
;---------------------

%macro subroutine_start 0
  pusha ; Push all registers onto the stack
%endmacro

%macro subroutine_end 0
  popa ; Pop all registers off the stack
  ret  ; Return from this subroutine
%endmacro
