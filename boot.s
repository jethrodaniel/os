# https://50linesofco.de/post/2018-02-28-writing-an-x86-hello-world-bootloader-with-assembly

.code16      # tell the assembler that we're using 16 bit mode
.global init # make our label 'init' available to the outside

init:
  mov $msg, %si # loads the address of msg into si
  mov $0xe, %ah # loads 0xe (function number for int 0x10) into ah
print_char:
  lodsb # loads the byte from the address in si into al and increments si
  cmp $0, %al # compares content in AL with zero
  je done # if al == 0, go to "done"
  int $0x10 # prints the character in al to screen
  jmp print_char # repeat with next byte
done:
  hlt # stop execution

msg: .asciz "Hello world!" # stores the string (plus a byte with value "0") and gives us access via $msg

.fill 510-(.-init), 1, 0 # add zeroes to make it 510 bytes long
# Oh wait... if the magic bytes are 0x55aa, why are we swapping them here?
# That is because x86 is little endian, so the bytes get swapped in memory.
.word 0xaa55 # magic bytes that tell BIOS that this is bootable

