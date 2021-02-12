#include <stdio.h>
#include <stdlib.h>

// Globlals.
//
char newline[] = "\n";


// Get a character of input, echo as typed.
//
#define io_getc(c) getchar(c)


// Print the character c.
//
#define io_putc(c) putchar(c)


// Print the null-terminated string `str`.
//
int io_print(char *str) {
  char c;

  while (c = *str++)
    io_putc(c);
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

  while (c = io_getc(), c != '\n')
    *str++ = c;

  return str;
}


// Print a number `n` in hexadecimal.
//
int io_print_hex(int n) {
  char *stack = malloc(25 * sizeof(char)),
       c;
  int i, digit;

  do {
    digit = n % 16;
    n /= 16;

    // convert to ascii
    digit += '0';
    if (digit > '9')
      digit += 7;

    // push
    *stack++ = digit;
    i++;
  } while (n > 0);
  stack--;

  io_putc('0');
  io_putc('x');

  while (i >= 0) {
    // pop
    c = *stack--;
    i--;
    io_putc(c);
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
  io_print_hex(48879);
  printf("\n");

  printf("io_readline: ");
  io_readline(input);
  printf("io_puts: ");
  io_puts(input);

  return 0;
}
