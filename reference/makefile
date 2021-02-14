CC=gcc -g
default: clean atoi io
io:
	@echo -e "\n=== io test ==="
	$(CC) $@.c -o $@.exe && ./$@.exe
	@echo "=== ok ==="
atoi:
	@echo -e "\n=== atoi() test ==="
	$(CC) $@.c -o $@.exe && ./$@.exe
	@echo "=== ok ==="
forth:
	$(CC) $@.c -o $@.exe && ./$@.exe
clean:
	rm -f *.exe
