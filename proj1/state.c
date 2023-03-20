#include "state.h"

#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "snake_utils.h"

/* Helper function definitions */
static void set_board_at(game_state_t* state, unsigned int row, unsigned int col, char ch);
static bool is_tail(char c);
static bool is_head(char c);
static bool is_snake(char c);
static char body_to_tail(char c);
static char head_to_body(char c);
static unsigned int get_next_row(unsigned int cur_row, char c);
static unsigned int get_next_col(unsigned int cur_col, char c);
static void find_head(game_state_t* state, unsigned int snum);
static char next_square(game_state_t* state, unsigned int snum);
static void update_tail(game_state_t* state, unsigned int snum);
static void update_head(game_state_t* state, unsigned int snum);

/* Task 1 */
game_state_t* create_default_state() {
  // TODO: Implement this function.
  game_state_t *new_state;
  new_state = malloc(sizeof(game_state_t));
  if (new_state == NULL) {
      fprintf(stderr, "Out of memory.\n");
      exit(1);
  }
  new_state->num_rows = 18;
  new_state->num_snakes = 1;
    new_state->board = malloc(378 * sizeof(char));
    for (int i = 0; i < 18; i ++) {
        new_state->board[i] = malloc(21*sizeof(char));
    }
    for (int i = 0; i < 18; i++) {
        for (int j = 0; j < 20; j ++) {
            if (i == 0 || j == 0 || i == 17|| j == 19) {
                new_state->board[i][j] = '#';
            } else {
                new_state->board[i][j] = ' ';
            }
        }
        new_state->board[i][20] = '\0';
    }
    new_state->board[2][9] = '*';

    new_state->snakes = malloc(sizeof(snake_t));
    if (new_state->snakes == NULL) {
        fprintf(stderr, "Out of memory.\n");
        exit(1);
    }
    new_state->snakes[0].head_row = 2;
    new_state->snakes[0].head_col = 4;
    new_state->snakes[0].tail_row = 2;
    new_state->snakes[0].tail_col = 2;
    new_state->snakes[0].live = true;
    new_state->board[2][2] = 'd';
    new_state->board[2][3] = '>';
    new_state->board[2][4] = 'D';


  return new_state;
}

/* Task 2 */
void free_state(game_state_t* state) {
  // TODO: Implement this function.
    free(state->snakes);
    for (int i = 0; i < state->num_rows; i ++) {
        free(state->board[i]);
    }
    free(state->board);
    free(state);
  return;
}

/* Task 3 */
void print_board(game_state_t* state, FILE* fp) {
  // TODO: Implement this function.
    for (int i = 0; i < state->num_rows; i++) {
        fprintf(fp,"%s\n",state->board[i]);
    }
  return;
}

/*
  Saves the current state into filename. Does not modify the state object.
  (already implemented for you).
*/
void save_board(game_state_t* state, char* filename) {
  FILE* f = fopen(filename, "w");
  print_board(state, f);
  fclose(f);
}

/* Task 4.1 */

/*
  Helper function to get a character from the board
  (already implemented for you).
*/
char get_board_at(game_state_t* state, unsigned int row, unsigned int col) {
  return state->board[row][col];
}

/*
  Helper function to set a character on the board
  (already implemented for you).
*/
static void set_board_at(game_state_t* state, unsigned int row, unsigned int col, char ch) {
  state->board[row][col] = ch;
}

/*
  Returns true if c is part of the snake's tail.
  The snake consists of these characters: "wasd"
  Returns false otherwise.
*/
static bool is_tail(char c) {
  // TODO: Implement this function.
  if (c == 'w' || c == 'a' || c == 's' || c == 'd') {
      return true;
  }
  return false;
}

/*
  Returns true if c is part of the snake's head.
  The snake consists of these characters: "WASDx"
  Returns false otherwise.
*/
static bool is_head(char c) {
  // TODO: Implement this function.
    if (c == 'W' || c == 'A' || c == 'S' || c == 'D' || c == 'x') {
        return true;
    }
  return false;
}

