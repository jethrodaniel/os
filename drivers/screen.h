#ifndef SCREEN_H
#define SCREEN_H

#include "../kernel/low_level.h"
#include "../kernel/util.h"

#define VIDEO_ADDRESS 0xb8000
#define MAX_ROWS 25
#define MAX_COLS 80

// attribute byte for our default color scheme
#define WHITE_ON_BLACK 0x07

// screen device i/o ports
#define REG_SCREEN_CTRL 0x3d4
#define REG_SCREEN_DATA 0x3d5

unsigned int get_screen_offset(unsigned int col, unsigned int row);
int get_cursor();
void set_cursor(int offset);
int handle_scrolling(int cursor_offset);
void print_char(char character, int col, int row, char attribute_byte);
void print_at(char* message, int col, int row);
void print(char* message);
void clear_screen();
void fb_write_cell(unsigned int i, char c, unsigned char fg, unsigned char bg);

#define FB_BLACK          0x0
#define FB_BLUE           0x1
#define FB_GREEN          0x2
#define FB_CYAN           0x3
#define FB_RED            0x4
#define FB_MAGENTA        0x5
#define FB_BROWN          0x6
#define FB_GRAY           0x7
#define FB_DARK_GREY      0x8
#define FB_BRIGHT_BLUE    0x9
#define FB_BRIGHT_GREEN   0xa
#define FB_BRIGHT_CYAN    0xb
#define FB_BRIGHT_RED     0xc
#define FB_BRIGHT_MAGENTA 0xd
#define FB_YELLOW         0xe
#define FB_WHITE          0xf

#endif // SCREEN_H
