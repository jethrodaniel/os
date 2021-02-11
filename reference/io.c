#include <stdio.h>

// Globlals.
//
char newline[] = "\n";

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


// Demo
//
int main() {
  char input[25];

  char str[] = "testing, 1, 2, 3...\n";

  printf("io_print: ");
  io_print(str);

  printf("io_puts: ");
  io_puts(str);

  printf("io_readline: ");
  io_readline(input);

  printf("io_puts: ");
  io_puts(input);
}
