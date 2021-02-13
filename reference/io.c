#include "io.h"

// Demo
//
int main() {
  char input[25];

  char str[] = "testing, 1, 2, 3...\n";

  printf("io_print: ");
  io_print(str);

  printf("io_puts: ");
  io_puts(str);

  printf("io_print_hex:");
  printf("\n");
  io_print_hex(291);
  printf("\n");
  io_print_hex(4660);
  printf("\n");
  io_print_hex(74565);
  printf("\n");
  io_print_hex(1193046);
  printf("\n");
  io_print_hex(48879);
  printf("\n");

  // printf("io_readline: ");
  // io_readline(input);
  // printf("io_puts: ");
  // io_puts(input);

  return 0;
}
