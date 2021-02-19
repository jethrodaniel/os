// https://github.com/jethrodaniel/z

main() {}

monitor_repl() {
  putchar(65);
}

// TODO: support args
//
putchar(c) {
  asm {
    mov al, 65;
    mov ah, 14; // 0eh
    int 16;     // 0x10
  }
}
