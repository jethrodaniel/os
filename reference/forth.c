#include "io.h"
#include "atoi.h"

// Demo
//
int main() {
  char *input,
       prompt[] = "? ";
  int n;

  while (1) {
    input = malloc(25);

    io_print(prompt);

    io_readline(input);
    n = _atoi(input);

    io_print_hex(n);

    if (input)
      io_print("\n");
  }
}
