#include "../drivers/screen.h"

int main(int argc, char** argv)
{
        /* clear_screen(); */
        /* print("yo!!!!!!!!!!!1!"); */
        /* char c = 'X'; */
        /* int col = 1, */
            /* row = 1; */
        /* char attr = 0; */
        /* print_char(c, col, row, attr); */

        /* char* video_memory = (char *)0xb8000; */
        /* *(video_memory + 3) = 'X'; */

        fb_write_cell(1, 'A', FB_GREEN, FB_DARK_GREY);


        /* set_cursor(10); */
}
