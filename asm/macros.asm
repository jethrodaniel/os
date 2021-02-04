; vim: :set ft=nasm:

[bits 16]

;---------------------
; BIOS
;---------------------

; BIOS call to read an ASCII character into `al`.
;
%macro bios.read_char_into_al 0
  mov ah, 00h
  int 16h
%endmacro

; BIOS call to print the ASCII character in `al`.
;
%macro bios.print_char_in_al 0
  mov ah, 0eh
  int 0x10
%endmacro
