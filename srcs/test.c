#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int _ft_strlen(char *string);
char *_ft_strcpy(char *dest, char *src);
int _ft_strcmp(char *s1, char *s2);
int _ft_write(int fd, const void *buffer, size_t count);
ssize_t _ft_read(int fd, void *buf, size_t count);
char *_ft_strdup(char *s);

int main(void)
{
	char *string = "hello world!";
	printf("og strlen = %lu\n", strlen(string));
	printf("asm strlen = %d\n", _ft_strlen(string));

	// --------------------------------------------------------------- //

	char *og_src = "Hello You! You've succeed at strcpy apparently";
	char *og_dest = malloc(100);
	char *asm_dest = malloc(100);
	char *ret_og = strcpy(og_dest, og_src);
	char *ret_asm = _ft_strcpy(asm_dest, og_src);
	printf("og strcpy = %s\n", ret_og);
	printf("asm strcpy = %s\n", ret_asm);

	// --------------------------------------------------------------- //

	char *s1 = "hello world";
	char *s2 = "hello world";

	printf("og strcmp = %d\n", strcmp(s1, s2));
	printf("asm ft_strcmp = %d\n", _ft_strcmp(s1, s2));

	// --------------------------------------------------------------- //

	int asm_write_ret = _ft_write(1, "asm_write : Hello World!\n", 25);
	int write_ret = write(1, "og write : Hello World!\n", 25);

	printf("%d\n", write_ret);
	printf("%d\n", asm_write_ret);

	// --------------------------------------------------------------- //

	char buffer[1024];

	int asm_read_ret = _ft_read(0, buffer, sizeof(buffer));
	int read_ret = read(0, buffer, sizeof(buffer));

	printf("asm_read = %d\n", asm_read_ret);
	printf("read = %d\n", read_ret);

	// --------------------------------------------------------------- //

	char *msg = _ft_strdup("strdup ca marche");
	printf("_ft_strdup() = %s\n", msg);

	return 0;
}
