#ifndef CHANCEAPI
#define CHANCEAPI

#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>


#define DATAFILE "/var/chance.data" // File to store user data

struct user{
	int uid;
	int credits;
	int highscore;
	char name[100];
	//int (*current_game) ();
};

// Global variable
struct user player;

int get_player_data();
void register_new_player();
void update_player_data();
void input_name();
void fatal(char*);
void *ec_malloc(unsigned int);

void *ec_malloc(unsigned int size){
	void *ptr;
	ptr = malloc(size);
	if(ptr == NULL)
		fatal("in ec_malloc() on memory allocation");
   return ptr;	
}

void fatal(char* message){
	char error_message[100];

	strcpy(error_message, "[!!] Fatal Error ");
	strncat(error_message, message, 83);
	perror(error_message);
	exit(-1);
}

void register_new_player(){
	int fd;

	printf("-=-= Register New Player =-=-\n");
	printf("Enter your name: ");
	input_name();

	player.uid = getuid();
	player.highscore = player.credits = 100;

	fd = open(DATAFILE, O_WRONLY|O_CREAT|O_APPEND, S_IRUSR|S_IWUSR);
	if(fd == -1)
		fatal("in register_new_player() while opening file");
	write(fd, &player, sizeof(struct user));
	close(fd);
	
	printf("\nWelcome! %s.\n", player.name);
	printf("You have been given %u credits\n", player.credits);
}

void input_name(){
	char *name_ptr, input_char = '\n';
	while(input_char == '\n')
		scanf("%c", &input_char);

	name_ptr = (char *) &(player.name);
	while(input_char != '\n'){
		*name_ptr = input_char;
		scanf("%c", &input_char);
		name_ptr++;
	}
	*name_ptr = 0;
}

#endif
