

// Read an integer, one character at a time.
//
int readnum() {
  printf("reading a number...\n");

  int n, // our sum
      c; // current character read

  n = 0;

  // Read in a character's ASCII value, add to current sum
  c = getchar();
nextchar:
  if (c == -1) // EOF
    goto done;
  if (c == '\n')
    goto done;

  if ((c - '0') > 9) {
    printf("error: %d is not a number\n", c);
    c = -1;
    goto done;
  }

  // Subtract 0x30 to get ASCII digits
  c -= '0';

  n = n * 10 + c;

  printf("n = %d\n", n);

  c = getchar();
  goto nextchar;

done:
  return n;
}

int main()
{
  int n;
loop:
  n = readnum();
  if (n == 42)
    return n;
  goto loop;
}
