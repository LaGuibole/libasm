#include <string.h>
#include <stdio.h>
#include <stdlib.h>

int ft_strlen(char *string);
char *ft_strcpy(char *dest, char *src);

int main(void)
{
	char *string = "hello world!";
	printf("og strlen = %lu\n", strlen(string));
	printf("asm strlen = %d\n", ft_strlen(string));

	char *og_src = "Hello You! You've succeed at strcpy apparently";
	char *og_dest = malloc(100);

	char *asm_dest = malloc(100);
	char *ret_og = strcpy(og_dest, og_src);
	char *ret_asm = ft_strcpy(asm_dest, og_src);
	printf("og strcpy = %s\n", ret_og);
	printf("asm strcpy = %s\n", ret_asm);

	return 0;
}
