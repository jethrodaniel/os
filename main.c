#include <stdio.h>
#include <assert.h>

// Read an ASCII string, convert it to an integer.
//
int atoi(char *str) {
  int n = 0, // our sum
      i = 0, // position, for skipping leading negative sign
    neg = 0, // is this a negative number?
    err = 0; // did we error?

  char c = *str++; // current char

  if (c == '-') {
    c = *str++; // eat the `-`
    neg = 1;    // flag as negative
  }

nextchar:
  // finish if we're at the end of the string
  if (c == 0)
    goto done;

  // subtract 0x30 to convert ASCII digit to integer value
  c -= '0';

  // check for invalid numbers, print error message, set error flag
  if (c > 9 || c < 0) {
    c += '0';
    printf("error: `%d = %c` is not a number\n", c, c);
    err = 1;
    goto done;
  }

  // increase previous digit by a factor of the base
  n = n * 10;

  // add this digit
  n = n + c;

  // get next character (may be '0' if end of input)
  c = *str++;

  goto nextchar;
done:
  // neg n
  if (neg)
    n = -1 * n;

  return n;
}

// Read a character.
//
char _getchar() {
  // BIOS
  return getchar();
}

int main()
{
  int n;
  char *valid    = "143",
       *negative = "-42",
       *err      = "9001error";
  char input[25];

  n = atoi(valid);
  assert(n == 143);

  n = atoi(negative);
  assert(n == -42);

  n = atoi(err);
  printf("n = %d\n", n);

  printf("enter a num: ", n);
  n = atoi(num);
  printf("n = %d\n", n);
}
