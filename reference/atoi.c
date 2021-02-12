#include <stdio.h>
#include <assert.h>

// Read an ASCII string, convert it to an integer.
//
int atoi(char *str) {
  int n = 0, // our sum
    neg = 0; // is this a negative number?

  char c = *str++; // current char

  if (c == '-') {
    c = *str++; // eat the `-`
    neg = 1;    // flag as negative
  }

  while (c) {
    c -= '0'; // convert ASCII to digit value

    // check for invalid numbers, print error message
    if (c > 9 || c < 0) {
      c += '0';
      printf("error: `%d = %c` is not a number\n", c, c);
      return;
    }

    n *= 10; // increase prev digit by factor of the base
    n += c;  // add this digit
    c = *str++; // get next char ('0' if end of input)
  }
  if (neg)
    n = -1 * n;

  return n;
}

// Demo.
//
int main() {
  int n;
  char *valid    = "143",
       *negative = "-42",
       *err      = "9001error";

  n = atoi(valid);
  assert(n == 143);

  n = atoi(negative);
  assert(n == -42);

  n = atoi(err);
  printf("n = %d\n", n);

  return 0;
}
