// copy bytes from one place to another
void memory_copy(char* source, char* destination, int num_bytes)
{
        int i;
        for (i = 0; i < num_bytes; i++)
                *(destination + i) = *(source + i);
}
