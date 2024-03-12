CC = gcc -std=c11 -Wall -Wextra -Werror
OS = $(shell uname)
NAME_TEST = test_solve_equation
NAME_LIB = solve_equation.a
SRCS = quadratic_equation.c
OBJS = $(SRCS:.c=.o)

ifeq ($(OS), Linux)
	FLAGS = -lcheck -lm -lpthread -lrt -lsubunit
else
	FLAGS = -lcheck -lm
endif

all: check

%.o: %.c
	$(CC) -c -o $@ $<

check: clean clang $(NAME_LIB) $(NAME_TEST).o  
	$(CC)  $(NAME_TEST).o $(NAME_LIB) $(FLAGS) -o test
	./test

create_tests:
	checkmk clean_mode=1 $(NAME_TEST).check > $(NAME_TEST).c

$(NAME_TEST).o: create_tests
	$(CC) -w -c $(NAME_TEST).c

$(NAME_LIB): $(OBJS)
	ar -rc $(NAME_LIB) $(OBJS)
	ranlib $(NAME_LIB)
	rm -rf *.o

clean:
	-@rm *.o solve_equation.a test $(NAME_TEST).c

clang:
	clang-format --style=google -i *.c
