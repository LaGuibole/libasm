#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include "test_helper.c"

typedef struct s_list {
	void *data;
	struct s_list *next;
} t_list;

int ft_strlen(char *string);
char *ft_strcpy(char *dest, char *src);
int ft_strcmp(char *s1, char *s2);
int ft_write(int fd, const void *buffer, size_t count);
ssize_t ft_read(int fd, void *buf, size_t count);
char *ft_strdup(char *s);
void ft_putstr(char *str);
int ft_atoi_base(char *str, char *str_base);
char *ft_strchr(char *str, int c);
t_list *ft_list_new(void *data);
void ft_list_push_front(t_list **begin_list, void *data);
int	ft_list_size(t_list *begin_list);

int *box_int(int nb)
{
    int *p = malloc(sizeof *p);
    if (!p)
    {
        perror("malloc");
        exit(1);
    }
    *p = nb;
    return p;
}

void free_list_int(t_list *lst)
{
    while (lst)
    {
        t_list *nb = lst->next;
        free(lst->data);
        free(lst);
        lst = nb;
    }
}


int main(void)
{

	print_title("FT_STRLEN");
	char *string = "hello world!";
	printf("og strlen = %lu\n", strlen(string));
	printf("asm strlen = %d\n", ft_strlen(string));

	// --------------------------------------------------------------- //

	print_title("FT_STRCPY");
	char *og_src = "Hello You! You've succeed at strcpy apparently";
	char *og_dest = malloc(100);
	char *asm_dest = malloc(100);
	char *ret_og = strcpy(og_dest, og_src);
	char *ret_asm = ft_strcpy(asm_dest, og_src);
	printf("og strcpy = %s\n", ret_og);
	printf("asm strcpy = %s\n", ret_asm);

	// --------------------------------------------------------------- //

	print_title("FT_STRCMP");
	char *s1 = "hello world";
	char *s2 = "hello world";

	printf("og strcmp = %d\n", strcmp(s1, s2));
	printf("asm ft_strcmp = %d\n", ft_strcmp(s1, s2));

	// --------------------------------------------------------------- //

	print_title("FT_WRITE");
	int asm_write_ret = ft_write(1, "asm_write : Hello World!\n", 25);
	int write_ret = write(1, "og write : Hello World!\n", 25);

	printf("%d\n", write_ret);
	printf("%d\n", asm_write_ret);

	// --------------------------------------------------------------- //

	print_title("FT_READ");
	char buffer[1024];

	int asm_read_ret = ft_read(0, buffer, sizeof(buffer));
	int read_ret = read(0, buffer, sizeof(buffer));

	printf("asm_read = %d\n", asm_read_ret);
	printf("read = %d\n", read_ret);

	// --------------------------------------------------------------- //

	print_title("FT_STRDUP");
	char *msg = ft_strdup("strdup ca marche");
	printf("_ft_strdup() = %s\n", msg);

	// --------------------------------------------------------------- //

	print_title("FT_ATOI_BASE");
	int atoi_result = ft_atoi_base("2a", "0123456789abcdef");
	printf("_ft_atoi_base() = %d\n", atoi_result);

	// --------------------------------------------------------------- //

	print_title("FT_LST_SIZE");
	printf("Test 1 : Liste vide\n");
	t_list *head = NULL;
	int size = ft_list_size(head);
	printf("List size = %d\n", size);

	printf("Test 2 : Singleton\n");
	head = ft_list_new(box_int(42));
	size = ft_list_size(head);
	printf("List size = %d\n", size);

	return 0;
}
