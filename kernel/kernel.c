#include "../drivers/screen.h"

int main(int argc, char** argv)
{
        char* video_memory = (char *)0xb8000;

        *video_memory = 'X';

        print("yo!!!!!!!!!!!1!");

        //int offset = get_screen_offset(3, 4);
        //offset += '0';
}
