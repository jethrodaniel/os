#include <stdio.h>
/* #include <string> */

#define MAX_LENGTH 255

int main(int argc, char **argv) {

  char input[MAX_LENGTH];
  char c;
  int len;

  printf("forth. ^D to exit.\n");

loop:
  len = 0;
  printf("? ");

  while ((c = getchar()) != '\n' && c != EOF && len < MAX_LENGTH - 1) {
    input[len++] = c;
  }

  if (c == '\n' && len == 0)
    goto loop;

  if (c == EOF) {
    printf("bye.\n");
    return 0;
  }

  input[len] = '\0';
  printf("=> %s\n", input);
  goto loop;

  // if (c == '\r') {
  //   printf("\n? ");
  //   continue;
  // }

  return 0;
}
