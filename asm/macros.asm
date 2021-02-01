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

; Initialize the stack.
;
%macro bios.setup_stack 0
  mov ax, 0      ; set up segments
  mov ds, ax
  mov es, ax
  mov ss, ax     ; setup stack
  mov sp, 0x7c00 ; stack grows downwards from 0x7c00
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

;---------------------
; IO
;---------------------

%macro io.puts_str 1
  mov bx, %1
  call io._puts_str
%endmacro

%macro io.print_str 1
  mov bx, %1
  call io._print_str
%endmacro
