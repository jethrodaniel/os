#ifndef SCREEN_H
#define SCREEN_H

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

#endif // SCREEN_H
