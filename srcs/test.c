#include <string.h>
#include <stdio.h>

int ft_strlen(char *string);

int main(void)
{
	char *string = "hello world!";
	printf("og strlen = %lu\n", strlen(string));
	printf("asm strlen = %d\n", ft_strlen(string));

	return 0;
}
