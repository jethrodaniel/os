#include "../drivers/screen.h"

int main(int argc, char** argv)
{
        char* video_memory = (char *)0xb8000;
        *video_memory = 'X';

        /* clear_screen(); */
        /* print("yo!!!!!!!!!!!1!"); */
        char c = 'X';
        int col = 1,
            row = 1;
        char attr = 0;
        print_char(c, col, row, attr);

        /* int offset = get_screen_offset(3, 4); */
        /* offset += '0'; */

        /* set_cursor(10); */
}
