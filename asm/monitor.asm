; vim: :set ft=nasm:
[bits 16]
main:
  push bp
  mov bp, sp
  sub sp, 0
  push 0
  pop ax
  mov sp, bp
  pop bp
  ret
monitor_repl:
  push bp
  mov bp, sp
  sub sp, 0
  push 65
  pop di
  call putchar
  push ax
  pop ax
  mov sp, bp
  pop bp
  ret
putchar:
  push bp
  mov bp, sp
  sub sp, 8
  mov [bp-8], di
  mov al, 65
  mov ah, 14
  int 16
  pop ax
  mov sp, bp
  pop bp
  ret
