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

// Demo
//
int main()
{
  char input[25];

  char str[] = "testing, 1, 2, 3...\n";

  io_print(str);
}
