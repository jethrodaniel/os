; vim: :set ft=nasm:

[bits 16]

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

; Subroutines preserve some registers, in order to avoid messing
; with the caller's registers (except for any intended side-effects,
; such as for a "return" value).

%macro subroutine_start 0
  ; Push all registers onto the stack
  pusha
%endmacro

%macro subroutine_end 0
  ; Pop all registers off the stack
  popa

  ; Return from this subroutine
  ret
%endmacro
