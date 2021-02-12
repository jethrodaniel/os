; vim: :set ft=nasm:

[bits 16]


; Read `dh` sectors from disk `dl` into memory, starting at the second
; sector (in our case, after the bootloader).
;
; TODO: more generic
;
disk_load:
  push dx ; preserve requested number of sectors across BIOS call

  mov ah, 0x02 ; BIOS read sector function
  mov al, dh   ; read dh sectors
  mov ch, 0x00 ; select cylinder 0
  mov dh, 0x00 ; select head 0
  mov cl, 0x02 ; start reading from the second sector (after the bootloader)
  int 0x13     ; execute BIOS call

  jc .read_error ; jump if read error

  pop dx ; restore number of sectors

  ; if sectors read (al) != sectors expected (dh), raise an error
  cmp dh, al
  jne .sectors_error

.return:
  ret

.read_error:
  bios.print_newline
  mov bx, data.disk_read_err_msg
  call io.print

  jmp .disk_error

.sectors_error:
  bios.print_newline
  mov bx, data.disk_sectors_err_msg
  call io.print

  jmp .disk_error

.disk_error:
  bios.print_newline
  mov bx, data.disk_sectors_err_msg
  call io.print

  jmp $ ; halt

data.disk_read_err_msg:    db "[disk error]: read", 0
data.disk_sectors_err_msg: db "[disk error]: sectors read != sectors expected", 0
