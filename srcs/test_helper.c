#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#define LINE_WIDTH 92

void print_line(void)
{
    for (int i = 0; i < LINE_WIDTH; i++)
        putchar('-');
    putchar('\n');
}

void print_name(const char *function)
{
    int len = strlen(function);
    int inside_width = LINE_WIDTH - 2; // car on a | et |

    // calcul des espaces avant et après
    int left_pad  = (inside_width - len) / 2;
    int right_pad = inside_width - len - left_pad;

    printf("|%*s%s%*s|\n", left_pad, "", function, right_pad, "");
}

void print_title(const char *title)
{
    print_line();
    print_name(title);
    print_line();
}
