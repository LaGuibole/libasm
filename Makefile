NAME = libasm.a
SRC_DIR = srcs/
OBJ_DIR = objs/

CC = gcc
CFLAGS = -Wall -Wextra -Werror -g

SRCS = test.c
OBJS = $(patsubst %.c,$(OBJ_DIR)%.o,$(SRCS))

all: $(NAME)

$(NAME): $(OBJS)
	@ar rcs $(NAME) $(OBJS)
	@ranlib $(NAME)

$(OBJ_DIR)%.o : $(SRC_DIR)%.c
	@mkdir -p $(dir $@)
	@$(CC) $(CFLAGS) -c $< -o $@

clean:
	@rm -f $(OBJS)
	@rm -rf $(OBJ_DIR)

fclean: clean
	@rm -rf $(NAME)

re: fclean all

.PHONY: all clean fclean re
