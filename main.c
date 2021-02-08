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

  // defensive input sanitization, oof
  if ((c - '0') > 9) {
    printf("error: `%c` is not a number\n", c);
    err = 1;
    goto done;
  }

  // subtract 0x30 to convert ASCII digit to integer value
  c -= '0';

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


// Read an integer, one character at a time.
//
int readnum(char *str) {
  printf("reading a number...\n");

  int n;  // Our sum
  char c; // Current character read

  // Read in a character's ASCII value, add to current sum
  c = *str++;
nextchar:
  // Done if at end of string
  if (c == 0)
    goto done;

  printf("->\n");

  if ((c - '0') > 9) {
    printf("error: %d is not a number\n", c);
    n = -1;
    goto done;
  }
  printf("c: %d = %c\n", c, c);

  // Subtract 0x30 to get ASCII digits
  c -= '0';

  n = n * 10 + c;

  printf("n = %d\n", n);

  c = *str++;

  goto nextchar;

done:
  return n;
}

int main()
{
  int n;
  char *valid    = "143",
       *negative = "-42",
       *err      = "9001error";

  n = atoi(valid);
  assert(n == 143);

  n = atoi(negative);
  assert(n == -42);

  n = atoi(err);
}
