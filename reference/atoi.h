#include <stdio.h>
#include <assert.h>

// Read an ASCII string, convert it to an integer.
//
int _atoi(char *str) {
  int n = 0;
  char c;

  while (c = *str++) {
    c -= '0'; // convert ASCII to digit value
    n *= 10;  // increase prev digit by factor of the base
    n += c;   // add this digit
  }

  return n;
}
