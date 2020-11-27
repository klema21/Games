#ifndef CHANCEAPI
#define CHANCEAPI

#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>

#define DATAFILE "/var/chance.data" // File to store user data

struct user{
	int uid;
	int credits;
	int hightscore;
	char name[100];
	//int (*current_game) ();
};

// Global variable
struct user player;

int get_player_data();
void register_new_player();
void update_player_data();
void input_name();

void register_new_player(){
	int fd;

	printf("-=-= Register New Player =-=-\n");
	printf("Enter your name: ");
	input_name();

	player.uid = getuid();
	player.highscore = player.credits = 100;

	fd = open(DATAFILE, O_WRONLY|O_CREAT|O_APPEND, S_IRUSR|S_IWUSR);
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