/*
  Returns true if c is part of the snake.
  The snake consists of these characters: "wasd^<v>WASDx"
*/
static bool is_snake(char c) {
  // TODO: Implement this function.
  if (is_head(c) || is_tail(c) || c == '^' || c == '<' || c == 'v' || c == '>') {
      return true;
  }
  return false;
}

/*
  Converts a character in the snake's body ("^<v>")
  to the matching character representing the snake's
  tail ("wasd").
*/
static char body_to_tail(char c) {
    char result = ' ';
    if (c == '^') {
        result = 'w';
    } else if (c == 'v') {
        result = 's';
    } else if (c == '<') {
        result = 'a';
    } else if (c == '>') {
        result = 'd';
    }
  // TODO: Implement this function.
  return result;
}

/*
  Converts a character in the snake's head ("WASD")
  to the matching character representing the snake's
  body ("^<v>").
*/
static char head_to_body(char c) {
    char result = ' ';
    if (c == 'W') {
        result = '^';
    } else if (c == 'S') {
        result = 'v';
    } else if (c == 'A') {
        result = '<';
    } else if (c == 'D') {
        result = '>';
    }
  return result;
}

/*
  Returns cur_row + 1 if c is 'v' or 's' or 'S'.
  Returns cur_row - 1 if c is '^' or 'w' or 'W'.
  Returns cur_row otherwise.
*/
static unsigned int get_next_row(unsigned int cur_row, char c) {
  // TODO: Implement this function.
  if (c == 'v' || c == 's' || c == 'S') {
      cur_row++;
  }
  if (c == '^' || c == 'w' || c == 'W') {
      cur_row--;
  }
  return cur_row;
}

/*
  Returns cur_col + 1 if c is '>' or 'd' or 'D'.
  Returns cur_col - 1 if c is '<' or 'a' or 'A'.
  Returns cur_col otherwise.
*/
static unsigned int get_next_col(unsigned int cur_col, char c) {
  // TODO: Implement this function.
    if (c == '>' || c == 'd' || c == 'D') {
        cur_col++;
    }
    if (c == '<' || c == 'a' || c == 'A') {
        cur_col--;
    }
  return cur_col;
}

/*
  Task 4.2

  Helper function for update_state. Return the character in the cell the snake is moving into.

  This function should not modify anything.
*/
static char next_square(game_state_t* state, unsigned int snum) {
  // TODO: Implement this function.
  char head = get_board_at(state, state->snakes[snum].head_row, state->snakes[snum].head_col);
  unsigned int next_row = get_next_row(state->snakes[snum].head_row, head);
  unsigned int next_col = get_next_col(state->snakes[snum].head_col, head);
  return get_board_at(state, next_row, next_col);
}

/*
  Task 4.3

  Helper function for update_state. Update the head...

  ...on the board: add a character where the snake is moving

  ...in the snake struct: update the row and col of the head

  Note that this function ignores food, walls, and snake bodies when moving the head.
*/
static void update_head(game_state_t* state, unsigned int snum) {
  // TODO: Implement this function.
  char head = get_board_at(state, state->snakes[snum].head_row, state->snakes[snum].head_col);
  unsigned int next_row = get_next_row(state->snakes[snum].head_row, head);
  unsigned int next_col = get_next_col(state->snakes[snum].head_col, head);
  state->board[state->snakes[snum].head_row][state->snakes[snum].head_col] = head_to_body(head);
  state->board[next_row][next_col] = head;
  state->snakes[snum].head_row = next_row;
  state->snakes[snum].head_col = next_col;
  return;
}

