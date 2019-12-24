int main(int argc, char** argv)
{
        char* video_memory = (char *)0xb8000;

        *video_memory = 'X';
}
