#include <stdio.h>
#include <stdlib.h>

// Globlals.
//
char newline[] = "\n";
char hex_table[] = "0123456789ABCDEF";

// Print the null-terminated string `str`.
//
int io_print(char *str) {
  char c;

  while (c = *str++)
    putchar(c);
}


// Print the null-terminated string `str`, then a newline.
//
int io_puts(char *str) {
  io_print(str);
  io_print(newline);
}


// Read a \n-terminated string into `str`, echo characters as typed.
//
// NOTE: c gives us echo for free, and only returns a `\n`, not `\n\r`.
//
char *io_readline(char *str) {
  char c;

  while (c = getchar(), c != '\n') {
    // putchar(c);
    *str++ = c;
  }

  return str;
}

int io_print_hex(int n) {
  char *stack = malloc(25 * sizeof(char)),
       c;
  int i, digit;

  do {
    digit = n % 16;
    n /= 16;

    // push
    *stack++ = hex_table[digit];
    i++;
  } while (n > 0);
  stack--;

  putchar('0');
  putchar('x');

  while (i >= 0) {
    // pop
    c = *stack--;
    i--;
    putchar(c);
  }
}


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

  printf("io_readline: ");
  io_readline(input);
  printf("io_puts: ");
  io_puts(input);

  return 0;
}
