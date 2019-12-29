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
        /* *(video_memory + 2) = 'X'; */
        /* *(video_memory + 3) = FB_GREEN; */

        fb_write_cell(2, 'h', FB_BLACK, FB_WHITE);
        fb_write_cell(4, 'i', FB_BLACK, FB_WHITE);
        fb_write_cell(6, '!', FB_BLACK, FB_WHITE);


        /* set_cursor(10); */
}
