# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: guphilip <guphilip@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/09/08 16:32:45 by guphilip          #+#    #+#              #
#    Updated: 2025/09/09 17:00:33 by guphilip         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

NAME     = libasm.a
SRC_DIR  = srcs
OBJ_DIR  = objs

ASM      = nasm
ASMFLAGS = -felf64 -g
ASMFLAGS_MACOS = -fmacho64

CC       = cc
CFLAGS   = -Wall -Wextra -Werror -g

SRCS     = $(SRC_DIR)/ft_strlen.s $(SRC_DIR)/ft_strcpy.s $(SRC_DIR)/ft_strcmp.s $(SRC_DIR)/ft_write.s $(SRC_DIR)/ft_read.s $(SRC_DIR)/ft_strdup.s
OBJS     = $(SRCS:$(SRC_DIR)/%.s=$(OBJ_DIR)/%.o)

TEST_SRC = $(SRC_DIR)/test.c
TEST_OBJ = $(OBJ_DIR)/test.o
TEST_BIN = run_test

# ----------------------------------------------------------------- #

all: $(NAME)

$(NAME): $(OBJS)
	@ar rcs $@ $^
	@ranlib $@

# .s -> .o via NASM
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.s
	@mkdir -p $(dir $@)
	@$(ASM) $(ASMFLAGS) -o $@ $<

# .c -> .o via cc
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c
	@mkdir -p $(dir $@)
	@$(CC) $(CFLAGS) -c $< -o $@

# test binary
$(TEST_BIN): $(TEST_OBJ) $(NAME)
	@$(CC) $(CFLAGS) -o $@ $(TEST_OBJ) -L. -lasm

test: $(TEST_BIN)
	@./$(TEST_BIN)

clean:
	@rm -f $(OBJS) $(TEST_OBJ)
	@rm -rf $(OBJ_DIR)

fclean: clean
	@rm -f $(NAME) $(TEST_BIN)

re: fclean all

mac: ASMFLAGS = -fmacho64
mac: re

linux: ASMFLAGS = -felf64
linux: re

.PHONY: all clean fclean re test
