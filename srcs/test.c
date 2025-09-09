#include <string.h>
#include <stdio.h>
#include <stdlib.h>

int _ft_strlen(char *string);
char *_ft_strcpy(char *dest, char *src);
int _ft_strcmp(char *s1, char *s2);

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

	return 0;
}