/*
  Task 4.4

  Helper function for update_state. Update the tail...

  ...on the board: blank out the current tail, and change the new
  tail from a body character (^<v>) into a tail character (wasd)

  ...in the snake struct: update the row and col of the tail
*/
static void update_tail(game_state_t* state, unsigned int snum) {
  // TODO: Implement this function.
  char tail = get_board_at(state, state->snakes[snum].tail_row, state->snakes[snum].tail_col);
  unsigned int next_row = get_next_row(state->snakes[snum].tail_row, tail);
  unsigned int next_col = get_next_col(state->snakes[snum].tail_col, tail);
  state->board[state->snakes[snum].tail_row][state->snakes[snum].tail_col] = ' ';
  state->board[next_row][next_col] = body_to_tail(get_board_at(state, next_row, next_col));
  state->snakes[snum].tail_row = next_row;
  state->snakes[snum].tail_col = next_col;
  return;
}

/* Task 4.5 */
void update_state(game_state_t* state, int (*add_food)(game_state_t* state)) {
  // TODO: Implement this function.
  for (unsigned int i = 0; i < state->num_snakes; i ++) {
      if (state->snakes[i].live) {
          char next_step = next_square(state, i);
          if (next_step == '#' || is_snake(next_step)) {
              state->snakes[i].live = false;
              state->board[state->snakes[i].head_row][state->snakes[i].head_col] = 'x';
          } else if (next_step == '*') {
              update_head(state, i);
              add_food(state);
          } else {
              update_head(state, i);
              update_tail(state, i);
          }
      }
  }
  return;
}

/* Task 5 */
game_state_t* load_board(char* filename) {
  // TODO: Implement this function.
  game_state_t *new_state;
  new_state = malloc(sizeof(game_state_t));
  if (new_state == NULL) {
      fprintf(stderr, "Out of memory.\n");
      exit(1);
  }
  FILE* fp;
    char* line = NULL;
    size_t len = 0;
    ssize_t nread;
  fp = fopen(filename, "r");
  if (fp == NULL) {
      return NULL;
  }
  unsigned int row_counter = 0;
  new_state->board = (char**) malloc( (row_counter + 1) * sizeof(char*));
  while ((nread = getline(&line, &len, fp)) != -1) {
      // Process the line
      if (line[nread - 1] == '\n') {
          line[nread - 1] = '\0';
      }
      new_state->board = realloc(new_state->board, (row_counter + 1) * sizeof(char*));
      new_state->board[row_counter] = malloc(len *sizeof(char));
      strcpy(new_state->board[row_counter], line);
      row_counter++;
  }
  new_state->num_rows = row_counter;

  return new_state;
}

/*
  Task 6.1

  Helper function for initialize_snakes.
  Given a snake struct with the tail row and col filled in,
  trace through the board to find the head row and col, and
  fill in the head row and col in the struct.
*/
static void find_head(game_state_t* state, unsigned int snum) {
  // TODO: Implement this function.
  unsigned int current_row = state->snakes[snum].tail_row;
  unsigned int current_col = state->snakes[snum].tail_col;
  while (!is_head(get_board_at(state, current_row, current_col))) {
      unsigned int temp_row = get_next_row(current_row, get_board_at(state, current_row, current_col));
      unsigned int temp_col = get_next_col(current_col, get_board_at(state, current_row, current_col));
      current_row = temp_row;
      current_col = temp_col;
  }
  state->snakes[snum].head_row = current_row;
  state->snakes[snum].head_col = current_col;
  return;
}

/* Task 6.2 */
game_state_t* initialize_snakes(game_state_t* state) {
  // TODO: Implement this function.
  unsigned int snake_counter = 0;
  unsigned int col_counter = 0;
  state->snakes = malloc(sizeof(snake_t));
  if (state->snakes == NULL) {
      fprintf(stderr, "Out of memory.\n");
      exit(1);
  }
  for (unsigned int i = 0; i < state->num_rows; i++) {
      while (state->board[i][col_counter] != '\0') {
          if (is_tail(state->board[i][col_counter])) {
              state->snakes[snake_counter].tail_row = i;
              state->snakes[snake_counter].tail_col = col_counter;
              find_head(state, snake_counter);
              state->snakes[snake_counter].live = true;
              snake_counter++;
          }
          col_counter++;
      }
      col_counter = 0;

  }
  state->num_snakes = snake_counter;
  return state;
}
