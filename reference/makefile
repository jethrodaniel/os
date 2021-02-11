default: clean atoi io
io:
	@echo -e "\n=== io test ==="
	$(CC) $@.c -o $@.exe && ./$@.exe
	@echo "=== ok ==="
atoi:
	@echo -e "\n=== atoi() test ==="
	$(CC) $@.c -o $@.exe && ./$@.exe
	@echo "=== ok ==="
clean:
	rm -f *.exe
